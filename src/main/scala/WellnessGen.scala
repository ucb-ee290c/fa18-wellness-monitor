package wellness

import chisel3._
import chisel3.core.FixedPoint
import chisel3.util._
import dspblocks._
import dspjunctions.ValidWithSync
import dsptools.numbers._
import firFilter._
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

  val tap_count = 5
  val windowLength = 4
  val coefficients1 = Seq(1,2,3,4)

  // val coefficients1 = mutable.ArrayBuffer[Int]()
  // for(j <- 0 until tap_count) {
  //   coefficients1 += j
  // }


  val filter1Params = new FIRFilterParams[SInt] {
    val protoData = SInt(64.W)
    val taps = coefficients1.map(_.asSInt())
  }

  val lineLength1Params = new lineLengthParams[SInt] {
    val protoData = SInt(64.W)
    val windowSize = windowLength
  }

  val datapathSeq = Seq(("FIR",filter1Params), ("lineLength",lineLength1Params))


  val FIRBucket = mutable.ArrayBuffer[ConstantCoefficientFIRFilter[SInt]]()
  val lineLengthBucket = mutable.ArrayBuffer[lineLength[SInt]]()
  val datapathGenSeq : mutable.ArrayBuffer[(String,Int)] = mutable.ArrayBuffer()

  for(i <- 0 until datapathSeq.length)
  {
    datapathSeq(i)._1 match
    {
      case "FIR" =>
      { // FIR
        FIRBucket += Module(new ConstantCoefficientFIRFilter(datapathSeq(i)._2.asInstanceOf[FIRFilterParams[SInt]]))
        datapathGenSeq += (("FIR",FIRBucket.length-1))
      }
      case "lineLength" =>
      { // lineLength
        lineLengthBucket += Module(new lineLength(datapathSeq(i)._2.asInstanceOf[lineLengthParams[SInt]]))
        datapathGenSeq += (("lineLength",lineLengthBucket.length-1))
      }
    }
  }

  for(i <- 0 until datapathGenSeq.length)
  {
    if (i == 0)
    {
      datapathGenSeq(i)._1 match
      {
      case "FIR" =>
        {
          FIRBucket(datapathGenSeq(i)._2).io.in.valid := io.in.valid
          FIRBucket(datapathGenSeq(i)._2).io.in.bits := io.in.bits
          FIRBucket(datapathGenSeq(i)._2).io.in.sync := false.B
        }
      case "lineLength" =>
        {
          lineLengthBucket(datapathGenSeq(i)._2).io.in.valid := io.in.valid
          lineLengthBucket(datapathGenSeq(i)._2).io.in.bits := io.in.bits
          lineLengthBucket(datapathGenSeq(i)._2).io.in.sync := false.B
        }
      }
    }
    else
    {
      datapathGenSeq(i)._1 match
      {
        case "FIR" =>
        {
          datapathGenSeq(i-1)._1 match
          {
            case "FIR" =>
            {
              FIRBucket(datapathGenSeq (i)._2).io.in.valid :=  FIRBucket(datapathGenSeq (i)._2).io.out.valid
              FIRBucket(datapathGenSeq (i)._2).io.in.bits  :=  FIRBucket(datapathGenSeq (i)._2).io.out.bits
              FIRBucket(datapathGenSeq (i)._2).io.in.sync  :=  false.B
            }
            case "lineLength" =>
            {
              FIRBucket(datapathGenSeq (i)._2).io.in.valid := lineLengthBucket (datapathGenSeq (i)._2).io.out.valid
              FIRBucket(datapathGenSeq (i)._2).io.in.bits  := lineLengthBucket (datapathGenSeq (i)._2).io.out.bits
              FIRBucket(datapathGenSeq (i)._2).io.in.sync  := false.B
            }
          }
        }
        case "lineLength" =>
        {
          datapathGenSeq(i-1)._1 match
          {
            case "FIR" =>
            {
              lineLengthBucket(datapathGenSeq (i)._2).io.in.valid :=  FIRBucket(datapathGenSeq (i)._2).io.out.valid
              lineLengthBucket(datapathGenSeq (i)._2).io.in.bits  :=  FIRBucket(datapathGenSeq (i)._2).io.out.bits
              lineLengthBucket(datapathGenSeq (i)._2).io.in.sync  :=  false.B
            }
            case "lineLength" =>
            {
              lineLengthBucket(datapathGenSeq (i)._2).io.in.valid := lineLengthBucket (datapathGenSeq (i)._2).io.out.valid
              lineLengthBucket(datapathGenSeq (i)._2).io.in.bits  := lineLengthBucket (datapathGenSeq (i)._2).io.out.bits
              lineLengthBucket(datapathGenSeq (i)._2).io.in.sync  := false.B
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
          io.out.sync  := lineLengthBucket(datapathGenSeq(i)._2).io.out.sync
        }
      }
    }
  }
  io.in.ready := true.B
}
