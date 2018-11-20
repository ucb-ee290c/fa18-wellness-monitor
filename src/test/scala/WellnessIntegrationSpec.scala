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

abstract class lineLengthParamsTemplate {
  val windowSize:Int
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

abstract class configurationMemoryParamsTemplate {
  val nDimensions:Int
  val nFeatures:Int
  val nSupports:Int
  val nClassifiers:Int
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
  val lineLength1Params:lineLengthParamsTemplate = new lineLengthParamsTemplate {
    override val windowSize = 2
  }
  val lineLength2Params:lineLengthParamsTemplate = new lineLengthParamsTemplate {
    override val windowSize = 2
  }
  val lineLength3Params:lineLengthParamsTemplate = new lineLengthParamsTemplate {
    override val windowSize = 2
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
    override val nFeatures:Int = 2
    override val nClasses = 2
    override val nDegree = 1
    override val kernelType = "poly"
    override val classifierType = "ovo"
    override val codeBook:Seq[Seq[Int]] = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
  }
  val pcaVectorBufferParams:pcaVectorBufferParamsTemplate = new pcaVectorBufferParamsTemplate {
    override val nRows: Int = 2
    override val nColumns: Int = 3
  }
  val configurationMemoryParams:configurationMemoryParamsTemplate = new configurationMemoryParamsTemplate {
    override val nDimensions: Int = 3
    override val nFeatures: Int = 2
    override val nSupports: Int = 2
    override val nClassifiers: Int = 1
  }

}

class WellnessIntegrationSpec extends FlatSpec with Matchers {
  behavior of "Wellness"

