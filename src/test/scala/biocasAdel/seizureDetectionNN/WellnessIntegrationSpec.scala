/*
package wellness

import java.io._

import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._
import features._
import firFilter._
import org.scalatest.{FlatSpec, Matchers}
import neuralNet._

import scala.collection.{Seq, mutable}

/**
  * WellnessIntegrationSpec
  *
  * This code is organized as follows:
  *   xxParamsTemplate: Parameter Templates for Golden Models
  *   wellnessIntegrationParameterBundle: Parameters Bundle for wellnessTester
  *   wellnessIntegrationSpec: Spec definitions for the wellnessTester
  *
  */

/**
  * xxParamsTemplate
  *
  * These are parameter templates for Golden Models since they require different parameters than the modules themselves
  *
  */
abstract class filterParamsTemplate {
  val taps:Seq[Double]
}

abstract class lineLengthParamsTemplate {
  val windowSize:Int
}

abstract class sumSquaresParamsTemplate {
  val windowSize:Int
}

abstract class neuralNetsParamsTemplate {
  val nFeatures:Int
  val nNeurons:Int
}

abstract class configurationMemoryParamsTemplate {
  val nFeatures:Int
  val nNeurons:Int
}

/**
  * wellnessIntegrationParameterBundle
  *
  * Bundle containing all the parameters for the golden models.
  *
  */

class wellnessIntegrationParameterBundle {

  // the numbers here are actually irrelevant, you just need to put something
  // these will be overwritten anyway in the WellnessIntegrationSpec class
  // the 'requires' are not even being checked!
  val filter1Params:filterParamsTemplate = new filterParamsTemplate {
    val taps = Seq(0.toDouble)
  }
  val lineLength1Params:lineLengthParamsTemplate = new lineLengthParamsTemplate {
    val windowSize = 0
  }
  val filterAlphaParams:filterParamsTemplate = new filterParamsTemplate {
    val taps = Seq(0.toDouble)
  }
  val filterBetaParams:filterParamsTemplate = new filterParamsTemplate {
    val taps = Seq(0.toDouble)
  }
  val filterGammaParams:filterParamsTemplate = new filterParamsTemplate {
    val taps = Seq(0.toDouble)
  }
  val bandpowerParams:sumSquaresParamsTemplate = new sumSquaresParamsTemplate {
    val windowSize = 0
  }
  val neuralNetsParams: neuralNetsParamsTemplate = new neuralNetsParamsTemplate {
    val nFeatures: Int = 0
    val nNeurons: Int = 0
  }
  val configurationMemoryParams:configurationMemoryParamsTemplate = new configurationMemoryParamsTemplate {
    val nFeatures: Int = 0
    val nNeurons: Int = 0
  }
}

/**
  * WellnessIntegrationSpec
  *
  * Spec list for the Integration Test. Three tests are currently programmed to run:
  *   -> SInt test with a random input stream with random block parameters
  *   -> FixedPoint test with a random input stream with random block parameters
  *   -> FixedPoint test with a pre-determined input, with pre-determined block parameters
  *
  */

class WellnessIntegrationSpec extends FlatSpec with Matchers {
  behavior of "Wellness"

  // set this to 1 to use the generated files from the Python model
  val integrated = 0

