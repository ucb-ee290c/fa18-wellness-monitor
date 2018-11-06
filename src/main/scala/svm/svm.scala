package svm

import chisel3._
import chisel3.util._
import dsptools.numbers._
import dspjunctions.ValidWithSync
import scala.collection._

trait SVMParams[T <: Data] {
  val protoData: T
  val nSupports: Int // the number of support vectors, from offline training
  val nFeatures: Int // the number of reduced dimensions, coming from SVM
  val nClasses:  Int // the number of classes, for multi-class classification
  val nDegree: Int   // the polynomial kernel degree, ignored if kernelType = 1
  val kernelType: Int// if 0, polynomial kernel, if 1, rbf kernel
  val classifierType: Int     // if 0, one vs rest; if 1, one vs one; if 2, error correcting output code
  val codeBook: Seq[Seq[Int]] // code array used for error correcting output codes, ignored otherwise
}

class SVMIO[T <: Data](params: SVMParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nFeatures, params.protoData)))
  val out = ValidWithSync(UInt(1.W)) // TODO: update this with the actual data type!

  // define the number of classifiers
  var nClassifiers = params.nClasses  // one vs rest default
  if (params.classifierType == 0) {
    if (params.nClasses == 2) nClassifiers = params.nClasses - 1
  } else if (params.classifierType == 1) {   // one vs one
    nClassifiers = (params.nClasses*(params.nClasses - 1))/2
  } else if (params.classifierType == 2) {  // error correcting output code
    nClassifiers = params.codeBook.head.length // # columns = # classifiers
  }

  // these are the arrays needed by the SVM for classification, these are generated through offline training
  // the collection of support vectors (number depends on training), with a vector of features mapped to each one
  val supportVector = Input(Vec(params.nSupports, Vec(params.nFeatures, params.protoData)))
  // the weights of the support vectors for every classifier that has to be built (acquired from the Python training)
  val alphaVector = Input(Vec(nClassifiers, Vec(params.nSupports, params.protoData)))
  // the constant that has to be added after performing all the dot products, per classifier as well
  val intercept = Input(Vec(nClassifiers, params.protoData))

  // these are some probe points, to ensure computational accuracy
  val rawVotes = Output(Vec(params.nClasses, params.protoData))
  val classVotes = Output(Vec(params.nClasses,UInt((log2Ceil(nClassifiers)+1).W)))

  override def cloneType: this.type = SVMIO(params).asInstanceOf[this.type]
}
object SVMIO {
  def apply[T <: Data](params: SVMParams[T]): SVMIO[T] = new SVMIO(params)
}

class SVM[T <: chisel3.Data : Real](val params: SVMParams[T]) extends Module {
  require(params.nSupports > 0, "Must have more than 1 support vector")
  require(params.nFeatures > 0, "Must have at least 1 feature")
  require(params.nClasses > 1, "Must have at least 2 classes")
  require(params.nDegree > 0, "Polynomial degree must be at least 1")
  require(params.kernelType == 1 || params.kernelType == 0, "Kernel type must be either 0 (poly) or 1 (rbf")
  require(params.classifierType == 0 || params.classifierType == 1 || params.classifierType == 2,
                                "Classifier type must be either 0 (one vs rest), 1 (one vs one), 2 (error correct)")
  require(params.codeBook.length == params.nClasses,
                                "Number of rows for codeBook should be the number of classes (nClasses)")

  val io = IO(new SVMIO[T](params))

  // ##################################################################################################################
  // KERNEL CALCULATION
  // ##################################################################################################################

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

  // ##################################################################################################################
  // DECISION MAKING / VOTING CALCULATION
  // ##################################################################################################################

  val decision = Seq.fill(io.nClassifiers)(Wire(params.protoData)) // the raw answer after all the dot product ops

  val actualVotes = Seq.fill(params.nClasses)(Wire(params.protoData)) // summed raw votes, in case of a tie
  val normalizedVotes = Seq.fill(params.nClasses)(Wire(UInt((log2Ceil(io.nClassifiers) + 1).W))) // sum of votes / class

  for (i <- 0 until io.nClassifiers) { // do this for all the classifiers that we have
    decision(i) := (io.alphaVector(i).zip(kernel).map { case (a, b) => a * b }.reduce(_ + _)
      + io.intercept(i)).asTypeOf(params.protoData)
  }

