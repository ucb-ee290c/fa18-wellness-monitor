package wellness

// *********************************************
// Import packages
// *********************************************
import firFilter._
import iirFilter._
import fft._
import features._
import pca._
import svm._
import memorybuffer._

import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._

import org.scalatest.{FlatSpec, Matchers}

import scala.collection.Seq
import scala.collection.mutable.ArrayBuffer

// *********************************************
// Abstract class declarations for golden params
// *********************************************
abstract class firGenParamsTemplate {
  val taps: Seq[Double]
}

abstract class iirGenParamsTemplate {
  val tapsA: Seq[Double]
  val tapsB: Seq[Double]
}

abstract class lineLengthGenParamsTemplate {
  val windowSize: Int
}

abstract class fftBufferGenParamsTemplate {
  val lanes: Int
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
  val nDimensions: Int
  val nFeatures: Int
}

abstract class svmParamsGenTemplate {
  val nSupports: Int
  val nFeatures: Int
  val nClasses: Int
  val nDegree: Int
  val kernelType: String
  val classifierType: String
  val codeBook: Seq[Seq[Int]]
}

abstract class configurationMemoryParamsGenTemplate {
  val nDimensions: Int
  val nFeatures: Int
  val nSupports: Int
  val nClassifiers: Int
}

// *********************************************
// Golden PCA, SVM, and Configuration Memory
// params bundle
// *********************************************
class wellnessGenIntegrationParameterBundle {
  val goldenPCAParams: pcaParamsGenTemplate = new pcaParamsGenTemplate {
    val nDimensions: Int = 0
    val nFeatures: Int = 0
  }
  val goldenSVMParams: svmParamsGenTemplate = new svmParamsGenTemplate {
    val nSupports: Int = 0
    val nFeatures:Int = 0
    val nClasses: Int = 0
    val nDegree: Int = 0
    val kernelType: String = "adel"
    val classifierType: String = "adel"
    val codeBook: Seq[Seq[Int]] = Seq.fill(1,1)(0)
  }
  val goldenConfigurationMemoryParams: configurationMemoryParamsGenTemplate = new configurationMemoryParamsGenTemplate {
    val nDimensions: Int = 0
    val nFeatures: Int = 0
    val nSupports: Int = 0
    val nClassifiers: Int = 0
  }
}


class wellnessGenIntegrationSpec extends FlatSpec with Matchers {
  behavior of "WellnessGen"