  it should "pass the input through filters, compute features, and classify (FixedPoint)" in {
    val debug = 0

    val windowLength = 32

    val dataWidth = 32
    val dataBP = 8

    // write out the dataWidth and dataBP to a file
    // these values need to be consistent between WellnessIntegrationTester, Wellness, and the C code
    val file = new FileWriter(new File("scripts/generated_files/datasize.csv"))
    file.write(f"$dataWidth,$dataBP")
    file.close()

    val tap_count = scala.util.Random.nextInt(15) + 1
    val coefficients1 = mutable.ArrayBuffer[Double]()
    for(j <- 0 until tap_count) {
      coefficients1 += (-5 + scala.util.Random.nextFloat * 10)
    }
    val coefficients2 = mutable.ArrayBuffer[Double]()
    for(j <- 0 until tap_count) {
      coefficients2 += (-5 + scala.util.Random.nextFloat * 10)
    }
    val coefficients3 = mutable.ArrayBuffer[Double]()
    for(j <- 0 until tap_count) {
      coefficients3 += (-5 + scala.util.Random.nextFloat * 10)
    }
    val coefficients4 = mutable.ArrayBuffer[Double]()
    for(j <- 0 until tap_count) {
      coefficients4 += (-5 + scala.util.Random.nextFloat * 10)
    }

    val goldenModelParameters = new wellnessIntegrationParameterBundle {
      override val filter1Params: filterParamsTemplate = new filterParamsTemplate {
        val taps: Seq[Double] = coefficients1
      }
      override val lineLength1Params: lineLengthParamsTemplate = new lineLengthParamsTemplate {
        val windowSize = windowLength
      }
      override val filterAlphaParams: filterParamsTemplate = new filterParamsTemplate {
        val taps: Seq[Double] = coefficients2
      }
      override val filterBetaParams: filterParamsTemplate = new filterParamsTemplate {
        val taps: Seq[Double] = coefficients3
      }
      override val filterGammaParams: filterParamsTemplate = new filterParamsTemplate {
        val taps: Seq[Double] = coefficients4
      }
      override val bandpowerParams: sumSquaresParamsTemplate = new sumSquaresParamsTemplate {
        val windowSize = windowLength
      }

      override val neuralNetsParams:neuralNetsParamsTemplate = new neuralNetsParamsTemplate {
        val protoData = FixedPoint(dataWidth.W,dataBP.BP)
        val nFeatures = 4
        val nNeurons = 10
      }

      override val configurationMemoryParams: configurationMemoryParamsTemplate = new configurationMemoryParamsTemplate {
        val nFeatures: Int = neuralNetsParams.nFeatures
        val nNeurons: Int = neuralNetsParams.nNeurons
      }
    }

    val filter1Params = new FIRFilterParams[FixedPoint] {
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      val taps = coefficients1.map(ConvertableTo[FixedPoint].fromDouble(_))
    }

    val lineLength1Params = new lineLengthParams[FixedPoint] {
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      val windowSize = windowLength
    }

    val filterAlphaParams = new FIRFilterParams[FixedPoint] {
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      val taps = coefficients2.map(ConvertableTo[FixedPoint].fromDouble(_))
    }
    val filterBetaParams = new FIRFilterParams[FixedPoint] {
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      val taps = coefficients3.map(ConvertableTo[FixedPoint].fromDouble(_))
    }
    val filterGammaParams = new FIRFilterParams[FixedPoint] {
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      val taps = coefficients4.map(ConvertableTo[FixedPoint].fromDouble(_))
    }

    val bandpowerParams = new sumSquaresParams[FixedPoint] {
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      val windowSize = windowLength
    }

    val neuralNetsParams = new NeuralNetParams[FixedPoint] {
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      val nFeatures = 4
      val nNeurons = 10
    }

    val configurationMemoryParams = new ConfigurationMemoryParams[FixedPoint] {
      val protoData = neuralNetsParams.protoData.cloneType
      val nFeatures: Int = neuralNetsParams.nFeatures
      val nNeurons: Int = neuralNetsParams.nNeurons
    }

    WellnessIntegrationTesterFP(filter1Params: FIRFilterParams[FixedPoint],
      lineLength1Params: lineLengthParams[FixedPoint],
      filterAlphaParams: FIRFilterParams[FixedPoint],
      filterBetaParams: FIRFilterParams[FixedPoint],
      filterGammaParams: FIRFilterParams[FixedPoint],
      bandpowerParams: sumSquaresParams[FixedPoint],
      neuralNetsParams: NeuralNetParams[FixedPoint],
      configurationMemoryParams: ConfigurationMemoryParams[FixedPoint],
      goldenModelParameters: wellnessIntegrationParameterBundle, debug, 0) should be (true)
  }

}
*/