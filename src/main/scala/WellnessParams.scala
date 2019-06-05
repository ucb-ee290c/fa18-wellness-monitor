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
import logistic._
import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._
import wellness.FixedPointWellnessGenParams.{datapathParamsArr, datapathsArr, trimTree}

import scala.collection.Seq
import scala.collection.mutable.ArrayBuffer
import scala.util.control.Breaks._

object SIntWellnessParams {
  val nPts = 4

  val filter1Params = new FIRFilterParams[SInt] {
    val protoData = SInt(32.W)
    val taps = Seq(1.S, 2.S, 3.S, 4.S, 5.S, 0.S)
  }

  val lineLength1Params = new lineLengthParams[SInt] {
    val protoData = SInt(32.W)
    val windowSize = 2
  }

  val fftBufferParams = new FFTBufferParams[SInt] {
    val protoData = SInt(32.W)
    val lanes = nPts
  }

  val fftConfig = FFTConfig(
    genIn = DspComplex(SInt(32.W), SInt(32.W)),
    genOut = DspComplex(SInt(32.W), SInt(32.W)),
    n = nPts,
    lanes = nPts,
    pipelineDepth = 0,
    quadrature = false,
  )

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

  val logisticParams = new LogisticParams[SInt] {
    val protoData = SInt(32.W)
    val nFeatures = pcaParams.nFeatures           // the number of reduced dimensions, coming from PCA if ever
    val nThresholds = 10          // the number of threshold points for logit estimation

    val onlineLearn = 0          // online learning activation switch
    val nWindow = 5              // the training window for ictal segments
    val nInterCount = 60         // the training window for interictal segments

    val ictalIndex = nThresholds       // the index wrt threshold, for the online learning scheme
    val interIndex = 1       // same as above, but for interictal training

    val learningRate = 0.01
  }

  val logisticConfigurationMemoryParams = new ConfigurationMemoryParams[SInt] {

    val protoData = pcaParams.protoData.cloneType
    val nDimensions: Int = 3
    val nFeatures: Int = pcaParams.nFeatures
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

  val wellnessGenParams1 = new wellnessGenParams[FixedPoint] {
    val dataType = FixedPoint(dataWidth.W,dataBP.BP)
  }

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

  val logisticParams = new LogisticParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val nFeatures = pcaParams.nFeatures           // the number of reduced dimensions, coming from PCA if ever
    val nThresholds = 10          // the number of threshold points for logit estimation

    val onlineLearn = 0          // online learning activation switch
    val nWindow = 5              // the training window for ictal segments
    val nInterCount = 60         // the training window for interictal segments

    val ictalIndex = nThresholds       // the index wrt threshold, for the online learning scheme
    val interIndex = 1       // same as above, but for interictal training

    val learningRate = 0.01
  }

  val configurationMemoryParams = new ConfigurationMemoryParams[FixedPoint] {

    val protoData = pcaParams.protoData.cloneType
    val nDimensions: Int = pcaParams.nDimensions
    val nFeatures: Int = pcaParams.nFeatures
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

  val logisticParams = new LogisticParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W,dataBP.BP)
    val nFeatures = pcaParams.nFeatures           // the number of reduced dimensions, coming from PCA if ever
    val nThresholds = 10          // the number of threshold points for logit estimation

    val onlineLearn = 0          // online learning activation switch
    val nWindow = 5              // the training window for ictal segments
    val nInterCount = 60         // the training window for interictal segments

    val ictalIndex = nThresholds       // the index wrt threshold, for the online learning scheme
    val interIndex = 1       // same as above, but for interictal training

    val learningRate = 0.01
  }

  val configurationMemoryParams = new ConfigurationMemoryParams[FixedPoint] {

    val protoData = pcaParams.protoData.cloneType
    val nDimensions: Int = pcaParams.nDimensions
    val nFeatures: Int = pcaParams.nFeatures
  }
}


// *********************************************
// Param generation (for actual use/C tests
// *********************************************
object SIntWellnessGenParams {
  val nFFT = 4

  val dataPrototype = SInt(64.W)

  val wellnessGenParams1 = new wellnessGenParams[SInt] {
    val dataType = dataPrototype
  }

