package wellness

import chisel3.{UInt, _}
import chisel3.core.FixedPoint
import dsptools.numbers._
import features._
import fft._
import firFilter._
import memorybuffer._
import org.scalatest.{FlatSpec, Matchers}
import pca._
import svm._

import scala.collection.{Seq, mutable}

abstract class filterParamsTemplate {
  val taps:Seq[Double]
}

abstract class fftBufferParamsTemplate {
  val lanes:Int
}

abstract class pcaParamsTemplate {
  val nDimensions:Int
  val nFeatures:Int
}

abstract class svmParamsTemplate {
  val nSupports:Int
  val nFeatures:Int
  val nClasses:Int
  val nDegree:Int
  val kernelType:String
  val classifierType:String
  val codeBook:Seq[Seq[Int]]
}

abstract class pcaVectorBufferParamsTemplate {
  val nRows:Int
  val nColumns:Int
}

class wellnessIntegrationParameterBundle {

  val filter1Params:filterParamsTemplate = new filterParamsTemplate {
    override val taps = Seq(1.toDouble,2.toDouble,3.toDouble,4.toDouble,5.toDouble,0.toDouble)
  }
  val filter2Params:filterParamsTemplate = new filterParamsTemplate {
    override val taps = Seq(5.toDouble,4.toDouble,3.toDouble,2.toDouble,1.toDouble,0.toDouble)
  }
  val filter3Params:filterParamsTemplate = new filterParamsTemplate {
    override val taps = Seq(0.toDouble,1.toDouble,2.toDouble,2.toDouble,1.toDouble,0.toDouble)
  }
  val fftBufferParams:fftBufferParamsTemplate = new fftBufferParamsTemplate {
    override val lanes: Int = 4
  }
  val pcaParams:pcaParamsTemplate = new pcaParamsTemplate {
    override val nDimensions: Int = 3
    override val nFeatures: Int = 2
  }
  val svmParams:svmParamsTemplate = new svmParamsTemplate {
    override val nSupports = 2
    override val nFeatures:Int = pcaParams.nFeatures
    override val nClasses = 2
    override val nDegree = 1
    override val kernelType = "poly"
    override val classifierType = "ovo"
    override val codeBook:Seq[Seq[Int]] = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
  }
  val pcaVectorBufferParams:pcaVectorBufferParamsTemplate = new pcaVectorBufferParamsTemplate {
    override val nRows: Int = pcaParams.nFeatures
    override val nColumns: Int = pcaParams.nDimensions
  }

}

class WellnessIntegrationSpec extends FlatSpec with Matchers {
  behavior of "Wellness"

  it should "pass the input through filters, compute features, and classify (SInt)" in {

    val nPts = 4

    val filter1Params = new FIRFilterParams[SInt] {
      override val protoData = SInt(32.W)
      override val taps = Seq(1.S, 2.S, 3.S, 4.S, 5.S, 0.S)
    }

    val filter2Params = new FIRFilterParams[SInt] {
      override val protoData = SInt(32.W)
      override val taps = Seq(5.S, 4.S, 3.S, 2.S, 1.S, 0.S)
    }

    val filter3Params = new FIRFilterParams[SInt] {
      override val protoData = SInt(32.W)
      override val taps = Seq(0.S, 1.S, 2.S, 2.S, 1.S, 0.S)
    }

    // FFTBufferParams
    val fftBufferParams = new FFTBufferParams[SInt] {
      val protoData = SInt(32.W)
      val lanes = nPts
    }

    // FFTConfigs
    val fftConfig = FFTConfig(
      genIn = DspComplex(SInt(32.W), SInt(32.W)),
      genOut = DspComplex(SInt(32.W), SInt(32.W)),
      n = nPts,
      lanes = nPts,
      pipelineDepth = 0,
      quadrature = false,
    )

    // BandpowerParams
    val bandpower1Params = new BandpowerParams[SInt] {
      val idxStartBin = 0
      val idxEndBin = nPts-1
      val nBins = nPts
      val protoData = SInt(32.W)
    }
    val bandpower2Params = new BandpowerParams[SInt] {
      val idxStartBin = 0
      val idxEndBin = nPts-1
      val nBins = nPts
      val protoData = SInt(32.W)
    }
    val bandpower3Params = new BandpowerParams[SInt] {
      val idxStartBin = 0
      val idxEndBin = nPts-1
      val nBins = nPts
      val protoData = SInt(32.W)
    }

    val pcaParams = new PCAParams[SInt] {
      override val protoData = SInt(32.W)
      override val nDimensions = 3 // input dimension, minimum 1
      override val nFeatures = 2   // output dimension to SVM, minimum 1
    }

    val svmParams = new SVMParams[SInt] {
      val protoData = SInt(32.W)
      val nSupports = 2
      val nFeatures = pcaParams.nFeatures
      val nClasses = 2
      val nDegree = 1
      val kernelType = "poly"
      val classifierType = "ovo"
      val codeBook = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
    }

    val pcaVectorBufferParams = new MemoryBufferParams[SInt] {
      override val protoData = SInt(32.W)
      override val nRows:Int = pcaParams.nFeatures
      override val nColumns:Int = pcaParams.nDimensions
    }

    val goldenModelParameters = new wellnessIntegrationParameterBundle


    WellnessIntegrationTesterSInt(filter1Params: FIRFilterParams[SInt],
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
      goldenModelParameters: wellnessIntegrationParameterBundle) should be (true)
  }

