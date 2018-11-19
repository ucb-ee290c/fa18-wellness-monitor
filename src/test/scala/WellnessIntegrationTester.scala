package wellness

import chisel3._
import chisel3.util._
import chisel3.experimental.FixedPoint
import dspblocks._
import dspjunctions.ValidWithSync
import dsptools.DspTester
import dsptools.numbers._
import firFilter._
import fft._
import features._
import pca._
import memorybuffer._
import svm._
import freechips.rocketchip.amba.axi4stream._
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.subsystem._

import scala.collection.Seq
import scala.collection.mutable

class wellnessTester[T <: chisel3.Data](c: WellnessModule[T], goldenModelParameters: wellnessIntegrationParameterBundle) extends DspTester(c) {

  val testType =
    if ( (c.filter1Params.protoData.getClass.getTypeName == "chisel3.core.SInt") || (c.filter1Params.protoData.getClass.getTypeName == "chisel3.core.UInt") )
      0
    else
      1


  //TODO: Instantiate Golden Models (FFT & BandPower remaining)
  val filter1 = new GoldenDoubleFIRFilter(goldenModelParameters.filter1Params.taps)
  val filter2 = new GoldenDoubleFIRFilter(goldenModelParameters.filter2Params.taps)
  val filter3 = new GoldenDoubleFIRFilter(goldenModelParameters.filter3Params.taps)
  val lineLength1 = new GoldenDoubleLineLength(goldenModelParameters.lineLength1Params.windowSize,testType)
  val lineLength2 = new GoldenDoubleLineLength(goldenModelParameters.lineLength2Params.windowSize,testType)
  val lineLength3 = new GoldenDoubleLineLength(goldenModelParameters.lineLength3Params.windowSize,testType)
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
  val referencePCAVector = Seq(Seq(5, 0, -2), Seq(1, 2, 3))
  val referenceSVMSupportVector = Seq(Seq(1, 2), Seq(3, 4))
  val referenceSVMAlphaVector = Seq(Seq(7, 3))
  val referenceSVMIntercept = Seq(4)
  /*val referencePCAVector = Seq(Seq(5, 0, -2), Seq(1, 2, 3))
  val PCAVector = Wire(Vec(2, Vec(3, pcaParams.protoData)))
  for(i <- 0 until 2) {
    PCAVector(i) := VecInit(referencePCAVector(i).map(ConvertableTo[T].fromInt(_)))
  }

  val referenceSVMSupportVector = Seq(Seq(1, 2), Seq(3, 4))
  val SVMSupportVector = Wire(Vec(2, Vec(2, svmParams.protoData)))
  for(i <- 0 until 2) {
    SVMSupportVector(i) := VecInit(referenceSVMSupportVector(i).map(ConvertableTo[T].fromInt(_)))
  }

  val referenceSVMAlphaVector = Seq(Seq(7, 3))
  val SVMAlphaVector = Wire(Vec(1, Vec(2, svmParams.protoData)))
  for(i <- 0 until 1) {
    SVMAlphaVector(i) := VecInit(referenceSVMAlphaVector(i).map(ConvertableTo[T].fromInt(_)))
  }

  val referenceSVMIntercept = Seq(4)
  val SVMIntercept = VecInit(referenceSVMIntercept.map(ConvertableTo[T].fromInt(_)))
  //for(i <- 0 until 1) {
  //  SVMIntercept(i) := VecInit(ConvertableTo[T].fromInt(referenceSVMIntercept(i)))
  //} */

  //poke(c.io.inConf.bits.confSVMIntercept, referenceSVMIntercept)

