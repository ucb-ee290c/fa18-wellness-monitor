package wellness

import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._
import firFilter._
import fft._
import features._
import pca._
import svm._

import scala.collection.Seq
import scala.collection.mutable.ArrayBuffer

object SIntWellnessParams {

  val nPts = 4

  val filter1Params = new FIRFilterParams[SInt] {
    val protoData = SInt(32.W)
    val taps = Seq(1.S, 2.S, 3.S, 4.S, 5.S, 0.S)
  }

  // lineLength params
  val lineLength1Params = new lineLengthParams[SInt] {
    val protoData = SInt(32.W)
    val windowSize = 2
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
    val idxEndBin = nPts - 1
    val nBins = nPts
    val genIn = DspComplex(SInt(32.W), SInt(32.W))
    val genOut = SInt(32.W)
  }
  val bandpower2Params = new BandpowerParams[SInt] {
    val idxStartBin = 0
    val idxEndBin = nPts - 1
    val nBins = nPts
    val genIn = DspComplex(SInt(32.W), SInt(32.W))
    val genOut = SInt(32.W)
  }

  val pcaParams = new PCAParams[SInt] {
    val protoData = SInt(32.W)
    val nDimensions = 3 // input dimension, minimum 1
    val nFeatures = 2 // output dimension to SVM, minimum 1
  }

  val svmParams = new SVMParams[SInt] {
    val protoData = pcaParams.protoData.cloneType
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
}

object utilities {
  // function to read CSVs and return data in 2D format (in Strings, need to convert after calling if needed)
  def readCSV(fileLoc: String): Seq[Seq[String]] = {
    val fileContents = ArrayBuffer[Array[String]]()
    val fileSource = io.Source.fromFile(fileLoc)
    fileSource.getLines.foreach { line => fileContents += line.split(",").map(_.trim) }
    fileSource.close()
    fileContents.map(_.toSeq)
  }
}

object FixedPointWellnessParams {

  val nPts = 4

  val Seq(dataWidth, dataBP) = utilities.readCSV("scripts/generated_files/datasize.csv").flatMap(_.map(_.toInt))

  val filter1Params = new FIRFilterParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val taps = Seq(1, 2, 3, 4, 5, 0).map(ConvertableTo[FixedPoint].fromDouble(_))
  }

  val lineLength1Params = new lineLengthParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val windowSize = 2
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
    val idxEndBin = 3
    val nBins = nPts
    val genIn = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP))
    val genOut = FixedPoint(dataWidth.W,dataBP.BP)
  }
  val bandpower2Params = new BandpowerParams[FixedPoint] {
    val idxStartBin = 0
    val idxEndBin = 1
    val nBins = nPts
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
}

object FixedPointModelWellnessParams {

  // determine the dataWidth and dataBP parameters
  val Seq(dataWidth, dataBP) = utilities.readCSV("scripts/generated_files/datasize.csv").flatMap(_.map(_.toInt))

  val filter_taps = utilities.readCSV("scripts/generated_files/filter_taps.csv").flatMap(_.map(_.toDouble))

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

  val filter1Params = new FIRFilterParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val taps = filter_taps.map(ConvertableTo[FixedPoint].fromDouble(_))
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
    val idxStartBin = bandpower1Index(0)
    val idxEndBin = bandpower1Index(1)
    val nBins = windowLength
    val genIn = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP))
    val genOut = FixedPoint(dataWidth.W,dataBP.BP)
  }
  val bandpower2Params = new BandpowerParams[FixedPoint] {
    val idxStartBin = bandpower2Index(0)
    val idxEndBin = bandpower2Index(1)
    val nBins = windowLength
    val genIn = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP))
    val genOut = FixedPoint(dataWidth.W,dataBP.BP)
  }

  val pcaParams = new PCAParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val nDimensions = dimensions
    val nFeatures = features
  }

  val svmParams = new SVMParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val nSupports = supports
    val nFeatures = pcaParams.nFeatures
    val nClasses = classes
    val nDegree = degree
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
}