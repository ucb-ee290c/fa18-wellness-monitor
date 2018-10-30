package svm

import chisel3._
import dsptools.numbers._
import dspjunctions.ValidWithSync
import scala.collection._

trait SVMParams[T <: Data] {
  val protoData: T
  val nSupports: Int
  val nFeatures: Int
  //val nClasses:  Int
}

class SVMIO[T <: Data](params: SVMParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nFeatures, params.protoData)))
  val out = ValidWithSync(params.protoData)

  val supportVector = Input(Vec(Vec(params.nFeatures, params.protoData), params.nSupports))
  val alphaVector = Input(Vec(params.nSupports, params.protoData))
  val intercept = Input(params.protoData)

  val rawOut = Output(params.protoData)

  //val alphaVector = Input(Vec(Vec(params.nSupports, params.protoData), params.nClasses*(params.nClasses - 1)/2))
  //val intercept = Input(Vec(params.nClasses*(params.nClasses - 1)/2, params.protoData))

  override def cloneType: this.type = SVMIO(params).asInstanceOf[this.type]
}
object SVMIO {
  def apply[T <: Data](params: SVMParams[T]): SVMIO[T] = new SVMIO(params)
}

class SVM[T <: chisel3.Data : Real](val params: SVMParams[T]) extends Module {
  val io = IO(new SVMIO[T](params))

  // dot product, this is where the kernel goes
  val kernel = Wire(Vec(params.nSupports, params.protoData))
  for (i <- 0 until params.nSupports){
    kernel(i) := io.in.bits.zip(io.supportVector(i)).map{ case (a,b) => a * b}.reduce(_ + _)
  }

  // multiply by the weights, add the intercept, clamp it to either 0 or 1, you're done
  // for binary classification this is easy

  val decisionFunction = (io.alphaVector.zip(kernel).map{ case (a,b) => a * b}.reduce(_ + _) + io.intercept).asTypeOf(params.protoData)
  io.rawOut := decisionFunction

  when (decisionFunction > 0) {
    io.out.bits := ConvertableTo[T].fromInt(1)
  } .otherwise {
    io.out.bits := ConvertableTo[T].fromInt(0)
  }

  /*
  // multi-class support, creating votes for every classifier generated
  val nClassifiers = params.nClasses*(params.nClasses - 1)/2

  val votes = Wire(Vec(nClassifiers, params.protoData))
  val decision = Wire(Vec(nClassifiers, params.protoData))
  for (i <- 0 until nClassifiers) {
    //votes(i) := (io.alphaVector(i).zip(kernel).map{ case (a,b) => a * b}.reduce(_ + _) + io.intercept(i)) > 0
    votes(i) := io.alphaVector(i).zip(kernel).map{ case (a,b) => a * b}.reduce(_ + _) + io.intercept(i)


    when(votes > ConvertableTo[T].fromInt(0)) {
      decision(i) := ConvertableTo[T].fromInt(1)
    } .otherwise {
      decision(i) := ConvertableTo[T].fromInt(1)
    }
  }

  val combinations = mutable.ArrayBuffer[mutable.ArrayBuffer[T]]()
  for (x <- 0 until params.nClasses) {
    for (y <- x + 1 until params.nClasses) {
      combinations += mutable.ArrayBuffer(ConvertableTo[T].fromInt(x),ConvertableTo[T].fromInt(y))
    }
  }
  */
  io.out.valid := io.in.valid
  io.out.sync := io.in.sync
}