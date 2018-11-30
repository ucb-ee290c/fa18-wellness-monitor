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

abstract class fftBufferParamsTemplate {
  val lanes:Int
}

abstract class fftConfigTemplate {
  val nPts: Int
}

abstract class bandpowerParamsTemplate {
  val idxStartBin: Int
  val idxEndBin: Int
  val nBins: Int
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
  val fftBufferParams:fftBufferParamsTemplate = new fftBufferParamsTemplate {
    val lanes: Int = 0
  }
  val fftConfig: fftConfigTemplate = new fftConfigTemplate {
    val nPts: Int = 0
  }
  val bandpower1Params: bandpowerParamsTemplate = new bandpowerParamsTemplate {
    val idxStartBin: Int = 0
    val idxEndBin: Int = 0
    val nBins: Int = 0
  }
  val bandpower2Params: bandpowerParamsTemplate = new bandpowerParamsTemplate {
    val idxStartBin: Int = 0
    val idxEndBin: Int = 0
    val nBins: Int = 0
  }
}

class wellnessGenIntegrationSpec extends FlatSpec with Matchers {
  behavior of "Wellness"

  it should "Should generate and randomnly test the datapath" in {

    val debug = 0

    val tap_count = 2
    val coefficients1 = Seq(1,1)
    val windowLength = 4

    val goldenModelParameters = new wellnessGenIntegrationParameterBundle {
      override val filter1Params: filterGenParamsTemplate = new filterGenParamsTemplate {
        val taps: Seq[Double] = coefficients1.map(_.toDouble)
      }
      override val lineLength1Params: lineLengthGenParamsTemplate = new lineLengthGenParamsTemplate {
        override val windowSize: Int = windowLength
      }
      override val fftBufferParams:fftBufferParamsTemplate = new fftBufferParamsTemplate {
        val lanes: Int = windowLength
      }
      override val fftConfig: fftConfigTemplate = new fftConfigTemplate {
        val nPts: Int = windowLength
      }
      // TODO: parameterize to match Chisel params
      override val bandpower1Params: bandpowerParamsTemplate = new bandpowerParamsTemplate {
        val idxStartBin: Int = 0
        val idxEndBin: Int = 2
        val nBins: Int = windowLength
      }
      override val bandpower2Params: bandpowerParamsTemplate = new bandpowerParamsTemplate {
        val idxStartBin: Int = 0
        val idxEndBin: Int = 2
        val nBins: Int = windowLength
      }
    }

    val wellnessGenParams1 = new wellnessGenParams[SInt] {
      val protoData = SInt(64.W)
    }


    wellnessGenIntegrationTesterSInt(wellnessGenParams1: wellnessGenParams[SInt],
      goldenModelParameters: wellnessGenIntegrationParameterBundle, debug) should be (true)
  }
}