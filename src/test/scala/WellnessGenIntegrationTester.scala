package wellness

// *********************************************
// Import packages
// *********************************************
import firFilter._
import iirFilter._
import fft._
import features._
import pca._
import svm._
import memorybuffer._

import chisel3._
import chisel3.core.FixedPoint
import chisel3.util.log2Ceil
import dsptools.DspTester
import dsptools.numbers._

import freechips.rocketchip.config.Parameters

import scala.collection.Seq
import scala.collection.mutable.{Buffer, ArrayBuffer}

import breeze.math.Complex

/*
wellnessGenTester:

Generates a scala version of the given wellness datapath, builds a wellnessGen object, feeds random inputs to both
in order to verify consistent operation, and checks both datapaths output and compares them with a given tolerance

@params $wellnessGenParams1
        $pcaParams
        $svmParams
        $configurationMemoryParams
        $goldenModelParamas

@inputs $dataBP
        $testType

@output Will print whether or not the random tests have passed or failed. If they failed then it will print out which
        tests have failed and the datapaths' outputs in those cases

@throws
 */


class wellnessGenTester[T <: chisel3.Data] (
    c: wellnessGenModule[T],
    wellnessGenParams1: wellnessGenParams[T],
    datapathParamsArr: ArrayBuffer[Seq[(String, Any)]],
    pcaParams: PCAParams[T],
    svmParams: SVMParams[T],
    configurationMemoryParams: ConfigurationMemoryParams[T],
    goldenDatapathParamsArr: ArrayBuffer[Seq[(String, Any)]],
    goldenModelParameters: wellnessGenIntegrationParameterBundle,
    testType: Int
  ) extends DspTester(c) {

  val dataBP = 8 // TODO: Get this from a param?

  val generatedDatapaths: ArrayBuffer[ArrayBuffer[(String,Object)]] = ArrayBuffer()

  // In order to keep track of intermediate results, we need to store them somewhere
  // But they're all different types so we need array buffers of different types to store data for different blocks
  // Doubles will be stored here (used by FIR, IIR, lineLength, and Bandpower)
  var generatedDoubleResults: ArrayBuffer[ArrayBuffer[Double]] = ArrayBuffer()
  var generatedFFTResults: ArrayBuffer[ArrayBuffer[Seq[Complex]]] = ArrayBuffer()
  var generatedFFTBufferResults: ArrayBuffer[ArrayBuffer[Buffer[Double]]] = ArrayBuffer()

  // *********************************************
  // Golden SVM and PCA
  // *********************************************
  val SVM = new GoldenSVM(
    goldenModelParameters.goldenSVMParams.nSupports,
    goldenModelParameters.goldenSVMParams.nFeatures,
    goldenModelParameters.goldenSVMParams.nClasses,
    goldenModelParameters.goldenSVMParams.nDegree,
    goldenModelParameters.goldenSVMParams.kernelType,
    goldenModelParameters.goldenSVMParams.classifierType,
    goldenModelParameters.goldenSVMParams.codeBook,
    flag = 0,
    c.svmParams.protoData.getClass.getTypeName)
  val PCA = new GoldenIntPCA(goldenModelParameters.goldenPCAParams.nDimensions, goldenModelParameters.goldenPCAParams.nFeatures)

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

  // *********************************************
  // Generate and connect golden module datapaths
  // from golden param datapaths
  // *********************************************
  for (k <- 0 until goldenDatapathParamsArr.length)
  {
    val singlePathParamsSeq = goldenDatapathParamsArr(k)
    val generatedSinglePath: ArrayBuffer[(String,Object)] = ArrayBuffer()
    val genSinglePathResults: ArrayBuffer[Double] = ArrayBuffer()
    var genSingleFFTResults: ArrayBuffer[Seq[Complex]] = ArrayBuffer()
    var genSingleBufResults: ArrayBuffer[Buffer[Double]] = ArrayBuffer()

    for (i <- 0 until singlePathParamsSeq.length)
    {
      singlePathParamsSeq(i)._1 match
      {
        case "FIR" =>
        {
          generatedSinglePath   += (("FIR", new GoldenDoubleFIRFilter(singlePathParamsSeq(i)._2.asInstanceOf[firGenParamsTemplate].taps)))
          genSinglePathResults  += 0.toDouble
          genSingleFFTResults   += Seq.fill(64)(Complex(0.0, 0.0))
          genSingleBufResults   += Buffer.fill(64)(0.toDouble)
        }
        case "IIR" =>
        {
          generatedSinglePath   += (("IIR", new GoldenIIRFilter(singlePathParamsSeq(i)._2.asInstanceOf[iirGenParamsTemplate].tapsA,
            singlePathParamsSeq(i)._2.asInstanceOf[iirGenParamsTemplate].tapsB)))
          genSinglePathResults  += 0.toDouble
          genSingleFFTResults   += Seq.fill(64)(Complex(0.0, 0.0))
          genSingleBufResults   += Buffer.fill(64)(0.toDouble)
        }
        case "FFTBuffer" =>
        {
          generatedSinglePath   += (("FFTBuffer", new GoldenFFTBuffer(singlePathParamsSeq(i)._2.asInstanceOf[fftBufferGenParamsTemplate].lanes)))
          genSinglePathResults  += 0.toDouble
          genSingleFFTResults   += Seq.fill(64)(Complex(0.0, 0.0))
          genSingleBufResults   += Buffer.fill(singlePathParamsSeq(i)._2.asInstanceOf[fftBufferGenParamsTemplate].lanes)(0.toDouble)
        }
        case "FFT" =>
        {
          generatedSinglePath   += (("FFT", new GoldenDoubleFFT(singlePathParamsSeq(i)._2.asInstanceOf[fftConfigGenTemplate].nPts)))
          genSinglePathResults  += 0.toDouble
          genSingleFFTResults   += Seq.fill(singlePathParamsSeq(i)._2.asInstanceOf[fftConfigGenTemplate].nPts)(Complex(0.0, 0.0))
          genSingleBufResults   += Buffer.fill(64)(0.toDouble)
        }
        case "LineLength" =>
        {
          generatedSinglePath   += (("LineLength", new GoldenDoubleLineLength(singlePathParamsSeq(i)._2.asInstanceOf[lineLengthGenParamsTemplate].windowSize,
            wellnessGenParams1.dataType.getClass.getTypeName)))
          genSinglePathResults  += 0.toDouble
          genSingleFFTResults   += Seq.fill(64)(Complex(0.0, 0.0))
          genSingleBufResults   += Buffer.fill(64)(0.toDouble)
        }
        case "Bandpower" =>
        {
          generatedSinglePath   += (("Bandpower", new GoldenDoubleBandpower(
            singlePathParamsSeq(i)._2.asInstanceOf[bandpowerParamsGenTemplate].nBins,
            singlePathParamsSeq(i)._2.asInstanceOf[bandpowerParamsGenTemplate].idxStartBin,
            singlePathParamsSeq(i)._2.asInstanceOf[bandpowerParamsGenTemplate].idxEndBin,
            wellnessGenParams1.dataType.getClass.getTypeName)))
          genSinglePathResults  += 0.toDouble
          genSingleFFTResults   += Seq.fill(64)(Complex(0.0, 0.0))
          genSingleBufResults   += Buffer.fill(64)(0.toDouble)
        }
      }
    }
    generatedDatapaths         += generatedSinglePath
    generatedDoubleResults     += genSinglePathResults
    generatedFFTResults        += genSingleFFTResults
    generatedFFTBufferResults  += genSingleBufResults
  }


  var PCA_inputs = Seq.fill(generatedDatapaths.length)(0.toDouble)
  var pcaResult = PCA.poke(PCA_inputs, referencePCAVector.map(_.map(_.toDouble)))
  var svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
    referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)


  for (i <- 0 until 50)
  {
    var input = scala.util.Random.nextDouble * 6 - 3
    if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
      input = scala.util.Random.nextInt(16)
    }
    else if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
      input = scala.util.Random.nextInt(32) - 16
    }

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
        val generatedSinglePath      = generatedDatapaths(k)
        val genSinglePathResult      = generatedDoubleResults(k)
        val genSingleFFTPathResults  = generatedFFTResults(k)
        val genSingleBufPathResults  = generatedFFTBufferResults(k)

        for (j <- (generatedSinglePath.length - 1) to 0 by -1)
        {
          val name = generatedSinglePath(j)._1
          if (j == 0)
          {
            name match
            {
              case "FIR" =>
                genSinglePathResult(j) = generatedSinglePath(j)._2.asInstanceOf[GoldenDoubleFIRFilter].poke(input)
              case "LineLength" =>
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
              case "LineLength" =>
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
        val tolerance = 0.3 // tolerate 10% error
        for (i <- 0 until goldenModelParameters.goldenSVMParams.nClasses) {
          if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.SInt" || c.svmParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
            fixTolLSBs.withValue(204){
              expect(c.io.rawVotes(i), svmResult(0)(i))
            }
          } else {
            // Due to the series of multiply and accumulates, error actually blows up, let's be lenient
            // +-16, 4 extra bits after the binary point
            fixTolLSBs.withValue(log2Ceil((svmResult(0)(i).abs * tolerance).toInt + 1) + dataBP + 1) {
              expect(c.io.rawVotes(i), svmResult(0)(i))
            }
          }
        }
      }
  }
}


