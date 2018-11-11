package features

import chisel3._
import chisel3.util.RegEnable
import chisel3.experimental.FixedPoint
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._

import scala.collection._

/**
  * Base class for FIR Filter parameters
  *
  * These are type generic
  */
trait lineLengthParams[T <: Data] {
  val protoData: T
  val windowSize: Int
}

class lineLengthIO[T <: chisel3.Data : Ring](params: lineLengthParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(params.protoData))
  val out = ValidWithSync(params.protoData)

  override def cloneType: this.type = lineLengthIO(params).asInstanceOf[this.type]
}
object lineLengthIO {
  def apply[T <: chisel3.Data : Ring](params: lineLengthParams[T]): lineLengthIO[T] =
    new lineLengthIO(params)
}

class lineLength[T <: chisel3.Data : Ring](val params: lineLengthParams[T]) extends Module {
  require(params.windowSize > 1)
  val io = IO(lineLengthIO[T](params))

  val shift_en = Wire(Bool())

  val lineLengths = RegInit(Vec(params.windowSize-1, params.protoData), VecInit(List.fill(params.windowSize-1)(Ring[T].zero)))

  val pastVal = RegInit(params.protoData, Ring[T].zero)

  when(shift_en === true.B) {
    pastVal := io.in.bits
  } .otherwise {
    pastVal := pastVal
  }

  for(i <- 0 until params.windowSize-1) {
    when(shift_en === true.B) {
      if (i == 0) lineLengths(i) := io.in.bits - pastVal
      else lineLengths(i) := lineLengths(i - 1)
    } .otherwise {
      lineLengths(i) := lineLengths(i)
    }
  }

  val accumulator = mutable.ArrayBuffer[T]()
  for(i <- 0 until params.windowSize-1) {
    if (i == 0) accumulator += lineLengths(i)
    else accumulator += lineLengths(i) + accumulator(i - 1)
  }

  when(io.in.valid === true.B) {
    shift_en := true.B
  } .otherwise{
    shift_en := false.B
  }

  io.out.bits := accumulator.last * (1/params.windowSize).asUInt.asTypeOf(params.protoData)
  io.out.valid := (ShiftRegisterWithReset(io.in.valid, params.windowSize, false.B, shift_en) && shift_en)
  io.out.sync := (ShiftRegisterWithReset(io.in.sync, params.windowSize, false.B, shift_en) && shift_en)

}