  // Instantiate arr to hold param datapaths
  val datapathsArr: ArrayBuffer[Seq[(String, Any)]] = ArrayBuffer()
  // Bandpower 1
  datapathsArr += makeBandpower(0, 0, 2)
  // Bandpower 2
  datapathsArr += makeBandpower(0, 0, 2)
  // Line Length 1
  val ll1FilterTapsA: Seq[Double] = Seq(1.0, 2.0, 3.0, 4.0, 5.0, 0.0)
  datapathsArr += makeLineLength(0, 2, "FIR", ll1FilterTapsA, ll1FilterTapsA)
  // Rename to pass to tester
  // TODO: Change after more channels are added
  // val datapathParamsArr = datapathsArr
  val (trimmedTree,heritageArray) = trimTree(datapathsArr)
  val datapathParamsArr = trimmedTree // ADDED

  // Ryan's addition
  def compareBlocks(block1: (String, Any), block2: (String, Any)): Int = {
    if (block1._1 == block2._1)
    {
      block1._1 match
      {
        case "Bandpower" =>
          if ((block1._2.asInstanceOf[BandpowerParams[SInt]].idxStartBin == block2._2.asInstanceOf[BandpowerParams[SInt]].idxStartBin) &&
            (block1._2.asInstanceOf[BandpowerParams[SInt]].idxEndBin == block2._2.asInstanceOf[BandpowerParams[SInt]].idxEndBin) &&
            (block1._2.asInstanceOf[BandpowerParams[SInt]].nBins == block2._2.asInstanceOf[BandpowerParams[SInt]].nBins))
          {
            return 1
          }
        case "FFTBuffer" =>
          if (block1._2.asInstanceOf[FFTBufferParams[SInt]].lanes == block2._2.asInstanceOf[FFTBufferParams[SInt]].lanes)
          {
            return 1
          }
        case "FFT" =>
          if ((block1._2.asInstanceOf[FFTConfig[SInt]].lanes == block2._2.asInstanceOf[FFTConfig[SInt]].lanes) &&
            (block1._2.asInstanceOf[FFTConfig[SInt]].n == block2._2.asInstanceOf[FFTConfig[SInt]].n) &&
            (block1._2.asInstanceOf[FFTConfig[SInt]].pipelineDepth == block2._2.asInstanceOf[FFTConfig[SInt]].pipelineDepth))
          {
            return 1
          }
        case "FIR" =>
          if ((block1._2.asInstanceOf[FIRFilterParams[SInt]].protoData == block2._2.asInstanceOf[FIRFilterParams[SInt]].protoData) &&
            (block1._2.asInstanceOf[FIRFilterParams[SInt]].taps == block2._2.asInstanceOf[FIRFilterParams[SInt]].taps))
          {
            return 1
          }
        case "IIR" =>
          if ((block1._2.asInstanceOf[IIRFilterParams[SInt]].consts_A == block2._2.asInstanceOf[IIRFilterParams[SInt]].consts_A) &&
            (block1._2.asInstanceOf[IIRFilterParams[SInt]].consts_B == block2._2.asInstanceOf[IIRFilterParams[SInt]].consts_B) &&
            (block1._2.asInstanceOf[IIRFilterParams[SInt]].protoData == block2._2.asInstanceOf[IIRFilterParams[SInt]].protoData))
          {
            return 1
          }
        case "LineLength" =>
          if ((block1._2.asInstanceOf[lineLengthParams[SInt]].protoData == block2._2.asInstanceOf[lineLengthParams[SInt]].protoData) &&
            (block1._2.asInstanceOf[lineLengthParams[SInt]].windowSize == block2._2.asInstanceOf[lineLengthParams[SInt]].windowSize))
          {
            return 1
          }
        case "Buffer" =>
          if ((block1._2.asInstanceOf[FIRFilterParams[SInt]].protoData == block2._2.asInstanceOf[FIRFilterParams[SInt]].protoData) &&
            (block1._2.asInstanceOf[FIRFilterParams[SInt]].taps == block2._2.asInstanceOf[FIRFilterParams[SInt]].taps))
          {
            return 1
          }
      }
    }
    return -1
  }



