package fft

import breeze.numerics.{log, log10}
import chisel3._
import chisel3.util.RegEnable
import chisel3.experimental.FixedPoint
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._

import scala.collection._

trait FFTBufferParams[T <: Data] {
  val protoData: T
  val lanes: Int // How many lanes should the output have?
}

case class FixedFFTBufferParams(
                                 width: Int,
                                 bp: Int,
                                 laneCount: Int
                               ) extends FFTBufferParams[FixedPoint] {
  val protoData = FixedPoint(width.W, bp.BP)
  val lanes = laneCount
}

/**
  * Bundle type as IO for FIR Filter modules
  */
class FFTBufferIO[T <: chisel3.Data : Ring](params: FFTBufferParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(params.protoData.cloneType))
  val out = ValidWithSync(Vec(params.lanes,params.protoData.cloneType))

  val vectoring = Input(Bool())

  override def cloneType: this.type = FFTBufferIO(params).asInstanceOf[this.type]
}
object FFTBufferIO {
  def apply[T <: chisel3.Data : Ring](params: FFTBufferParams[T]): FFTBufferIO[T] =
    new FFTBufferIO(params)
}

class FFTBuffer[T <: chisel3.Data : Ring](val params: FFTBufferParams[T]) extends Module {
  require(params.lanes > 0)
  val io = IO(FFTBufferIO[T](params))

  val shift_en = Wire(Bool())
  val counter = Reg(UInt( (log10(params.lanes)/log10(2)).ceil.toInt.W ))

  val regs = mutable.ArrayBuffer[T]()
  for(i <- 0 until params.lanes) {
    if(i == 0) regs += RegEnable(io.in.bits, Ring[T].zero, shift_en)
    else       regs += RegEnable(regs(i - 1), Ring[T].zero, shift_en)
  }

  when(io.in.valid === true.B) {
    shift_en := true.B
    when(counter === params.lanes.asUInt() ) {
      counter := 1.U
      io.out.valid := true.B
    } .otherwise {
      counter := counter + 1
      io.out.valid := false.B
    }
  } .otherwise{
    shift_en := false.B
    io.out.valid := false.B
  }
  for(i <- 0 until params.lanes) {
    io.out.bits(i) := regs(i)
  }
  io.out.sync := (ShiftRegisterWithReset(io.in.sync, params.lanes, false.B, shift_en) && shift_en)

}