  it should "Generate and test a Wellness Monitor (SInt)" in {
    val debug = 0

    val nFFT: Int = 4

    val dataPrototype = SInt(64.W)

    val wellnessGenParams1 = new wellnessGenParams[SInt] {
      val dataType = dataPrototype
    }

    // Generate arr of params datapaths
    val datapathsArr: ArrayBuffer[Seq[(String, Any)]] = ArrayBuffer()
    val goldenDatapathsArr: ArrayBuffer[Seq[(String, Any)]] = ArrayBuffer()

    // *********************************************
    // Generate Chisel datapath from feature request
    // *********************************************
    def makeChiselBandpower(channel: Int, idxLowBin: Int, idxUpBin: Int): Seq[(String, Any)] = {
      val fftBufferParams = new FFTBufferParams[SInt] {
        val protoData = dataPrototype
        val lanes = nFFT
      }
      val fftConfig = FFTConfig(
        genIn = DspComplex(dataPrototype, dataPrototype),
        genOut = DspComplex(dataPrototype, dataPrototype),
        n = nFFT,
        lanes = nFFT,
        pipelineDepth = 0,
        quadrature = false,
      )
      val bandpowerParams = new BandpowerParams[SInt] {
        val idxStartBin = idxLowBin
        val idxEndBin = idxUpBin
        val nBins = nFFT
        val genIn = DspComplex(dataPrototype, dataPrototype)
        val genOut = dataPrototype
      }

      val bandpowerDatapath: Seq[(String, Any)] = Seq(("FFTBuffer", fftBufferParams), ("FFT", fftConfig), ("Bandpower", bandpowerParams))
      bandpowerDatapath
    }

    def makeChiselLineLength(channel: Int, windowLength: Int, filterType: String, filterTapsA: Seq[Double], filterTapsB: Seq[Double]): Seq[(String, Any)] = {
      val filterParams =
        if (filterType == "FIR")
          new FIRFilterParams[SInt] {
            val protoData = dataPrototype
            val taps = filterTapsA.map(ConvertableTo[SInt].fromDouble(_))
          }
        else if (filterType == "IIR")
          new IIRFilterParams[SInt] {
            val protoData = dataPrototype
            val consts_A = filterTapsA.map(ConvertableTo[SInt].fromDouble(_))
            val consts_B = filterTapsB.map(ConvertableTo[SInt].fromDouble(_))
          }

      val lineLengthParams = new lineLengthParams[SInt] {
        val protoData = dataPrototype
        val windowSize = windowLength
      }

      val lineLengthDatapath: Seq[(String, Any)] = Seq((filterType, filterParams), ("LineLength", lineLengthParams))
      lineLengthDatapath
    }

    // *********************************************
    // Generate golden datapath from feature request
    // *********************************************
    def makeGoldenBandpower(channel: Int, idxLowBin: Int, idxUpBin: Int): Seq[(String, Any)] = {
      val fftBufferParams = new fftBufferGenParamsTemplate {
        override val lanes: Int = nFFT
      }
      val fftConfig = new fftConfigGenTemplate {
        override val nPts: Int = nFFT
      }
      val bandpowerParams = new bandpowerParamsGenTemplate {
        override val idxStartBin: Int = idxLowBin
        override val idxEndBin: Int = idxUpBin
        override val nBins: Int = nFFT
      }

      val bandpowerDatapath: Seq[(String, Any)] = Seq(("FFTBuffer", fftBufferParams), ("FFT", fftConfig), ("Bandpower", bandpowerParams))
      bandpowerDatapath
    }

    def makeGoldenLineLength(channel: Int, windowLength: Int, filterType: String, filterTapsA: Seq[Double], filterTapsB: Seq[Double]): Seq[(String, Any)] = {
      val filterParams =
        if (filterType == "FIR")
          new firGenParamsTemplate {
            override val taps: Seq[Double] = filterTapsA
          }
        else if (filterType == "IIR")
          new iirGenParamsTemplate {
            override val tapsA: Seq[Double] = filterTapsA
            override val tapsB: Seq[Double] = filterTapsB
          }

      val lineLengthParams = new lineLengthGenParamsTemplate {
        override val windowSize: Int = windowLength
      }

      val lineLengthDatapath: Seq[(String, Any)] = Seq((filterType, filterParams), ("LineLength", lineLengthParams))
      lineLengthDatapath
    }

    // TODO: CODE SECTION RELEVANT TO USER
    // Bandpower 1
    datapathsArr += makeChiselBandpower(0, 0, 2)
    goldenDatapathsArr += makeGoldenBandpower(0, 0, 2)
    // Bandpower 2
    datapathsArr += makeChiselBandpower(0, 0, 2)
    goldenDatapathsArr += makeGoldenBandpower(0, 0, 2)
    // Line Length 1
    val ch0LL1FilterTapsA: Seq[Double] = Seq(1.0, 2.0, 3.0, 4.0, 5.0, 0.0)
    datapathsArr += makeChiselLineLength(0, 2, "FIR", ch0LL1FilterTapsA, ch0LL1FilterTapsA)
    goldenDatapathsArr += makeGoldenLineLength(0, 2, "FIR", ch0LL1FilterTapsA, ch0LL1FilterTapsA)

    // Rename to pass to tester
    // TODO: Change after more channels are added
    val datapathParamsArr: ArrayBuffer[Seq[(String, Any)]] = datapathsArr
    val goldenDatapathParamsArr: ArrayBuffer[Seq[(String, Any)]] = goldenDatapathsArr

    // *********************************************
    // Chisel PCA, SVM, and
    // Configuration Memory params
    // *********************************************
    val pcaParams = new PCAParams[SInt] {
      val protoData = dataPrototype
      val nDimensions = 3 // input dimension, minimum 1
      val nFeatures = 2 // output dimension to SVM, minimum 1
    }

    val svmParams = new SVMParams[SInt] {
      val protoData = dataPrototype
      val nSupports = 2
      val nFeatures = pcaParams.nFeatures
      val nClasses = 2
      val nDegree = 1
      val kernelType = "poly"
      val classifierType = "ovo"
      val codeBook = Seq.fill(nClasses, nClasses * 2)((scala.util.Random.nextInt(2) * 2) - 1) // ignored for this test case
    }

    val configurationMemoryParams = new ConfigurationMemoryParams[SInt] {
      object computeNClassifiers {
        def apply(params: SVMParams[SInt] with Object {
          val nClasses: Int
          val codeBook: Seq[Seq[Int]]
          val classifierType: String
        }): Int =
          if (params.classifierType == "ovr") {
            if (params.nClasses == 2) params.nClasses - 1
            else 1
          }
          else if (params.classifierType == "ovo") {
            (params.nClasses * (params.nClasses - 1)) / 2
          }
          else if (params.classifierType == "ecoc") {
            params.codeBook.head.length
          }
          else 1
      }
      val protoData = dataPrototype
      val nDimensions: Int = pcaParams.nDimensions
      val nFeatures: Int = pcaParams.nFeatures
      val nSupports: Int = svmParams.nSupports
      val nClassifiers: Int = computeNClassifiers(svmParams)
    }

    // *********************************************
    // Golden PCA, SVM, and
    // Configuration Memory params
    // *********************************************
    val goldenParams = new wellnessGenIntegrationParameterBundle {
      override val goldenPCAParams: pcaParamsGenTemplate = new pcaParamsGenTemplate {
        val nDimensions: Int = pcaParams.nDimensions
        val nFeatures: Int = pcaParams.nFeatures
      }
      override val goldenSVMParams: svmParamsGenTemplate = new svmParamsGenTemplate {
        val nSupports: Int = svmParams.nSupports
        val nFeatures: Int = svmParams.nFeatures
        val nClasses: Int = svmParams.nClasses
        val nDegree: Int = svmParams.nDegree
        val kernelType: String = svmParams.kernelType
        val classifierType: String = svmParams.classifierType
        val codeBook: Seq[Seq[Int]] = svmParams.codeBook
      }
      override val goldenConfigurationMemoryParams: configurationMemoryParamsGenTemplate = new configurationMemoryParamsGenTemplate {
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
        val nDimensions: Int = goldenPCAParams.nDimensions
        val nFeatures: Int = goldenPCAParams.nFeatures
        val nSupports: Int = goldenSVMParams.nSupports
        val nClassifiers: Int = computeNClassifiers(goldenSVMParams)
      }
    }

    // Call tester
    wellnessGenIntegrationTesterSInt(
      wellnessGenParams1,
      datapathParamsArr,
      pcaParams,
      svmParams,
      configurationMemoryParams,
      goldenDatapathParamsArr,
      goldenParams,
      debug
    ) should be (true)
  }


