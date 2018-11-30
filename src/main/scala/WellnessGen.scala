package wellness

import chisel3._
import chisel3.core.FixedPoint
import chisel3.util._
import dspblocks._
import dspjunctions.ValidWithSync
import dsptools.numbers._
import firFilter._
import iirFilter._
import fft._
import features._
import pca._
import svm._
import freechips.rocketchip.amba.axi4stream._
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.subsystem._
import scala.collection._


trait wellnessGenParams[T <: Data] {
  val protoData: T
}

// Right now wellnessGen is just a testbed for making a high level scala generator class
// First up is generating an arbitrary number of filters and driving them with the same input


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

  // TODO: remove manual params and whatnot

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

  val channelSeq = Seq(Seq(("FIR",filter1Params), ("lineLength",lineLength1Params)),
    Seq(("FIR",filter1Params), ("lineLength",lineLength1Params)))

  var datapathSeq = Seq(("FIR",filter1Params), ("lineLength",lineLength1Params))

  val FIRBucket       = mutable.ArrayBuffer[ConstantCoefficientFIRFilter[T]]()
  val IIRBucket       = mutable.ArrayBuffer[ConstantCoefficientIIRFilter[T]]()
  val FFTBucket       = mutable.ArrayBuffer[FFT[T]]()
  val FFTBufferBucket = mutable.ArrayBuffer[FFTBuffer[T]]()
  val BandpowerBucket = mutable.ArrayBuffer[Bandpower[T]]()
  val lineLengthBucket = mutable.ArrayBuffer[lineLength[T]]()
  val datapathGenSeq : mutable.ArrayBuffer[(String,Int)] = mutable.ArrayBuffer()

  // val genDatapath : mutable.ArrayBuffer[(String,Module)] = mutable.ArrayBuffer()
  val genChannel : mutable.ArrayBuffer[mutable.ArrayBuffer[(String,Module)]] = mutable.ArrayBuffer()

