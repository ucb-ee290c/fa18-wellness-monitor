package features

import chisel3._
import chisel3.util._
import dsptools.numbers._
import dspjunctions._
import scala.collection._
import scala.math.pow

// Currently designed with a lane for each bin

trait BandpowerParams[T <: Data] {
  val idxStartBin: Int
  val idxEndBin: Int
  val nBins: Int
  val protoData: T
}

class BandpowerIO[T <: Data](params: BandpowerParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nBins, params.protoData.cloneType)))
  val out = ValidWithSync(params.protoData.cloneType)

  override def cloneType: this.type = BandpowerIO(params).asInstanceOf[this.type]
}
object BandpowerIO {
  def apply[T <: Data](params: BandpowerParams[T]): BandpowerIO[T] = new BandpowerIO(params)
}

class Bandpower[T <: Data : Real](val params: BandpowerParams[T]) extends Module {
  val io = IO(new BandpowerIO[T](params))

  // TODO: division
  // Should be unnecessary b/c just a scale factor
  // Division is not built-in b/c expensive
  // But should be able to shift for FixedPoint, etc.
  // Then write a case for floating point

  // Bit reverse a value
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

//  // Unscramble FFT output
//  def unscramble(in: Vec[T], p: Int): Seq[T] = {
//    val n = in.size
//    val bp = n/p
//    val res = Array.fill(n)(0.asInstanceOf[T])
//    in.grouped(p).zipWithIndex.foreach { case (set, sindex) =>
//      set.zipWithIndex.foreach { case (bin, bindex) =>
//        if (bp > 1) {
//          val p1 = if (sindex/(bp/2) >= 1) 1 else 0
//          val new_index = bit_reverse((sindex % (bp/2)) * 2 + p1, log2Ceil(bp)) + bit_reverse(bindex, log2Ceil(n))
//          res(new_index) = bin
//        } else {
//          val new_index = bit_reverse(bindex, log2Ceil(n))
//          res(new_index) = bin
//        }
//      }
//    }
//    res
//  }
//
//  val unscrambled = VecInit(unscramble(io.in.bits, params.nBins))

    val in = io.in.bits
    val p = params.nBins
    val n = in.size
    val bp = n/p
    val res = mutable.Seq.fill(n)(Ring[T].zero)
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
    val unscrambled = VecInit(res)

  // Take abs of FFT output
  val p2 = unscrambled.map(_.abs)
  // Except for DC and sampling freq, 2x for 2-sided to 1-sided
  val p1Scaled = unscrambled.slice(1, params.nBins/2 - 1).map(_ * 2)
  // Concatenate back in unscaled DC and sampling freq elems
  val p1 = VecInit(p2(0)) ++ p1Scaled ++ VecInit(p2(params.nBins/2))
  // Square and sum elems in band of interest
  io.out.bits := p1.slice(params.idxStartBin, params.idxEndBin).map{ case p => p * p}.reduce(_ + _)

  io.out.valid := io.in.valid
  io.out.sync := io.in.sync
}