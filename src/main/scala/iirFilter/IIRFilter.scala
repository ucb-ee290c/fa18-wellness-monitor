package iirFilter

import chisel3._
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._

import scala.collection._

/**
class ConstantCoefficientIIRFilter:

The iir block takes two sequences of coefficients and will generate a direct form II IIR Filter with a `validWithSync`
i/o interface. The generator extrapolates the number of taps from the length of the coefficient sequences. It uses the valid signal to
ingest new inputs when valid is high. While it seems trivial, it's importance cannot be overstated because it prevents
output instability while applying new signals to the input (in between clock edges).

@Parameters   $protoData                      Defines general block dataType
              $consts_A                       'A' filter coefficients (refer to github documentation for sample block diagram)
              $consts_B                       'B' filter coefficients (refer to github documentation for sample block diagram)


@Notes        - Coefficients_B must be one element larger than Coefficients_A
              - Generate coefficient values in matlab
              - Plug coefficient values as sequences into params
              - To test this block, there is a golden scala implementation of an IIR block in the tests folder.
              Running SBT test will automatically run the proper tests(currently it tests the generator with UInts and SInts).
              Keep in mind, with random coefficients, the IIR block will most likely overflow if you run it for too many cycles.
  */

/**
  * Base class for IIR Filter parameters
  *
  * These are type generic
  */
trait IIRFilterParams[T <: Data] {
  val protoData: T
  val consts_A: Seq[T]
  val consts_B: Seq[T]
}

/**
  * Bundle type as IO for FIR Filter modules
  *
  * In and out are both single data streams of type [T]
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

/**
  * ConstantCoefficientIIRFilter class definition
  */
class ConstantCoefficientIIRFilter[T <: chisel3.Data : Ring](val params: IIRFilterParams[T]) extends Module {
  require(params.consts_A.nonEmpty, "Missing filter taps")
  require(params.consts_B.nonEmpty, "Missing filter taps")
  val io = IO(IIRFilterIO[T](params))

  val shift_en = Wire(Bool())

  // predefine all collections to keep track of multipliers and sum
  val muls_B = mutable.ArrayBuffer[T]()
  val scan_B = mutable.ArrayBuffer[T]()

  val muls_A = mutable.ArrayBuffer[T]()
  val scan_A = mutable.ArrayBuffer[T]()

  // make a wire to keep track of total sum
  val topLine = Wire(params.protoData.cloneType)

  // build registers (however many we need based off of number of taps)
  val regs = RegInit(Vec(params.consts_A.length, params.protoData), VecInit(List.fill(params.consts_A.length)(Ring[T].zero)))

  // loop through all the generated registers and connect their i/o properly
  for(i <- 0 until params.consts_A.length) {
    when(shift_en === true.B) {
      if (i == 0) regs(i) := topLine
      else regs(i) := regs(i - 1)
    } .otherwise {
      regs(i) := regs(i)
    }
  }

  // need to split into two to allow for different constant sequences
  // place all the 'A' tap multipliers
  for(i <- 0 to params.consts_A.length)
  {
    if(i == 0) {
      muls_A += io.in.bits
    }
    else muls_A += regs(i-1) * params.consts_A(i-1)
  }

  // Place all the 'B' tap multipliers
  for(i <- 0 until params.consts_B.length)
  {
    if (i == 0) muls_B += (topLine * params.consts_B(0))
    else muls_B += regs(i-1) * params.consts_B(i)
  }

  // Reduce all the multiplier outputs with addition
  for(i <- 0 to params.consts_A.length)
  {
    if(i == 0) scan_A += muls_A(i)
    else scan_A += muls_A(i) + scan_A(i - 1)
  }

  // drive topline wire with sum
  topLine := scan_A.last

  // Reduce all the multiplier outputs with addition
  for(i <- 0 until params.consts_B.length)
  {
    if(i == 0) scan_B += muls_B(i)
    else scan_B += muls_B(i) + scan_B(i - 1)
  } // should replace this with a fold statement as well

  // drive output bits
  io.out.bits := scan_B.last

  // drive shift bits when valid is true so we shift values in when we want to
  when(io.in.valid === true.B) {
    shift_en := true.B
  } .otherwise{
    shift_en := false.B
  }

  // connect valids and syncs with shift registers of length 'consts_A' such that valids are properly delayed from input
  // to output
  io.out.valid := (ShiftRegisterWithReset(io.in.valid, params.consts_A.length, false.B, shift_en) && shift_en)
  io.out.sync := (ShiftRegisterWithReset(io.in.sync, params.consts_A.length, false.B, shift_en) && shift_en)

}

