package wellness
import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._
import features._
import fft._
import firFilter._
import org.scalatest.{FlatSpec, Matchers}
import pca._
import svm._

import scala.collection.mutable.ArrayBuffer
import scala.collection.{Seq, mutable}

abstract class filterGenParamsTemplate {
  val taps:Seq[Double]
}
abstract class lineLengthGenParamsTemplate {
  val windowSize:Int
}

abstract class fftBufferGenParamsTemplate {
  val lanes:Int
}

abstract class fftConfigGenTemplate {
  val nPts: Int
}

abstract class bandpowerParamsGenTemplate {
  val idxStartBin: Int
  val idxEndBin: Int
  val nBins: Int
}

abstract class pcaParamsGenTemplate {
  val nDimensions:Int
  val nFeatures:Int
}

abstract class svmParamsGenTemplate {
  val nSupports:Int
  val nFeatures:Int
  val nClasses:Int
  val nDegree:Int
  val kernelType:String
  val classifierType:String
  val codeBook:Seq[Seq[Int]]
}

abstract class configurationMemoryParamsGenTemplate {
  val nDimensions:Int
  val nFeatures:Int
  val nSupports:Int
  val nClassifiers:Int
}

class wellnessGenIntegrationParameterBundle {

  // the numbers here are actually irrelevant, you just need to put something
  // these will be overwritten anyway in the WellnessIntegrationSpec class
  // the 'requires' are not even being checked!
  val filter1Params:filterGenParamsTemplate = new filterGenParamsTemplate {
    val taps = Seq(0.toDouble)
  }
  val lineLength1Params:lineLengthGenParamsTemplate = new lineLengthGenParamsTemplate {
    val protoData = SInt(64.W)
    val windowSize = 4
  }
  val fftBufferParams:fftBufferGenParamsTemplate = new fftBufferGenParamsTemplate {
    val lanes: Int = 0
  }
  val fftConfig: fftConfigGenTemplate = new fftConfigGenTemplate {
    val nPts: Int = 0
  }
  val bandpower1Params: bandpowerParamsGenTemplate = new bandpowerParamsGenTemplate {
    val idxStartBin: Int = 0
    val idxEndBin: Int = 0
    val nBins: Int = 0
  }
  val bandpower2Params: bandpowerParamsGenTemplate = new bandpowerParamsGenTemplate {
    val idxStartBin: Int = 0
    val idxEndBin: Int = 0
    val nBins: Int = 0
  }
  val pcaParams:pcaParamsGenTemplate = new pcaParamsGenTemplate {
    val nDimensions: Int = 0
    val nFeatures: Int = 0
  }
  val svmParams:svmParamsGenTemplate = new svmParamsGenTemplate {
    val nSupports: Int = 0
    val nFeatures:Int = 0
    val nClasses: Int = 0
    val nDegree: Int = 0
    val kernelType: String = "adel"
    val classifierType: String = "adel"
    val codeBook:Seq[Seq[Int]] = Seq.fill(1,1)(0)
  }
  val configurationMemoryParams:configurationMemoryParamsGenTemplate = new configurationMemoryParamsGenTemplate {
    val nDimensions: Int = 0
    val nFeatures: Int = 0
    val nSupports: Int = 0
    val nClassifiers: Int = 0
  }
}

class wellnessGenIntegrationSpec extends FlatSpec with Matchers {
  behavior of "Wellness"

  it should "Should generate and randomnly test the datapath" in {

    val debug = 0

    val tap_count = 4
    val coefficients1 = Seq(2,4,5,6)
    val windowLength = 32

    val goldenModelParameters = new wellnessGenIntegrationParameterBundle {
      override val filter1Params: filterGenParamsTemplate = new filterGenParamsTemplate {
        val taps: Seq[Double] = coefficients1.map(_.toDouble)
      }
      override val lineLength1Params: lineLengthGenParamsTemplate = new lineLengthGenParamsTemplate {
        override val windowSize: Int = windowLength
      }
      override val fftBufferParams: fftBufferGenParamsTemplate = new fftBufferGenParamsTemplate {
        val lanes: Int = windowLength
      }
      override val fftConfig: fftConfigGenTemplate = new fftConfigGenTemplate {
        val nPts: Int = windowLength
      }
      // TODO: parameterize to match Chisel params
      override val bandpower1Params: bandpowerParamsGenTemplate = new bandpowerParamsGenTemplate {
        val idxStartBin: Int = 0
        val idxEndBin: Int = 2
        val nBins: Int = windowLength
      }
      override val bandpower2Params: bandpowerParamsGenTemplate = new bandpowerParamsGenTemplate {
        val idxStartBin: Int = 0
        val idxEndBin: Int = 2
        val nBins: Int = windowLength
      }
      override val pcaParams: pcaParamsGenTemplate = new pcaParamsGenTemplate {
        val nDimensions: Int = 3
        val nFeatures: Int = 2
      }
      override val svmParams: svmParamsGenTemplate = new svmParamsGenTemplate {
        val nSupports: Int = 2
        val nFeatures: Int = pcaParams.nFeatures
        val nClasses: Int = 2
        val nDegree: Int = 1
        val kernelType: String = "poly"
        val classifierType: String = "ovo"
        val codeBook: Seq[Seq[Int]] = Seq.fill(nClasses, nClasses * 2)((scala.util.Random.nextInt(2) * 2) - 1)
      }
      override val configurationMemoryParams: configurationMemoryParamsGenTemplate = new configurationMemoryParamsGenTemplate {
        object computeNClassifiers {
          def apply(params: svmParamsGenTemplate with Object {
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
        val nDimensions: Int = pcaParams.nDimensions
        val nFeatures: Int = pcaParams.nFeatures
        val nSupports: Int = svmParams.nSupports
        val nClassifiers: Int = computeNClassifiers(svmParams)
      }
    }

    val wellnessGenParams1 = new wellnessGenParams[SInt] {
      val dataType = SInt(64.W)
    }


    val pcaParams = new PCAParams[SInt] {
      val protoData = SInt(64.W)
      val nDimensions = 3 // input dimension, minimum 1
      val nFeatures = 2   // output dimension to SVM, minimum 1
    }

    val svmParams = new SVMParams[SInt] {
      val protoData = SInt(64.W)
      val nSupports = 2
      val nFeatures = pcaParams.nFeatures
      val nClasses = 2
      val nDegree = 1
      val kernelType = "poly"
      val classifierType = "ovo"
      val codeBook = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
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
      val protoData = pcaParams.protoData.cloneType
      val nDimensions: Int = pcaParams.nDimensions
      val nFeatures: Int = pcaParams.nFeatures
      val nSupports: Int = svmParams.nSupports
      val nClassifiers: Int = computeNClassifiers(svmParams)
    }


    wellnessGenIntegrationTesterSInt(wellnessGenParams1: wellnessGenParams[SInt],
      pcaParams: PCAParams[SInt],
      svmParams: SVMParams[SInt],
      configurationMemoryParams: ConfigurationMemoryParams[SInt],
      goldenModelParameters: wellnessGenIntegrationParameterBundle, debug) should be (true)
  }
}