package features

import chisel3._
import chisel3.util.log2Ceil
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._

import scala.collection._

/**
  * Base class for FIR Filter parameters
  *
  * These are type generic
  */
trait sumSquaresParams[T <: Data] {
  val protoData: T
  val windowSize: Int
}

class sumSquaresIO[T <: chisel3.Data : Ring](params: sumSquaresParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(params.protoData))
  val out = ValidWithSync(params.protoData)

  override def cloneType: this.type = sumSquaresIO(params).asInstanceOf[this.type]
}
object sumSquaresIO {
  def apply[T <: chisel3.Data : Ring](params: sumSquaresParams[T]): sumSquaresIO[T] =
    new sumSquaresIO(params)
}

class sumSquares[T <: chisel3.Data : Ring : Order : BinaryRepresentation](val params: sumSquaresParams[T]) extends Module {
  // Check that there are at least 2 line length windows to be averaged.
  require(params.windowSize > 1, f"Window size must be greater than 1, currently ${params.windowSize}")
  // Check that window size is a power of 2. This is enforced due to output normalization, to make division easier.
  require( (params.windowSize & (params.windowSize - 1)) == 0 , f"Window size must be a power of 2, currently ${params.windowSize}")
  val io = IO(sumSquaresIO[T](params))

  val shift_en = Wire(Bool())

  val sumSquaress = RegInit(Vec(params.windowSize-1, params.protoData), VecInit(List.fill(params.windowSize-1)(Ring[T].zero)))

  val pastVal = RegInit(params.protoData, Ring[T].zero)

  when(shift_en === true.B) {
    pastVal := io.in.bits
  } .otherwise {
    pastVal := pastVal
  }

  for(i <- 0 until params.windowSize-1) {
    when(shift_en === true.B) {
      if (i == 0) sumSquaress(i) := io.in.bits * io.in.bits
      else sumSquaress(i) := sumSquaress(i - 1)
    } .otherwise {
      sumSquaress(i) := sumSquaress(i)
    }
  }

  val accumulator = mutable.ArrayBuffer[T]()
  for(i <- 0 until params.windowSize-1) {
    if (i == 0) accumulator += sumSquaress(i)
    else accumulator += sumSquaress(i) + accumulator(i - 1)
  }

  when(io.in.valid === true.B) {
    shift_en := true.B
  } .otherwise{
    shift_en := false.B
  }

  // Output normalization: Take the average over the given window size.
  // Currently only works for window sizes of powers of 2.

  // Also do division by 8 to minimize dynamic range of output values
  // Check https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/scripts/features.py
  io.out.bits := (accumulator.last >> log2Ceil(params.windowSize)) >> 3
  io.out.valid := (ShiftRegisterWithReset(io.in.valid, params.windowSize, false.B, shift_en) && shift_en)
  io.out.sync := (ShiftRegisterWithReset(io.in.sync, params.windowSize, false.B, shift_en) && shift_en)

}