  def trimTree(arr: ArrayBuffer[Seq[(String, Any)]]): (ArrayBuffer[Seq[(String, Any)]],ArrayBuffer[Seq[(Int, Int)]]) = {
    print("starting trimTree")
    var newArray: ArrayBuffer[Seq[(String, Any)]] = ArrayBuffer()

    // Generate graph of coordinates
    var coordArr: ArrayBuffer[Seq[(Int, Int)]] = ArrayBuffer()

    // Add first datapath by hand because you have to start somewhere
    // Pull out first dp sequence
    var firstDp = arr(0)
    var firstParentSeq: Seq[(Int,Int)] = Seq((0,0))
    for (i <- 1 until firstDp.length)
    {
      firstParentSeq = firstParentSeq :+ (0,i-1)
    }
    newArray += firstDp
    coordArr = coordArr :+ firstParentSeq
    print("\nAdded first datapath and edge ")

    var state = "search"
    var isDone = 0

    var compareDp_num = 0
    var compareBlock_idx = 0

    for (i <- 1 until (arr.length))
    {
      val currentDp = arr(i)
      var currentBlock = currentDp(0)
      var currentBlock_idx = 0

      var newDp: Seq[(String,Any)] = Seq()
      var newCoordDp: Seq[(Int,Int)] = Seq()
      isDone = 0

      while (isDone == 0)
      {
        state match
        {
          case "search" =>
            breakable
            { for(j <- 0 until newArray.length){
              var isBlockSame = 0
              val compareDp = newArray(j)
              val compareBlock = compareDp(0)
              isBlockSame = compareBlocks(currentBlock,compareBlock)
              if (isBlockSame == 1)
              {
                print("\n Found duplicate block! move to populate")
                compareDp_num = j
                compareBlock_idx = 1 // add one so you start at new block
                newDp = newDp :+ ("Null",0)
                newCoordDp = newCoordDp :+ (-9,-9)
                state = "populate"
                break
              }
            }}
            if (state == "search")
            {
              print("\n No duplicate block, move to finish")
              // There were no matches so currentDP is unique and can be added as a whole
              // Jump to finish
              state = "finish"
            }

          case "populate" =>
            // first find shortest dp
            var compareDp = newArray(compareDp_num)
            var loopLength = Seq(compareDp.length,currentDp.length).min
            breakable
            { for (j <- compareBlock_idx until loopLength) {
              var currentBlock = currentDp(j)
              var compareBlock = compareDp(j)
              var isBlockSame = compareBlocks(currentBlock,compareBlock)
              if (isBlockSame == 1)
              {
                newDp = newDp :+ ("Null",0)
                newCoordDp = newCoordDp :+ (-9,-9)
                print("\n" + currentBlock._1 + "is duplicate at" + (i,j) + "- keep nulling/looking")
              }
              else
              {// blocks are unique, add actual block, take appropriate coordinate and pass off to finish state
                currentBlock_idx = j+1
                newDp = newDp :+ currentBlock
                newCoordDp = newCoordDp :+ coordArr(compareDp_num)(j)
                state = "finish"
                break
                print("\n Found first unique block, move to finish")
              }
            }}

          case "finish" =>
            print("\n Made it to finish")
            for (m <- currentBlock_idx until currentDp.length)
            {
              print("\n populate remaining blocks, index = " + currentBlock_idx)
              newDp = newDp :+ currentDp(m)
              if (m == 0) { newCoordDp = newCoordDp :+ (newArray.length,0)}
              else { newCoordDp = newCoordDp :+ (newArray.length,m-1)}
            }
            newArray = newArray :+ newDp
            coordArr = coordArr :+ newCoordDp
            state = "search"
            isDone = 1
        }
      }
    }

    return (newArray,coordArr)
  }

