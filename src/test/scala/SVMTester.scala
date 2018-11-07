package svm

import chisel3._
import dsptools.numbers._
import dsptools.DspTester

import scala.collection._
import scala.math._

class GoldenIntSVM(params: SVMParams[SInt]) {
  def poke(input: Seq[Int], supportVector: Seq[Seq[Int]], alphaVector: Seq[Seq[Int]],
           intercept: Seq[Int], flag: Int): Seq[Seq[Int]] = {

    // this is the decision function (raw output of each classifier), array of length #classifiers
    val decision = mutable.ArrayBuffer.fill(alphaVector.length)(0)
    var dotTemp = mutable.ArrayBuffer.fill(params.nSupports)(0) // used for the polynomial kernel

    var classVotes = mutable.ArrayBuffer.fill(params.nClasses)(0) // contains binarized votes per class
    var rawVotes = mutable.ArrayBuffer.fill(params.nClasses)(0) // contains the raw votes per class

    // ################################################################################################################
    // KERNEL CALCULATION
    // ################################################################################################################

    // perform dot product, manually (that's why it's a nested for loop)
    // if you understand the required operations for the dot product, this loop shouldn't be that hard to understand
    for (x <- alphaVector.indices) { // number of classifiers
      for (y <- supportVector.indices) { // number of support vectors
        for (z <- supportVector(0).indices) { // number of features
          // kernel computation depends on the type: polynomial or rbf
          if (params.kernelType == 0) { // for polynomial kernel, get the dot product first
            dotTemp(y) = dotTemp(y) + input(z) * supportVector(y)(z)
          } else { // for rbf kernel, solve for the exponent value first
            decision(x) = decision(x) + alphaVector(x)(y) *
              -1 * (input(z) - supportVector(y)(z)) * (input(z) - supportVector(y)(z))
          }
        }
        if (params.kernelType == 0) { // multiply the dot product by itself (only used by polynomial kernel)
          decision(x) = decision(x) + alphaVector(x)(y) * pow(dotTemp(y).toDouble, params.nDegree.toDouble).toInt
        } else {
          // TODO: this is probably where you will put the exponential for the RBF kernel
        }
      }
      dotTemp = mutable.ArrayBuffer.fill(params.nSupports)(0) // reset accumulator (only used for polynomial kernel)
      decision(x) = decision(x) + intercept(x) // final addition of the intercept per classifier
    }

    // ################################################################################################################
    // DECISION MAKING / VOTING CALCULATION
    // ################################################################################################################
    
    // #############################################################
    // for one vs rest classifier implementation
    if (params.classifierType == 0) {

      // this block is essentially the same as in the svm.scala implementation, but a little bit high-level
      if (params.nClasses > 2) {
        rawVotes = decision
        for (x <- 0 until params.nClasses) {
          if (decision(x) > 0)  classVotes(x) = 1
          else                  classVotes(x) = 0
        }
      } else {
        if (decision(0) > 0) {
          classVotes = mutable.ArrayBuffer(0, 1)
          rawVotes = mutable.ArrayBuffer(0, decision(0))
        } else {
          classVotes = mutable.ArrayBuffer(1,0)
          rawVotes = mutable.ArrayBuffer(-1*decision(0), 0)
        }
      }

    // #############################################################
    // for one vs one classifier implementation
    } else if (params.classifierType == 1) {

      val combinations = mutable.ArrayBuffer[mutable.ArrayBuffer[Int]]()
      // just like the one in svm.scala, the generation of all pairwise combinations of classes
      for (x <- 0 until params.nClasses) {
        for (y <- x + 1 until params.nClasses) {
          combinations += mutable.ArrayBuffer(x, y)
        }
      }

      for (x <- alphaVector.indices) {
        // similar structure with svm.scala, although a little high level (thus shorter)
        // can possibly be optimized?
        if (decision(x) > 0) {
          if (params.nClasses > 2) {
            classVotes(combinations(x)(0)) = classVotes(combinations(x)(0)) + 1
            rawVotes(combinations(x)(0)) = rawVotes(combinations(x)(0)) + decision(x)
          } else {
            classVotes(combinations(x)(1)) = classVotes(combinations(x)(1)) + 1
            rawVotes(combinations(x)(1)) = rawVotes(combinations(x)(1)) + decision(x)
          }
        } else {
          if (params.nClasses > 2) {
            classVotes(combinations(x)(1)) = classVotes(combinations(x)(1)) + 1
            rawVotes(combinations(x)(1)) = rawVotes(combinations(x)(1)) + -1 * decision(x)
          } else {
            classVotes(combinations(x)(0)) = classVotes(combinations(x)(0)) + 1
            rawVotes(combinations(x)(0)) = rawVotes(combinations(x)(0)) + -1 * decision(x)
          }
        }
      }

    // #############################################################
    // for error correcting output code classifier implementation
    } else {

      // again, same structure as the svm.scala implementation
      val decisionBits = mutable.ArrayBuffer.fill(alphaVector.length)(0)
      val codeBookBits = mutable.ArrayBuffer.fill(params.nClasses,alphaVector.length)(0)

      for (x <- alphaVector.indices) {
        if (decision(x) > 0) decisionBits(x) = 1
      }

      for (x <- 0 until params.nClasses) {
        for (y <- alphaVector.indices) {
          if (params.codeBook(x)(y) == 1) codeBookBits(x)(y) = 1
        }
      }

      // do the dot product in a nested loop, since I know how to do it
      for (x <- 0 until params.nClasses) {
        for (y <- alphaVector.indices) {  // number of classifiers, we'll compute for the distance
          rawVotes(x) = rawVotes(x) + -1*pow((decision(y) - params.codeBook(x)(y)).toDouble,2.toDouble).toInt
          classVotes(x) = classVotes(x) + abs(decisionBits(y) - codeBookBits(x)(y))
        }
        classVotes(x) = alphaVector.length - classVotes(x)
      }
    }

    if (flag == 1) { // bypass just to show that these are the correct answers for the toy data
      Seq(Seq(647, 297, 0, 347), Seq(2, 3, 0, 1))
    } else {
      Seq(rawVotes, classVotes) // interesting that this is OK, component vectors have diff length
    }

  }
}

