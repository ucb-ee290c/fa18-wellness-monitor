package svm

import chisel3._
import dsptools.numbers._
import dspjunctions.ValidWithSync

trait SVMParams[T <: Data] {
  val protoData: T
  val nSupports: Int
  val nFeatures: Int
}

class SVMIO[T <: Data](params: SVMParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nFeatures, params.protoData.cloneType)))
  val out = ValidWithSync(params.protoData.cloneType)

  val supportVector = Input(Vec(Vec(params.nFeatures, params.protoData.cloneType), params.nSupports))
  val alphaVector = Input(Vec(params.nSupports, params.protoData.cloneType))
  val intercept = Input(params.protoData.cloneType)

  override def cloneType: this.type = SVMIO(params).asInstanceOf[this.type]
}
object SVMIO {
  def apply[T <: Data](params: SVMParams[T]): SVMIO[T] = new SVMIO(params)
}

class SVM[T <: chisel3.Data : Real](val params: SVMParams[T]) extends Module {
  val io = IO(new SVMIO[T](params))

  // dot product, this is where the kernel goes
  val kernel = Wire(Vec(params.nSupports, params.protoData.cloneType))
  for (i <- 0 until params.nSupports){
    kernel(i) := io.in.bits.zip(io.supportVector(i)).map{ case (a,b) => a * b}.reduce(_ + _)
  }

  // multiply by the weights, add the intercept, clamp it to either 0 or 1, you're done
  // for binary classification this is easy
  io.out.bits := io.alphaVector.zip(kernel).map{ case (a,b) => a * b}.reduce(_ + _) + io.intercept
  io.out.valid := io.in.valid
  io.out.sync := io.in.sync
}