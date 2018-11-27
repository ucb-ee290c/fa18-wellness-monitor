package wellness

import java.io._

import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._
import features._
import fft._
import firFilter._
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

abstract class fftConfigTemplate {
  val nPts: Int
}

abstract class bandpowerParamsTemplate {
  val idxStartBin: Int
  val idxEndBin: Int
  val nBins: Int
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

abstract class configurationMemoryParamsTemplate {
  val nDimensions:Int
  val nFeatures:Int
  val nSupports:Int
  val nClassifiers:Int
}

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
  val pcaParams:pcaParamsTemplate = new pcaParamsTemplate {
    val nDimensions: Int = 0
    val nFeatures: Int = 0
  }
  val svmParams:svmParamsTemplate = new svmParamsTemplate {
    val nSupports: Int = 0
    val nFeatures:Int = 0
    val nClasses: Int = 0
    val nDegree: Int = 0
    val kernelType: String = "adel"
    val classifierType: String = "adel"
    val codeBook:Seq[Seq[Int]] = Seq.fill(1,1)(0)
  }
  val configurationMemoryParams:configurationMemoryParamsTemplate = new configurationMemoryParamsTemplate {
    val nDimensions: Int = 0
    val nFeatures: Int = 0
    val nSupports: Int = 0
    val nClassifiers: Int = 0
  }
}

class WellnessIntegrationSpec extends FlatSpec with Matchers {
  behavior of "Wellness"

  // set this to 1 to use the generated files from the Python model
  val integrated = 1