  def makeBandpower(channel: Int, idxLowBin: Int, idxUpBin: Int): Seq[(String, Any)] = {
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

  def makeLineLength(channel: Int, windowLength: Int, filterType: String, filterTapsA: Seq[Double], filterTapsB: Seq[Double]): Seq[(String, Any)] = {
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

    val bufferSeq = Seq.fill(1)(1)
    val bufferParams = new FIRFilterParams[SInt] {
      val protoData = dataPrototype
      val taps = bufferSeq.map(ConvertableTo[SInt].fromDouble(_))
    }


    val lineLengthDatapath: Seq[(String, Any)] = Seq((filterType, filterParams), ("LineLength", lineLengthParams),("Buffer",bufferParams))
    lineLengthDatapath
  }

  // *********************************************
  // PCA, SVM, and Configuration Memory params
  // *********************************************
  val pcaParams = new PCAParams[SInt] {
    val protoData = dataPrototype
    val nDimensions = 3 // input dimension, minimum 1
    val nFeatures = 2 // output dimension to SVM, minimum 1
  }

  val logisticParams = new LogisticParams[SInt] {
    val protoData = dataPrototype
    val nFeatures = pcaParams.nFeatures           // the number of reduced dimensions, coming from PCA if ever
    val nThresholds = 10          // the number of threshold points for logit estimation

    val onlineLearn = 0          // online learning activation switch
    val nWindow = 5              // the training window for ictal segments
    val nInterCount = 60         // the training window for interictal segments

    val ictalIndex = nThresholds       // the index wrt threshold, for the online learning scheme
    val interIndex = 1       // same as above, but for interictal training

    val learningRate = 0.01
  }

  val configurationMemoryParams = new ConfigurationMemoryParams[SInt] {

    val protoData = dataPrototype
    val nDimensions: Int = 3
    val nFeatures: Int = pcaParams.nFeatures
  }
}

object FixedPointWellnessGenParams {

  // TODO: CODE SECTION RELEVANT TO USER
//  val nFFT: Int = 8
//  val dataWidth = 32
//  val dataBP = 8
  val Seq(dataWidth, dataBP) = utilities.readCSV("scripts/generated_files/datasize.csv").flatMap(_.map(_.toInt))
  val Seq(windowLength, features, dimensions, supports, classes, degree) =
  /* This is the order of parameters, as written in the Python file, for reference
  fe.window,                  # windowSize, lanes, nPts, nBins
  pca.components_.shape[0],   # nFeatures
  pca.components_.shape[1],   # nDimensions
  supports.shape[0],          # nSupports
  classes,                    # nClasses
  degree                      # nDegree */
    utilities.readCSV("scripts/generated_files/parameters.csv").flatMap(_.map(_.toInt))
  val nFFT: Int = windowLength

  val dataPrototype = FixedPoint(dataWidth.W, dataBP.BP)

  val wellnessGenParams1 = new wellnessGenParams[FixedPoint] {
    val dataType = dataPrototype
  }

  // Instantiate arr to hold param datapaths
  val datapathsArr: ArrayBuffer[Seq[(String, Any)]] = ArrayBuffer()
  //val heritageArray: ArrayBuffer[Seq[(Int, Int)]] = ArrayBuffer()
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

  // TODO: CODES SECTION RELEVANT TO USER
//  val filterTapsA: Seq[Double] = Seq(1.0, 2.0, 3.0, 4.0, 5.0, 0.0)
  val filterTapsA: Seq[Double] = utilities.readCSV("scripts/generated_files/filter_taps.csv").flatMap(_.map(_.toDouble))
  // Bandpower 1
  datapathsArr += makeBandpower(0, "FIR", filterTapsA, filterTapsA, bandpower1Index(0), bandpower1Index(1))
  // Bandpower 2
  datapathsArr += makeBandpower(0, "FIR", filterTapsA, filterTapsA, bandpower2Index(0), bandpower2Index(1))
  // Line Length 1
  datapathsArr += makeLineLength(0, windowLength, "FIR", filterTapsA, filterTapsA)

  // Rename to pass to tester
  // TODO: Change after more channels are added
  // val datapathParamsArr = datapathsArr
  val (trimmedTree,heritageArray) = trimTree(datapathsArr)
  val datapathParamsArr = trimmedTree // ADDED