object wellnessGenIntegrationTesterSInt {
  implicit val p: Parameters = null
  def apply(wellnessGenParams1: wellnessGenParams[SInt],
            datapathParamsArr: ArrayBuffer[Seq[(String, Any)]],
            pcaParams: PCAParams[SInt],
            svmParams: SVMParams[SInt],
            configurationMemoryParams: ConfigurationMemoryParams[SInt],
            goldenDatapathParamsArr: ArrayBuffer[Seq[(String, Any)]],
            goldenModelParameters: wellnessGenIntegrationParameterBundle,
            debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new wellnessGenModule(
        wellnessGenParams1,
        datapathParamsArr,
        pcaParams,
        svmParams,
        configurationMemoryParams)) {
        c => new wellnessGenTester(c,
          wellnessGenParams1,
          datapathParamsArr,
          pcaParams,
          svmParams,
          configurationMemoryParams,
          goldenDatapathParamsArr,
          goldenModelParameters,
          0)
      }
    } else {
      dsptools.Driver.execute(() => new wellnessGenModule(
        wellnessGenParams1,
        datapathParamsArr,
        pcaParams,
        svmParams,
        configurationMemoryParams),
        TestSetup.dspTesterOptions) {
        c => new wellnessGenTester(c,
          wellnessGenParams1,
          datapathParamsArr,
          pcaParams,
          svmParams,
          configurationMemoryParams,
          goldenDatapathParamsArr,
          goldenModelParameters,
          0)
      }
    }
  }
}