  val pcaVectorMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = c.configurationMemoryParams.protoData.cloneType
    override val nRows: Int = c.configurationMemoryParams.nDimensions
    override val nColumns: Int = c.configurationMemoryParams.nFeatures
  }

  val svmSupportVectorMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = c.configurationMemoryParams.protoData.cloneType
    override val nRows: Int = c.configurationMemoryParams.nFeatures
    override val nColumns: Int = c.configurationMemoryParams.nSupports
  }

  val svmAlphaVectorMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = c.configurationMemoryParams.protoData.cloneType
    override val nRows: Int = c.configurationMemoryParams.nSupports
    override val nColumns: Int = c.configurationMemoryParams.nClassifiers
  }

  val svmInterceptMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = c.configurationMemoryParams.protoData.cloneType
    override val nRows: Int = c.configurationMemoryParams.nClassifiers
    override val nColumns: Int = 1
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


  var pcaResult = PCA.poke(Seq(0,0,0),referencePCAVector.map(_.map(_.toDouble)))
  var filter1Result = filter1.poke(0)
  var filter2Result = filter2.poke(0)
  var filter3Result = filter3.poke(0)
  var lineLength1Result = lineLength1.poke(value = 0)
  var lineLength2Result = lineLength2.poke(value = 0)
  var lineLength3Result = lineLength3.poke(value = 0)
  var filterOutBundle = Seq(filter1Result, filter2Result, filter3Result)
  var lineLengthOutBundle = Seq(lineLength1Result, lineLength2Result, lineLength3Result)
  var svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
    referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)

  for(i <- 0 until 1000) {
    var input = scala.util.Random.nextFloat*32
    if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
      input = scala.util.Random.nextInt(32)
    }
    else if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
      input = scala.util.Random.nextInt(64) - 32
    }

    //TODO: Poke inputs to golden models
    lineLength1Result = lineLength1.poke(value = filter1Result)
    lineLength2Result = lineLength2.poke(value = filter2Result)
    lineLength3Result = lineLength3.poke(value = filter3Result)
    lineLengthOutBundle = Seq(lineLength1Result, lineLength2Result, lineLength3Result)

    // lineLength1Result = lineLength1.poke(input)
    // lineLength2Result = lineLength2.poke(input)
    // lineLength3Result = lineLength3.poke(input)
    // lineLengthOutBundle = Seq(lineLength1Result, lineLength2Result, lineLength3Result)

    filter1Result = filter1.poke(input)
    filter2Result = filter2.poke(input)
    filter3Result = filter3.poke(input)
    // filterOutBundle = Seq(filter1Result, filter2Result, filter3Result)

    // pcaResult = PCA.poke(filterOutBundle,referencePCAVector.map(_.map(_.toDouble)))
    pcaResult = PCA.poke(lineLengthOutBundle,referencePCAVector.map(_.map(_.toDouble)))
    svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
      referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)

    //TODO: Poke inputs to real thing
    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)

    step(1)

    //TODO: Expect Results
    if (c.io.lineLengthValid == 1) {
      fixTolLSBs.withValue(16) {
        expect(c.io.filterOut, filter1Result)
        expect(c.io.lineOut, lineLength1Result)
      }


      for (i <- 0 until goldenModelParameters.pcaParams.nFeatures) {
        if (c.pcaParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
          expect(c.io.pcaOut(i), pcaResult(i))
        } else {
          // due to the series of multiply and accumulates, error actually blows up, let's be lenient
          fixTolLSBs.withValue(16) { // at least the integer part must match
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
          fixTolLSBs.withValue(20) { // +-16, 4 extra bits after the binary point
            expect(c.io.rawVotes(i), svmResult(0)(i))
          }
          // strict check for the class votes
          expect(c.io.classVotes(i), svmResult(1)(i))
        }
      }
    }
  }
}

