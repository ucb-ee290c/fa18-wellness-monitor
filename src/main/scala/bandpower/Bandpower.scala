package bandpower

import chisel3._
//import chisel3.core.FixedPoint
import chisel3.experimental.FixedPoint
import dsptools.numbers._
import dspjunctions._

// Currently designed with a lane for each bin

trait BandpowerParams[T <: Data] {
  val indStartBin: Int
  val indEndBin: Int
  val nBins: Int
  val genIn: T
  val genOut: T
}

case class FixedBandpowerParams(
  indStart: Int,
  indEnd: Int,
  n: Int,
  width: Int,
  bp: Int
) extends BandpowerParams[DspComplex[FixedPoint]] {
  val indStartBin = indStart
  val indEndBin = indEnd
  val nBins = n
  val genIn = DspComplex(FixedPoint(width.W, bp.BP), FixedPoint(width.W, bp.BP))
  val genOut = DspComplex(FixedPoint(width.W, bp.BP), FixedPoint(width.W, bp.BP))
}

class BandpowerIO[T <: Data](params: BandpowerParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nBins, params.genIn.cloneType)))
  val out = ValidWithSync(params.genOut.cloneType)

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

  // Take abs of FFT output
  val p2 = io.in.bits.map(_.abs)
  // Except for DC and sampling freq, 2x for 2-sided to 1-sided
  val p1Scaled = io.in.bits.slice(1, params.nBins/2 - 1).map(_ * 2)
  // Concatenate back in unscaled DC and sampling freq elems
  val p1 = VecInit(p2(0)) ++ p1Scaled ++ VecInit(p2(params.nBins/2))
  // Square and sum elems in band of interest
  io.out.bits := p1.slice(params.indStartBin, params.indEndBin).map{ case p => p * p}.reduce(_ + _)

  io.out.valid := io.in.valid
  io.out.sync := io.in.sync
}