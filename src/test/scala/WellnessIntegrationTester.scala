
package wellness

import chisel3.experimental.FixedPoint
import chisel3.util.log2Ceil
import dsptools.DspTester
import dsptools.numbers._
import firFilter._
import features._
import memorybuffer._
import neuralNet._
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
  val neuralNets = new GoldenNeuralNet(
    goldenModelParameters.neuralNetsParams.nFeatures,
    goldenModelParameters.neuralNetsParams.nNeurons)

  var input = scala.util.Random.nextFloat*16 - 8
  if (c.neuralNetsParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
    input = scala.util.Random.nextInt(16)
  }
  else if (c.neuralNetsParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
    input = scala.util.Random.nextInt(32) - 16
  }

  // Define some arbitrary default values for PCA and SVM to be used in random input tests
  var referenceneuralNetsweightMatrix = Seq.fill(100, 4)(scala.util.Random.nextInt(10)-5)
  var referenceneuralNetsweightVec = Seq.fill(100)(scala.util.Random.nextInt(10)-5)
  var referenceneuralNetsbiasVec = Seq.fill(100)(scala.util.Random.nextInt(10)-5)
  var referenceneuralNetsbiasScalar = scala.util.Random.nextInt(10)-5

  // Configure the input mux selection to accept data from RISC-V core instead of external input
  poke(c.io.inConf.bits.confInputMuxSel, 0)

  val neuralNetsweightMatrixMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = c.configurationMemoryParams.nFeatures
    val nColumns: Int = c.configurationMemoryParams.nNeurons
  }

  val neuralNetsweightVecMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = c.configurationMemoryParams.nNeurons
    val nColumns: Int = 1
  }

  val neuralNetsbiasVecMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = c.configurationMemoryParams.nNeurons
    val nColumns: Int = 1
  }

  val neuralNetsbiasScalarMemoryParams = new MemoryBufferParams[T] {
    val protoData: T = c.configurationMemoryParams.protoData.cloneType
    val nRows: Int = 1
    val nColumns: Int = 1
  }

  // Fill the configuration inputs of the DUT

  for(x <- 0 until neuralNetsweightMatrixMemoryParams.nColumns) {
    for (y <- 0 until neuralNetsweightMatrixMemoryParams.nRows) {
      poke(c.io.inConf.bits.confneuralNetsweightMatrix(x)(y), referenceneuralNetsweightMatrix(x)(y))
    }
  }

  for(x <- 0 until neuralNetsweightVecMemoryParams.nColumns) {
    for (y <- 0 until neuralNetsweightVecMemoryParams.nRows) {
      poke(c.io.inConf.bits.confneuralNetsweightVec(y), referenceneuralNetsweightVec(y))
    }
  }

  for(x <- 0 until neuralNetsbiasVecMemoryParams.nColumns) {
    for (y <- 0 until neuralNetsbiasVecMemoryParams.nRows) {
      poke(c.io.inConf.bits.confneuralNetsbiasVec(y), referenceneuralNetsbiasVec(y))
    }
  }

  for(x <- 0 until neuralNetsbiasScalarMemoryParams.nColumns) {
    for (y <- 0 until neuralNetsbiasScalarMemoryParams.nRows) {
      poke(c.io.inConf.bits.confneuralNetsbiasScalar(0), referenceneuralNetsbiasScalar)
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
  var FeatureBundle = Seq.fill(4)(0.toDouble)
  var neuralNetsResult = neuralNets.poke(FeatureBundle.map(_.toDouble), referenceneuralNetsweightMatrix.map(_.map(_.toDouble)), referenceneuralNetsweightVec.map(_.toDouble),
    referenceneuralNetsbiasVec.map(_.toDouble), referenceneuralNetsbiasScalar.toDouble)

  var dataWidth = 0
  var dataBP = 0
  // determine the dataWidth and dataBP parameters override for Fixed Point numbers
  if (c.neuralNetsParams.protoData.getClass.getTypeName == "chisel3.core.FixedPoint") {
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
      if (c.neuralNetsParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
        input = scala.util.Random.nextInt(16)
      }
      else if (c.neuralNetsParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
        input = scala.util.Random.nextInt(32) - 16
      }
    }

    // Poke inputs to golden models
    // The order of poking matters. For sequential modules connected to eachother, poking should be from last-to-first.
    // For combinational modules between sequential modules, it should be from first-to-last.

    FeatureBundle = Seq(bandpowerAlphaResult, bandpowerBetaResult, bandpowerGammaResult, lineLength1ResultReg1)
    neuralNetsResult = neuralNets.poke(FeatureBundle.map(_.toDouble), referenceneuralNetsweightMatrix.map(_.map(_.toDouble)), referenceneuralNetsweightVec.map(_.toDouble),
      referenceneuralNetsbiasVec.map(_.toDouble), referenceneuralNetsbiasScalar.toDouble)
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

      if (c.neuralNetsParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
        expect(c.io.rawVotes, neuralNetsResult)
      } else {
        fixTolLSBs.withValue(log2Ceil((neuralNetsResult.abs * tolerance).toInt + 1) + dataBP - 1) {
          expect(c.io.rawVotes, neuralNetsResult)
        }
        // strict check for the class votes
        //expect(c.io.out.bits, neuralNetsResult)
      }
      //outputContainer += neuralNetsResult
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
            neuralNetsParams: NeuralNetParams[FixedPoint],
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
        neuralNetsParams: NeuralNetParams[FixedPoint],
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
        neuralNetsParams: NeuralNetParams[FixedPoint],
        configurationMemoryParams: ConfigurationMemoryParams[FixedPoint]),
        TestSetup.dspTesterOptions) {
        c => new wellnessTester(c, goldenModelParameters, testType)
      }
    }
  }
}
