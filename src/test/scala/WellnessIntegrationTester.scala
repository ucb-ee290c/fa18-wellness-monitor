package wellness

import java.io._

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
import scala.collection.Seq

class wellnessTester[T <: chisel3.Data](c: WellnessModule[T], goldenModelParameters: wellnessIntegrationParameterBundle, testType: Int) extends DspTester(c) {

  // Instantiate golden models
  val filter1 = new GoldenDoubleFIRFilter(goldenModelParameters.filter1Params.taps)
  val lineLength1 = new GoldenDoubleLineLength(goldenModelParameters.lineLength1Params.windowSize,c.lineLength1Params.protoData.getClass.getTypeName)
  val fftBuffer = new GoldenFFTBuffer(goldenModelParameters.fftBufferParams.lanes)
  val fft = new GoldenDoubleFFT(goldenModelParameters.fftConfig.nPts)
  val bandpower1 = new GoldenDoubleBandpower(
    goldenModelParameters.bandpower1Params.nBins,
    goldenModelParameters.bandpower1Params.idxStartBin,
    goldenModelParameters.bandpower1Params.idxEndBin,
    c.bandpower1Params.genOut.getClass.getTypeName
    )
  val bandpower2 = new GoldenDoubleBandpower(
    goldenModelParameters.bandpower2Params.nBins,
    goldenModelParameters.bandpower2Params.idxStartBin,
    goldenModelParameters.bandpower2Params.idxEndBin,
    c.bandpower2Params.genOut.getClass.getTypeName
  )
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

