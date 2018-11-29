package pca

import chisel3._
import chisel3.util.RegEnable
import dsptools.numbers._
import dspjunctions.ValidWithSync

trait PCAParams[T <: Data] {
  val protoData: T
  val nDimensions: Int // number of input dimensions (original features)
  val nFeatures: Int  // number of output dimensions (reduced features), going to SVM
}

class PCAIO[T <: Data](params: PCAParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nDimensions, params.protoData)))
  val out = ValidWithSync(Vec(params.nFeatures, params.protoData))

  val PCAVector = Input(Vec(params.nFeatures, Vec(params.nDimensions, params.protoData)))

  override def cloneType: this.type = PCAIO(params).asInstanceOf[this.type]
}
object PCAIO {
  def apply[T <: Data](params: PCAParams[T]): PCAIO[T] = new PCAIO(params)
}

class PCA[T <: chisel3.Data : Real](val params: PCAParams[T]) extends Module {
  require(params.nDimensions >= params.nFeatures,
    f"Number of projected dimensions ${params.nFeatures} should be at most the number of original dimensions ${params.nDimensions}")

  val io = IO(new PCAIO[T](params))

  // this is just a dot product! nothing special here
  val reduced = Wire(Vec(params.nFeatures, params.protoData))
  for (i <- 0 until params.nFeatures){
    reduced(i) := io.in.bits.zip(io.PCAVector(i)).map{ case (a,b) => a * b}.reduce(_ + _)
  }

  val outReg = RegEnable(reduced, io.in.valid)
  val valReg = RegNext(io.in.valid)
  val syncReg = RegNext(io.in.sync)

  io.out.bits := outReg
  io.out.valid := valReg
  io.out.sync := syncReg
}