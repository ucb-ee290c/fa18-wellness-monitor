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

class wellnessTester[T <: chisel3.Data](c: WellnessModule[T], goldenModelParameters: wellnessIntegrationParameterBundle, testType: Int) extends DspTester(c) {

  //TODO: Instantiate Golden Models (FFT & BandPower remaining)
  val filter1 = new GoldenDoubleFIRFilter(goldenModelParameters.filter1Params.taps)
  val filter2 = new GoldenDoubleFIRFilter(goldenModelParameters.filter2Params.taps)
  val filter3 = new GoldenDoubleFIRFilter(goldenModelParameters.filter3Params.taps)
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

  val pcaResult = PCA.poke(Seq(0,0,0),referencePCAVector.map(_.map(_.toDouble)))
  val filter1Result = filter1.poke(0)
  val filter2Result = filter2.poke(0)
  val filter3Result = filter3.poke(0)
  val filterOutBundle = Seq(filter1Result, filter2Result, filter3Result)

  for(i <- 0 until 100) {
    var input = scala.util.Random.nextFloat*32
    if (testType == 0) {
      input = scala.util.Random.nextInt(32)
    }

    //TODO: Poke inputs to golden models

    val filter1Result = filter1.poke(input)
    val filter2Result = filter2.poke(input)
    val filter3Result = filter3.poke(input)
    val filterOutBundle = Seq(filter1Result, filter2Result, filter3Result)
    val pcaResult = PCA.poke(filterOutBundle,referencePCAVector.map(_.map(_.toDouble)))
    val svmResult = SVM.poke(pcaResult.map(_.toDouble), referenceSVMSupportVector.map(_.map(_.toDouble)),
      referenceSVMAlphaVector.map(_.map(_.toDouble)), referenceSVMIntercept.map(_.toDouble), 0)

    //TODO: Poke inputs to real thing
    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)

    step(1)

    //TODO: Expect Results
    for (i <- 0 until goldenModelParameters.svmParams.nClasses) {
      if (c.svmParams.protoData.getClass.getTypeName == "chisel3.core.SInt") {
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

object WellnessIntegrationTesterSInt {
  implicit val p: Parameters = null
  def apply(filter1Params: FIRFilterParams[SInt],
            filter2Params: FIRFilterParams[SInt],
            filter3Params: FIRFilterParams[SInt],
            fftBufferParams: FFTBufferParams[SInt],
            fftConfig: FFTConfig[SInt],
            bandpower1Params: BandpowerParams[SInt],
            bandpower2Params: BandpowerParams[SInt],
            bandpower3Params: BandpowerParams[SInt],
            pcaParams: PCAParams[SInt],
            svmParams: SVMParams[SInt],
            pcaVectorBufferParams: MemoryBufferParams[SInt],
            goldenModelParameters: wellnessIntegrationParameterBundle): Boolean = {
    dsptools.Driver.execute(() => new WellnessModule(
      filter1Params: FIRFilterParams[SInt],
      filter2Params: FIRFilterParams[SInt],
      filter3Params: FIRFilterParams[SInt],
      fftBufferParams: FFTBufferParams[SInt],
      fftConfig: FFTConfig[SInt],
      bandpower1Params: BandpowerParams[SInt],
      bandpower2Params: BandpowerParams[SInt],
      bandpower3Params: BandpowerParams[SInt],
      pcaParams: PCAParams[SInt],
      svmParams: SVMParams[SInt],
      pcaVectorBufferParams: MemoryBufferParams[SInt]),
      TestSetup.dspTesterOptions) {
      c => new wellnessTester(c, goldenModelParameters, 0)
    }
  }
}