  var input = scala.util.Random.nextFloat*16 - 8
  if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
    input = scala.util.Random.nextInt(16)
  }
  else if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
    input = scala.util.Random.nextInt(32) - 16
  }

  var referencePCAVector = Seq(Seq(5.0, 0.0, -2.0), Seq(1.0, 2.0, 3.0))
  var referenceSVMSupportVector = Seq(Seq(1.0, 2.0), Seq(3.0, 4.0))
  var referenceSVMAlphaVector = Seq(Seq(7.0, 3.0))
  var referenceSVMIntercept = Seq(4.0)

  if (testType == 1) { // this is the file loading sequence for the configuration parameters
    referencePCAVector = utilities.readCSV("scripts/generated_files/pca_vectors.csv").map(_.map(_.toDouble))
    referenceSVMSupportVector = utilities.readCSV("scripts/generated_files/support_vectors.csv").map(_.map(_.toDouble))
    referenceSVMAlphaVector = utilities.readCSV("scripts/generated_files/alpha_vectors.csv").map(_.map(_.toDouble))
    referenceSVMIntercept = utilities.readCSV("scripts/generated_files/intercepts.csv").flatMap(_.map(_.toDouble))
  }

  poke(c.io.inConf.bits.confInputMuxSel, 0)

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

  var bandpower1Result = bandpower1.poke(Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0)))
  var bandpower2Result = bandpower2.poke(Seq.fill(goldenModelParameters.bandpower2Params.nBins)(Complex(0.0, 0.0)))
  var fftResult = fft.poke(Seq.fill(goldenModelParameters.fftConfig.nPts)(Complex(0.0, 0.0)))
  var fftBufferResult = fftBuffer.poke(0.0)

  var lineLength1Result = lineLength1.poke(value = 0)
  var filter1Result = filter1.poke(0)

  var pcaInputBundle = Seq(lineLength1Result, bandpower1Result, bandpower2Result)
  var pcaResult = PCA.poke(Seq(0,0,0),referencePCAVector.map(_.map(_.toDouble)))
  var svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
    referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)

  var dataWidth = 0
  var dataBP = 0
  // determine the dataWidth and dataBP parameters
  if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.FixedPoint") {
    dataWidth = utilities.readCSV("scripts/generated_files/datasize.csv").flatMap(_.map(_.toInt)).head
    dataBP = utilities.readCSV("scripts/generated_files/datasize.csv").flatMap(_.map(_.toInt)).last
  }

  var referenceInput = Seq(0.0)
  if (testType == 1) { // load the input matrix
    referenceInput = utilities.readCSV("scripts/generated_files/input.csv").flatMap(_.map(_.toDouble))
  }

  if (testType == 1) { // create the .h file to contain the reference arrays
    val file = new FileWriter(new File("tests/arrays.h"))
    // write out the preambles and define statements
    file.write( "#ifndef __ARRAY_H__\n" +
                      "#define __ARRAY_H__\n\n" +
                      f"#define DIMENSIONS ${c.configurationMemoryParams.nDimensions}         // number of channels going into the PCA\n" +
                      f"#define FEATURES ${c.configurationMemoryParams.nFeatures}           // number of reduced dimensions going into the SVM\n" +
                      f"#define SUPPORTS ${c.configurationMemoryParams.nSupports}           // number of support vectors for SVM\n" +
                      f"#define CLASSIFIERS ${c.configurationMemoryParams.nClassifiers}        // number of classifiers created\n\n" +

                      f"#define NUMTAPS ${goldenModelParameters.filter1Params.taps.length}         // number of filter taps, for output adjustment\n" +
                      f"#define WINDOW ${goldenModelParameters.bandpower1Params.nBins}         // number of lanes/bins/window, for output adjustment\n\n" +

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

    file.write("static double in[] = ")
    file.write(referenceInput.mkString("{", ", ", "};\n\n"))

    file.close()
  }

  val outputContainer = ArrayBuffer[Array[Double]]() // this will hold the rawVotes from SVM for printout
  for (i <- 0 until 100) {

    var input = scala.util.Random.nextDouble * 6 - 3

    if (testType == 1) {
      input = referenceInput(i)

    } else {
      if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
        input = scala.util.Random.nextInt(16)
      }
      else if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
        input = scala.util.Random.nextInt(32) - 16
      }
    }

    // Poke inputs to golden models
    bandpower1Result = bandpower1.poke(fftResult)
    bandpower2Result = bandpower2.poke(fftResult)
    fftResult = fft.poke(fftBufferResult.regs.map(x => Complex(x.toDouble, 0.0)))
    fftBufferResult = fftBuffer.poke(filter1Result)

    lineLength1Result = lineLength1.poke(value = filter1Result)
    filter1Result = filter1.poke(input)

    pcaInputBundle = Seq(lineLength1Result, bandpower1Result, bandpower2Result)
    pcaResult = PCA.poke(pcaInputBundle, referencePCAVector.map(_.map(_.toDouble)))
    svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
      referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)

    // Poke inputs to real thing
    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)
    step(1)

    // Expect Results
    if (peek(c.io.lineLengthValid) && peek(c.io.bandpower1Valid) && peek(c.io.bandpower2Valid)) {
      //val tolerance = dataBP + 6
      val tolerance = 0.1 // tolerate 10% error
      if (c.lineLength1Params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
        expect(c.io.filterOut, filter1Result)
        expect(c.io.lineOut, lineLength1Result)
        expect(c.io.bandpower1Out, bandpower1Result)
        expect(c.io.bandpower2Out, bandpower2Result)
      } else {
        fixTolLSBs.withValue(log2Ceil((bandpower1Result.abs*tolerance).toInt+1)+dataBP+1) {
          expect(c.io.filterOut, filter1Result)
          expect(c.io.lineOut, lineLength1Result)
          expect(c.io.bandpower1Out, bandpower1Result)
          expect(c.io.bandpower2Out, bandpower2Result)
        }
      }

      for (i <- 0 until goldenModelParameters.fftBufferParams.lanes) {
        if (c.fftBufferParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
          expect(c.io.fftBufferOut(i), fftBufferResult.regs(i))
        } else {
          fixTolLSBs.withValue(log2Ceil((fftBufferResult.regs(i).abs*tolerance).toInt+1)+dataBP+1) { // at least the integer part must match
            expect(c.io.fftBufferOut(i), fftBufferResult.regs(i))
          }
        }
      }

      for (i <- 0 until goldenModelParameters.fftConfig.nPts) {
        if (c.fftConfig.genOut.real.getClass.getTypeName == "chisel3.core.SInt") {
          expect(c.io.fftOut(i), fftResult(i))
        } else {
          fixTolLSBs.withValue(log2Ceil((fftResult(i).real.abs*tolerance).toInt+1)+dataBP+1) { // at least the integer part must match
            expect(c.io.fftOut(i), fftResult(i))
          }
        }
      }

      for (i <- 0 until goldenModelParameters.pcaParams.nFeatures) {
        if (c.pcaParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
          expect(c.io.pcaOut(i), pcaResult(i))
        } else {
          // due to the series of multiply and accumulates, error actually blows up, let's be lenient
          fixTolLSBs.withValue(log2Ceil((pcaResult(i).abs*tolerance).toInt+1)+dataBP+1) { // at least the integer part must match
            expect(c.io.pcaOut(i), pcaResult(i))
          }
        }
      }

      for (i <- 0 until goldenModelParameters.svmParams.nClasses) {
        if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.SInt" || c.svmParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
          expect(c.io.rawVotes(i), svmResult(0)(i))
          expect(c.io.classVotes(i), svmResult(1)(i))
        } else {
          // due to the series of multiply and accumulates, error actually blows up, let's be lenient
          fixTolLSBs.withValue(log2Ceil((svmResult(0)(i).abs*tolerance).toInt+1)+dataBP+1) { // +-16, 4 extra bits after the binary point
            expect(c.io.rawVotes(i), svmResult(0)(i))
          }
          // strict check for the class votes
          expect(c.io.classVotes(i), svmResult(1)(i))
        }
      }
      outputContainer += svmResult(0).toArray // inside the valid checks, only the valid outputs are recorded
    }
    //outputContainer += svmResult(0).toArray // outside the valid checks, if you want to include the false outputs
  }

  if (testType == 1) { // write out the expected rawVotes to the file
    val file = new FileWriter("tests/arrays.h",true)
    file.write("static double ex[][2] = ")
    file.write(outputContainer.map(_.mkString("{", ", ", "}")).mkString("{", ", ", "};\n\n"))

    file.write("#endif\n") // the end of the .h file

    file.close()
  }
}

