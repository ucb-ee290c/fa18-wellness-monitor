package wellness

import breeze.math.Complex
import chisel3._
import chisel3.experimental.FixedPoint
import chisel3.util.log2Ceil
import dsptools.DspTester
import dsptools.numbers._
import firFilter._
import fft._
import features._
import pca._
import memorybuffer._
import svm._
import freechips.rocketchip.config.Parameters

import scala.collection.mutable.ArrayBuffer
import scala.collection.{Seq, mutable}

class wellnessGenTester[T <: chisel3.Data](c: wellnessGenModule[T],
                                           goldenModelParameters: wellnessGenIntegrationParameterBundle,
                                           dataBP: Int, testType: Int) extends DspTester(c) {

  // Instantiate golden models
  val wellnessGenParams1 = new wellnessGenParams[SInt] {
    val protoData = SInt(64.W)
  }

  val datapathParamsSeqs = Seq(Seq(("FIR",goldenModelParameters.filter1Params),("lineLength",goldenModelParameters.lineLength1Params)),
    Seq(("FIR",goldenModelParameters.filter1Params),("lineLength",goldenModelParameters.lineLength1Params)))

  val generatedDatapaths        : mutable.ArrayBuffer[mutable.ArrayBuffer[(String,Object)]] = mutable.ArrayBuffer()

  // In order to keep track of intermediate results, we need to store them somewhere
  // But they're all different types so we need array buffers of different types to store data for different blocks
  // Doubles will be stored here (used by FIR, IIR, lineLength, and Bandpower)
  var generatedDatapathResults  : mutable.ArrayBuffer[mutable.ArrayBuffer[Double]] = mutable.ArrayBuffer()
  var generatedFFTResults       : mutable.ArrayBuffer[mutable.ArrayBuffer[Seq[Complex]]] = mutable.ArrayBuffer()


  for (k <- 0 until datapathParamsSeqs.length)
  {
    val singlePathParamsSeq = datapathParamsSeqs(k)
    val generatedSinglePath       : mutable.ArrayBuffer[(String,Object)] = mutable.ArrayBuffer()
    val genSinglePathResults      : mutable.ArrayBuffer[Double]       = mutable.ArrayBuffer()
    var genSingleFFTResults       : mutable.ArrayBuffer[Seq[Complex]] = mutable.ArrayBuffer()

    for (i <- 0 until singlePathParamsSeq.length)
    {
      singlePathParamsSeq(i)._1 match
      {
        case "FIR" =>
        { // FIR
          generatedSinglePath     += (("FIR", new GoldenDoubleFIRFilter(singlePathParamsSeq(i)._2.asInstanceOf[filterGenParamsTemplate].taps)))
          genSinglePathResults    += 0.toDouble
          genSingleFFTResults     += Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0))
        }
        case "lineLength" =>
        { // lineLength
          generatedSinglePath     += (("lineLength", new GoldenDoubleLineLength(singlePathParamsSeq(i)._2.asInstanceOf[lineLengthGenParamsTemplate].
            windowSize,wellnessGenParams1.protoData.getClass.getTypeName)))
          genSinglePathResults += 0.toDouble
          genSingleFFTResults     += Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0))
        }
        case "FFT" =>
        {
          generatedSinglePath     += (("FFT", new GoldenDoubleFFT()))
          genSinglePathResults    += 0.toDouble
          genSingleFFTResults     += Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0))
        }
        case "FFTBuffer" =>
        {
          generatedSinglePath     += (("FFTBuffer", new GoldenFFTBuffer(goldenModelParameters.fftBufferParams.lanes)))
          genSinglePathResults    += 0.toDouble
          genSingleFFTResults     += Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0))
        }
        case "Bandpower" =>
        {
          generatedSinglePath     += (("Bandpower", new GoldenDoubleBandpower(goldenModelParameters.bandpower1Params.nBins,
                                          goldenModelParameters.bandpower1Params.idxStartBin,
                                          goldenModelParameters.bandpower1Params.idxEndBin,
                                          wellnessGenParams1.protoData.getClass.getTypeName)))
          genSinglePathResults    += 0.toDouble
          genSingleFFTResults     += Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0))
        }
      }
    }
    generatedDatapaths += generatedSinglePath
    generatedDatapathResults += genSinglePathResults
    generatedFFTResults += genSingleFFTResults
  }



  for (i <- 0 until 100)
  {
    val input = scala.util.Random.nextDouble * 32

    for (k <- 0 until generatedDatapaths.length)
      {
        val generatedSinglePath = generatedDatapaths(k)
        val genSinglePathResult = generatedDatapathResults(k)
        for (j <- (generatedSinglePath.length - 1) to 0 by -1)
        {
          val name = generatedSinglePath(j)._1

          if (j == 0)
          {
            name match
            {
              case "FIR" =>
                genSinglePathResult(j) = generatedSinglePath(j)._2.asInstanceOf[GoldenDoubleFIRFilter].poke(input)
              case "lineLength" =>
                genSinglePathResult(j) = generatedSinglePath(j)._2.asInstanceOf[GoldenDoubleLineLength].poke(input)
              //case "FFTBuffer" =>
              //  genSinglePathResult(j) = genSinglePath(j).asInstanceOf[GoldenFFTBuffer].poke(input)
            }
          }
          else
          {
            name match
            {
              case "FIR" =>
              {
                genSinglePathResult(j) = generatedSinglePath(j)._2.asInstanceOf[GoldenDoubleFIRFilter].poke(genSinglePathResult(j-1))
              }
              case "lineLength" =>
              {
                genSinglePathResult(j) = generatedSinglePath(j)._2.asInstanceOf[GoldenDoubleLineLength].poke(genSinglePathResult(j-1))
              }
            }
          }
        }
      }

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)
    step(1)

    val check_i = 0
    val check_j = generatedDatapathResults(check_i).length-1

    if (peek(c.io.out.valid) == true)
      {
        //expect(c.io.out.bits, generatedDatapathResults(check_i)(check_j))
        fixTolLSBs.withValue(1)
        {
          expect(c.io.out.bits, generatedDatapathResults(check_i)(check_j), s"valid ${peek(c.io.out.valid)}")
        }
      }
    //expect(c.io.out.valid, false.B)
    //expect(c.io.out.bits, generatedDatapathResults(check_i)(check_j))
  }
}


object wellnessGenIntegrationTesterSInt {
  implicit val p: Parameters = null
  def apply(wellnessGenParams1: wellnessGenParams[SInt],
            goldenModelParameters: wellnessGenIntegrationParameterBundle, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new wellnessGenModule(
        wellnessGenParams1: wellnessGenParams[SInt])) {
        c => new wellnessGenTester(c, goldenModelParameters, 0,0)
      }
    } else {
      dsptools.Driver.execute(() => new wellnessGenModule(
        wellnessGenParams1: wellnessGenParams[SInt]),
        TestSetup.dspTesterOptions) {
        c => new wellnessGenTester(c, goldenModelParameters, 0, 0)
      }
    }
  }
}
