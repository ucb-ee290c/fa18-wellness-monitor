package features

import wellness._
import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._
import dsptools.DspTester

class GoldenDoubleBandpower[T <: Data](params: BandpowerParams[T]) {
  def poke(input: Seq[Double]): Double = {
    val p2 = input.map(scala.math.abs(_))
    val p1Scaled = p2.slice(1, params.nBins / 2 - 1).map(_ * 2)
    val p1 = Seq(p2(0)) ++ p1Scaled ++ Seq(p2(params.nBins / 2))
    val output = p1.slice(params.idxStartBin, params.idxEndBin).map{ case p => p * p}.reduce(_ + _)
    output
  }
}

class BandpowerTester[T <: Data](c: Bandpower[T], params: BandpowerParams[T], testType: Int = 0) extends DspTester(c) {
  val bandpower = new GoldenDoubleBandpower(params)

  var input = Seq.fill(params.nBins)(scala.util.Random.nextDouble)
  if (testType == 1) { // UInt
    input = Seq.fill(params.nBins)(scala.util.Random.nextInt(16))
  }

  val goldenModelResult = bandpower.poke(input)

  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }
  poke(c.io.in.valid, value = 1)
  step(1)

  if (testType == 0) { // FixedPoint
    fixTolLSBs.withValue(19) {
      expect(c.io.out.bits, goldenModelResult, msg = s"Input: $input, Golden: $goldenModelResult, ${peek(c.io.out.bits)}")
    }
  } else { // UInt
      expect(c.io.out.bits, goldenModelResult, msg = s"Input: $input, Golden: $goldenModelResult, ${peek(c.io.out.bits)}")
  }
}
object UIntBandpowerTester {
  def apply(params: BandpowerParams[UInt]): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new Bandpower(params)) {
    dsptools.Driver.execute(() => new Bandpower(params), TestSetup.dspTesterOptions) {
      c => new BandpowerTester(c, params)
    }
  }
}
object FixedPointBandpowerTester {
  def apply(params: BandpowerParams[FixedPoint]): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new Bandpower(params)) {
    dsptools.Driver.execute(() => new Bandpower(params), TestSetup.dspTesterOptions) {
      c => new BandpowerTester(c, params)
    }
  }
}