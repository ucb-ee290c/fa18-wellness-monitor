package svm

import chisel3._
import dsptools.numbers._
import dspjunctions.ValidWithSync
import scala.collection._
import breeze.numerics._

trait SVMParams[T <: Data] {
  val protoData: T
  val nSupports: Int // the number of support vectors, from offline training
  val nFeatures: Int // the number of reduced dimensions, coming from SVM
  val nClasses:  Int // the number of classes, for multi-class classification
  val nDegree: Int   // the polynomial kernel degree
}

class SVMIO[T <: Data](params: SVMParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nFeatures, params.protoData)))
  val out = ValidWithSync(UInt()) // update this with the actual class!

  val supportVector = Input(Vec(Vec(params.nFeatures, params.protoData), params.nSupports))
  val alphaVector = Input(Vec(Vec(params.nSupports, params.protoData), (params.nClasses*(params.nClasses - 1))/2))
  val intercept = Input(Vec((params.nClasses*(params.nClasses - 1))/2, params.protoData))

  val rawVotes = Output(Vec((params.nClasses*(params.nClasses - 1))/2, params.protoData))
  val rawSums = Output(Vec(params.nClasses,UInt(((log10(params.nClasses)/log10(2)).ceil.toInt+1).W)))

  override def cloneType: this.type = SVMIO(params).asInstanceOf[this.type]
}
object SVMIO {
  def apply[T <: Data](params: SVMParams[T]): SVMIO[T] = new SVMIO(params)
}

class SVM[T <: chisel3.Data : Real](val params: SVMParams[T]) extends Module {
  val io = IO(new SVMIO[T](params))

  // dot product, this is where the kernel goes
  val kernel = Wire(Vec(Vec(params.nSupports, params.protoData),params.nDegree))
  for (i <- 0 until params.nSupports){
    kernel(0)(i) := io.in.bits.zip(io.supportVector(i)).map{ case (a,b) => a * b}.reduce(_ + _)
    for (j <- 1 until params.nDegree) {
      kernel(j) := kernel(j-1).map{ p => p*p} // multiply by itself n times for nth degree poly
    }
  }

  // multiply by the weights, add the intercept, clamp it to either 0 or 1, you're done
  // for binary classification this is easy

  // multi-class support, creating votes for every classifier generated
  val nClassifiers = (params.nClasses*(params.nClasses - 1))/2
  val decision = Wire(Vec(nClassifiers, params.protoData))
  val combinations = mutable.ArrayBuffer[mutable.ArrayBuffer[Int]]()
  val classVotes = Wire(Vec(Vec(nClassifiers, UInt()), params.nClasses))
  val sumVotes = Wire(Vec(params.nClasses,UInt()))

  // create the one vs one classifier combinations, for voting later
  for (x <- 0 until params.nClasses) {
    for (y <- x + 1 until params.nClasses) {
      combinations += mutable.ArrayBuffer(x,y)
    }
  }

  for (i <- 0 until nClassifiers) {
    decision(i) := (io.alphaVector(i).zip(kernel(params.nDegree-1)).map{ case (a,b) => a * b}.reduce(_ + _) + io.intercept(i)).asTypeOf(params.protoData)

    // this can probably be optimized further?
    when (decision(i) > 0) {
      for (j <- 0 until params.nClasses) {
        if(params.nClasses > 2) {
          if (j == combinations(i)(0)) classVotes(j)(i) := 1.U
          else classVotes(j)(i) := 0.U
        } else {
          if (j == combinations(i)(1)) classVotes(j)(i) := 1.U
          else classVotes(j)(i) := 0.U
        }
      }
    } .otherwise {
      for (j <- 0 until params.nClasses) {
        if(params.nClasses > 2) {
          if (j == combinations(i)(1)) classVotes(j)(i) := 1.U
          else classVotes(j)(i) := 0.U
        } else {
          if (j == combinations(i)(0)) classVotes(j)(i) := 1.U
          else classVotes(j)(i) := 0.U
        }
      }
    }
  }

  for (i <- 0 until params.nClasses) {
    sumVotes(i) := classVotes(i).reduce(_ +& _) // damn
  }

  io.rawVotes := decision
  io.rawSums := sumVotes

  // TODO: how to select the index with the most number of votes?
  //io.out := sumVotes.indexOf(UInt(3)).asUInt() // returns -1?
  //io.out := sumVotes.zipWithIndex.maxBy(_._1)._2 // UInt has no max, damn
  io.out.bits := 0.U
  io.out.valid := io.in.valid
  io.out.sync := io.in.sync
}