  // Ryan's addition
  def compareBlocks(block1: (String, Any), block2: (String, Any)): Int = {
    if (block1._1 == block2._1)
    {
      block1._1 match
      {
        case "Bandpower" =>
          if ((block1._2.asInstanceOf[BandpowerParams[FixedPoint]].idxStartBin == block2._2.asInstanceOf[BandpowerParams[FixedPoint]].idxStartBin) &&
            (block1._2.asInstanceOf[BandpowerParams[FixedPoint]].idxEndBin == block2._2.asInstanceOf[BandpowerParams[FixedPoint]].idxEndBin) &&
            (block1._2.asInstanceOf[BandpowerParams[FixedPoint]].nBins == block2._2.asInstanceOf[BandpowerParams[FixedPoint]].nBins))
          {
            return 1
          }
        case "FFTBuffer" =>
          if (block1._2.asInstanceOf[FFTBufferParams[FixedPoint]].lanes == block2._2.asInstanceOf[FFTBufferParams[FixedPoint]].lanes)
          {
            return 1
          }
        case "FFT" =>
          if ((block1._2.asInstanceOf[FFTConfig[FixedPoint]].lanes == block2._2.asInstanceOf[FFTConfig[FixedPoint]].lanes) &&
            (block1._2.asInstanceOf[FFTConfig[FixedPoint]].n == block2._2.asInstanceOf[FFTConfig[FixedPoint]].n) &&
            (block1._2.asInstanceOf[FFTConfig[FixedPoint]].pipelineDepth == block2._2.asInstanceOf[FFTConfig[FixedPoint]].pipelineDepth))
          {
            return 1
          }
        case "FIR" =>
          if ((block1._2.asInstanceOf[FIRFilterParams[FixedPoint]].protoData == block2._2.asInstanceOf[FIRFilterParams[FixedPoint]].protoData) &&
            (block1._2.asInstanceOf[FIRFilterParams[FixedPoint]].taps.map(_.litToDouble) == block2._2.asInstanceOf[FIRFilterParams[FixedPoint]].taps.map(_.litToDouble)))
          {
            return 1
          }
        case "IIR" =>
          if ((block1._2.asInstanceOf[IIRFilterParams[FixedPoint]].consts_A == block2._2.asInstanceOf[IIRFilterParams[FixedPoint]].consts_A) &&
            (block1._2.asInstanceOf[IIRFilterParams[FixedPoint]].consts_B == block2._2.asInstanceOf[IIRFilterParams[FixedPoint]].consts_B) &&
            (block1._2.asInstanceOf[IIRFilterParams[FixedPoint]].protoData == block2._2.asInstanceOf[IIRFilterParams[FixedPoint]].protoData))
          {
            return 1
          }
        case "LineLength" =>
          if ((block1._2.asInstanceOf[lineLengthParams[FixedPoint]].protoData == block2._2.asInstanceOf[lineLengthParams[FixedPoint]].protoData) &&
            (block1._2.asInstanceOf[lineLengthParams[FixedPoint]].windowSize == block2._2.asInstanceOf[lineLengthParams[FixedPoint]].windowSize))
          {
            return 1
          }
        case "Buffer" =>
          if ((block1._2.asInstanceOf[FIRFilterParams[FixedPoint]].protoData == block2._2.asInstanceOf[FIRFilterParams[FixedPoint]].protoData) &&
            (block1._2.asInstanceOf[FIRFilterParams[FixedPoint]].taps == block2._2.asInstanceOf[FIRFilterParams[FixedPoint]].taps))
          {
            return 1
          }
      }
    }
    return -1
  }


