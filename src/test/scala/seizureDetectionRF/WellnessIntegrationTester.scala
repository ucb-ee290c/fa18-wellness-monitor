/*
package wellness

import chisel3.experimental.FixedPoint
import chisel3.util.log2Ceil
import dsptools.DspTester
import dsptools.numbers._
import firFilter._
import features._
import memorybuffer._
import randomforest._
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
  val randomForest = new GoldenRandomForest(
    goldenModelParameters.randomForestParams.nFeatures,
    goldenModelParameters.randomForestParams.nDepth,
    goldenModelParameters.randomForestParams.nTrees,
    goldenModelParameters.randomForestParams.featureSelect)

  var input = scala.util.Random.nextFloat*16 - 8
  if (c.randomForestParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
    input = scala.util.Random.nextInt(16)
  }
  else if (c.randomForestParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
    input = scala.util.Random.nextInt(32) - 16
  }

  // Define some arbitrary default values for PCA and SVM to be used in random input tests
  var referencerandomForestThresholds = Seq.fill(100, (1 << 4) - 1)(scala.util.Random.nextInt(20))
  var referencerandomForestLeafVotes = Seq.fill(100, (1 << 4))(scala.util.Random.nextInt(5))

  // Configure the input mux selection to accept data from RISC-V core instead of external input
  poke(c.io.inConf.bits.confInputMuxSel, 0)

  val randomForestThresholdsMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = (1 << c.configurationMemoryParams.nDepth) - 1
    val nColumns: Int = c.configurationMemoryParams.nTrees
  }

  val randomForestLeafVotesMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = 1 << c.configurationMemoryParams.nDepth
    val nColumns: Int = c.configurationMemoryParams.nTrees
  }

  // Fill the configuration inputs of the DUT

  for(x <- 0 until randomForestThresholdsMemoryParams.nColumns) {
    for (y <- 0 until randomForestThresholdsMemoryParams.nRows) {
      poke(c.io.inConf.bits.confrandomForestThresholds(x)(y), referencerandomForestThresholds(x)(y))
    }
  }

  for(x <- 0 until randomForestLeafVotesMemoryParams.nColumns) {
    for (y <- 0 until randomForestLeafVotesMemoryParams.nRows) {
      poke(c.io.inConf.bits.confrandomForestLeafVotes(x)(y), referencerandomForestLeafVotes(x)(y))
    }
  }
  // poke initial values, as well as the declaration of the variables, set to 0 first

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

  //var FeatureBundle = Seq(bandpowerAlphaResult, bandpowerBetaResult, bandpowerGammaResult, lineLength1ResultReg1)
  var FeatureBundle = Seq.fill(randomForestThresholdsMemoryParams.nRows)(0.toDouble)
  var randomForestResult = randomForest.poke(FeatureBundle.map(_.toDouble), referencerandomForestThresholds.map(_.map(_.toDouble)), referencerandomForestLeafVotes.map(_.map(_.toDouble)))

  var dataWidth = 0
  var dataBP = 0
  // determine the dataWidth and dataBP parameters override for Fixed Point numbers
  if (c.randomForestParams.protoData.getClass.getTypeName == "chisel3.core.FixedPoint") {
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
      if (c.randomForestParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
        input = scala.util.Random.nextInt(16)
      }
      else if (c.randomForestParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
        input = scala.util.Random.nextInt(32) - 16
      }
    }

    // Poke inputs to golden models
    // The order of poking matters. For sequential modules connected to eachother, poking should be from last-to-first.
    // For combinational modules between sequential modules, it should be from first-to-last.

    randomForestResult = randomForest.poke(FeatureBundle.map(_.toDouble), referencerandomForestThresholds.map(_.map(_.toDouble)),
      referencerandomForestLeafVotes.map(_.map(_.toDouble)))
    FeatureBundle = Seq(bandpowerAlphaResult, bandpowerBetaResult, bandpowerGammaResult, lineLength1ResultReg1)

    // TODO: double check why this is delayed, is there a register here?

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

      if (c.randomForestParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
        expect(c.io.rawVotes, randomForestResult)
      } else {
        fixTolLSBs.withValue(log2Ceil((randomForestResult.abs * tolerance).toInt + 1) + dataBP - 1) {
          expect(c.io.rawVotes, randomForestResult)
        }
        // strict check for the class votes
        //expect(c.io.out.bits, randomForestResult)
      }
      //outputContainer += randomForestResult
    }
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
            randomForestParams: RandomForestParams[FixedPoint],
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
        randomForestParams: RandomForestParams[FixedPoint],
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
        randomForestParams: RandomForestParams[FixedPoint],
        configurationMemoryParams: ConfigurationMemoryParams[FixedPoint]),
        TestSetup.dspTesterOptions) {
        c => new wellnessTester(c, goldenModelParameters, testType)
      }
    }
  }
}
*/
