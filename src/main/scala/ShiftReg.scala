package wellness

import chisel3._
import chisel3.core.FixedPoint
import dspjunctions.ValidWithSync
import dsptools.numbers._
//import wellness.FixedPointWellnessGenParams.{dataBP, dataWidth}

trait ShiftRegParams[T <: Data] {
  val protoData: T
  val delay: Int
}

class ShiftRegIO[T <: chisel3.Data : Ring](params: ShiftRegParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(params.protoData.cloneType))
  val out = ValidWithSync(params.protoData.cloneType)

  override def cloneType: this.type = ShiftRegIO(params).asInstanceOf[this.type]
}
object ShiftRegIO {
  def apply[T <: chisel3.Data : Ring](params: ShiftRegParams[T]): ShiftRegIO[T] =
    new ShiftRegIO(params)
}

class ShiftReg[T <: chisel3.Data : Ring](val params: ShiftRegParams[T]) extends Module {
  require(params.delay > 0, "Need positive delay")

  val io = IO(ShiftRegIO[T](params))

  val outRegs = RegInit(Vec(params.delay, params.protoData), VecInit(List.fill(params.delay)(Ring[T].zero)))
  val valRegs = RegInit(Vec(params.delay, Bool()), VecInit(List.fill(params.delay)(false.B)))

  for(i <- 0 until params.delay) {
    if (i == 0) {
      outRegs(i) := io.in.bits
      valRegs(i) := io.in.valid
    }
    else {
      outRegs(i) := outRegs(i - 1)
      valRegs(i) := valRegs(i - 1)
    }
  }

  io.out.bits := outRegs.last
  io.out.valid := valRegs.last
  io.out.sync := io.in.sync
}