  // I am leaving this SInt implementation as is, since my testbench is meant for floats/fixedpoints
  it should "pass the input through filters, compute features, and classify (SInt)" in {

    val debug = 0

    val windowLength = 4

    val tap_count = 5
    val coefficients1 = mutable.ArrayBuffer[Int]()
    for(j <- 0 until tap_count) {
      coefficients1 += j
       }

    val goldenModelParameters = new wellnessIntegrationParameterBundle {
      override val filter1Params: filterParamsTemplate = new filterParamsTemplate {
        val taps: Seq[Double] = coefficients1.map(_.toDouble)
      }
      override val lineLength1Params: lineLengthParamsTemplate = new lineLengthParamsTemplate {
        val windowSize = windowLength
      }
      override val fftBufferParams:fftBufferParamsTemplate = new fftBufferParamsTemplate {
        val lanes: Int = windowLength
      }
      override val fftConfig: fftConfigTemplate = new fftConfigTemplate {
        val nPts: Int = windowLength
      }
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
      override val pcaParams:pcaParamsTemplate = new pcaParamsTemplate {
        val nDimensions: Int = 3
        val nFeatures: Int = 2
      }
      override val svmParams:svmParamsTemplate = new svmParamsTemplate {
        val nSupports: Int = 2
        val nFeatures:Int = pcaParams.nFeatures
        val nClasses: Int = 2
        val nDegree: Int = 1
        val kernelType: String = "poly"
        val classifierType: String = "ovo"
        val codeBook:Seq[Seq[Int]] = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
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
        val nDimensions: Int = pcaParams.nDimensions
        val nFeatures: Int = pcaParams.nFeatures
        val nSupports: Int = svmParams.nSupports
        val nClassifiers: Int = computeNClassifiers(svmParams)
      }
    }

    val filter1Params = new FIRFilterParams[SInt] {
      val protoData = SInt(64.W)
      val taps = coefficients1.map(_.asSInt())
    }

    val lineLength1Params = new lineLengthParams[SInt] {
      val protoData = SInt(64.W)
      val windowSize = windowLength
    }

    // FFTBufferParams
    val fftBufferParams = new FFTBufferParams[SInt] {
      val protoData = SInt(64.W)
      val lanes = windowLength
    }

    // FFTConfigs
    val fftConfig = FFTConfig(
      genIn = DspComplex(SInt(64.W), SInt(64.W)),
      genOut = DspComplex(SInt(64.W), SInt(64.W)),
      n = windowLength,
      lanes = windowLength,
      pipelineDepth = 0,
      quadrature = false,
    )

    // BandpowerParams
    val bandpower1Params = new BandpowerParams[SInt] {
      val idxStartBin = 0
      val idxEndBin = 2
      val nBins = windowLength
      val genIn = DspComplex(SInt(64.W), SInt(64.W))
      val genOut = SInt(64.W)
    }
    val bandpower2Params = new BandpowerParams[SInt] {
      val idxStartBin = 0
      val idxEndBin = 2
      val nBins = windowLength
      val genIn = DspComplex(SInt(64.W), SInt(64.W))
      val genOut = SInt(64.W)
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

    WellnessIntegrationTesterSInt(filter1Params: FIRFilterParams[SInt],
      lineLength1Params: lineLengthParams[SInt],
      fftBufferParams: FFTBufferParams[SInt],
      fftConfig: FFTConfig[SInt],
      bandpower1Params: BandpowerParams[SInt],
      bandpower2Params: BandpowerParams[SInt],
      pcaParams: PCAParams[SInt],
      svmParams: SVMParams[SInt],
      configurationMemoryParams: ConfigurationMemoryParams[SInt],
      goldenModelParameters: wellnessIntegrationParameterBundle, debug) should be (true)
  }

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

    val goldenModelParameters = new wellnessIntegrationParameterBundle {
      override val filter1Params: filterParamsTemplate = new filterParamsTemplate {
        val taps: Seq[Double] = coefficients1
      }
      override val lineLength1Params: lineLengthParamsTemplate = new lineLengthParamsTemplate {
        val windowSize = windowLength
      }
      override val fftBufferParams:fftBufferParamsTemplate = new fftBufferParamsTemplate {
        val lanes: Int = windowLength
      }
      override val fftConfig: fftConfigTemplate = new fftConfigTemplate {
        val nPts: Int = windowLength
      }
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
      override val pcaParams:pcaParamsTemplate = new pcaParamsTemplate {
        val nDimensions: Int = 3
        val nFeatures: Int = 2
      }
      override val svmParams:svmParamsTemplate = new svmParamsTemplate {
        val nSupports: Int = 2
        val nFeatures:Int = pcaParams.nFeatures
        val nClasses: Int = 2
        val nDegree: Int = 1
        val kernelType: String = "poly"
        val classifierType: String = "ovo"
        val codeBook:Seq[Seq[Int]] = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
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
        val nDimensions: Int = pcaParams.nDimensions
        val nFeatures: Int = pcaParams.nFeatures
        val nSupports: Int = svmParams.nSupports
        val nClassifiers: Int = computeNClassifiers(svmParams)
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

    // FFTBufferParams
    val fftBufferParams = new FFTBufferParams[FixedPoint] {
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      val lanes = windowLength
    }

    // FFTConfigs
    val fftConfig = FFTConfig(
      genIn = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP)),
      genOut = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP)),
      n = windowLength,
      lanes = windowLength,
      pipelineDepth = 0,
      quadrature = false,
    )

    // BandpowerParams
    val bandpower1Params = new BandpowerParams[FixedPoint] {
      val idxStartBin = 0
      val idxEndBin = 2
      val nBins = windowLength
      val genIn = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP))
      val genOut = FixedPoint(dataWidth.W,dataBP.BP)
    }
    val bandpower2Params = new BandpowerParams[FixedPoint] {
      val idxStartBin = 0
      val idxEndBin = 2
      val nBins = windowLength
      val genIn = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP))
      val genOut = FixedPoint(dataWidth.W,dataBP.BP)
    }

    val pcaParams = new PCAParams[FixedPoint] {
      val protoData = FixedPoint(dataWidth.W,dataBP.BP)
      val nDimensions = 3 // input dimension, minimum 1
      val nFeatures = 2   // output dimension to SVM, minimum 1
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
      val protoData = pcaParams.protoData.cloneType
      val nDimensions: Int = pcaParams.nDimensions
      val nFeatures: Int = pcaParams.nFeatures
      val nSupports: Int = svmParams.nSupports
      val nClassifiers: Int = computeNClassifiers(svmParams)
    }

    WellnessIntegrationTesterFP(filter1Params: FIRFilterParams[FixedPoint],
      lineLength1Params: lineLengthParams[FixedPoint],
      fftBufferParams: FFTBufferParams[FixedPoint],
      fftConfig: FFTConfig[FixedPoint],
      bandpower1Params: BandpowerParams[FixedPoint],
      bandpower2Params: BandpowerParams[FixedPoint],
      pcaParams: PCAParams[FixedPoint],
      svmParams: SVMParams[FixedPoint],
      configurationMemoryParams: ConfigurationMemoryParams[FixedPoint],
      goldenModelParameters: wellnessIntegrationParameterBundle, debug, 0) should be (true)
  }

  if (integrated == 1) {
    it should "work using the Python model generated files" in {
      val debug = 1

      val dataWidth = 32
      val dataBP = 8

      // write out the dataWidth and dataBP to a file
      // these values need to be consistent between WellnessIntegrationTester, Wellness, and the C code
      val file = new FileWriter(new File("scripts/generated_files/datasize.csv"))
      file.write(f"$dataWidth,$dataBP")
      file.close()

      // get the filter taps from the file, generated in Python
      val filter_taps = utilities.readCSV("scripts/generated_files/filter_taps.csv").flatMap(_.map(_.toDouble))

      // get the parameter values from the file, generated in Python as well
      val Seq(windowLength, features, dimensions, supports, classes, degree) =
      /* This is the order of parameters, as written in the Python file, for reference
      fe.window,                  # windowSize, lanes, nPts, nBins
      pca.components_.shape[0],   # nFeatures
      pca.components_.shape[1],   # nDimensions
      supports.shape[0],          # nSupports
      classes,                    # nClasses
      degree                      # nDegree */
        utilities.readCSV("scripts/generated_files/parameters.csv").flatMap(_.map(_.toInt))

      // this is my preliminary attempt to generalize the identification of bandpower indices
      // looks cool :)
      val feature_list = utilities.readCSV("scripts/generated_files/feature_list.csv").flatten

      var bandpower1Index = Seq(0, 0)
      var bandpower2Index = Seq(0, 0)
      val band_list = Seq("delta", "theta", "alpha", "beta", "gamma")

      for (i <- feature_list.indices) {
        for (j <- band_list.indices) {
          if (feature_list(i) == band_list(j)) {
            if (i == 0) {
              bandpower1Index = utilities.readCSV(f"scripts/generated_files/${band_list(j)}%s_index.csv").flatMap(_.map(_.toInt))
            } else {
              bandpower2Index = utilities.readCSV(f"scripts/generated_files/${band_list(j)}%s_index.csv").flatMap(_.map(_.toInt))
            }
          }
        }
      }

      val goldenModelParameters = new wellnessIntegrationParameterBundle {
        override val filter1Params: filterParamsTemplate = new filterParamsTemplate {
          val taps: Seq[Double] = filter_taps
        }
        override val lineLength1Params: lineLengthParamsTemplate = new lineLengthParamsTemplate {
          val windowSize = windowLength
        }
        override val fftBufferParams: fftBufferParamsTemplate = new fftBufferParamsTemplate {
          val lanes: Int = windowLength
        }
        override val fftConfig: fftConfigTemplate = new fftConfigTemplate {
          val nPts: Int = windowLength
        }
        override val bandpower1Params: bandpowerParamsTemplate = new bandpowerParamsTemplate {
          val idxStartBin: Int = bandpower1Index(0)
          val idxEndBin: Int = bandpower1Index(1)
          val nBins: Int = windowLength
        }
        override val bandpower2Params: bandpowerParamsTemplate = new bandpowerParamsTemplate {
          val idxStartBin: Int = bandpower2Index(0)
          val idxEndBin: Int = bandpower2Index(1)
          val nBins: Int = windowLength
        }
        override val pcaParams: pcaParamsTemplate = new pcaParamsTemplate {
          val nDimensions: Int = dimensions
          val nFeatures: Int = features
        }
        override val svmParams: svmParamsTemplate = new svmParamsTemplate {
          val nSupports: Int = supports
          val nFeatures: Int = pcaParams.nFeatures
          val nClasses: Int = classes
          val nDegree: Int = degree
          val kernelType: String = "poly"
          val classifierType: String = "ovo"
          val codeBook: Seq[Seq[Int]] = Seq.fill(nClasses, nClasses * 2)((scala.util.Random.nextInt(2) * 2) - 1) // ignored for this test case
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
                (params.nClasses * (params.nClasses - 1)) / 2
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

      val filter1Params = new FIRFilterParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W, dataBP.BP)
        val taps = filter_taps.map(ConvertableTo[FixedPoint].fromDouble(_))
      }

      val lineLength1Params = new lineLengthParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W, dataBP.BP)
        val windowSize = windowLength
      }

      // FFTBufferParams
      val fftBufferParams = new FFTBufferParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W, dataBP.BP)
        val lanes = windowLength
      }

      // FFTConfigs
      val fftConfig = FFTConfig(
        genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP)),
        genOut = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP)),
        n = windowLength,
        lanes = windowLength,
        pipelineDepth = 0,
        quadrature = false,
      )

      // BandpowerParams
      val bandpower1Params = new BandpowerParams[FixedPoint] {
        val idxStartBin = bandpower1Index(0)
        val idxEndBin = bandpower1Index(1)
        val nBins = windowLength
        val genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP))
        val genOut = FixedPoint(dataWidth.W, dataBP.BP)
      }
      val bandpower2Params = new BandpowerParams[FixedPoint] {
        val idxStartBin = bandpower2Index(0)
        val idxEndBin = bandpower2Index(1)
        val nBins = windowLength
        val genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP))
        val genOut = FixedPoint(dataWidth.W, dataBP.BP)
      }

      val pcaParams = new PCAParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W, dataBP.BP)
        val nDimensions = dimensions
        val nFeatures = features
      }

      val svmParams = new SVMParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W, dataBP.BP)
        val nSupports = supports
        val nFeatures = pcaParams.nFeatures
        val nClasses = classes
        val nDegree = degree
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

        val protoData = pcaParams.protoData.cloneType
        val nDimensions: Int = pcaParams.nDimensions
        val nFeatures: Int = pcaParams.nFeatures
        val nSupports: Int = svmParams.nSupports
        val nClassifiers: Int = computeNClassifiers(svmParams)
      }

      WellnessIntegrationTesterFP(filter1Params: FIRFilterParams[FixedPoint],
        lineLength1Params: lineLengthParams[FixedPoint],
        fftBufferParams: FFTBufferParams[FixedPoint],
        fftConfig: FFTConfig[FixedPoint],
        bandpower1Params: BandpowerParams[FixedPoint],
        bandpower2Params: BandpowerParams[FixedPoint],
        pcaParams: PCAParams[FixedPoint],
        svmParams: SVMParams[FixedPoint],
        configurationMemoryParams: ConfigurationMemoryParams[FixedPoint],
        goldenModelParameters: wellnessIntegrationParameterBundle, debug, 1) should be(true)
    }
  }
}