  it should "pass the input through filters, compute features, and classify (FixedPoint)" in {

    val nPts = 4

    val dataWidth = 64
    val dataBP = 16

    val filter1Params = new FIRFilterParams[FixedPoint] {
      override val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      override val taps = Seq(1,2,3,4,5,0).map(ConvertableTo[FixedPoint].fromDouble(_))
    }

    val filter2Params = new FIRFilterParams[FixedPoint] {
      override val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      override val taps = Seq(5,4,3,2,1,0).map(ConvertableTo[FixedPoint].fromDouble(_))
    }

    val filter3Params = new FIRFilterParams[FixedPoint] {
      override val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      override val taps = Seq(0,1,2,2,1,0).map(ConvertableTo[FixedPoint].fromDouble(_))
    }

    // FFTBufferParams
    val fftBufferParams = new FFTBufferParams[FixedPoint] {
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      val lanes = nPts
    }

    // FFTConfigs
    val fftConfig = FFTConfig(
      genIn = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP)),
      genOut = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP)),
      n = nPts,
      lanes = nPts,
      pipelineDepth = 0,
      quadrature = false,
    )

    // BandpowerParams
    val bandpower1Params = new BandpowerParams[FixedPoint] {
      val idxStartBin = 0
      val idxEndBin = nPts-1
      val nBins = nPts
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    }
    val bandpower2Params = new BandpowerParams[FixedPoint] {
      val idxStartBin = 0
      val idxEndBin = nPts-1
      val nBins = nPts
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    }
    val bandpower3Params = new BandpowerParams[FixedPoint] {
      val idxStartBin = 0
      val idxEndBin = nPts-1
      val nBins = nPts
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    }

    val pcaParams = new PCAParams[FixedPoint] {
      override val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      override val nDimensions = 3 // input dimension, minimum 1
      override val nFeatures = 2   // output dimension to SVM, minimum 1
    }

    val svmParams = new SVMParams[FixedPoint] {
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      val nSupports = 2
      val nFeatures = pcaParams.nFeatures
      val nClasses = 2
      val nDegree = 1
      val kernelType = "poly"
      val classifierType = "ovo"
      val codeBook = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
    }

    val pcaVectorBufferParams = new MemoryBufferParams[FixedPoint] {
      override val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      override val nRows:Int = pcaParams.nFeatures
      override val nColumns:Int = pcaParams.nDimensions
    }

    val goldenModelParameters = new wellnessIntegrationParameterBundle


    WellnessIntegrationTesterFP(filter1Params: FIRFilterParams[FixedPoint],
      filter2Params: FIRFilterParams[FixedPoint],
      filter3Params: FIRFilterParams[FixedPoint],
      fftBufferParams: FFTBufferParams[FixedPoint],
      fftConfig: FFTConfig[FixedPoint],
      bandpower1Params: BandpowerParams[FixedPoint],
      bandpower2Params: BandpowerParams[FixedPoint],
      bandpower3Params: BandpowerParams[FixedPoint],
      pcaParams: PCAParams[FixedPoint],
      svmParams: SVMParams[FixedPoint],
      pcaVectorBufferParams: MemoryBufferParams[FixedPoint],
      goldenModelParameters: wellnessIntegrationParameterBundle) should be (true)
  }

}