package wellness

import firFilter._
import iirFilter._
import fft._
import features._
import pca._
import svm._

import chisel3._
import chisel3.util._
import dsptools.numbers._
import dspjunctions.ValidWithSync
import freechips.rocketchip.config.Parameters

import scala.collection._


trait wellnessGenParams[T <: Data] {
  val dataType: T
}


class WellnessConfigurationBundle[T <: Data](params: ConfigurationMemoryParams[T]) extends Bundle {
  val confPCAVector = Vec(params.nFeatures,Vec(params.nDimensions,params.protoData))
  val confSVMSupportVector = Vec(params.nSupports,Vec(params.nFeatures,params.protoData))
  val confSVMAlphaVector = Vec(params.nClassifiers,Vec(params.nSupports,params.protoData))
  val confSVMIntercept = Vec(params.nClassifiers,params.protoData)

  override def cloneType: this.type = WellnessConfigurationBundle(params).asInstanceOf[this.type]
}
object WellnessConfigurationBundle {
  def apply[T <: Data](params: ConfigurationMemoryParams[T]): WellnessConfigurationBundle[T]
    = new WellnessConfigurationBundle(params)
}


class wellnessGenModuleIO[T <: Data : Real : Order : BinaryRepresentation]
(genParams: wellnessGenParams[T],
 pcaParams: PCAParams[T],
 svmParams: SVMParams[T],
 configurationMemoryParams: ConfigurationMemoryParams[T])
extends Bundle {
  var nClassifiers = svmParams.nClasses  // one vs rest default
  if (svmParams.classifierType == "ovr") {
    if (svmParams.nClasses == 2) nClassifiers = svmParams.nClasses - 1
  } else if (svmParams.classifierType == "ovo") {   // one vs one
    nClassifiers = (svmParams.nClasses*(svmParams.nClasses - 1))/2
  } else if (svmParams.classifierType == "ecoc") {  // error correcting output code
    nClassifiers = svmParams.codeBook.head.length // # columns = # classifiers
  }

  val inConf = Flipped(ValidWithSync(WellnessConfigurationBundle(configurationMemoryParams)))

  val in = Flipped(DecoupledIO(genParams.dataType.cloneType))
  val out = ValidWithSync(Bool())
  val rawVotes = Output(Vec(svmParams.nClasses, svmParams.protoData))
  val classVotes = Output(Vec(svmParams.nClasses,UInt((log2Ceil(nClassifiers)+1).W)))

  override def cloneType: this.type = wellnessGenModuleIO(
    genParams: wellnessGenParams[T],
    pcaParams: PCAParams[T],
    svmParams: SVMParams[T],
    configurationMemoryParams: ConfigurationMemoryParams[T]).asInstanceOf[this.type]
}
object wellnessGenModuleIO {
  def apply[T <: chisel3.Data : Real : Order : BinaryRepresentation](
    genParams: wellnessGenParams[T],
    pcaParams: PCAParams[T],
    svmParams: SVMParams[T],
    configurationMemoryParams: ConfigurationMemoryParams[T]):
  wellnessGenModuleIO[T] = new wellnessGenModuleIO(
    genParams: wellnessGenParams[T],
    pcaParams: PCAParams[T],
    svmParams: SVMParams[T],
    configurationMemoryParams: ConfigurationMemoryParams[T])
}


class wellnessGenModule[T <: chisel3.Data : Real : Order : BinaryRepresentation]
(val genParams: wellnessGenParams[T],
 val pcaParams: PCAParams[T],
 val svmParams: SVMParams[T],
 val configurationMemoryParams: ConfigurationMemoryParams[T])
