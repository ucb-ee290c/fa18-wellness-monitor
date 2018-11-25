package wellness

import breeze.math.Complex
import chisel3._
import chisel3.experimental.FixedPoint
import dsptools.DspTester
import dsptools.numbers._
import firFilter._
import fft._
import features._
import pca._
import memorybuffer._
import svm._
import freechips.rocketchip.config.Parameters

import scala.collection.Seq

class wellnessTester[T <: chisel3.Data](c: WellnessModule[T], goldenModelParameters: wellnessIntegrationParameterBundle) extends DspTester(c) {

  // Instantiate golden models
  val filter1 = new GoldenDoubleFIRFilter(goldenModelParameters.filter1Params.taps)
  val lineLength1 = new GoldenDoubleLineLength(goldenModelParameters.lineLength1Params.windowSize,c.lineLength1Params.protoData.getClass.getTypeName)
  val fftBuffer = new GoldenFFTBuffer(goldenModelParameters.fftBufferParams.lanes)
  val fft = new GoldenDoubleFFT
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
  val referencePCAVector = Seq(Seq(5, 0, -2), Seq(1, 2, 3))
  val referenceSVMSupportVector = Seq(Seq(1, 2), Seq(3, 4))
  val referenceSVMAlphaVector = Seq(Seq(7, 3))
  val referenceSVMIntercept = Seq(4)

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

  var filter1Result = filter1.poke(0)
  var lineLength1Result = lineLength1.poke(value = 0)
  var fftBufferResult = fftBuffer.poke(0.0)
  var fftResult = fft.poke(Seq.fill(goldenModelParameters.fftConfig.nPts)(Complex(0.0, 0.0)))
  var bandpower1Result = bandpower1.poke(Seq.fill(goldenModelParameters.bandpower1Params.nBins)(Complex(0.0, 0.0)))
  var bandpower2Result = bandpower2.poke(Seq.fill(goldenModelParameters.bandpower2Params.nBins)(Complex(0.0, 0.0)))
  var pcaInputBundle = Seq(lineLength1Result, bandpower1Result, bandpower2Result)
  var pcaResult = PCA.poke(Seq(0,0,0),referencePCAVector.map(_.map(_.toDouble)))
  var svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
    referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)

  for(i <- 0 until 1000) {
    var input = scala.util.Random.nextFloat*16 - 8
    if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.UInt") {
      input = scala.util.Random.nextInt(16)
    }
    else if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
      input = scala.util.Random.nextInt(32) - 16
    }


    // Poke inputs to golden models
    fftBufferResult = fftBuffer.poke(filter1Result)
    lineLength1Result = lineLength1.poke(value = filter1Result)
    filter1Result = filter1.poke(input)
    //fftBufferResult.regs.map(x => Complex(x, 0.0)).zip(c.io.fftIn).foreach { case(sig, port) => poke(port, sig) } // TODO

    fftResult = fft.poke(fftBufferResult.regs.map(x => Complex(x, 0.0)))
    bandpower1Result = bandpower1.poke(fftResult)
    bandpower2Result = bandpower2.poke(fftResult)
    pcaInputBundle = Seq(lineLength1Result, bandpower1Result, bandpower2Result)
    pcaResult = PCA.poke(pcaInputBundle, referencePCAVector.map(_.map(_.toDouble)))
    svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
      referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)

    // Poke inputs to real thing
    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)
    step(1)

    // Expect Results
    if (peek(c.io.lineLengthValid) && peek(c.io.bandpowerValid)) {
      fixTolLSBs.withValue(16) {
        expect(c.io.filterOut, filter1Result)
        expect(c.io.lineOut, lineLength1Result)
        expect(c.io.bandpower1Out, bandpower1Result)
        expect(c.io.bandpower2Out, bandpower2Result)
      }
      for (i <- 0 until goldenModelParameters.fftBufferParams.lanes) {
        if (c.fftBufferParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
          expect(c.io.fftBufferOut(i), fftBufferResult.regs(i))
        } else {
          fixTolLSBs.withValue(20) { // at least the integer part must match
            expect(c.io.fftBufferOut(i), fftBufferResult.regs(i))
          }
        }
      }

      for (i <- 0 until goldenModelParameters.fftConfig.nPts) {
        if (c.fftConfig.genOut.real.getClass.getTypeName == "chisel3.core.SInt") {
          expect(c.io.fftOut(i), fftResult(i))
        } else {
          fixTolLSBs.withValue(20) { // at least the integer part must match
            expect(c.io.fftOut(i), fftResult(i))
          }
        }
      }

      for (i <- 0 until goldenModelParameters.pcaParams.nFeatures) {
        if (c.pcaParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
          expect(c.io.pcaOut(i), pcaResult(i))
        } else {
          // due to the series of multiply and accumulates, error actually blows up, let's be lenient
          fixTolLSBs.withValue(20) { // at least the integer part must match
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
            lineLength1Params: lineLengthParams[SInt],
            fftBufferParams: FFTBufferParams[SInt],
            fftConfig: FFTConfig[SInt],
            bandpower1Params: BandpowerParams[SInt],
            bandpower2Params: BandpowerParams[SInt],
            pcaParams: PCAParams[SInt],
            svmParams: SVMParams[SInt],
            pcaVectorBufferParams: MemoryBufferParams[SInt],
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
        pcaVectorBufferParams: MemoryBufferParams[SInt],
        configurationMemoryParams: ConfigurationMemoryParams[SInt])) {
        c => new wellnessTester(c, goldenModelParameters)
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
        pcaVectorBufferParams: MemoryBufferParams[SInt],
        configurationMemoryParams: ConfigurationMemoryParams[SInt]),
        TestSetup.dspTesterOptions) {
        c => new wellnessTester(c, goldenModelParameters)
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
            pcaVectorBufferParams: MemoryBufferParams[FixedPoint],
            configurationMemoryParams: ConfigurationMemoryParams[FixedPoint],
            goldenModelParameters: wellnessIntegrationParameterBundle, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new WellnessModule(
        filter1Params: FIRFilterParams[FixedPoint],
        lineLength1Params: lineLengthParams[FixedPoint],
        fftBufferParams: FFTBufferParams[FixedPoint],
        fftConfig: FFTConfig[FixedPoint],
        bandpower1Params: BandpowerParams[FixedPoint],
        bandpower2Params: BandpowerParams[FixedPoint],
        pcaParams: PCAParams[FixedPoint],
        svmParams: SVMParams[FixedPoint],
        pcaVectorBufferParams: MemoryBufferParams[FixedPoint],
        configurationMemoryParams: ConfigurationMemoryParams[FixedPoint])) {
        c => new wellnessTester(c, goldenModelParameters)
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
        pcaVectorBufferParams: MemoryBufferParams[FixedPoint],
        configurationMemoryParams: ConfigurationMemoryParams[FixedPoint]),
        TestSetup.dspTesterOptions) {
        c => new wellnessTester(c, goldenModelParameters)
      }
    }
  }
}