  it should "Generate and test a Wellness Monitor (FixedPoint)" in {
    val debug = 0

    val nFFT: Int = 8

    val dataWidth = 32
    val dataBP = 8
    val dataPrototype = FixedPoint(dataWidth.W, dataBP.BP)

    val wellnessGenParams1 = new wellnessGenParams[FixedPoint] {
      val dataType = dataPrototype
    }

    // Generate arr of params datapaths
    val datapathsArr: ArrayBuffer[Seq[(String, Any)]] = ArrayBuffer()
    val goldenDatapathsArr: ArrayBuffer[Seq[(String, Any)]] = ArrayBuffer()

    // *********************************************
    // Generate Chisel datapath from feature request
    // *********************************************
    def makeChiselBandpower(channel: Int, idxLowBin: Int, idxUpBin: Int): Seq[(String, Any)] = {
      val fftBufferParams = new FFTBufferParams[FixedPoint] {
        val protoData = dataPrototype
        val lanes = nFFT
      }
      val fftConfig = FFTConfig(
        genIn = DspComplex(dataPrototype, dataPrototype),
        genOut = DspComplex(dataPrototype, dataPrototype),
        n = nFFT,
        lanes = nFFT,
        pipelineDepth = 0,
        quadrature = false,
      )
      val bandpowerParams = new BandpowerParams[FixedPoint] {
        val idxStartBin = idxLowBin
        val idxEndBin = idxUpBin
        val nBins = nFFT
        val genIn = DspComplex(dataPrototype, dataPrototype)
        val genOut = dataPrototype
      }

      val bandpowerDatapath: Seq[(String, Any)] = Seq(("FFTBuffer", fftBufferParams), ("FFT", fftConfig), ("Bandpower", bandpowerParams))
      bandpowerDatapath
    }

    def makeChiselLineLength(channel: Int, windowLength: Int, filterType: String, filterTapsA: Seq[Double], filterTapsB: Seq[Double]): Seq[(String, Any)] = {
      val filterParams =
        if (filterType == "FIR")
          new FIRFilterParams[FixedPoint] {
            val protoData = dataPrototype
            val taps = filterTapsA.map(ConvertableTo[FixedPoint].fromDouble(_))
          }
        else if (filterType == "IIR")
          new IIRFilterParams[FixedPoint] {
            val protoData = dataPrototype
            val consts_A = filterTapsA.map(ConvertableTo[FixedPoint].fromDouble(_))
            val consts_B = filterTapsB.map(ConvertableTo[FixedPoint].fromDouble(_))
          }

      val lineLengthParams = new lineLengthParams[FixedPoint] {
        val protoData = dataPrototype
        val windowSize = windowLength
      }

      val lineLengthDatapath: Seq[(String, Any)] = Seq((filterType, filterParams), ("LineLength", lineLengthParams))
      lineLengthDatapath
    }

    // *********************************************
    // Generate golden datapath from feature request
    // *********************************************
    def makeGoldenBandpower(channel: Int, idxLowBin: Int, idxUpBin: Int): Seq[(String, Any)] = {
      val fftBufferParams = new fftBufferGenParamsTemplate {
        override val lanes: Int = nFFT
      }
      val fftConfig = new fftConfigGenTemplate {
        override val nPts: Int = nFFT
      }
      val bandpowerParams = new bandpowerParamsGenTemplate {
        override val idxStartBin: Int = idxLowBin
        override val idxEndBin: Int = idxUpBin
        override val nBins: Int = nFFT
      }

      val bandpowerDatapath: Seq[(String, Any)] = Seq(("FFTBuffer", fftBufferParams), ("FFT", fftConfig), ("Bandpower", bandpowerParams))
      bandpowerDatapath
    }

    def makeGoldenLineLength(channel: Int, windowLength: Int, filterType: String, filterTapsA: Seq[Double], filterTapsB: Seq[Double]): Seq[(String, Any)] = {
      val filterParams =
        if (filterType == "FIR")
          new firGenParamsTemplate {
            override val taps: Seq[Double] = filterTapsA
          }
        else if (filterType == "IIR")
          new iirGenParamsTemplate {
            override val tapsA: Seq[Double] = filterTapsA
            override val tapsB: Seq[Double] = filterTapsB
          }

      val lineLengthParams = new lineLengthGenParamsTemplate {
        override val windowSize: Int = windowLength
      }

      val lineLengthDatapath: Seq[(String, Any)] = Seq((filterType, filterParams), ("LineLength", lineLengthParams))
      lineLengthDatapath
    }

    // TODO: CODE SECTION RELEVANT TO USER
    // Bandpower 1
    datapathsArr += makeChiselBandpower(0, 0, 2)
    goldenDatapathsArr += makeGoldenBandpower(0, 0, 2)
    // Bandpower 2
    datapathsArr += makeChiselBandpower(0, 0, 2)
    goldenDatapathsArr += makeGoldenBandpower(0, 0, 2)
    // Line Length 1
    val ch0LL1FilterTapsA: Seq[Double] = Seq(1.0, 2.0, 3.0, 4.0, 5.0, 0.0)
    datapathsArr += makeChiselLineLength(0, 2, "FIR", ch0LL1FilterTapsA, ch0LL1FilterTapsA)
    goldenDatapathsArr += makeGoldenLineLength(0, 2, "FIR", ch0LL1FilterTapsA, ch0LL1FilterTapsA)

    // Rename to pass to tester
    // TODO: Change after more channels are added
    val datapathParamsArr: ArrayBuffer[Seq[(String, Any)]] = datapathsArr
    val goldenDatapathParamsArr: ArrayBuffer[Seq[(String, Any)]] = goldenDatapathsArr

    // *********************************************
    // Chisel PCA, SVM, and
    // Configuration Memory params
    // *********************************************
    val pcaParams = new PCAParams[FixedPoint] {
      val protoData = dataPrototype
      val nDimensions = 3 // input dimension, minimum 1
      val nFeatures = 2 // output dimension to SVM, minimum 1
    }

    val svmParams = new SVMParams[FixedPoint] {
      val protoData = dataPrototype
      val nSupports = 2
      val nFeatures = pcaParams.nFeatures
      val nClasses = 2
      val nDegree = 1
      val kernelType = "poly"
      val classifierType = "ovo"
      val codeBook = Seq.fill(nClasses, nClasses * 2)((scala.util.Random.nextInt(2) * 2) - 1) // ignored for this test case
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
            (params.nClasses * (params.nClasses - 1)) / 2
          }
          else if (params.classifierType == "ecoc") {
            params.codeBook.head.length
          }
          else 1
      }
      val protoData = dataPrototype
      val nDimensions: Int = pcaParams.nDimensions
      val nFeatures: Int = pcaParams.nFeatures
      val nSupports: Int = svmParams.nSupports
      val nClassifiers: Int = computeNClassifiers(svmParams)
    }

    // *********************************************
    // Golden PCA, SVM, and
    // Configuration Memory params
    // *********************************************
    val goldenParams = new wellnessGenIntegrationParameterBundle {
      override val goldenPCAParams: pcaParamsGenTemplate = new pcaParamsGenTemplate {
        val nDimensions: Int = pcaParams.nDimensions
        val nFeatures: Int = pcaParams.nFeatures
      }
      override val goldenSVMParams: svmParamsGenTemplate = new svmParamsGenTemplate {
        val nSupports: Int = svmParams.nSupports
        val nFeatures: Int = svmParams.nFeatures
        val nClasses: Int = svmParams.nClasses
        val nDegree: Int = svmParams.nDegree
        val kernelType: String = svmParams.kernelType
        val classifierType: String = svmParams.classifierType
        val codeBook: Seq[Seq[Int]] = svmParams.codeBook
      }
      override val goldenConfigurationMemoryParams: configurationMemoryParamsGenTemplate = new configurationMemoryParamsGenTemplate {
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
        val nDimensions: Int = goldenPCAParams.nDimensions
        val nFeatures: Int = goldenPCAParams.nFeatures
        val nSupports: Int = goldenSVMParams.nSupports
        val nClassifiers: Int = computeNClassifiers(goldenSVMParams)
      }
    }

    // Call tester
    wellnessGenIntegrationTesterFP(
      wellnessGenParams1,
      datapathParamsArr,
      pcaParams,
      svmParams,
      configurationMemoryParams,
      goldenDatapathParamsArr,
      goldenParams,
      debug
    ) should be (true)
  }
}