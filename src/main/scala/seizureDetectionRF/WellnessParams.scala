/*
package wellness

// *********************************************
// Import packages
// *********************************************
import firFilter._
import features._
import randomforest._
import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._

import scala.collection.Seq
import scala.collection.mutable.ArrayBuffer

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

  val filterAlphaParams = new FIRFilterParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val taps = Seq(1, 2, 3, 4, 5, 0).map(ConvertableTo[FixedPoint].fromDouble(_))
  }

  val filterBetaParams = new FIRFilterParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val taps = Seq(1, 2, 3, 4, 5, 0).map(ConvertableTo[FixedPoint].fromDouble(_))
  }

  val filterGammaParams = new FIRFilterParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val taps = Seq(1, 2, 3, 4, 5, 0).map(ConvertableTo[FixedPoint].fromDouble(_))
  }

  val bandpowerParams = new sumSquaresParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val windowSize = lineLength1Params.windowSize
  }

  val randomForestParams = new RandomForestParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val nFeatures = 4
    val nDepth = 4
    val nTrees = 100

    val featureSelect = Seq.fill(nTrees, (1 << nDepth) - 1)(0)
  }

  val configurationMemoryParams = new ConfigurationMemoryParams[FixedPoint] {

    val protoData = randomForestParams.protoData.cloneType
    val nTrees: Int = randomForestParams.nTrees
    val nDepth: Int = randomForestParams.nDepth
  }
}
*/

