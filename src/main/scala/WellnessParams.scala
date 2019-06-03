
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
import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._
//import wellness.FixedPointWellnessGenParams.{datapathParamsArr, datapathsArr, trimTree}

import scala.collection.Seq
import scala.collection.mutable.ArrayBuffer
import scala.util.control.Breaks._

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
  val nPts = 8

  val Seq(dataWidth, dataBP) = utilities.readCSV("scripts/generated_files/datasize.csv").flatMap(_.map(_.toInt))

  /*
  val wellnessGenParams1 = new wellnessGenParams[FixedPoint] {
    val dataType = FixedPoint(dataWidth.W,dataBP.BP)
  }
   */

  val filter1Params = new FIRFilterParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val taps = Seq(1, 2, 3, 4, 5, 0).map(ConvertableTo[FixedPoint].fromDouble(_))
  }

  val lineLength1Params = new lineLengthParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val windowSize = 2
  }

  val fftBufferParams = new FFTBufferParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val lanes = nPts
  }

  val fftConfig = FFTConfig(
    genIn = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP)),
    genOut = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP)),
    n = nPts,
    lanes = nPts,
    pipelineDepth = 0,
    quadrature = false,
  )

  val bandpower1Params = new BandpowerParams[FixedPoint] {
    val idxStartBin = 0
    val idxEndBin = 4
    val nBins = nPts
    val genIn = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP))
    val genOut = FixedPoint(dataWidth.W,dataBP.BP)
  }
  val bandpower2Params = new BandpowerParams[FixedPoint] {
    val idxStartBin = 0
    val idxEndBin = 2
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

/*
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

  val fftBufferParams = new FFTBufferParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val lanes = windowLength
  }

  val fftConfig = FFTConfig(
    genIn = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP)),
    genOut = DspComplex(FixedPoint(dataWidth.W,dataBP.BP), FixedPoint(dataWidth.W,dataBP.BP)),
    n = windowLength,
    lanes = windowLength,
    pipelineDepth = 0,
    quadrature = false,
  )

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

 */

