package memorybuffer

import breeze.numerics.{log, log10}
import chisel3._
import chisel3.util.RegEnable
import chisel3.experimental.FixedPoint
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._

import scala.collection._

trait MemoryBufferParams[T <: Data] {
  val protoData: T
  val nRows: Int    // corresponds to nSupports for SVM, nFeatures for PCA
  val nColumns: Int // corresponds to nFeatures for SVM, nDimensions for PCA
}

class MemoryBufferIO[T <: Data](params: MemoryBufferParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(params.protoData))
  val out = ValidWithSync(Vec(Vec(params.nRows,params.protoData),params.nColumns))

  override def cloneType: this.type = MemoryBufferIO(params).asInstanceOf[this.type]
}
object MemoryBufferIO {
  def apply[T <: Data](params: MemoryBufferParams[T]): MemoryBufferIO[T] =
    new MemoryBufferIO(params)
}

// stripped from Cem's FFTBuffer implementation :D
class MemoryBuffer[T <: chisel3.Data : Real](val params: MemoryBufferParams[T]) extends Module {
  require(params.nRows > 0)
  require(params.nColumns > 0)
  val io = IO(MemoryBufferIO[T](params))

  val totalSize = params.nRows * params.nColumns
  val shift_en = Wire(Bool())
  val counter = RegInit(UInt( ((log10(totalSize)/log10(2)).ceil.toInt+1).W ),0.U)

  // create the register matrix
  val regs = mutable.ArrayBuffer[T]()
  for(i <- 0 until totalSize) {
    if(i == 0) regs += RegEnable(io.in.bits, Ring[T].zero, shift_en)
    else       regs += RegEnable(regs(i - 1), Ring[T].zero, shift_en)
  }

  when(io.in.valid === true.B) {
    shift_en := true.B
    when(counter === totalSize.asUInt() ) {
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
  for(x <- 0 until params.nColumns) {
    for (y <- 0 until params.nRows) {
      io.out.bits(x)(y) := regs((x * params.nRows) + y)
    }
  }
  io.out.sync := (ShiftRegisterWithReset(io.in.sync, totalSize, false.B, shift_en) && shift_en)

}
