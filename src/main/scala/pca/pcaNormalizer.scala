package pca

import chisel3._
import chisel3.util.RegEnable
import dsptools.numbers._
import dspjunctions.ValidWithSync

class PCANormalizerIO[T <: Data](params: PCAParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nDimensions, params.protoData)))
  val out = ValidWithSync(Vec(params.nDimensions, params.protoData))

  val PCANormalizationData = Input(Vec(params.nDimensions, Vec(2, params.protoData)))

  override def cloneType: this.type = PCANormalizerIO(params).asInstanceOf[this.type]
}
object PCANormalizerIO {
  def apply[T <: Data](params: PCAParams[T]): PCANormalizerIO[T] = new PCANormalizerIO(params)
}

class PCANormalizer[T <: chisel3.Data : Real](val params: PCAParams[T]) extends Module {
  require(params.nDimensions >= params.nFeatures,
    f"Number of projected dimensions ${params.nFeatures} should be at most the number of original dimensions ${params.nDimensions}")

  val io = IO(new PCANormalizerIO[T](params))

  val normalizedDimensions = Wire(Vec(params.nDimensions,params.protoData))

  normalizedDimensions := io.in.bits.zip(io.PCANormalizationData).map{ case (a,b) => (a - b(0))*b(1)}

  val outReg = RegEnable(normalizedDimensions, io.in.valid)
  val valReg = RegNext(io.in.valid)
  val syncReg = RegNext(io.in.sync)

  io.out.bits := outReg
  io.out.valid := valReg
  io.out.sync := syncReg
}