(implicit val p: Parameters)
extends Module {
  val io = IO(wellnessGenModuleIO[T](
    genParams: wellnessGenParams[T],
    pcaParams: PCAParams[T],
    svmParams: SVMParams[T],
    configurationMemoryParams: ConfigurationMemoryParams[T]))

  val tap_count = 4
  val windowLength = 32
  val coefficients1 = Seq(2,4,5,6)

  val filter1Params = new FIRFilterParams[SInt] {
    val protoData = SInt(64.W)
    val taps = coefficients1.map(_.asSInt())
  }

  val lineLength1Params = new lineLengthParams[SInt] {
    val protoData = SInt(64.W)
    val windowSize = windowLength
  }


  // Ch x (params): seq of param datapaths
  // Each param datapath: seq of (block type, block params)
  val datapathParamsSeqs = Seq(Seq(("FIR",filter1Params), ("lineLength",lineLength1Params)),
    Seq(("FIR",filter1Params), ("lineLength",lineLength1Params)))
  // Ch x (modules): arr of module datapaths
  // Each module datapath: arr of (block type, gen'd module)
  val generatedDatapaths: mutable.ArrayBuffer[mutable.ArrayBuffer[(String,Module)]] = mutable.ArrayBuffer()

  // Just a var instantiation
  var singlePathParamsSeq = Seq(("FIR",filter1Params), ("lineLength",lineLength1Params))

  // Gen ch x's seq of module datapaths from param datapaths
  // For each (ith) param datapath in ch x (params)
  for (i <- 0 until datapathParamsSeqs.length)
  {
    // Param datapath i
    singlePathParamsSeq = datapathParamsSeqs(i)
    // Module datapath (i)
    val generatedSinglePath: mutable.ArrayBuffer[(String,Module)] = mutable.ArrayBuffer()

    // For each (jth) param in param datapath i
    for(j <- 0 until singlePathParamsSeq.length)
    {
      // Param j
      singlePathParamsSeq(j)._1 match
      {
        case "FIR" =>
        {
          generatedSinglePath += (("FIR",Module(new ConstantCoefficientFIRFilter(singlePathParamsSeq(j)._2.asInstanceOf[FIRFilterParams[T]]))))
        }
        case "IIR" =>
        {
          generatedSinglePath += (("IIR",Module(new ConstantCoefficientIIRFilter(singlePathParamsSeq(j)._2.asInstanceOf[IIRFilterParams[T]]))))
        }
        case "FFTBuffer" =>
        {
          generatedSinglePath += (("FFTBuffer",Module(new FFTBuffer(singlePathParamsSeq(j)._2.asInstanceOf[FFTBufferParams[T]]))))
        }
        case "FFT" =>
        {
          generatedSinglePath += (("FFT",Module(new FFT(singlePathParamsSeq(j)._2.asInstanceOf[FFTConfig[T]]))))
        }
        case "lineLength" =>
        {
          generatedSinglePath += (("lineLength",Module(new lineLength(singlePathParamsSeq(j)._2.asInstanceOf[lineLengthParams[T]]))))
        }
        case "Bandpower" =>
        {
          generatedSinglePath += (("Bandpower",Module(new Bandpower(singlePathParamsSeq(j)._2.asInstanceOf[BandpowerParams[T]]))))
        }
      }
    }
    // Add (jth) module datapath to ch x (modules)
    generatedDatapaths += generatedSinglePath
  }

  val pcaInVector = Wire(Vec(pcaParams.nFeatures, pcaParams.protoData))
  val pcaInValVec = Wire(Vec(pcaParams.nFeatures, Bool()))
  // For each (ith) module datapath in ch x, connect up modules
  for(i <- 0 until generatedDatapaths.length)
    {
      // Module datapath i
      val genDatapath = generatedDatapaths(i)
      // For each (jth) module in module datapath i
      for(j <- 0 until genDatapath.length)
      {
        // Connect first module to input
        if (j == 0)
        {
          genDatapath(j)._1 match
          {
            case "FIR" =>
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.valid := io.in.valid
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.bits := io.in.bits
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.sync := false.B
            case "IIR" =>
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.valid := io.in.valid
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.bits := io.in.bits
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.sync := false.B
            case "FFTBuffer" =>
              genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.valid := io.in.valid
              genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.bits := io.in.bits
              genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.sync := false.B
          }
        }
        // Other than first module, connect module to previous module
        else
        {
          genDatapath(j)._1 match
          {
            case "FIR" =>
            {
              genDatapath(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.valid := genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.bits  := genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.sync  := false.B
                }
              }
            }
            case "IIR" =>
            {
              genDatapath(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.valid := genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.bits  := genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.sync  := false.B
                }
              }
            }
            case "FFTBuffer" =>
            {
              genDatapath(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.sync  :=  false.B
                }
              }
            }
            case "FFT" =>
            {
              genDatapath(j)._2.asInstanceOf[FFT[T]].io.in.valid := genDatapath(j-1)._2.asInstanceOf[FFTBuffer[T]].io.out.valid
              genDatapath(j)._2.asInstanceOf[FFT[T]].io.in.bits  := genDatapath(j-1)._2.asInstanceOf[FFTBuffer[T]].io.out.bits
              genDatapath(j)._2.asInstanceOf[FFT[T]].io.in.sync  := false.B
            }
            case "lineLength" =>
            {
              genDatapath(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.sync  :=  false.B
                }
              }
            }
            case "Bandpower" =>
            {
              genDatapath(j)._2.asInstanceOf[Bandpower[T]].io.in.valid := genDatapath(j-1)._2.asInstanceOf[FFT[T]].io.out.valid
              genDatapath(j)._2.asInstanceOf[Bandpower[T]].io.in.bits  := genDatapath(j-1)._2.asInstanceOf[FFT[T]].io.out.bits
              genDatapath(j)._2.asInstanceOf[Bandpower[T]].io.in.sync  := false.B
            }
          }
        }
        // Connect output to last module
        if ((i == 0) & (j == genDatapath.length-1))
        {
          genDatapath(j)._1 match
          {
            case "FIR" =>
            {
              pcaInValVec(i) := genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.valid
              pcaInVector(i) := genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.bits
            }
            case "IIR" =>
            {
              pcaInValVec(i) := genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.valid
              pcaInVector(i) := genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.bits
            }
            case "lineLength" =>
            {
              pcaInValVec(i) := genDatapath(j)._2.asInstanceOf[lineLength[T]].io.out.valid
              pcaInVector(i) := genDatapath(j)._2.asInstanceOf[lineLength[T]].io.out.bits
            }
            case "Bandpower" =>
            {
              pcaInValVec(i) := genDatapath(j)._2.asInstanceOf[Bandpower[T]].io.out.valid
              pcaInVector(i) := genDatapath(j)._2.asInstanceOf[Bandpower[T]].io.out.bits
            }
          }
        }
      }
    }

  // PCA (datapaths to PCA)
  val pca = Module(new PCA(pcaParams))
  pca.io.PCAVector := io.inConf.bits.confPCAVector
  pca.io.in.valid := pcaInValVec.asUInt().andR()
  pca.io.in.bits := pcaInVector
  pca.io.in.sync := false.B

  // SVM (PCA to SVM)
  val svm = Module(new SVM(svmParams))
  // Configure SVM
  svm.io.supportVector := io.inConf.bits.confSVMSupportVector
  svm.io.alphaVector := io.inConf.bits.confSVMAlphaVector
  svm.io.intercept := io.inConf.bits.confSVMIntercept
  // Connect PCA to SVM
  svm.io.in.valid := pca.io.out.valid
  svm.io.in.bits := pca.io.out.bits
  svm.io.in.sync := false.B
  // SVM to Output
  io.out.valid := svm.io.out.valid
  io.out.sync := svm.io.out.sync
  io.out.bits := false.B
  io.rawVotes := svm.io.rawVotes
  io.classVotes := svm.io.classVotes

  io.in.ready := true.B
}