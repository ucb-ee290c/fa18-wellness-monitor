package features

import breeze.numerics.log10
import chisel3._
import dsptools.numbers._
import dspjunctions._

// Currently designed with a lane for each bin

trait BandpowerParams[T <: Data] {
  val idxStartBin: Int
  val idxEndBin: Int
  val nBins: Int
  val genIn: DspComplex[T]
  val genOut: T
}

class BandpowerIO[T <: Data](params: BandpowerParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nBins, params.genIn.cloneType)))
  val out = ValidWithSync(params.genOut.cloneType)

  override def cloneType: this.type = BandpowerIO(params).asInstanceOf[this.type]
}
object BandpowerIO {
  def apply[T <: Data](params: BandpowerParams[T]): BandpowerIO[T] = new BandpowerIO(params)
}

class Bandpower[T <: Data : Real : BinaryRepresentation](val params: BandpowerParams[T]) extends Module {
  require( params.idxEndBin > params.idxStartBin )
  require( ( (params.idxEndBin - params.idxStartBin + 1) & (params.idxEndBin - params.idxStartBin + 1 - 1)) == 0 )
  val io = IO(new BandpowerIO[T](params))

  // TODO: sqrt, division
  // Take mag squared of FFT output
  val p2 = io.in.bits.map(_.abssq())
  // Except for DC and sampling freq, 2x for 2-sided to 1-sided
  val p1Scaled = p2.slice(1, params.nBins/2 - 1).map(_ * 2)
  // Concatenate back in unscaled DC and sampling freq elems
  val p1 = VecInit(p2(0)) ++ p1Scaled ++ VecInit(p2(params.nBins/2))
  // Just sum because already squared
  io.out.bits := p1.slice(params.idxStartBin, params.idxEndBin).reduce(_ + _) >> (log10(params.idxEndBin - params.idxStartBin + 1) / log10(2)).toInt

  io.out.valid := io.in.valid
  io.out.sync := io.in.sync
}