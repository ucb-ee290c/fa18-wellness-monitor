package wellness

import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._

import chisel3.{Bundle, Flipped, Input, Module, SInt, Vec}
import chisel3.core.{FixedPoint, Wire}
import dspjunctions.ValidWithSync
import dsptools.numbers.{ConvertableTo, Ring}
import wellness.FixedPointWellnessGenParams.{dataBP, dataWidth}

class dummyIO[T <: chisel3.Data : Ring] extends Bundle {
  //val dummyIn = Input(Seq(10,10))
  val in = Flipped(ValidWithSync(FixedPoint(dataWidth.W, dataBP.BP)))
}
object dummyIO {
  def apply[T <: chisel3.Data : Ring]: dummyIO[T] =
    new dummyIO()
}

class dummy[T <: chisel3.Data : Ring] extends Module {
  val io = IO(dummyIO[T])

  val dummyCalc = 1
}