object WellnessIntegrationTesterSInt {
  implicit val p: Parameters = null
  def apply(filter1Params: FIRFilterParams[SInt],
            lineLength1Params: lineLengthParams[SInt],
            fftBufferParams: FFTBufferParams[SInt],
            fftConfig: FFTConfig[SInt],
            bandpower1Params: BandpowerParams[SInt],
            bandpower2Params: BandpowerParams[SInt],
            pcaParams: PCAParams[SInt],
            svmParams: SVMParams[SInt],
            configurationMemoryParams: ConfigurationMemoryParams[SInt],
            goldenModelParameters: wellnessIntegrationParameterBundle, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new WellnessModule(
        filter1Params: FIRFilterParams[SInt],
        lineLength1Params: lineLengthParams[SInt],
        fftBufferParams: FFTBufferParams[SInt],
        fftConfig: FFTConfig[SInt],
        bandpower1Params: BandpowerParams[SInt],
        bandpower2Params: BandpowerParams[SInt],
        pcaParams: PCAParams[SInt],
        svmParams: SVMParams[SInt],
        configurationMemoryParams: ConfigurationMemoryParams[SInt])) {
        c => new wellnessTester(c, goldenModelParameters,0)
      }
    } else {
      dsptools.Driver.execute(() => new WellnessModule(
        filter1Params: FIRFilterParams[SInt],
        lineLength1Params: lineLengthParams[SInt],
        fftBufferParams: FFTBufferParams[SInt],
        fftConfig: FFTConfig[SInt],
        bandpower1Params: BandpowerParams[SInt],
        bandpower2Params: BandpowerParams[SInt],
        pcaParams: PCAParams[SInt],
        svmParams: SVMParams[SInt],
        configurationMemoryParams: ConfigurationMemoryParams[SInt]),
        TestSetup.dspTesterOptions) {
        c => new wellnessTester(c, goldenModelParameters, 0)
      }
    }
  }
}

object WellnessIntegrationTesterFP {
  implicit val p: Parameters = null
  def apply(filter1Params: FIRFilterParams[FixedPoint],
            lineLength1Params: lineLengthParams[FixedPoint],
            fftBufferParams: FFTBufferParams[FixedPoint],
            fftConfig: FFTConfig[FixedPoint],
            bandpower1Params: BandpowerParams[FixedPoint],
            bandpower2Params: BandpowerParams[FixedPoint],
            pcaParams: PCAParams[FixedPoint],
            svmParams: SVMParams[FixedPoint],
            configurationMemoryParams: ConfigurationMemoryParams[FixedPoint],
            goldenModelParameters: wellnessIntegrationParameterBundle, debug: Int, testType: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "verilator", "-fiwv"), () => new WellnessModule(
        filter1Params: FIRFilterParams[FixedPoint],
        lineLength1Params: lineLengthParams[FixedPoint],
        fftBufferParams: FFTBufferParams[FixedPoint],
        fftConfig: FFTConfig[FixedPoint],
        bandpower1Params: BandpowerParams[FixedPoint],
        bandpower2Params: BandpowerParams[FixedPoint],
        pcaParams: PCAParams[FixedPoint],
        svmParams: SVMParams[FixedPoint],
        configurationMemoryParams: ConfigurationMemoryParams[FixedPoint])) {
        c => new wellnessTester(c, goldenModelParameters, testType)
      }
    } else {
      dsptools.Driver.execute(() => new WellnessModule(
        filter1Params: FIRFilterParams[FixedPoint],
        lineLength1Params: lineLengthParams[FixedPoint],
        fftBufferParams: FFTBufferParams[FixedPoint],
        fftConfig: FFTConfig[FixedPoint],
        bandpower1Params: BandpowerParams[FixedPoint],
        bandpower2Params: BandpowerParams[FixedPoint],
        pcaParams: PCAParams[FixedPoint],
        svmParams: SVMParams[FixedPoint],
        configurationMemoryParams: ConfigurationMemoryParams[FixedPoint]),
        TestSetup.dspTesterOptions) {
        c => new wellnessTester(c, goldenModelParameters, testType)
      }
    }
  }
}