  it should "pass the input through filters, compute features, and classify (SInt)" in {

    val tap_count = scala.util.Random.nextInt(50) + 1

    val coefficients1 = mutable.ArrayBuffer[Int]()
    val coefficients2 = mutable.ArrayBuffer[Int]()
    val coefficients3 = mutable.ArrayBuffer[Int]()
    for(j <- 0 until tap_count) {
      coefficients1 += (-32 + scala.util.Random.nextInt(64))
      coefficients2 += (-32 + scala.util.Random.nextInt(64))
      coefficients3 += (-32 + scala.util.Random.nextInt(64)) }

    //val numDimensions = scala.util.Random.nextInt(9) + 2
    //val numFeatures = scala.util.Random.nextInt(numDimensions - 1) + 1

    val goldenModelParameters = new wellnessIntegrationParameterBundle {
      override val filter1Params: filterParamsTemplate = new filterParamsTemplate {
        override val taps: Seq[Double] = coefficients1.map(_.toDouble)
      }
      override val filter2Params: filterParamsTemplate = new filterParamsTemplate {
        override val taps: Seq[Double] = coefficients2.map(_.toDouble)
      }
      override val filter3Params: filterParamsTemplate = new filterParamsTemplate {
        override val taps: Seq[Double] = coefficients3.map(_.toDouble)
      }
      override val lineLength1Params: lineLengthParamsTemplate = new lineLengthParamsTemplate {
        override val windowSize = 2
      }
      override val lineLength2Params: lineLengthParamsTemplate = new lineLengthParamsTemplate {
        override val windowSize = 2
      }
      override val lineLength3Params: lineLengthParamsTemplate = new lineLengthParamsTemplate {
        override val windowSize = 2
      }
      override val pcaParams:pcaParamsTemplate = new pcaParamsTemplate {
        override val nDimensions: Int = 3
        override val nFeatures: Int = 2
      }
      override val svmParams:svmParamsTemplate = new svmParamsTemplate {
        override val nSupports = 2
        override val nFeatures:Int = pcaParams.nFeatures
        override val nClasses = 2
        override val nDegree = 1
        override val kernelType = "poly"
        override val classifierType = "ovo"
        override val codeBook:Seq[Seq[Int]] = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
      }
      override val pcaVectorBufferParams:pcaVectorBufferParamsTemplate = new pcaVectorBufferParamsTemplate {
        override val nRows: Int = pcaParams.nFeatures
        override val nColumns: Int = pcaParams.nDimensions
      }
      override val configurationMemoryParams: configurationMemoryParamsTemplate = new configurationMemoryParamsTemplate {
        object computeNClassifiers {
          def apply(params: svmParamsTemplate with Object {
            val nClasses: Int
            val codeBook: Seq[Seq[Int]]
            val classifierType: String
          }): Int =
            if (params.classifierType == "ovr") {
              if (params.nClasses == 2) params.nClasses - 1
              else 1
            }
            else if (params.classifierType == "ovo") {
              (params.nClasses*(params.nClasses - 1))/2
            }
            else if (params.classifierType == "ecoc") {
              params.codeBook.head.length
            }
            else 1
        }
        override val nDimensions: Int = pcaParams.nDimensions
        override val nFeatures: Int = pcaParams.nFeatures
        override val nSupports: Int = svmParams.nSupports
        override val nClassifiers: Int = computeNClassifiers(svmParams)
      }
    }

    val nPts = 4

    val filter1Params = new FIRFilterParams[SInt] {
      override val protoData = SInt(32.W)
      override val taps = coefficients1.map(_.asSInt())
    }

    val filter2Params = new FIRFilterParams[SInt] {
      override val protoData = SInt(32.W)
      override val taps = coefficients2.map(_.asSInt())
    }

    val filter3Params = new FIRFilterParams[SInt] {
      override val protoData = SInt(32.W)
      override val taps = coefficients3.map(_.asSInt())
    }

    val lineLength1Params = new lineLengthParams[SInt] {
      override val protoData = SInt(32.W)
      override val windowSize = 2
    }

    val lineLength2Params = new lineLengthParams[SInt] {
      override val protoData = SInt(32.W)
      override val windowSize = 2
    }

    val lineLength3Params = new lineLengthParams[SInt] {
      override val protoData = SInt(32.W)
      override val windowSize = 2
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

    val configurationMemoryParams = new ConfigurationMemoryParams[SInt] {
      object computeNClassifiers {
        def apply(params: SVMParams[chisel3.SInt] with Object {
          val nClasses: Int
          val codeBook: Seq[Seq[Int]]
          val classifierType: String
        }): Int =
          if (params.classifierType == "ovr") {
            if (params.nClasses == 2) params.nClasses - 1
            else 1
          }
          else if (params.classifierType == "ovo") {
            (params.nClasses*(params.nClasses - 1))/2
          }
          else if (params.classifierType == "ecoc") {
            params.codeBook.head.length
          }
          else 1
      }
      override val protoData = pcaParams.protoData.cloneType
      override val nDimensions: Int = pcaParams.nDimensions
      override val nFeatures: Int = pcaParams.nFeatures
      override val nSupports: Int = svmParams.nSupports
      override val nClassifiers: Int = computeNClassifiers(svmParams)
    }


    WellnessIntegrationTesterSInt(filter1Params: FIRFilterParams[SInt],
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
      goldenModelParameters: wellnessIntegrationParameterBundle) should be (true)
  }

  it should "pass the input through filters, compute features, and classify (FixedPoint)" in {

    val nPts = 4

    val dataWidth = 32
    val dataBP = 8

    val tap_count = scala.util.Random.nextInt(50) + 1
    val coefficients1 = mutable.ArrayBuffer[Double]()
    val coefficients2 = mutable.ArrayBuffer[Double]()
    val coefficients3 = mutable.ArrayBuffer[Double]()
    for(j <- 0 until tap_count) {
      coefficients1 += (-32 + scala.util.Random.nextFloat * 64)
      coefficients2 += (-32 + scala.util.Random.nextFloat * 64)
      coefficients3 += (-32 + scala.util.Random.nextFloat * 64)
    }

    val goldenModelParameters = new wellnessIntegrationParameterBundle {
      override val filter1Params: filterParamsTemplate = new filterParamsTemplate {
        override val taps: Seq[Double] = coefficients1
      }
      override val filter2Params: filterParamsTemplate = new filterParamsTemplate {
        override val taps: Seq[Double] = coefficients2
      }
      override val filter3Params: filterParamsTemplate = new filterParamsTemplate {
        override val taps: Seq[Double] = coefficients3
      }
      override val lineLength1Params: lineLengthParamsTemplate = new lineLengthParamsTemplate {
        override val windowSize = 2
      }
      override val lineLength2Params: lineLengthParamsTemplate = new lineLengthParamsTemplate {
        override val windowSize = 2
      }
      override val lineLength3Params: lineLengthParamsTemplate = new lineLengthParamsTemplate {
        override val windowSize = 2
      }
      override val pcaParams:pcaParamsTemplate = new pcaParamsTemplate {
        override val nDimensions: Int = 3
        override val nFeatures: Int = 2
      }
      override val svmParams:svmParamsTemplate = new svmParamsTemplate {
        override val nSupports = 2
        override val nFeatures:Int = pcaParams.nFeatures
        override val nClasses = 2
        override val nDegree = 1
        override val kernelType = "poly"
        override val classifierType = "ovo"
        override val codeBook:Seq[Seq[Int]] = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
      }
      override val pcaVectorBufferParams:pcaVectorBufferParamsTemplate = new pcaVectorBufferParamsTemplate {
        override val nRows: Int = pcaParams.nFeatures
        override val nColumns: Int = pcaParams.nDimensions
      }
      override val configurationMemoryParams: configurationMemoryParamsTemplate = new configurationMemoryParamsTemplate {
        object computeNClassifiers {
          def apply(params: svmParamsTemplate with Object {
            val nClasses: Int
            val codeBook: Seq[Seq[Int]]
            val classifierType: String
          }): Int =
            if (params.classifierType == "ovr") {
              if (params.nClasses == 2) params.nClasses - 1
              else 1
            }
            else if (params.classifierType == "ovo") {
              (params.nClasses*(params.nClasses - 1))/2
            }
            else if (params.classifierType == "ecoc") {
              params.codeBook.head.length
            }
            else 1
        }
        override val nDimensions: Int = pcaParams.nDimensions
        override val nFeatures: Int = pcaParams.nFeatures
        override val nSupports: Int = svmParams.nSupports
        override val nClassifiers: Int = computeNClassifiers(svmParams)
      }
    }

    val filter1Params = new FIRFilterParams[FixedPoint] {
      override val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      override val taps = coefficients1.map(ConvertableTo[FixedPoint].fromDouble(_))
    }

    val filter2Params = new FIRFilterParams[FixedPoint] {
      override val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      override val taps = coefficients2.map(ConvertableTo[FixedPoint].fromDouble(_))
    }

    val filter3Params = new FIRFilterParams[FixedPoint] {
      override val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      override val taps = coefficients3.map(ConvertableTo[FixedPoint].fromDouble(_))
    }
    val lineLength1Params = new lineLengthParams[FixedPoint] {
      override val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      override val windowSize = 2
    }
    val lineLength2Params = new lineLengthParams[FixedPoint] {
      override val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      override val windowSize = 2
    }
    val lineLength3Params = new lineLengthParams[FixedPoint] {
      override val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      override val windowSize = 2
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

    val configurationMemoryParams = new ConfigurationMemoryParams[FixedPoint] {
      object computeNClassifiers {
        def apply(params: SVMParams[FixedPoint] with Object {
          val nClasses: Int
          val codeBook: Seq[Seq[Int]]
          val classifierType: String
        }): Int =
          if (params.classifierType == "ovr") {
            if (params.nClasses == 2) params.nClasses - 1
            else 1
          }
          else if (params.classifierType == "ovo") {
            (params.nClasses*(params.nClasses - 1))/2
          }
          else if (params.classifierType == "ecoc") {
            params.codeBook.head.length
          }
          else 1
      }
      override val protoData = pcaParams.protoData.cloneType
      override val nDimensions: Int = pcaParams.nDimensions
      override val nFeatures: Int = pcaParams.nFeatures
      override val nSupports: Int = svmParams.nSupports
      override val nClassifiers: Int = computeNClassifiers(svmParams)
    }


    WellnessIntegrationTesterFP(filter1Params: FIRFilterParams[FixedPoint],
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
      goldenModelParameters: wellnessIntegrationParameterBundle) should be (true)
  }

}