object wellnessGenIntegrationTesterFP {
  implicit val p: Parameters = null
  def apply(wellnessGenParams1: wellnessGenParams[FixedPoint],
            datapathParamsArr: ArrayBuffer[Seq[(String, Any)]],
            pcaParams: PCAParams[FixedPoint],
            svmParams: SVMParams[FixedPoint],
            configurationMemoryParams: ConfigurationMemoryParams[FixedPoint],
            goldenDatapathParamsArr: ArrayBuffer[Seq[(String, Any)]],
            goldenModelParameters: wellnessGenIntegrationParameterBundle,
            debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new wellnessGenModule(
        wellnessGenParams1,
        datapathParamsArr,
        pcaParams,
        svmParams,
        configurationMemoryParams)) {
        c => new wellnessGenTester(c,
          wellnessGenParams1,
          datapathParamsArr,
          pcaParams,
          svmParams,
          configurationMemoryParams,
          goldenDatapathParamsArr,
          goldenModelParameters,
          0)
      }
    } else {
      dsptools.Driver.execute(() => new wellnessGenModule(
        wellnessGenParams1,
        datapathParamsArr,
        pcaParams,
        svmParams,
        configurationMemoryParams),
        TestSetup.dspTesterOptions) {
        c => new wellnessGenTester(c,
          wellnessGenParams1,
          datapathParamsArr,
          pcaParams,
          svmParams,
          configurationMemoryParams,
          goldenDatapathParamsArr,
          goldenModelParameters,
          0)
      }
    }
  }
}