for (k <- 0 until channelSeq.length)
  {
    datapathSeq = channelSeq(k)
    val genDatapath : mutable.ArrayBuffer[(String,Module)] = mutable.ArrayBuffer()

    for(i <- 0 until datapathSeq.length)
    {
      datapathSeq(i)._1 match
      {
        case "FIR" =>
        { // FIR
          genDatapath += (("FIR",Module(new ConstantCoefficientFIRFilter(datapathSeq(i)._2.asInstanceOf[FIRFilterParams[T]]))))
        }
        case "lineLength" =>
        { // lineLength
          genDatapath += (("lineLength",Module(new lineLength(datapathSeq(i)._2.asInstanceOf[lineLengthParams[T]]))))
        }
        case "IIR" =>
        {
          genDatapath += (("IIR",Module(new ConstantCoefficientIIRFilter(datapathSeq(i)._2.asInstanceOf[IIRFilterParams[T]]))))
        }
        case "FFT" =>
        {
          genDatapath += (("FFT",Module(new FFT(datapathSeq(i)._2.asInstanceOf[FFTConfig[T]]))))
        }
        case "FFTBuffer" =>
        {
          genDatapath += (("FFTBuffer",Module(new FFTBuffer(datapathSeq(i)._2.asInstanceOf[FFTBufferParams[T]]))))
        }
        case "Bandpower" =>
        {
          genDatapath += (("Bandpower",Module(new Bandpower(datapathSeq(i)._2.asInstanceOf[BandpowerParams[T]]))))
        }
      }
    }
    genChannel += genDatapath
  }

  for(i <- 0 until genChannel.length)
    {
      val genDatapath = genChannel(i)
      for(j <- 0 until genDatapath.length)
      {
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
            case "lineLength" =>
              genDatapath(j).asInstanceOf[lineLength].io.in.valid := io.in.valid
              genDatapath(j).asInstanceOf[lineLength].io.in.bits := io.in.bits
              genDatapath(j).asInstanceOf[lineLength].io.in.sync := false.B
            case "FFTBuffer" =>
              genDatapath(j).asInstanceOf[FFTBuffer].io.in.valid := io.in.valid
              genDatapath(j).asInstanceOf[FFTBuffer].io.in.bits := io.in.bits
              genDatapath(j).asInstanceOf[FFTBuffer].io.in.sync := false.B
          }
        }
        else
        {
          datapathGenSeq(j)._1 match
          {
            case "FIR" =>
            {
              datapathGenSeq(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.valid :=  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.out.valid
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.bits  :=  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.out.bits
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.sync  :=  false.B
                }
                case "lineLength" =>
                {
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.valid := genDatapath(j).asInstanceOf[lineLength].io.out.valid
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.bits  := genDatapath(j).asInstanceOf[lineLength].io.out.bits
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.sync  := false.B
                }
                case "IIR" =>
                {
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.valid := genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.out.valid
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.bits  := genDatapath(j).asInstanceOf[ConstantCoefficientIIRFilter].io.out.bits
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.sync  := false.B
                }
                case "FFT" =>
                {
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.valid := genDatapath(j).asInstanceOf[FFT].io.out.valid
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.bits  := genDatapath(j).asInstanceOf[FFT].io.out.bits
                  genDatapath(j).asInstanceOf[ConstantCoefficientFIRFilter].io.in.sync  := false.B
                }
              }
            }
            case "lineLength" =>
            {
              datapathGenSeq(i-1)._1 match
              {
                case "FIR" =>
                {
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.valid :=  FIRBucket(datapathGenSeq (i-1)._2).io.out.valid
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.bits  :=  FIRBucket(datapathGenSeq (i-1)._2).io.out.bits
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.sync  :=  false.B
                }
                case "lineLength" =>
                {
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.valid := lineLengthBucket (datapathGenSeq (i-1)._2).io.out.valid
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.bits  := lineLengthBucket (datapathGenSeq (i-1)._2).io.out.bits
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.sync  := false.B
                }
                case "IIR" =>
                {
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.valid := IIRBucket (datapathGenSeq (i-1)._2).io.out.valid
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.bits  := IIRBucket (datapathGenSeq (i-1)._2).io.out.bits
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.sync  := false.B
                }
                case "FFT" =>
                {
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.valid := FFTBucket (datapathGenSeq (i-1)._2).io.out.valid
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.bits  := FFTBucket (datapathGenSeq (i-1)._2).io.out.bits
                  lineLengthBucket(datapathGenSeq (i)._2).io.in.sync  := false.B
                }
              }
            }
            case "IIR" =>
            {
              datapathGenSeq(i-1)._1 match
              {
                case "FIR" =>
                {
                  IIRBucket(datapathGenSeq (i)._2).io.in.valid :=  FIRBucket(datapathGenSeq (i-1)._2).io.out.valid
                  IIRBucket(datapathGenSeq (i)._2).io.in.bits  :=  FIRBucket(datapathGenSeq (i-1)._2).io.out.bits
                  IIRBucket(datapathGenSeq (i)._2).io.in.sync  :=  false.B
                }
                case "lineLength" =>
                {
                  IIRBucket(datapathGenSeq (i)._2).io.in.valid := lineLengthBucket (datapathGenSeq (i-1)._2).io.out.valid
                  IIRBucket(datapathGenSeq (i)._2).io.in.bits  := lineLengthBucket (datapathGenSeq (i-1)._2).io.out.bits
                  IIRBucket(datapathGenSeq (i)._2).io.in.sync  := false.B
                }
                case "IIR" =>
                {
                  IIRBucket(datapathGenSeq (i)._2).io.in.valid := IIRBucket (datapathGenSeq (i-1)._2).io.out.valid
                  IIRBucket(datapathGenSeq (i)._2).io.in.bits  := IIRBucket (datapathGenSeq (i-1)._2).io.out.bits
                  IIRBucket(datapathGenSeq (i)._2).io.in.sync  := false.B
                }
                case "FFT" =>
                {
                  IIRBucket(datapathGenSeq (i)._2).io.in.valid := FFTBucket (datapathGenSeq (i-1)._2).io.out.valid
                  IIRBucket(datapathGenSeq (i)._2).io.in.bits  := FFTBucket (datapathGenSeq (i-1)._2).io.out.bits
                  IIRBucket(datapathGenSeq (i)._2).io.in.sync  := false.B
                }
              }
            }
            case "FFT" =>
            {
              FFTBucket(datapathGenSeq (i)._2).io.in.valid :=  FFTBufferBucket(datapathGenSeq (i-1)._2).io.out.valid
              FFTBucket(datapathGenSeq (i)._2).io.in.bits  :=  FFTBufferBucket(datapathGenSeq (i-1)._2).io.out.bits
              FFTBucket(datapathGenSeq (i)._2).io.in.sync  :=  false.B
            }
            case "Bandpower" =>
            {
              BandpowerBucket(datapathGenSeq (i)._2).io.in.valid :=  FFTBucket(datapathGenSeq (i-1)._2).io.out.valid
              BandpowerBucket(datapathGenSeq (i)._2).io.in.bits  :=  FFTBucket(datapathGenSeq (i-1)._2).io.out.bits
              BandpowerBucket(datapathGenSeq (i)._2).io.in.sync  :=  false.B
            }
            case "FFTBuffer" =>
            {
              datapathGenSeq(i-1)._1 match
              {
                case "FIR" =>
                {
                  FFTBufferBucket(datapathGenSeq (i)._2).io.in.valid :=  FIRBucket(datapathGenSeq (i-1)._2).io.out.valid
                  FFTBufferBucket(datapathGenSeq (i)._2).io.in.bits  :=  FIRBucket(datapathGenSeq (i-1)._2).io.out.bits
                  FFTBufferBucket(datapathGenSeq (i)._2).io.in.sync  :=  false.B
                }
                case "lineLength" =>
                {
                  FFTBufferBucket(datapathGenSeq (i)._2).io.in.valid := lineLengthBucket (datapathGenSeq (i-1)._2).io.out.valid
                  FFTBufferBucket(datapathGenSeq (i)._2).io.in.bits  := lineLengthBucket (datapathGenSeq (i-1)._2).io.out.bits
                  FFTBufferBucket(datapathGenSeq (i)._2).io.in.sync  := false.B
                }
                case "IIR" =>
                {
                  FFTBufferBucket(datapathGenSeq (i)._2).io.in.valid := IIRBucket (datapathGenSeq (i-1)._2).io.out.valid
                  FFTBufferBucket(datapathGenSeq (i)._2).io.in.bits  := IIRBucket (datapathGenSeq (i-1)._2).io.out.bits
                  FFTBufferBucket(datapathGenSeq (i)._2).io.in.sync  := false.B
                }
              }
            }
          }
        }
        if (i == datapathGenSeq.length-1)
        {
          datapathGenSeq(i)._1 match
          {
            case "FIR" =>
            {
              io.out.valid := FIRBucket(datapathGenSeq(i)._2).io.out.valid
              io.out.bits  := FIRBucket(datapathGenSeq(i)._2).io.out.bits
              io.out.sync  := false.B
            }
            case "lineLength" =>
            {
              io.out.valid := lineLengthBucket(datapathGenSeq(i)._2).io.out.valid
              io.out.bits  := lineLengthBucket(datapathGenSeq(i)._2).io.out.bits
              io.out.sync  := false.B
            }
            case "lineLength" =>
            {
              io.out.valid := IIRBucket(datapathGenSeq(i)._2).io.out.valid
              io.out.bits  := IIRBucket(datapathGenSeq(i)._2).io.out.bits
              io.out.sync  := false.B
            }
            case "FFT" =>
            {
              io.out.valid := FFTBucket(datapathGenSeq(i)._2).io.out.valid
              io.out.bits  := FFTBucket(datapathGenSeq(i)._2).io.out.bits
              io.out.sync  := false.B
            }
            case "Bandpower" =>
            {
              io.out.valid := BandpowerBucket(datapathGenSeq(i)._2).io.out.valid
              io.out.bits  := BandpowerBucket(datapathGenSeq(i)._2).io.out.bits
              io.out.sync  := false.B
            }
          }
        }
      }
    }
  io.in.ready := true.B
}
