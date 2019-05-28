package features

import chisel3._
import chisel3.util._
import dsptools.numbers._
import dspjunctions._
import breeze.numerics.log2

/**
  * @tparam T
  *
  * idxStartBin   Index of lower freq bound of freq range of interest (inclusive)
  * idxEndBin     Index of upper freq bound of freq range of interest (exclusive!)
  * nBins         Length of incoming FFT signal
  * genIn         Input data type (a DspComplex bundle of type T)
  * genOut        Output data type
  *
  * Reqs:         End index must be > start index
  *               Diff b/w end (exclusive) and start indices must be a power of 2
  *               End index must be <= nBins/2
  */
trait BandpowerNoFFTParams[T <: Data] {
  val idxStartBin: Int
  val idxEndBin: Int
  val nBins: Int
  val genIn: DspComplex[T]
  val genOut: T
}

/**
  * Input is parallelized, output is a scalar
  *
  * @param params   See BandpowerNoFFTParams above
  * @tparam T
  *
  * in              bits: vector of length nBins and same type as genIn
  *                   containing incoming FFT signal
  *                 valid
  *                 sync
  * out             bits: same type as genOut containing scalar average bandpower output
  */
class BandpowerNoFFTIO[T <: Data](params: BandpowerNoFFTParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nBins, params.genIn.cloneType)))
  val out = ValidWithSync(params.genOut.cloneType)

  override def cloneType: this.type = BandpowerNoFFTIO(params).asInstanceOf[this.type]
}
object BandpowerNoFFTIO {
  def apply[T <: Data](params: BandpowerNoFFTParams[T]): BandpowerNoFFTIO[T] = new BandpowerNoFFTIO(params)
}

/**
  * Takes incoming FFT signal and output average power in frequency band of interest
  *
  * @param params                   See trait BandpowerNoFFTParams above
  *
  * @param real$T
  * @param binaryRepresentation$T
  * @tparam T
  *
  * IO                              See class BandpowerNoFFTIO above
  */
class BandpowerNoFFT[T <: Data : Real : BinaryRepresentation](val params: BandpowerNoFFTParams[T]) extends Module {
  require(params.idxEndBin > params.idxStartBin, f"End index ${params.idxEndBin} must be greater than start index ${params.idxStartBin}")
  // TODO: Check this one
  require(((params.idxEndBin - params.idxStartBin) & (params.idxEndBin - params.idxStartBin - 1)) == 0,
    f"Difference between the two indices must be a power of 2, currently ${params.idxEndBin - params.idxStartBin}")
  require(params.nBins/2 >= params.idxEndBin,
    f"End index ${params.idxEndBin} must be at most half of the total number of bins ${params.nBins}")

  val io = IO(new BandpowerNoFFTIO[T](params))

  // Take mag squared of FFT output
  val p2 = io.in.bits.map(_.abssq())
  // Except for DC and sampling freq, 2x for 2-sided to 1-sided
  val p1Scaled = p2.slice(1, params.nBins/2).map(_ * 2)
  // Concatenate back in unscaled DC and sampling freq elems
  val p1 = VecInit(p2(0)) ++ p1Scaled ++ VecInit(p2(params.nBins/2))
  // Sum and divide by num of bins of interest squared

  // Also do division by 2^23 to minimize dynamic range of output values
  // Check https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/scripts/features.py
  val outNext = (p1.slice(params.idxStartBin, params.idxEndBin).reduce(_ + _)
    >> (2 * log2(params.idxEndBin - params.idxStartBin).toInt))  >> 23

  // Pipeline register at output
  // (to prevent system critical path from exploding)
  val outReg = RegEnable(outNext, io.in.valid)
  val valReg = RegNext(io.in.valid)
  val syncReg = RegNext(io.in.sync)

  io.out.bits := outReg
  io.out.valid := valReg
  io.out.sync := syncReg
}