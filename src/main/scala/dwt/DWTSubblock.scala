package dwt

import chisel3._
import chisel3.util.Decoupled
import chisel3.util.RegEnable
import firFilter._
import dsptools.numbers._
import dspjunctions.ValidWithSync

trait DWTParams[T <: Data] {
  val protoData: T
  val taps_LPF: Seq[T]
  val taps_HPF: Seq[T]
  // val num_levels // TODO: implement FSM for variable number of levels
}

class DWTSubblockIO[T <: Data](params: DWTParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(params.protoData.cloneType))
  val detail_coeff_out = ValidWithSync(params.protoData.cloneType) // output of the HPF
  val approx_coeff_out = ValidWithSync(params.protoData.cloneType) // output of the LPF


  //val DWTVector = Input(Vec(params.nFeatures, Vec(params.nDimensions, params.protoData)))

  override def cloneType: this.type = DWTSubblockIO(params).asInstanceOf[this.type]
}
object DWTSubblockIO {
  def apply[T <: Data](params: DWTParams[T]): DWTSubblockIO[T] = new DWTSubblockIO(params)
}

class DWTSubblock[T <: chisel3.Data: Real](val params: DWTParams[T]) extends Module {
  //require(params.nDimensions >= params.nFeatures,
  // f"Number of projected dimensions ${params.nFeatures} should be at most the number of original dimensions ${params.nDimensions}")

  val io = IO(new DWTSubblockIO[T](params))

  val lpf_params = new FIRFilterParams[T] {
    val protoData = params.protoData
    val taps = params.taps_LPF
  }

  val hpf_params = new FIRFilterParams[T] {
    val protoData = params.protoData
    val taps = params.taps_HPF
  }

  val lpf = Module(new ConstantCoefficientFIRFilter(lpf_params))
  val hpf = Module(new ConstantCoefficientFIRFilter(hpf_params))
  lpf.io.in <> io.in
  hpf.io.in <> io.in

  // Decimate LPF output
  val lpf_decimator = Module(new Decimator[T](params.protoData))
  lpf_decimator.io.in <> lpf.io.out
  lpf_decimator.io.out <> io.approx_coeff_out

  // Decimate HPF output
  val hpf_decimator = Module(new Decimator[T](params.protoData))
  hpf_decimator.io.in <> hpf.io.out
  hpf_decimator.io.out <> io.detail_coeff_out
}

class Decimator[T <: chisel3.Data: Real](val protoData: T) extends Module {
  // Decimate every other sample

  val io = IO(new Bundle {
    val in = Flipped(Decoupled(protoData.cloneType))
    val out = Decoupled(protoData.cloneType)
  })

  io.out.valid := false.B
  io.in.ready := io.out.ready
  io.out.bits := io.in.bits

  val lastState = RegInit(false.B)
  when(io.in.fire()) {
    val nextState = !lastState
    lastState := nextState
    io.out.valid := lastState
  }
}
/*
  lpf.io.

  val outReg = RegEnable(reduced, io.in.valid)
  val valReg = RegNext(io.in.valid)
  val syncReg = RegNext(io.in.sync)

  io.out.bits := outReg
  io.out.valid := valReg
  io.out.sync := syncReg
 */