  // #############################################################
  // for one vs rest classifier implementation
  if (params.classifierType == 0) {

    if (params.nClasses > 2) {
      for (i <- 0 until params.nClasses) {
        actualVotes(i) := decision(i)
        when(decision(i) > 0) {
          normalizedVotes(i) := 1.U
        }.otherwise {
          normalizedVotes(i) := 0.U
        }
      }
    } else {  // special case for 2 classes since there's only 1 classifier for that
      when (decision(0) > 0) {
        normalizedVotes(0) := 0.U
        normalizedVotes(1) := 1.U
        actualVotes(0) := ConvertableTo[T].fromInt(0)
        actualVotes(1) := decision(0)
      }.otherwise {
        normalizedVotes(0) := 1.U
        normalizedVotes(1) := 0.U
        actualVotes(0) := ConvertableTo[T].fromInt(0) - decision(0)
        actualVotes(1) := ConvertableTo[T].fromInt(0)
      }
    }

  // #############################################################
  // for one vs one classifier implementation
  } else if (params.classifierType == 1) {

    val classVotes = Seq.fill(params.nClasses)(List.fill(io.nClassifiers)(Wire(UInt(1.W)))) // votes per class per classifier
    val rawVotes = Seq.fill(params.nClasses)(List.fill(io.nClassifiers)(Wire(params.protoData))) // raw votes array, to be summed

    val combinations = mutable.ArrayBuffer[mutable.ArrayBuffer[Int]]() // will contain the mapping to the classifiers
    // this creates an array of the pairwise combinations of all classes
    // for example: if we have 4 classes, then the pattern would be: (0,1) (0,2) (0,3) (1,2) (1,3) (2,3)
    // we need this since this is how the alpha vectors are configured (after training)
    for (x <- 0 until params.nClasses) {
      for (y <- x + 1 until params.nClasses) {
        combinations += mutable.ArrayBuffer(x, y)
      }
    }

    // now do the actual dot product of the kernel with the alphas (weights), add the intercept as well
    for (i <- 0 until io.nClassifiers) { // do this for all the 1v1 classifiers that we have
      // now depending on the sign of the raw answer, that's the vote belonging to a class
      // for example, if the (2,3) classifier has a negative sign (0), then it votes for class 3 (class 2 if positive)
      // TODO: this can probably be optimized further? this is so long, but there is some pattern
      when(decision(i) > 0) {
        for (j <- 0 until params.nClasses) {
          // there is a special case for 2 classes, we formed (0,1) classifier...
          // but the positive vote of 1 should correspond to 1 which is not the first element
          // this is contrary to the multi-class combination (check python script, it works)
          if (params.nClasses > 2) {
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

      }.otherwise {
        for (j <- 0 until params.nClasses) {
          if (params.nClasses > 2) {
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

    // sum up all the votes per class, you will use this to determine the final class of the data point
    for (i <- 0 until params.nClasses) actualVotes(i) := rawVotes(i).reduce(_ + _) // sum up the raw votes
    for (i <- 0 until params.nClasses) normalizedVotes(i) := classVotes(i).reduce(_ +& _) // damn, that +&

  // #############################################################
  // for error correcting output code classifier implementation
  } else {

    // hmm, I can't think of something to put into normalized votes
    val decisionBits = Seq.fill(io.nClassifiers)(Wire(UInt(1.W)))
    val codeBookBits = Seq.fill(params.nClasses,io.nClassifiers)(Wire(UInt(1.W)))

    for (i <- 0 until io.nClassifiers) {
      when (decision(i) > 0) {
        decisionBits(i) := 1.U
      } .otherwise {
        decisionBits(i) := 0.U
      }
    }

    for (i <- 0 until params.nClasses) {
      for (j <- 0 until io.nClassifiers) {
        if(params.codeBook(i)(j) == 1) {
          codeBookBits(i)(j) := 1.U
        } else {
          codeBookBits(i)(j) := 0.U
        }
      }
    }

    for (i <- 0 until params.nClasses) {
      actualVotes(i) := decision.zip(params.codeBook(i)).map{ case (a,b) => (a - b).abs()}.reduce(_ + _)
      normalizedVotes(i) := decisionBits.zip(codeBookBits(i)).map{ case (a,b) => (a - b).abs()}.reduce(_ +& _)
    }
  }

  // put for output probing and checking for computation accuracy
  io.rawVotes := actualVotes      // sometimes you end up with ties, this is for tie breaking classifications
  io.classVotes := normalizedVotes  // normally, you just find the max value of normalized votes per classifier

  // now, we select the class that has the highest number of votes
  // TODO: how to select the index with the most number of votes?
  //io.out := sumVotes.indexOf(UInt(3)).asUInt() // returns -1?
  //io.out := sumVotes.zipWithIndex.maxBy(_._1)._2 // UInt has no max, damn
  io.out.bits := 0.U

  io.out.valid := io.in.valid
  io.out.sync := io.in.sync
}