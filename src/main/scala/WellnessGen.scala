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
  val protoData: T
}

class wellnessGenModuleIO[T <: Data : Real : Order : BinaryRepresentation](genParams: wellnessGenParams[T])  extends Bundle {
  val in = Flipped(DecoupledIO(genParams.protoData.cloneType))
  val out = ValidWithSync(genParams.protoData.cloneType)

  override def cloneType: this.type = wellnessGenModuleIO(genParams: wellnessGenParams[T]).asInstanceOf[this.type]
}

object wellnessGenModuleIO {
  def apply[T <: chisel3.Data : Real : Order : BinaryRepresentation](genParams: wellnessGenParams[T]):
  wellnessGenModuleIO[T] = new wellnessGenModuleIO(genParams: wellnessGenParams[T])
}


class wellnessGenModule[T <: chisel3.Data : Real : Order : BinaryRepresentation]
( val genParams: wellnessGenParams[T])(implicit val p: Parameters) extends Module {
  val io = IO(wellnessGenModuleIO[T](genParams: wellnessGenParams[T]))

  val tap_count = 2
  val windowLength = 2
  val coefficients1 = Seq(1,1)

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
              genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.valid := io.in.valid
              genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.bits := io.in.bits
              genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.sync := false.B
            case "IIR" =>
              genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.in.valid := io.in.valid
              genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.in.bits := io.in.bits
              genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.in.sync := false.B
            case "FFTBuffer" =>
              genDatapath(j).asInstanceOf[FFTBuffer].io.in.valid := io.in.valid
              genDatapath(j).asInstanceOf[FFTBuffer].io.in.bits := io.in.bits
              genDatapath(j).asInstanceOf[FFTBuffer].io.in.sync := false.B
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
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.valid :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientFIRFilter].io.out.valid
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.bits  :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientFIRFilter].io.out.bits
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.valid := genDatapath(j-1).asInstanceOf[ConstantCoefficientIIRFilter].io.out.valid
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.bits  := genDatapath(j-1).asInstanceOf[ConstantCoefficientIIRFilter].io.out.bits
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.sync  := false.B
                }
              }
            }
            case "IIR" =>
            {
              genDatapath(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.in.valid :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientFIRFilter].io.out.valid
                  genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.in.bits  :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientFIRFilter].io.out.bits
                  genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.in.valid := genDatapath(j-1).asInstanceOf[ConstantCoefficientIIRFilter].io.out.valid
                  genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.in.bits  := genDatapath(j-1).asInstanceOf[ConstantCoefficientIIRFilter].io.out.bits
                  genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.in.sync  := false.B
                }
              }
            }
            case "FFTBuffer" =>
            {
              genDatapath(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j).asInstanceOf[FFTBuffer].io.in.valid :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientFIRFilter].io.out.valid
                  genDatapath(j).asInstanceOf[FFTBuffer].io.in.bits  :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientFIRFilter].io.out.bits
                  genDatapath(j).asInstanceOf[FFTBuffer].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j).asInstanceOf[FFTBuffer].io.in.valid :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientIIRFilter].io.out.valid
                  genDatapath(j).asInstanceOf[FFTBuffer].io.in.bits  :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientIIRFilter].io.out.bits
                  genDatapath(j).asInstanceOf[FFTBuffer].io.in.sync  :=  false.B
                }
              }
            }
            case "FFT" =>
            {
              genDatapath(j).asInstanceOf[FFT].io.in.valid := genDatapath(j-1).asInstanceOf[FFTBuffer].io.out.valid
              genDatapath(j).asInstanceOf[FFT].io.in.bits  := genDatapath(j-1).asInstanceOf[FFTBuffer].io.out.bits
              genDatapath(j).asInstanceOf[FFT].io.in.sync  := false.B
            }
            case "lineLength" =>
            {
              genDatapath(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j).asInstanceOf[lineLength].io.in.valid :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientFIRFilter].io.out.valid
                  genDatapath(j).asInstanceOf[lineLength].io.in.bits  :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientFIRFilter].io.out.bits
                  genDatapath(j).asInstanceOf[lineLength].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j).asInstanceOf[lineLength].io.in.valid :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientIIRFilter].io.out.valid
                  genDatapath(j).asInstanceOf[lineLength].io.in.bits  :=  genDatapath(j-1).asInstanceOf[ConstantCoefficientIIRFilter].io.out.bits
                  genDatapath(j).asInstanceOf[lineLength].io.in.sync  :=  false.B
                }
              }
            }
            case "Bandpower" =>
            {
              genDatapath(j).asInstanceOf[Bandpower].io.in.valid := genDatapath(j-1).asInstanceOf[FFT].io.out.valid
              genDatapath(j).asInstanceOf[Bandpower].io.in.bits  := genDatapath(j-1).asInstanceOf[FFT].io.out.bits
              genDatapath(j).asInstanceOf[Bandpower].io.in.sync  := false.B
            }
          }
        }
        // Connect output to last module
        if (j == genDatapath.length-1)
        {
          genDatapath(j)._1 match
          {
            case "FIR" =>
            {
              io.out.valid := genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.out.valid
              io.out.bits  := genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.out.bits
              io.out.sync  := false.B
            }
            case "IIR" =>
            {
              io.out.valid := genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.out.valid
              io.out.bits  := genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.out.bits
              io.out.sync  := false.B
            }
            case "lineLength" =>
            {
              io.out.valid := genDatapath(j).asInstanceOf[lineLength].io.out.valid
              io.out.bits  := genDatapath(j).asInstanceOf[lineLength].io.out.bits
              io.out.sync  := false.B
            }
            case "Bandpower" =>
            {
              io.out.valid := genDatapath(j).asInstanceOf[Bandpower].io.out.valid
              io.out.bits  := genDatapath(j).asInstanceOf[Bandpower].io.out.bits
              io.out.sync  := false.B
            }
          }
        }
      }
    }
  io.in.ready := true.B
}