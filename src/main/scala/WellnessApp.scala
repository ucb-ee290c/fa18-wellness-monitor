package wellness

import firFilter._
import iirFilter._
import fft._
import features._

import chisel3._
import dsptools.numbers._

import scala.collection.mutable._

object WellnessApp extends App {
  val dataType = SInt(64.W)
  val nFFT: Int = 32

  // Ch 0
  val ch0DatapathsArr: ArrayBuffer[Seq[(String, Any)]] = ArrayBuffer()
  ch0DatapathsArr += makeBandpower(0, 0, 2)
  ch0DatapathsArr += makeBandpower(0, 3, 4)
  val ch0LL1FilterTapsA: Seq[Double] = Seq(0.0, 1.0, 3.0)
  val ch0LL1FilterTapsB: Seq[Double] = Seq(0.0, 0.0, 0.0)
  ch0DatapathsArr += makeLineLength(0, 32, 0, ch0LL1FilterTapsA, ch0LL1FilterTapsB)
  val ch0LL2FilterTapsA: Seq[Double] = Seq(0.0, 1.0, 3.0)
  val ch0LL2FilterTapsB: Seq[Double] = Seq(0.0, 2.0, 4.0)
  ch0DatapathsArr += makeLineLength(0, 32, 1, ch0LL2FilterTapsA, ch0LL2FilterTapsB)


  val fftConfig = FFTConfig(
    genIn = DspComplex(dataType, dataType),
    genOut = DspComplex(dataType, dataType),
    n = nFFT,
    lanes = nFFT,
    pipelineDepth = 0,
    quadrature = false,
  )

  def makeBandpower(channel: Int, idxLowBin: Int, idxUpBin: Int): Seq[(String, Any)] = {
    val bandpowerParams = new BandpowerParams[SInt] { // TODO: type
      val idxStartBin = idxLowBin
      val idxEndBin = idxUpBin
      val nBins = nFFT
      val genIn = DspComplex(dataType, dataType)
      val genOut = dataType
    }

    val bandpowerDatapath: Seq[(String, Any)] = Seq(("FFT", fftConfig), ("Bandpower", bandpowerParams))
    bandpowerDatapath
  }

  def makeLineLength(channel: Int, windowLength: Int, filterTypeIdx: Int, filterTapsA: Seq[Double], filterTapsB: Seq[Double]): Seq[(String, Any)] = {
    val filterParams =
      if (filterTypeIdx == 0) // FIRFilter
        new FIRFilterParams[SInt] {
          val protoData = dataType
          val taps = filterTapsA.map(ConvertableTo[SInt].fromDouble(_))
        }
      else if (filterTypeIdx == 1) // IIRFilter
        new IIRFilterParams[SInt] {
          val protoData = dataType
          val consts_A = filterTapsA.map(ConvertableTo[SInt].fromDouble(_))
          val consts_B = filterTapsB.map(ConvertableTo[SInt].fromDouble(_))
        }

    val lineLengthParams = new lineLengthParams[SInt] {
      val protoData = dataType
      val windowSize = windowLength
    }

    val lineLengthDatapath: Seq[(String, Any)] = Seq(("FIRFilter", filterParams), ("LineLength", lineLengthParams))
    lineLengthDatapath
  }

  // TODO: instantiate WellnessGen
}