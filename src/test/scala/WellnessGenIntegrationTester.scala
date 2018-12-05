package wellness

// *********************************************
// Import packages
// *********************************************
import java.io.{File, FileWriter}

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
import scala.collection.mutable.{ArrayBuffer, Buffer}
import breeze.math.Complex

/**
  * wellnessGenTester:
  *
  * Generates a scala version of the given wellness datapath, builds a wellnessGen object, feeds random inputs to both
  * in order to verify consistent operation, and checks both datapaths output and compares them with a given tolerance
  *
  * @params $wellnessGenParams1
  *         $pcaParams
  *         $svmParams
  *         $configurationMemoryParams
  *         $goldenModelParamas
  * @inputs $dataBP
  *         $testType
  * @output Will print whether or not the random tests have passed or failed. If they failed then it will print out which
  *         tests have failed and the datapaths' outputs in those cases
  * @throws
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

  val dataWidth = utilities.readCSV("scripts/generated_files/datasize.csv").flatMap(_.map(_.toInt)).head
  val dataBP = utilities.readCSV("scripts/generated_files/datasize.csv").flatMap(_.map(_.toInt)).last

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
  val PCANormalizer = new GoldenIntPCANormalizer(goldenModelParameters.goldenPCAParams.nDimensions)
  val PCA = new GoldenIntPCA(goldenModelParameters.goldenPCAParams.nDimensions, goldenModelParameters.goldenPCAParams.nFeatures)

  var referencePCAVector = Seq(Seq(5.0, 0.0, -2.0), Seq(1.0, 2.0, 3.0))
  var referenceSVMSupportVector = Seq(Seq(1.0, 2.0), Seq(3.0, 4.0))
  var referenceSVMAlphaVector = Seq(Seq(7.0, 3.0))
  var referenceSVMIntercept = Seq(4.0)
  var referencePCANormalizationData = Seq(Seq(10.0,2.0),Seq(3.0,5.0),Seq(1.0,1.0))

  // If doing test with Python model
  if (testType == 1) { // this is the file loading sequence for the configuration parameters
    referencePCAVector = utilities.readCSV("scripts/generated_files/pca_vectors.csv").map(_.map(_.toDouble))
    referenceSVMSupportVector = utilities.readCSV("scripts/generated_files/support_vectors.csv").map(_.map(_.toDouble))
    referenceSVMAlphaVector = utilities.readCSV("scripts/generated_files/alpha_vectors.csv").map(_.map(_.toDouble))
    referenceSVMIntercept = utilities.readCSV("scripts/generated_files/intercepts.csv").flatMap(_.map(_.toDouble))
    referencePCANormalizationData = utilities.readCSV("scripts/generated_files/normalization.csv").map(_.map(_.toDouble))
  }

  poke(c.io.inConf.bits.confInputMuxSel, 0)

  val pcaVectorMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = c.configurationMemoryParams.nDimensions
    val nColumns: Int = c.configurationMemoryParams.nFeatures
  }

  val pcaNormalizationMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = 2
    val nColumns: Int = c.configurationMemoryParams.nDimensions
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
  for(x <- 0 until pcaNormalizationMemoryParams.nColumns) {
    for (y <- 0 until pcaNormalizationMemoryParams.nRows) {
      poke(c.io.inConf.bits.confPCANormalizationData(x)(y), referencePCANormalizationData(x)(y))
    }
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
        case "Buffer" =>
        {
          // Buffer doesn't actually need an FIR filter - it's just a dummy object to appease scala's type checking
          // Instead buffer will literally just be a pass through
          generatedSinglePath   += (("Buffer", new GoldenDoubleFIRFilter(Seq.fill(3)(0.0))))
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

  // *********************************************
  // Initialize results
  // *********************************************
  var PCA_inputs = Seq.fill(generatedDatapaths.length)(0.toDouble)
  var pcaNormalizerResult = PCANormalizer.poke(Seq(0,0,0),referencePCANormalizationData.map(_.map(_.toDouble)))
  var pcaResult = PCA.poke(PCA_inputs, referencePCAVector.map(_.map(_.toDouble)))
  var svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
    referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)

  // *********************************************
  // Loop over inputs
  // *********************************************
  var referenceInput = Seq(0.0)
  if (testType == 1) { // load the input matrix
    referenceInput = utilities.readCSV("scripts/generated_files/input.csv").flatMap(_.map(_.toDouble))
  }

  if (testType == 1) { // create the .h file to contain the reference arrays
    val Seq(windowLength, features, dimensions, supports, classes, degree) =
    /* This is the order of parameters, as written in the Python file, for reference
    fe.window,                  # windowSize, lanes, nPts, nBins
    pca.components_.shape[0],   # nFeatures
    pca.components_.shape[1],   # nDimensions
    supports.shape[0],          # nSupports
    classes,                    # nClasses
    degree                      # nDegree */
      utilities.readCSV("scripts/generated_files/parameters.csv").flatMap(_.map(_.toInt))
    val nFFT: Int = windowLength
    val filterTapsA = utilities.readCSV("scripts/generated_files/filter_taps.csv").flatMap(_.map(_.toDouble))
    val file = new FileWriter(new File("tests/arrays.h"))
    // write out the preambles and define statements
    file.write( "#ifndef __ARRAY_H__\n" +
      "#define __ARRAY_H__\n\n" +
      f"#define DIMENSIONS ${c.configurationMemoryParams.nDimensions}         // number of channels going into the PCA\n" +
      f"#define FEATURES ${c.configurationMemoryParams.nFeatures}           // number of reduced dimensions going into the SVM\n" +
      f"#define SUPPORTS ${c.configurationMemoryParams.nSupports}           // number of support vectors for SVM\n" +
      f"#define CLASSIFIERS ${c.configurationMemoryParams.nClassifiers}        // number of classifiers created\n\n" +

      f"#define NUMTAPS ${filterTapsA.length}         // number of filter taps, for output adjustment\n" +
      f"#define WINDOW ${nFFT}         // number of lanes/bins/window, for output adjustment\n\n" +

      f"#define DATA_WIDTH $dataWidth         // total bit size\n" +
      f"#define DATA_BP $dataBP         // number of fractional components\n\n")

    // write out all the configuration matrices to the file
    file.write("static double pcaVector[FEATURES][DIMENSIONS] = ")
    file.write(referencePCAVector.map(_.mkString("{", ", ", "}")).mkString("{", ", ", "};\n\n"))

    file.write("static double SVMSupportVector[SUPPORTS][FEATURES] = ")
    file.write(referenceSVMSupportVector.map(_.mkString("{", ", ", "}")).mkString("{", ", ", "};\n\n"))

    file.write("static double SVMAlphaVector[CLASSIFIERS][SUPPORTS] = ")
    file.write(referenceSVMAlphaVector.map(_.mkString("{", ", ", "}")).mkString("{", ", ", "};\n\n"))

    file.write("static double SVMIntercept[CLASSIFIERS] = ")
    file.write(referenceSVMIntercept.mkString("{", ", ", "};\n\n"))

    file.write("static double PCANormVector[DIMENSIONS][2] = ")
    file.write(referencePCANormalizationData.map(_.mkString("{", ", ", "}")).mkString("{", ", ", "};\n\n"))

    file.write("static double in[] = ")
    file.write(referenceInput.mkString("{", ", ", "};\n\n"))

    file.close()
  }

  val outputContainer = ArrayBuffer[Array[Double]]() // this will hold the rawVotes from SVM for printout
  for (i <- 0 until 100)
  {
    var input = scala.util.Random.nextDouble * 4 - 2
    if (testType == 1) {
      input = referenceInput(i)
    }
    else {
      if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
        input = scala.util.Random.nextInt(16)
      }
      else if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
        input = scala.util.Random.nextInt(32) - 16
      }
    }

    // poke SVM with PCA output
    svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
      referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)

    // make a sequence of results to poke into PCA
    for (x <- 0 until generatedDoubleResults.length)
    {
        PCA_inputs = PCA_inputs.updated(x,generatedDoubleResults(x)(generatedDoubleResults(x).length - 1))
    }
    pcaResult = PCA.poke(pcaNormalizerResult, referencePCAVector.map(_.map(_.toDouble)))
    pcaNormalizerResult = PCANormalizer.poke(PCA_inputs, referencePCANormalizationData.map(_.map(_.toDouble)))

    // Get golden model results
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
            case "Buffer" =>
              genSinglePathResult(j) = input
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
            case "Buffer" =>
              genSinglePathResult(j) = genSinglePathResult(j-1)
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
      val tolerance = 0.1 // tolerate 10% error
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
      outputContainer += svmResult(0).toArray // inside the valid checks, only the valid outputs are recorded
    }
  }

  if (testType == 1) { // write out the expected rawVotes to the file
    val file = new FileWriter("tests/arrays.h",true)
    file.write("static double ex[][2] = ")
    file.write(outputContainer.map(_.mkString("{", ", ", "}")).mkString("{", ", ", "};\n\n"))

    file.write("#endif\n") // the end of the .h file

    file.close()
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
            debug: Int,
            testType: Int): Boolean = {
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
          testType)
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
          testType)
      }
    }
  }
}