  def trimTree(arr: ArrayBuffer[Seq[(String, Any)]]): (ArrayBuffer[Seq[(String, Any)]],ArrayBuffer[Seq[(Int, Int)]]) = {
    print("starting trimTree")
    var newArray: ArrayBuffer[Seq[(String, Any)]] = ArrayBuffer()

    // Generate graph of coordinates
    var coordArr: ArrayBuffer[Seq[(Int, Int)]] = ArrayBuffer()

    // Add first datapath by hand because you have to start somewhere
    // Pull out first dp sequence
    var firstDp = arr(0)
    var firstParentSeq: Seq[(Int,Int)] = Seq((0,0))
    for (i <- 1 until firstDp.length)
    {
      firstParentSeq = firstParentSeq :+ (0,i-1)
    }
    newArray += firstDp
    coordArr = coordArr :+ firstParentSeq
    print("\nAdded first datapath and edge ")

    var state = "search"
    var isDone = 0

    var compareDp_num = 0
    var compareBlock_idx = 0

    for (i <- 1 until (arr.length))
    {
      val currentDp = arr(i)
      var currentBlock = currentDp(0)
      var currentBlock_idx = 0

      var newDp: Seq[(String,Any)] = Seq()
      var newCoordDp: Seq[(Int,Int)] = Seq()
      isDone = 0

      while (isDone == 0)
      {
        state match
        {
          case "search" =>
            breakable
            { for(j <- 0 until newArray.length){
              var isBlockSame = 0
              val compareDp = newArray(j)
              val compareBlock = compareDp(0)
              isBlockSame = compareBlocks(currentBlock,compareBlock)
              if (isBlockSame == 1)
              {
                print("\n Found duplicate block! move to populate")
                compareDp_num = j
                compareBlock_idx = 1 // add one so you start at new block
                newDp = newDp :+ ("Null",0)
                newCoordDp = newCoordDp :+ (-9,-9)
                state = "populate"
                break
              }
            }}
            if (state == "search")
            {
              print("\n No duplicate block, move to finish")
              // There were no matches so currentDP is unique and can be added as a whole
              // Jump to finish
              state = "finish"
            }

          case "populate" =>
            // first find shortest dp
            var compareDp = newArray(compareDp_num)
            var loopLength = Seq(compareDp.length,currentDp.length).min
            breakable
            { for (j <- compareBlock_idx until loopLength) {
              var currentBlock = currentDp(j)
              var compareBlock = compareDp(j)
              var isBlockSame = compareBlocks(currentBlock,compareBlock)
              if (isBlockSame == 1)
              {
                newDp = newDp :+ ("Null",0)
                newCoordDp = newCoordDp :+ (-9,-9)
                print("\n" + currentBlock._1 + "is duplicate at" + (i,j) + "- keep nulling/looking")
              }
              else
              {// blocks are unique, add actual block, take appropriate coordinate and pass off to finish state
                currentBlock_idx = j+1
                newDp = newDp :+ currentBlock
                newCoordDp = newCoordDp :+ coordArr(compareDp_num)(j)
                state = "finish"
                break
                print("\n Found first unique block, move to finish")
              }
            }}

          case "finish" =>
            print("\n Made it to finish")
            for (m <- currentBlock_idx until currentDp.length)
            {
              print("\n populate remaining blocks, index = " + currentBlock_idx)
              newDp = newDp :+ currentDp(m)
              if (m == 0) { newCoordDp = newCoordDp :+ (newArray.length,0)}
              else { newCoordDp = newCoordDp :+ (newArray.length,m-1)}
            }
            newArray = newArray :+ newDp
            coordArr = coordArr :+ newCoordDp
            state = "search"
            isDone = 1
        }
      }
    }

    return (newArray,coordArr)
  }

  def makeBandpower(channel: Int, filterType: String, filterTapsA: Seq[Double], filterTapsB: Seq[Double], idxLowBin: Int, idxUpBin: Int): Seq[(String, Any)] = {
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

    val bandpowerDatapath: Seq[(String, Any)] = Seq((filterType, filterParams), ("FFTBuffer", fftBufferParams), ("FFT", fftConfig), ("Bandpower", bandpowerParams))
    bandpowerDatapath
  }

  def makeLineLength(channel: Int, windowLength: Int, filterType: String, filterTapsA: Seq[Double], filterTapsB: Seq[Double]): Seq[(String, Any)] = {
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

    val bufferParams = new ShiftRegParams[FixedPoint] {
      val protoData = dataPrototype
      val delay = 1
    }

    val lineLengthDatapath: Seq[(String, Any)] = Seq((filterType, filterParams), ("LineLength", lineLengthParams), ("Buffer", bufferParams), ("Buffer", bufferParams))
    lineLengthDatapath
  }

  // *********************************************
  // PCA, SVM, and Configuration Memory params
  // *********************************************
  val pcaParams = new PCAParams[FixedPoint] {
    val protoData = dataPrototype
    val nDimensions = dimensions // input dimension, minimum 1
    val nFeatures = features   // output dimension to SVM, minimum 1
  }

  val logisticParams = new LogisticParams[FixedPoint] {
    val protoData = dataPrototype
    val nFeatures = pcaParams.nFeatures           // the number of reduced dimensions, coming from PCA if ever
    val nThresholds = 10          // the number of threshold points for logit estimation

    val onlineLearn = 0          // online learning activation switch
    val nWindow = 5              // the training window for ictal segments
    val nInterCount = 60         // the training window for interictal segments

    val ictalIndex = nThresholds       // the index wrt threshold, for the online learning scheme
    val interIndex = 1       // same as above, but for interictal training

    val learningRate = 0.01
  }



  val configurationMemoryParams = new ConfigurationMemoryParams[FixedPoint] {

    val protoData = dataPrototype
    val nDimensions: Int = 3
    val nFeatures: Int = pcaParams.nFeatures

  }

}