class SVMTester[T <: Data](c: SVM[T], params: SVMParams[SInt], flag: Int) extends DspTester(c) {
  val SVM = new GoldenIntSVM(params)

  // initialize test vectors/arrays with random ints
  var input = Seq.fill(params.nFeatures)(scala.util.Random.nextInt(16) - 8)

  var supportVector = Seq.fill(params.nSupports, params.nFeatures)(scala.util.Random.nextInt(10) - 5)
  var alphaVector = Seq.fill(c.io.nClassifiers, params.nSupports)(scala.util.Random.nextInt(4) - 2)
  var intercept = Seq.fill(c.io.nClassifiers)(scala.util.Random.nextInt(10) - 5)

  // these are predefined inputs that can be used when testing in C code
  if (flag == 1) {
    input = Seq(0, 1, 2)
    supportVector = Seq(Seq(1, 2, 3), Seq(4, 5, 6))
    alphaVector = Seq(Seq(1, -1), Seq(1, 1), Seq(0, 1), Seq(1, 0), Seq(0,0), Seq(-1, -1))
    intercept = Seq(1, 2, 3, 4, 5, 6)

    // expected outputs:
    // rawVotes = Seq(647, 297, 0, 347)
    // classVotes = Seq(2, 3, 0, 1)
  }

  val goldenModelResult = SVM.poke(input, supportVector, alphaVector, intercept, flag)

  print("kernelType: " + params.kernelType + "\n")
  print("nDegree: " + params.nDegree + "\n")
  print("nClasses: " + params.nClasses + "\n")
  print("nSupports: " + params.nSupports + "\n")
  print("nFeatures: " + params.nFeatures + "\n")
  print("Classifiers: " + params.codeBook.head.length + "\n")

  // pokes for all the vectors and arrays
  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }

  for (i <- 0 until params.nSupports) {
    supportVector(i).zip(c.io.supportVector(i)).foreach { case (sig, port) => poke(port, sig) }
  }

  for (i <- 0 until c.io.nClassifiers) {
    alphaVector(i).zip(c.io.alphaVector(i)).foreach { case (sig, port) => poke(port, sig) }
  }

  intercept.zip(c.io.intercept).foreach { case(sig, port) => poke(port, sig) }

  // start!
  poke(c.io.in.valid, value = 1)
  step(1) // not really needed for now since everything is combinational

  // check for computational accuracy
  for (i <- 0 until params.nClasses) {
    expect(c.io.rawVotes(i), goldenModelResult(0)(i))
  }

  for (i <- 0 until params.nClasses) {
    expect(c.io.classVotes(i), goldenModelResult(1)(i))
  }
}

object SVMTester {
  def apply(params: SVMParams[SInt], flag: Int): Boolean = {
    chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new SVM(params)) {
      c => new SVMTester(c, params, flag)
    }
  }
}

