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
  val nDegree: Int   // the polynomial kernel degree, ignored if kernelType = 1
  val kernelType: Int// if 0, polynomial kernel, if 1, rbf kernel
}

class SVMIO[T <: Data](params: SVMParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nFeatures, params.protoData)))
  val out = ValidWithSync(UInt(1.W)) // TODO: update this with the actual data type!

  // these are the arrays needed by the SVM for classification, these are generated through offline training
  // the collection of support vectors (number depends on training), with a vector of features mapped to each one
  val supportVector = Input(Vec(params.nSupports, Vec(params.nFeatures, params.protoData)))
  // the weights of the support vectors for every classifier that has to be built (acquired from the Python training)
  val alphaVector = Input(Vec((params.nClasses*(params.nClasses - 1))/2, Vec(params.nSupports, params.protoData)))
  // the constant that has to be added after performing all the dot products, per classifier as well
  val intercept = Input(Vec((params.nClasses*(params.nClasses - 1))/2, params.protoData))

  // these are some probe points, to ensure computational accuracy
  val rawVotes = Output(Vec(params.nClasses, params.protoData))
  val classVotes = Output(Vec(params.nClasses,UInt((log10(params.nClasses)/log10(2)).ceil.toInt.W)))

  override def cloneType: this.type = SVMIO(params).asInstanceOf[this.type]
}
object SVMIO {
  def apply[T <: Data](params: SVMParams[T]): SVMIO[T] = new SVMIO(params)
}

class SVM[T <: chisel3.Data : Real](val params: SVMParams[T]) extends Module {
  require(params.nSupports > 0)
  require(params.nFeatures > 0)
  require(params.nClasses > 1)
  require(params.nDegree > 0)
  require(params.kernelType == 1 || params.kernelType == 0)
  val io = IO(new SVMIO[T](params))

  // dot product, this is where the kernel goes
  val kernel = Wire(Vec(params.nSupports, params.protoData))

  // if kernelType = 0, this is a polynomial kernel
  // this is simply the dot product of the support vector and the input, raised to a power depending on the degree
  if (params.kernelType == 0) {
    val polyKernel = Wire(Vec(params.nDegree, Vec(params.nSupports, params.protoData)))
    for (i <- 0 until params.nSupports) { // get the dot product first (like a typical linear kernel)
      polyKernel(0)(i) := io.in.bits.zip(io.supportVector(i)).map {case (a, b) => a * b}.reduce(_ + _)
    }
    for (i <- 1 until params.nDegree) { // multiply by itself n times for nth degree polynomial
      polyKernel(i) := polyKernel(i - 1).zip(polyKernel(0)).map {case(a, b) => a * b}
    }
    kernel := polyKernel(params.nDegree-1)

  // if kernelType = 1, this is an RBF kernel
  // you subtract the support vector features to the input, square it, then sum it all up
  // you also have to use that answer as an exponent (negative) to an exponential function
  } else {
    val rbfKernel = Wire(Vec(params.nSupports, params.protoData))
    for (i <- 0 until params.nSupports) {
      // TODO: after reduction, perform exp^(ans), how to do that?
      rbfKernel(i) := io.in.bits.zip(io.supportVector(i)).map {case (a, b) => b - a}.map{ k => -1*(k * k)}.reduce(_ + _)
    }
    kernel := rbfKernel
  }

  // at this point, the kernel has been computed, now we perform dot product with the weights
  // TODO: implement the one vs all, and the ECOC classification (use params)
  // this depends on the number of classes, 1v1 classification requires n*(n-1)/2 classifiers!
  // multiply by the weights, add the intercept, clamp it to either 0 or 1, you're done

  val nClassifiers = (params.nClasses*(params.nClasses - 1))/2    // just a constant
  val decision = Wire(Vec(nClassifiers, params.protoData))        // the raw answer after all the dot product ops
  val combinations = mutable.ArrayBuffer[mutable.ArrayBuffer[Int]]()  // will contain the mapping to the classifiers
  val classVotes = Wire(Vec(params.nClasses, Vec(nClassifiers, UInt(1.W)))) // votes per class per classifier
  val rawVotes = Wire(Vec(params.nClasses, Vec(nClassifiers, params.protoData))) // raw votes array, to be summed
  val actualVotes = Wire(Vec(params.nClasses, params.protoData)) // summed raw votes, in case of a tie in normalized votes
  val normalizedVotes = Wire(Vec(params.nClasses,UInt((log10(params.nClasses)/log10(2)).ceil.toInt.W))) // sum of votes / class

