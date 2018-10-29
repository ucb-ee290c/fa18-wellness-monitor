package pca

import chisel3._
import dsptools.numbers._
import dspjunctions.ValidWithSync
import scala.collection._

trait PCAParams[T <: Data] {
  val protoData: T
  val nDimensions: Int // number of input dimensions (original features)
  val nFeatures: Int // number of output dimensions (reduced features), going to SVM
}

class PCAIO[T <: Data](params: PCAParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nDimensions, params.protoData)))
  val out = ValidWithSync(Vec(params.nFeatures, params.protoData))

  val PCAVector = Input(Vec(Vec(params.nDimensions, params.protoData), params.nFeatures))

  override def cloneType: this.type = PCAIO(params).asInstanceOf[this.type]
}
object PCAIO {
  def apply[T <: Data](params: PCAParams[T]): PCAIO[T] = new PCAIO(params)
}

class PCA[T <: chisel3.Data : Real](val params: PCAParams[T]) extends Module {
  val io = IO(new PCAIO[T](params))

  // dot product, this is where the kernel goes
  val reduced = Wire(Vec(params.nFeatures, params.protoData))
  for (i <- 0 until params.nFeatures){
    reduced(i) := io.in.bits.zip(io.PCAVector(i)).map{ case (a,b) => a * b}.reduce(_ + _)
  }

  io.out.bits := reduced
  io.out.valid := io.in.valid
  io.out.sync := io.in.sync
}