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
                                           pcaParams: PCAParams[T],
                                           svmParams: SVMParams[T],
                                           configurationMemoryParams: ConfigurationMemoryParams[T],
                                           goldenModelParameters: wellnessGenIntegrationParameterBundle,
                                           dataBP: Int, testType: Int) extends DspTester(c) {

  // Instantiate golden models
  val wellnessGenParams1 = new wellnessGenParams[SInt] {
    val dataType = SInt(64.W)
  }

  // val datapathParamsSeqs = Seq(Seq(("FIR",goldenModelParameters.filter1Params),("lineLength",goldenModelParameters.lineLength1Params)),
  //   Seq(("FIR",goldenModelParameters.filter1Params),("lineLength",goldenModelParameters.lineLength1Params)),
  //   Seq(("FIR",goldenModelParameters.filter1Params),("lineLength",goldenModelParameters.lineLength1Params)))

  val datapathParamsSeqs = Seq(Seq(("FIR",goldenModelParameters.filter1Params),("lineLength",goldenModelParameters.lineLength1Params)),
    Seq(("FIR",goldenModelParameters.filter1Params),("FFTBuffer",goldenModelParameters.fftBufferParams),("FFT",goldenModelParameters.fftConfig),("Bandpower",goldenModelParameters.bandpower1Params)),
    Seq(("FIR",goldenModelParameters.filter1Params),("FFTBuffer",goldenModelParameters.fftBufferParams),("FFT",goldenModelParameters.fftConfig),("Bandpower",goldenModelParameters.bandpower1Params)))

  val generatedDatapaths        : mutable.ArrayBuffer[mutable.ArrayBuffer[(String,Object)]] = mutable.ArrayBuffer()

  // In order to keep track of intermediate results, we need to store them somewhere
  // But they're all different types so we need array buffers of different types to store data for different blocks
  // Doubles will be stored here (used by FIR, IIR, lineLength, and Bandpower)
  var generatedDoubleResults  : mutable.ArrayBuffer[mutable.ArrayBuffer[Double]] = mutable.ArrayBuffer()
  var generatedFFTResults       : mutable.ArrayBuffer[mutable.ArrayBuffer[Seq[Complex]]] = mutable.ArrayBuffer()
  var generatedFFTBufferResults : mutable.ArrayBuffer[mutable.ArrayBuffer[mutable.Buffer[Double]]] = mutable.ArrayBuffer()

  val SVM = new GoldenSVM(
    goldenModelParameters.svmParams.nSupports,
    goldenModelParameters.svmParams.nFeatures,
    goldenModelParameters.svmParams.nClasses,
    goldenModelParameters.svmParams.nDegree,
    goldenModelParameters.svmParams.kernelType,
    goldenModelParameters.svmParams.classifierType,
    goldenModelParameters.svmParams.codeBook,
    flag = 0,
    c.svmParams.protoData.getClass.getTypeName)
  val PCA = new GoldenIntPCA(goldenModelParameters.pcaParams.nDimensions,goldenModelParameters.pcaParams.nFeatures)

  var referencePCAVector = Seq(Seq(5.0, 0.0, -2.0), Seq(1.0, 2.0, 3.0))
  var referenceSVMSupportVector = Seq(Seq(1.0, 2.0), Seq(3.0, 4.0))
  var referenceSVMAlphaVector = Seq(Seq(7.0, 3.0))
  var referenceSVMIntercept = Seq(4.0)

  val pcaVectorMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = c.configurationMemoryParams.nDimensions
    val nColumns: Int = c.configurationMemoryParams.nFeatures
  }

  val svmSupportVectorMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = c.configurationMemoryParams.nFeatures
    val nColumns: Int = c.configurationMemoryParams.nSupports
  }

  val svmAlphaVectorMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = c.configurationMemoryParams.nSupports
    val nColumns: Int = c.configurationMemoryParams.nClassifiers
  }

  val svmInterceptMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = c.configurationMemoryParams.nClassifiers
    val nColumns: Int = 1
  }

  for(x <- 0 until pcaVectorMemoryParams.nColumns) {
    for (y <- 0 until pcaVectorMemoryParams.nRows) {
      poke(c.io.inConf.bits.confPCAVector(x)(y), referencePCAVector(x)(y))
    }
  }
  for(x <- 0 until svmSupportVectorMemoryParams.nColumns) {
    for (y <- 0 until svmSupportVectorMemoryParams.nRows) {
      poke(c.io.inConf.bits.confSVMSupportVector(x)(y), referenceSVMSupportVector(x)(y))
    }
  }
  for(x <- 0 until svmAlphaVectorMemoryParams.nColumns) {
    for (y <- 0 until svmAlphaVectorMemoryParams.nRows) {
      poke(c.io.inConf.bits.confSVMAlphaVector(x)(y), referenceSVMAlphaVector(x)(y))
    }
  }
  for (y <- 0 until svmInterceptMemoryParams.nRows) {
    poke(c.io.inConf.bits.confSVMIntercept(y), referenceSVMIntercept(y))
  }

  for (k <- 0 until datapathParamsSeqs.length)
  {
    val singlePathParamsSeq = datapathParamsSeqs(k)
    val generatedSinglePath       : mutable.ArrayBuffer[(String,Object)] = mutable.ArrayBuffer()
    val genSinglePathResults      : mutable.ArrayBuffer[Double]       = mutable.ArrayBuffer()
    var genSingleFFTResults       : mutable.ArrayBuffer[Seq[Complex]] = mutable.ArrayBuffer()
    var genSingleBufResults       : mutable.ArrayBuffer[mutable.Buffer[Double]] = mutable.ArrayBuffer()

    for (i <- 0 until singlePathParamsSeq.length)
    {
      singlePathParamsSeq(i)._1 match
      {
        case "FIR" =>
        { // FIR
          generatedSinglePath     += (("FIR", new GoldenDoubleFIRFilter(singlePathParamsSeq(i)._2.asInstanceOf[filterGenParamsTemplate].taps)))
          genSinglePathResults    += 0.toDouble
          genSingleFFTResults     += Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0))
          genSingleBufResults     += mutable.Buffer.fill(goldenModelParameters.bandpower1Params.nBins)(0.toDouble)
        }
        case "lineLength" =>
        { // lineLength
          generatedSinglePath     += (("lineLength", new GoldenDoubleLineLength(singlePathParamsSeq(i)._2.asInstanceOf[lineLengthGenParamsTemplate].
            windowSize,wellnessGenParams1.dataType.getClass.getTypeName)))
          genSinglePathResults += 0.toDouble
          genSingleFFTResults     += Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0))
          genSingleBufResults     += mutable.Buffer.fill(goldenModelParameters.bandpower1Params.nBins)(0.toDouble)
        }
        case "FFT" =>
        {
          generatedSinglePath     += (("FFT", new GoldenDoubleFFT(goldenModelParameters.fftConfig.nPts)))
          genSinglePathResults    += 0.toDouble
          genSingleFFTResults     += Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0))
          genSingleBufResults     += mutable.Buffer.fill(goldenModelParameters.bandpower1Params.nBins)(0.toDouble)
        }
        case "FFTBuffer" =>
        {
          generatedSinglePath     += (("FFTBuffer", new GoldenFFTBuffer(goldenModelParameters.fftBufferParams.lanes)))
          genSinglePathResults    += 0.toDouble
          genSingleFFTResults     += Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0))
          genSingleBufResults     += mutable.Buffer.fill(goldenModelParameters.bandpower1Params.nBins)(0.toDouble)
        }
        case "Bandpower" =>
        {
          generatedSinglePath     += (("Bandpower", new GoldenDoubleBandpower(goldenModelParameters.bandpower1Params.nBins,
                                          goldenModelParameters.bandpower1Params.idxStartBin,
                                          goldenModelParameters.bandpower1Params.idxEndBin,
                                          wellnessGenParams1.dataType.getClass.getTypeName)))
          genSinglePathResults    += 0.toDouble
          genSingleFFTResults     += Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0))
          genSingleBufResults     += mutable.Buffer.fill(goldenModelParameters.bandpower1Params.nBins)(0.toDouble)
        }
      }
    }
    generatedDatapaths += generatedSinglePath
    generatedDoubleResults += genSinglePathResults
    generatedFFTResults += genSingleFFTResults
    generatedFFTBufferResults += genSingleBufResults
  }


  var PCA_inputs = Seq.fill(generatedDatapaths.length)(0.toDouble)
  var pcaResult = PCA.poke(PCA_inputs, referencePCAVector.map(_.map(_.toDouble)))
  var svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
    referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)


  for (i <- 0 until 50)
  {
    val input = scala.util.Random.nextDouble * 32

    // poke SVM with PCA output
    svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
      referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)

    // make a sequence of results to poke into PCA
    for (x <- 0 until generatedDoubleResults.length)
    {
        PCA_inputs = PCA_inputs.updated(x,generatedDoubleResults(x)(generatedDoubleResults(x).length - 1))
    }
    pcaResult = PCA.poke(PCA_inputs, referencePCAVector.map(_.map(_.toDouble)))

    for (k <- 0 until generatedDatapaths.length)
      {

        val generatedSinglePath     = generatedDatapaths(k)
        val genSinglePathResult     = generatedDoubleResults(k)
        val genSingleFFTPathResults = generatedFFTResults(k)
        val genSingleBufPathResults = generatedFFTBufferResults(k)
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
              case "FFTBuffer" =>
                genSingleBufPathResults(j) = generatedSinglePath(j)._2.asInstanceOf[GoldenFFTBuffer].poke(input).regs
            }
          }
          else
          {
            name match
            {
              case "FIR" =>
                genSinglePathResult(j) = generatedSinglePath(j)._2.asInstanceOf[GoldenDoubleFIRFilter].
                  poke(genSinglePathResult(j-1))
              case "lineLength" =>
                genSinglePathResult(j) = generatedSinglePath(j)._2.asInstanceOf[GoldenDoubleLineLength].
                  poke(genSinglePathResult(j-1))
              case "FFTBuffer" =>
                genSingleBufPathResults(j) = generatedSinglePath(j)._2.asInstanceOf[GoldenFFTBuffer].
                  poke(genSinglePathResult(j-1)).regs
              case "FFT" =>
                genSingleFFTPathResults(j) = generatedSinglePath(j)._2.asInstanceOf[GoldenDoubleFFT].
                  poke(genSingleBufPathResults(j-1).map(x => Complex(x.toDouble, 0.0)))
              case "Bandpower" =>
                genSinglePathResult(j) = generatedSinglePath(j)._2.asInstanceOf[GoldenDoubleBandpower].
                  poke(genSingleFFTPathResults(j-1))
            }
          }
        }
      }

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)
    step(1)

    val check_i = 0
    val check_j = generatedDoubleResults(check_i).length-1

    if (peek(c.io.out.valid) == true)
      {
        //fixTolLSBs.withValue(1)
        //{
        //  expect(c.io.out.bits, generatedDoubleResults(check_i)(check_j), s"valid ${peek(c.io.out.valid)}")
        //}
        val tolerance = 0.1 // tolerate 10% error
        for (i <- 0 until goldenModelParameters.svmParams.nClasses) {
          if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.SInt" || c.svmParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
            fixTolLSBs.withValue(204){
              expect(c.io.rawVotes(i), svmResult(0)(i))
            }
            //expect(c.io.classVotes(i), svmResult(1)(i))
          } else {
            // due to the series of multiply and accumulates, error actually blows up, let's be lenient
            fixTolLSBs.withValue(log2Ceil((svmResult(0)(i).abs*tolerance).toInt+1)+dataBP+1) { // +-16, 4 extra bits after the binary point
              expect(c.io.rawVotes(i), svmResult(0)(i))
            }
            // strict check for the class votes
            //expect(c.io.classVotes(i), svmResult(1)(i))
          }
        }
      }
    //expect(c.io.out.valid, false.B)
    //expect(c.io.out.bits, generatedDoubleResults(check_i)(check_j))
  }
}


object wellnessGenIntegrationTesterSInt {
  implicit val p: Parameters = null
  def apply(wellnessGenParams1: wellnessGenParams[SInt],
            pcaParams: PCAParams[SInt],
            svmParams: SVMParams[SInt],
            configurationMemoryParams: ConfigurationMemoryParams[SInt],
            goldenModelParameters: wellnessGenIntegrationParameterBundle, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new wellnessGenModule(
        wellnessGenParams1,
        pcaParams,
        svmParams,
        configurationMemoryParams)) {
        c => new wellnessGenTester(c,
          pcaParams,
          svmParams,
          configurationMemoryParams, goldenModelParameters, 0,0)
      }
    } else {
      dsptools.Driver.execute(() => new wellnessGenModule(
        wellnessGenParams1,
        pcaParams,
        svmParams,
        configurationMemoryParams),
        TestSetup.dspTesterOptions) {
        c => new wellnessGenTester(c,
          pcaParams,
          svmParams,
          configurationMemoryParams,
          goldenModelParameters, 0, 0)
      }
    }
  }
}
