package features

import wellness._
import chisel3._
import chisel3.util._
import dsptools.numbers._
import dsptools.DspTester
import scala.math.pow

class GoldenIntBandpower(params: BandpowerParams[UInt]) {
  def poke(input: Seq[Int]): Int = {

    def bit_reverse(in: Int, width: Int): Int = {
      var test = in
      var out = 0
      for (i <- 0 until width) {
        if (test / pow(2, width-i-1) >= 1) {
          out += pow(2, i).toInt
          test -= pow(2, width-i-1).toInt
        }
      }
      out
    }

    def unscramble(in: Seq[Int], p: Int): Seq[Int] = {
      val n = in.size
      val bp = n/p
      val res = Array.fill(n)(0)
      in.grouped(p).zipWithIndex.foreach { case (set, sindex) =>
        set.zipWithIndex.foreach { case (bin, bindex) =>
          if (bp > 1) {
            val p1 = if (sindex/(bp/2) >= 1) 1 else 0
            val new_index = bit_reverse((sindex % (bp/2)) * 2 + p1, log2Ceil(bp)) + bit_reverse(bindex, log2Ceil(n))
            res(new_index) = bin
          } else {
            val new_index = bit_reverse(bindex, log2Ceil(n))
            res(new_index) = bin
          }
        }
      }
      res
    }

    val unscrambled = unscramble(input, params.nBins)

    val p2 = unscrambled.map(scala.math.abs(_))
    val p1Scaled = p2.slice(1, params.nBins / 2 - 1).map(_ * 2)
    val p1 = Seq(p2(0)) ++ p1Scaled ++ Seq(p2(params.nBins / 2))
    val output = p1.slice(params.idxStartBin, params.idxEndBin).map{ case p => p * p}.reduce(_ + _)
    output
  }
}

class BandpowerTester[T <: Data](c: Bandpower[T], params: BandpowerParams[UInt]) extends DspTester(c) {
  val bandpower = new GoldenIntBandpower(params)
  val input = Seq.fill(params.nBins)(scala.util.Random.nextInt(16))
  val goldenModelResult = bandpower.poke(input)

  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }
  poke(c.io.in.valid, value = 1)
  step(1)
  expect(c.io.out.bits, goldenModelResult, msg = s"Input: $input, Golden: $goldenModelResult, ${peek(c.io.out.bits)}")
}
object UIntBandpowerTester {
  def apply(params: BandpowerParams[UInt]): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new Bandpower(params)) {
    dsptools.Driver.execute(() => new Bandpower(params), TestSetup.dspTesterOptions) {
      c => new BandpowerTester(c, params)
    }
  }
}