package iirFilter

import chisel3._
import chisel3.util.RegEnable
import chisel3.experimental.FixedPoint
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._

import scala.collection._

/**
  * Base class for IIR Filter parameters
  *
  * These are type generic
  */
trait IIRFilterParams[T <: Data] {
  val protoData: T
  //val taps: Seq[T]
  val consts_A: Seq[T]
  val consts_B: Seq[T]
}

/**
  * Bundle type as IO for FIR Filter modules
  */
class IIRFilterIO[T <: chisel3.Data : Ring](params: IIRFilterParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(params.protoData.cloneType))
  val out = ValidWithSync(params.protoData.cloneType)

  override def cloneType: this.type = IIRFilterIO(params).asInstanceOf[this.type]
}
object IIRFilterIO {
  def apply[T <: chisel3.Data : Ring](params: IIRFilterParams[T]): IIRFilterIO[T] =
    new IIRFilterIO(params)
}

class ConstantCoefficientIIRFilter[T <: chisel3.Data : Ring](val params: IIRFilterParams[T]) extends Module {
  require(params.consts_A.nonEmpty)
  require(params.consts_B.nonEmpty)
  val io = IO(IIRFilterIO[T](params))

  val shift_en = Wire(Bool())

  // val regs = mutable.ArrayBuffer[T]()
  val muls_B = mutable.ArrayBuffer[T]()
  val scan_B = mutable.ArrayBuffer[T]()

  val muls_A = mutable.ArrayBuffer[T]()
  val scan_A = mutable.ArrayBuffer[T]()

  val topLine = Wire(params.protoData.cloneType)

  val regs = RegInit(Vec(params.consts_A.length, params.protoData), VecInit(List.fill(params.consts_A.length)(Ring[T].zero)))

  for(i <- 0 until params.consts_A.length) {
    when(shift_en === true.B) {
      if (i == 0) regs(i) := topLine
      else regs(i) := regs(i - 1)
    } .otherwise {
      regs(i) := regs(i)
    }
  }

  // need to split into two to allow for different constant sequences
  for(i <- 0 to params.consts_A.length)
  {
      if(i == 0) {
          muls_A += io.in.bits
      }
      else muls_A += regs(i-1) * params.consts_A(i-1)
  }


  for(i <- 0 until params.consts_B.length)
  {
    if (i == 0) muls_B += (topLine * params.consts_B(0))
    else muls_B += regs(i-1) * params.consts_B(i)
  }

  for(i <- 0 to params.consts_A.length) 
  {
    if(i == 0) scan_A += muls_A(i)
    else scan_A += muls_A(i) + scan_A(i - 1)
  }

  topLine := scan_A.last

  for(i <- 0 until params.consts_B.length) 
  {
    if(i == 0) scan_B += muls_B(i)
    else scan_B += muls_B(i) + scan_B(i - 1)
  } // should replace this with a fold statement as well


  io.out.bits := scan_B.last

  when(io.in.valid === true.B) {
    shift_en := true.B
  } .otherwise{
    shift_en := false.B
  }

  io.out.valid := (ShiftRegisterWithReset(io.in.valid, params.consts_A.length, false.B, shift_en) && shift_en)
  io.out.sync := (ShiftRegisterWithReset(io.in.sync, params.consts_A.length, false.B, shift_en) && shift_en)

}