  // this creates an array of the pairwise combinations of all classes
  // for example: if we have 4 classes, then the pattern would be: (0,1) (0,2) (0,3) (1,2) (1,3) (2,3)
  // we need this since this is how the alpha vectors are configured (after training)
  for (x <- 0 until params.nClasses) {
    for (y <- x + 1 until params.nClasses) {
      combinations += mutable.ArrayBuffer(x,y)
    }
  }

  // now do the actual dot product of the kernel with the alphas (weights), add the intercept as well
  for (i <- 0 until nClassifiers) {   // do this for all the 1v1 classifiers that we have
    decision(i) := (io.alphaVector(i).zip(kernel).map{case (a,b) => a * b}.reduce(_ + _)
                + io.intercept(i)).asTypeOf(params.protoData)

    // now depending on the sign of the raw answer, that's the vote belonging to a class
    // for example, if the (2,3) classifier has a negative sign (0), then it votes for class 3 (class 2 if positive)
    // TODO: this can probably be optimized further? this is so long, but there is some pattern
    when (decision(i) > 0) {
      for (j <- 0 until params.nClasses) {
        // there is a special case for 2 classes, we formed (0,1) classifier...
        // but the positive vote of 1 should correspond to 1 which is not the first element
        // this is contrary to the multi-class combination (check python script, it works)
        if(params.nClasses > 2) {
          if (j == combinations(i)(0)) {
            classVotes(j)(i) := 1.U
            rawVotes(j)(i) := decision(i)
          } else {
            classVotes(j)(i) := 0.U
            rawVotes(j)(i) := ConvertableTo[T].fromInt(0)
          }
        } else {
          if (j == combinations(i)(1)) {
            classVotes(j)(i) := 1.U
            rawVotes(j)(i) := decision(i)
          } else {
            classVotes(j)(i) := 0.U
            rawVotes(j)(i) := ConvertableTo[T].fromInt(0)
          }
        }
      }
    } .otherwise {
      for (j <- 0 until params.nClasses) {
        if(params.nClasses > 2) {
          if (j == combinations(i)(1)) {
            classVotes(j)(i) := 1.U
            rawVotes(j)(i) := ConvertableTo[T].fromInt(0) - decision(i)
          } else {
            classVotes(j)(i) := 0.U
            rawVotes(j)(i) := ConvertableTo[T].fromInt(0)
          }
        } else {
          if (j == combinations(i)(0)) {
            classVotes(j)(i) := 1.U
            rawVotes(j)(i) := ConvertableTo[T].fromInt(0) - decision(i)
          } else {
            classVotes(j)(i) := 0.U
            rawVotes(j)(i) := ConvertableTo[T].fromInt(0)
          }
        }
      }
    }
  }

  // sum up all the votes per class, you will use this to determine the final class of the datapoint
  for (i <- 0 until params.nClasses) {
    normalizedVotes(i) := classVotes(i).reduce(_ +& _) // damn, that & is very critical to extend the bits
  }

  for (i <- 0 until params.nClasses) {
    actualVotes(i) := rawVotes(i).reduce(_ + _) // damn, that & is very critical to extend the bits
  }

  // put for output probing and checking for computation accuracy
  io.classVotes := normalizedVotes  // normally, you just find the max value of normalized votes per classifier
  io.rawVotes := actualVotes        // sometimes you end up with ties, this is for tie breaking classifications

  // now, we select the class that has the highest number of votes
  // TODO: how to select the index with the most number of votes?
  //io.out := sumVotes.indexOf(UInt(3)).asUInt() // returns -1?
  //io.out := sumVotes.zipWithIndex.maxBy(_._1)._2 // UInt has no max, damn
  io.out.bits := 0.U

  io.out.valid := io.in.valid
  io.out.sync := io.in.sync
}