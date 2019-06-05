/*
package wellness

import chisel3.experimental.FixedPoint
import chisel3.util.log2Ceil
import dsptools.DspTester
import dsptools.numbers._
import firFilter._
import features._
import memorybuffer._
import svm._
import freechips.rocketchip.config.Parameters

import scala.collection.mutable.ArrayBuffer
import scala.collection.Seq

class wellnessTester[T <: chisel3.Data](c: WellnessModule[T], goldenModelParameters: wellnessIntegrationParameterBundle, testType: Int) extends DspTester(c) {

  // Instantiate golden models
  val filter1 = new GoldenDoubleFIRFilter(goldenModelParameters.filter1Params.taps)
  val lineLength1 = new GoldenDoubleLineLength(goldenModelParameters.lineLength1Params.windowSize,c.lineLength1Params.protoData.getClass.getTypeName)
  val filterAlpha = new GoldenDoubleFIRFilter(goldenModelParameters.filterAlphaParams.taps)
  val filterBeta = new GoldenDoubleFIRFilter(goldenModelParameters.filterBetaParams.taps)
  val filterGamma = new GoldenDoubleFIRFilter(goldenModelParameters.filterGammaParams.taps)
  val bandpowerAlpha = new GoldenDoublesumSquares(goldenModelParameters.bandpowerParams.windowSize,c.bandpowerParams.protoData.getClass.getTypeName)
  val bandpowerBeta = new GoldenDoublesumSquares(goldenModelParameters.bandpowerParams.windowSize,c.bandpowerParams.protoData.getClass.getTypeName)
  val bandpowerGamma = new GoldenDoublesumSquares(goldenModelParameters.bandpowerParams.windowSize,c.bandpowerParams.protoData.getClass.getTypeName)
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

  var input = scala.util.Random.nextFloat*16 - 8
  if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
    input = scala.util.Random.nextInt(16)
  }
  else if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
    input = scala.util.Random.nextInt(32) - 16
  }

  // Define some arbitrary default values for PCA and SVM to be used in random input tests
  var referenceSVMSupportVector = Seq(Seq(1.0, 2.0, 3.0, 4.0), Seq(3.0, 4.0, 5.0, 6.0))
  var referenceSVMAlphaVector = Seq(Seq(7.0, 3.0))
  var referenceSVMIntercept = Seq(4.0)

  // Configure the input mux selection to accept data from RISC-V core instead of external input
  poke(c.io.inConf.bits.confInputMuxSel, 0)

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

  // Fill the configuration inputs of the DUT

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

  // poke initial values, as well as the declaration of the variables, set to 0 first
  var svmResult = SVM.poke(Seq.fill(goldenModelParameters.svmParams.nFeatures)(0.0), referenceSVMSupportVector.map(_.map(_.toDouble)),
    referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)

  var bandpowerAlphaResult = bandpowerAlpha.poke(value = 0)
  var bandpowerBetaResult = bandpowerBeta.poke(value = 0)
  var bandpowerGammaResult = bandpowerGamma.poke(value = 0)

  var filterAlphaResult = filterAlpha.poke(0)
  var filterBetaResult = filterBeta.poke(0)
  var filterGammaResult = filterGamma.poke(0)

  var lineLength1Result = lineLength1.poke(value = 0)
  // pipeline 'registers' to delay line length result for bandpower alignment
  var lineLength1ResultReg1 = 0.0
  var filter1Result = filter1.poke(0)

  var FeatureBundle = Seq(bandpowerAlphaResult, bandpowerBetaResult, bandpowerGammaResult, lineLength1ResultReg1)

  var dataWidth = 0
  var dataBP = 0
  // determine the dataWidth and dataBP parameters override for Fixed Point numbers
  if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.FixedPoint") {
    dataWidth = utilities.readCSV("scripts/generated_files/datasize.csv").flatMap(_.map(_.toInt)).head
    dataBP = utilities.readCSV("scripts/generated_files/datasize.csv").flatMap(_.map(_.toInt)).last
  }

  var referenceInput = Seq(0.0)

  val tolerance = 0.15 // tolerate 10% error
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
    // The order of poking matters. For sequential modules connected to eachother, poking should be from last-to-first.
    // For combinational modules between sequential modules, it should be from first-to-last.
    svmResult = SVM.poke(FeatureBundle.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
      referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)
    FeatureBundle = Seq(bandpowerAlphaResult, bandpowerBetaResult, bandpowerGammaResult, lineLength1ResultReg1)

    bandpowerAlphaResult = bandpowerAlpha.poke(filterAlphaResult)
    bandpowerBetaResult = bandpowerBeta.poke(filterBetaResult)
    bandpowerGammaResult = bandpowerGamma.poke(filterGammaResult)

    filterAlphaResult = filterAlpha.poke(filter1Result)
    filterBetaResult = filterBeta.poke(filter1Result)
    filterGammaResult = filterGamma.poke(filter1Result)

    // pipeline 'register' to delay line length result for bandpower alignment
    lineLength1ResultReg1 = lineLength1Result
    lineLength1Result = lineLength1.poke(value = filter1Result)
    filter1Result = filter1.poke(input)

    // Poke inputs to real thing
    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)
    step(1)

    // Expect Results
    if (peek(c.io.out.valid)) {

      if (c.lineLength1Params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
        expect(c.io.filterOut, filter1Result)
        expect(c.io.lineOut, lineLength1Result)
        expect(c.io.bandpower1Out, bandpowerAlphaResult)
        expect(c.io.bandpower2Out, bandpowerBetaResult)
        expect(c.io.bandpower3Out, bandpowerGammaResult)
      } else {
        fixTolLSBs.withValue(log2Ceil((bandpowerAlphaResult.abs*tolerance).toInt+1)+dataBP+1) {
          expect(c.io.filterOut, filter1Result)
          expect(c.io.lineOut, lineLength1Result)
          expect(c.io.bandpower1Out, bandpowerAlphaResult)
          expect(c.io.bandpower2Out, bandpowerBetaResult)
          expect(c.io.bandpower3Out, bandpowerGammaResult)
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

}

object WellnessIntegrationTesterFP {
  implicit val p: Parameters = null
  def apply(filter1Params: FIRFilterParams[FixedPoint],
            lineLength1Params: lineLengthParams[FixedPoint],
            filterAlphaParams: FIRFilterParams[FixedPoint],
            filterBetaParams: FIRFilterParams[FixedPoint],
            filterGammaParams: FIRFilterParams[FixedPoint],
            bandpowerParams: sumSquaresParams[FixedPoint],
            svmParams: SVMParams[FixedPoint],
            configurationMemoryParams: ConfigurationMemoryParams[FixedPoint],
            goldenModelParameters: wellnessIntegrationParameterBundle, debug: Int, testType: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "verilator", "-fiwv"), () => new WellnessModule(
        filter1Params: FIRFilterParams[FixedPoint],
        lineLength1Params: lineLengthParams[FixedPoint],
        filterAlphaParams: FIRFilterParams[FixedPoint],
        filterBetaParams: FIRFilterParams[FixedPoint],
        filterGammaParams: FIRFilterParams[FixedPoint],
        bandpowerParams: sumSquaresParams[FixedPoint],
        svmParams: SVMParams[FixedPoint],
        configurationMemoryParams: ConfigurationMemoryParams[FixedPoint])) {
        c => new wellnessTester(c, goldenModelParameters, testType)
      }
    } else {
      dsptools.Driver.execute(() => new WellnessModule(
        filter1Params: FIRFilterParams[FixedPoint],
        lineLength1Params: lineLengthParams[FixedPoint],
        filterAlphaParams: FIRFilterParams[FixedPoint],
        filterBetaParams: FIRFilterParams[FixedPoint],
        filterGammaParams: FIRFilterParams[FixedPoint],
        bandpowerParams: sumSquaresParams[FixedPoint],
        svmParams: SVMParams[FixedPoint],
        configurationMemoryParams: ConfigurationMemoryParams[FixedPoint]),
        TestSetup.dspTesterOptions) {
        c => new wellnessTester(c, goldenModelParameters, testType)
      }
    }
  }
}
 */