object WellnessIntegrationTesterSInt {
  implicit val p: Parameters = null
  def apply(filter1Params: FIRFilterParams[SInt],
            filter2Params: FIRFilterParams[SInt],
            filter3Params: FIRFilterParams[SInt],
            lineLength1Params: lineLengthParams[SInt],
            lineLength2Params: lineLengthParams[SInt],
            lineLength3Params: lineLengthParams[SInt],
            fftBufferParams: FFTBufferParams[SInt],
            fftConfig: FFTConfig[SInt],
            bandpower1Params: BandpowerParams[SInt],
            bandpower2Params: BandpowerParams[SInt],
            bandpower3Params: BandpowerParams[SInt],
            pcaParams: PCAParams[SInt],
            svmParams: SVMParams[SInt],
            pcaVectorBufferParams: MemoryBufferParams[SInt],
            configurationMemoryParams: ConfigurationMemoryParams[SInt],
            goldenModelParameters: wellnessIntegrationParameterBundle): Boolean = {
    dsptools.Driver.execute(() => new WellnessModule(
      filter1Params: FIRFilterParams[SInt],
      filter2Params: FIRFilterParams[SInt],
      filter3Params: FIRFilterParams[SInt],
      lineLength1Params: lineLengthParams[SInt],
      lineLength2Params: lineLengthParams[SInt],
      lineLength3Params: lineLengthParams[SInt],
      fftBufferParams: FFTBufferParams[SInt],
      fftConfig: FFTConfig[SInt],
      bandpower1Params: BandpowerParams[SInt],
      bandpower2Params: BandpowerParams[SInt],
      bandpower3Params: BandpowerParams[SInt],
      pcaParams: PCAParams[SInt],
      svmParams: SVMParams[SInt],
      pcaVectorBufferParams: MemoryBufferParams[SInt],
      configurationMemoryParams: ConfigurationMemoryParams[SInt]),
      TestSetup.dspTesterOptions) {
      c => new wellnessTester(c, goldenModelParameters)
    }
  }
}

object WellnessIntegrationTesterFP {
  implicit val p: Parameters = null
  def apply(filter1Params: FIRFilterParams[FixedPoint],
            filter2Params: FIRFilterParams[FixedPoint],
            filter3Params: FIRFilterParams[FixedPoint],
            lineLength1Params: lineLengthParams[FixedPoint],
            lineLength2Params: lineLengthParams[FixedPoint],
            lineLength3Params: lineLengthParams[FixedPoint],
            fftBufferParams: FFTBufferParams[FixedPoint],
            fftConfig: FFTConfig[FixedPoint],
            bandpower1Params: BandpowerParams[FixedPoint],
            bandpower2Params: BandpowerParams[FixedPoint],
            bandpower3Params: BandpowerParams[FixedPoint],
            pcaParams: PCAParams[FixedPoint],
            svmParams: SVMParams[FixedPoint],
            pcaVectorBufferParams: MemoryBufferParams[FixedPoint],
            configurationMemoryParams: ConfigurationMemoryParams[FixedPoint],
            goldenModelParameters: wellnessIntegrationParameterBundle): Boolean = {
    dsptools.Driver.execute(() => new WellnessModule(
      filter1Params: FIRFilterParams[FixedPoint],
      filter2Params: FIRFilterParams[FixedPoint],
      filter3Params: FIRFilterParams[FixedPoint],
      lineLength1Params: lineLengthParams[FixedPoint],
      lineLength2Params: lineLengthParams[FixedPoint],
      lineLength3Params: lineLengthParams[FixedPoint],
      fftBufferParams: FFTBufferParams[FixedPoint],
      fftConfig: FFTConfig[FixedPoint],
      bandpower1Params: BandpowerParams[FixedPoint],
      bandpower2Params: BandpowerParams[FixedPoint],
      bandpower3Params: BandpowerParams[FixedPoint],
      pcaParams: PCAParams[FixedPoint],
      svmParams: SVMParams[FixedPoint],
      pcaVectorBufferParams: MemoryBufferParams[FixedPoint],
      configurationMemoryParams: ConfigurationMemoryParams[FixedPoint]),
      TestSetup.dspTesterOptions) {
      c => new wellnessTester(c, goldenModelParameters)
    }
  }
}
