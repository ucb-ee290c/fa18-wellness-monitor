package svm

import chisel3._
import chisel3.util._
import dsptools.numbers._
import dspjunctions.ValidWithSync
import scala.collection._

trait SVMParams[T <: Data] {
  val protoData: T
  val nSupports: Int          // the number of support vectors, from offline training
  val nFeatures: Int          // the number of reduced dimensions, coming from PCA
  val nClasses:  Int          // the number of classes, for multi-class classification
  val classifierType: String  // 'ovr' (one vs rest), 'ovo' (one vs one), 'ecoc' (error correcting)
  val codeBook: Seq[Seq[Int]] // code array used for error correcting output codes, ignored otherwise
  val kernelType: String      // 'poly' or 'rbf' kernels
  val nDegree: Int            // the polynomial kernel degree, ignored if kernelType = 'poly'
}

class SVMIO[T <: Data](params: SVMParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nFeatures, params.protoData)))
  val out = ValidWithSync(UInt(1.W)) // TODO: update this with the actual data type!

  // define the number of classifiers
  var nClassifiers = params.nClasses  // one vs rest default
  if (params.classifierType == "ovr") {
    if (params.nClasses == 2) nClassifiers = params.nClasses - 1
  } else if (params.classifierType == "ovo") {   // one vs one
    nClassifiers = (params.nClasses*(params.nClasses - 1))/2
  } else if (params.classifierType == "ecoc") {  // error correcting output code
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
  require(params.nSupports > 1, "Must have more than 1 support vector")
  require(params.nFeatures > 0, "Must have at least 1 feature")
  require(params.nClasses >= 2, "Must have at least 2 classes")
  require(params.nDegree >= 1, "Polynomial degree must be at least 1")
  require(params.kernelType == "poly" || params.kernelType == "rbf", "Kernel type must be either poly or rbf")
  require(params.classifierType == "ovr" || params.classifierType == "ovo" || params.classifierType == "ecoc",
                "Classifier type must be either ovr (one vs rest), ovo (one vs one), ecoc (error correct)")
  require(params.codeBook.length == params.nClasses,
                "Number of rows for codeBook should be the number of classes (nClasses)")
  require(params.codeBook.map(_.forall(a => (a == 1) || (a == -1))).forall(_ == true))

  val io = IO(new SVMIO[T](params))

  // ##################################################################################################################
  // KERNEL CALCULATION
  // ##################################################################################################################

  // dot product, this is where the kernel goes
  val kernel = Wire(Vec(params.nSupports, params.protoData))

  // this is the computation for a polynomial kernel
  // this is simply the dot product of the support vector and the input, raised to a power depending on the degree
  if (params.kernelType == "poly") {
    val polyKernel = Wire(Vec(params.nDegree, Vec(params.nSupports, params.protoData)))
    for (i <- 0 until params.nSupports) { // get the dot product first (like a typical linear kernel)
      polyKernel(0)(i) := io.in.bits.zip(io.supportVector(i)).map {case (a, b) => a * b}.reduce(_ + _)
    }
    for (i <- 1 until params.nDegree) { // multiply by itself n times for nth degree polynomial
      polyKernel(i) := polyKernel(i - 1).zip(polyKernel(0)).map {case(a, b) => a * b}
    }
    kernel := polyKernel(params.nDegree-1)

    // else, this is for the RBF kernel
    // you subtract the support vector features to the input, square it, then sum it all up
    // you also have to use that answer as an exponent (negative) to an exponential function
  } else {
    val rbfKernel = Wire(Vec(params.nSupports, params.protoData))
    for (i <- 0 until params.nSupports) {
      // TODO: after reduction, perform exp^(ans), how to do that?
      rbfKernel(i) := io.in.bits.zip(io.supportVector(i)).map {case (a,b) => b - a}.map{k => -1*(k * k)}.reduce(_ + _)
    }
    kernel := rbfKernel
  }
  // at this point, the kernel has been computed, now we perform dot product with the weights

  // ##################################################################################################################
  // DECISION MAKING / VOTING CALCULATION
  // ##################################################################################################################

  val decision = Seq.fill(io.nClassifiers)(Wire(params.protoData)) // the raw answer after all the dot product ops

  // this is the final dot product that needs to be performed to create the SVM decision function
  for (i <- 0 until io.nClassifiers) {
    decision(i) := io.alphaVector(i).zip(kernel).map { case (a, b) => a * b }.reduce(_ + _) + io.intercept(i)
  }
  // using this decision function, we can now perform classification, which depends on the type

  val actualVotes = Seq.fill(params.nClasses)(Wire(params.protoData)) // summed raw votes, in case of a tie
  val normalizedVotes = Seq.fill(params.nClasses)(Wire(UInt((log2Ceil(io.nClassifiers) + 1).W))) // sum of votes / class

  // #############################################################
  // for one vs rest classifier implementation
  if (params.classifierType == "ovr") {

    if (params.nClasses > 2) {
      // each classifier corresponds to a single class,
      // therefore, if the decision function corresponding to that class is positive, that's a vote to that class
      for (i <- 0 until params.nClasses) {
        actualVotes(i) := decision(i)
        normalizedVotes(i) := Mux(decision(i) > 0, 1.U, 0.U) // if decision is +, vote for that class, else 0
      }
    } else {  // special case for 2 classes since there's only 1 classifier for that, so we'll loop only once
      // the logic is the same, but we assign both index 0 and 1 in one shot since we only go through here once
      // if decision is +, index 1 has 1, index 0 has 0, else reverse. Raw score will go to the voted one.
      normalizedVotes(0) := Mux(decision.head > 0, 0.U, 1.U)
      normalizedVotes(1) := Mux(decision.head > 0, 1.U, 0.U)
      actualVotes(0) := Mux(decision.head > 0, ConvertableTo[T].fromInt(0), decision.head.abs)
      actualVotes(1) := Mux(decision.head > 0, decision.head, ConvertableTo[T].fromInt(0))
    }

  // #############################################################
  // for one vs one classifier implementation
  } else if (params.classifierType == "ovo") {

    val combinations = mutable.ArrayBuffer[mutable.ArrayBuffer[Int]]() // will contain the mapping to the classifiers
    // this creates an array of the pairwise combinations of all classes
    // for example: if we have 4 classes, then the pattern would be: (0,1) (0,2) (0,3) (1,2) (1,3) (2,3)
    // we need this since this is how the alpha vectors are configured (after training)

    for (x <- 0 until params.nClasses)            // loop for all classes excluding the last one
      for (y <- x + 1 until params.nClasses)      // second pair starts at x + 1
        combinations += mutable.ArrayBuffer(x, y) // append the new combination pair to the array buffer

    val classVotes = Seq.fill(params.nClasses,io.nClassifiers)(Wire(UInt(1.W))) // votes per class per classifier
    val rawVotes = Seq.fill(params.nClasses,io.nClassifiers)(Wire(params.protoData)) // raw votes array, to be summed

    // now do the actual dot product of the kernel with the alphas (weights), add the intercept as well
    for (i <- 0 until io.nClassifiers) { // do this for all the 1v1 classifiers that we have
      for (j <- 0 until params.nClasses) {

        // now depending on the sign of the raw answer, that's the vote belonging to a class
        // for example, if the (2,3) classifier has a negative sign (0), then it votes for class 3 (class 2 if positive)
        // there is a special case for 2 classes, we formed (0,1) classifier...
        // where the positive vote of 1 should correspond to 1 which is not the first element
        // this is contrary to the multi-class combination, therefore we do the XOR for this decision

        when((decision(i) > 0) ^ (params.nClasses.asUInt() > 2.U)) { // logic for 2 class is opposite to multi-class
          classVotes(j)(i) := Mux((j == combinations(i)(1)).asBool,1.U,0.U) // index 1 class will get the vote
          rawVotes(j)(i) := Mux((j == combinations(i)(1)).asBool,decision(i).abs(),ConvertableTo[T].fromInt(0))

        }.otherwise { // handler for opposite decision values
          classVotes(j)(i) := Mux((j == combinations(i)(0)).asBool,1.U,0.U) // index 0 class will get the vote
          rawVotes(j)(i) := Mux((j == combinations(i)(0)).asBool,decision(i).abs(),ConvertableTo[T].fromInt(0))
        }
      }
    }

    // sum up all the votes per class, you will use this to determine the final class of the data point
    for (i <- 0 until params.nClasses) {
      actualVotes(i) := rawVotes(i).reduce(_ + _)        // sum up the raw votes
      normalizedVotes(i) := classVotes(i).reduce(_ +& _) // damn, that +&, it's so critical
    }

  // #############################################################
  // for error correcting output code classifier implementation
  } else {

    // from the classifier combinations, we end up with a binary string, which we then compare to the code book
    // so the votes are actually a distance metric (look at my Python code for this)
    val decisionBits = Seq.fill(io.nClassifiers)(Wire(UInt(1.W)))
    val codeBookBits = Seq.fill(params.nClasses,io.nClassifiers)(Wire(UInt(1.W)))

    // creating an array containing the sign of the decision function
    // we will use this for the hamming distance measurement
    for (i <- 0 until io.nClassifiers) decisionBits(i) := Mux(decision(i) > 0, 1.U, 0.U)

    // this translates the code book from [-1,1] to [0,1]
    // the [-1,1] is used for L1 distance measurement (sum of absolute values of raw scores)
    // the [0,1] is used for the hamming distance (sum of absolute values of binary scores
    for (i <- 0 until params.nClasses)
      for (j <- 0 until io.nClassifiers)
        codeBookBits(i)(j) := Mux((params.codeBook(i)(j) == 1).asBool, 1.U, 0.U)

    // we can just do the distance measurement using this chain of function calls
    for (i <- 0 until params.nClasses) {
      actualVotes(i) := decision.zip(params.codeBook(i)).map{ case (a,b) => -1*(a - b)*(a - b)}.reduce(_ + _)
      normalizedVotes(i) := io.nClassifiers -
        decisionBits.zip(codeBookBits(i)).map{ case (a,b) => (a - b).abs()}.reduce(_ +& _)
    }
  }

  // put for output probing and checking for computation accuracy
  io.rawVotes := actualVotes      // sometimes you end up with ties, this is for tie breaking classifications
  io.classVotes := normalizedVotes  // normally, you just find the max value of normalized votes per classifier

  // TODO: out is meant to contain the final vote, if it's hard, just check rawVotes and classVotes instead
  io.out.bits := 0.U

  // technically, this isn't needed because everything is combinational right now
  // TODO: you might want to implement some sequential logic (pipelines) to reduce the critical path
  io.out.valid := io.in.valid
  io.out.sync := io.in.sync
}