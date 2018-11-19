package features

import chisel3._
import dsptools.numbers._
import dspjunctions._

// Currently designed with a lane for each bin

trait BandpowerParams[T <: Data] {
  val idxStartBin: Int
  val idxEndBin: Int
  val nBins: Int
  val protoData: DspComplex[T]
}

class BandpowerIO[T <: Data : Real](params: BandpowerParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nBins, params.protoData.cloneType)))
  val out = ValidWithSync(params.protoData.cloneType)

  override def cloneType: this.type = BandpowerIO(params).asInstanceOf[this.type]
}
object BandpowerIO {
  def apply[T <: Data : Real](params: BandpowerParams[T]): BandpowerIO[T] = new BandpowerIO(params)
}

class Bandpower[T <: Data : Real](val params: BandpowerParams[T]) extends Module {
  val io = IO(new BandpowerIO[T](params))

  // TODO: sqrt, division
  // Take mag squared of FFT output
  val p2 = io.in.bits.map(_.abssq())
  // Except for DC and sampling freq, 2x for 2-sided to 1-sided
  val p1Scaled = io.in.bits.slice(1, params.nBins/2 - 1).map(_ * 2)
  // Concatenate back in unscaled DC and sampling freq elems
  val p1 = VecInit(p2(0)) ++ p1Scaled ++ VecInit(p2(params.nBins/2))
  // TODO: fix type mismatch error
  // Square and sum elems in band of interest
//  io.out.bits := p1.slice(params.idxStartBin, params.idxEndBin).map{ case x => x * x}.reduce(_ + _)
  // Just sum because already squared
  io.out.bits := p1.slice(params.idxStartBin, params.idxEndBin).sum

  io.out.valid := io.in.valid
  io.out.sync := io.in.sync
}