package svm

import wellness._
import chisel3._
import dsptools.numbers._
import dsptools.DspTester

import chisel3.core.FixedPoint
import scala.collection._
import scala.math._

class GoldenSVM(nSupports: Int, nFeatures: Int, nClasses: Int, nDegree: Int,
                   kernelType: String, classifierType: String, codeBook: Seq[Seq[Int]], flag: Int, dataType: String) {

  def poke(input: Seq[Double], supportVector: Seq[Seq[Double]], alphaVector: Seq[Seq[Double]],
           intercept: Seq[Double], flag: Int): Seq[Seq[Double]] = {

    // this is the decision function (raw output of each classifier), array of length #classifiers
    val decision = mutable.ArrayBuffer.fill(alphaVector.length)(0D)
    var dotTemp = mutable.ArrayBuffer.fill(nSupports)(0D) // used for the polynomial kernel

    // ################################################################################################################
    // KERNEL CALCULATION
    // ################################################################################################################

    // perform dot product, manually (that's why it's a nested for loop)
    // if you understand the required operations for the dot product, this loop shouldn't be that hard to understand
    for (x <- alphaVector.indices) { // number of classifiers
      for (y <- supportVector.indices) { // number of support vectors
        for (z <- supportVector(0).indices) { // number of features
          // kernel computation depends on the type: polynomial or rbf
          if (kernelType == "poly") { // for polynomial kernel, get the dot product first
            dotTemp(y) = dotTemp(y) + input(z) * supportVector(y)(z)
          } else { // for rbf kernel, solve for the exponent value first
            decision(x) = decision(x) + alphaVector(x)(y) *
              -1 * (input(z) - supportVector(y)(z)) * (input(z) - supportVector(y)(z))
          }
        }
        if (kernelType == "poly") { // multiply the dot product by itself (only used by polynomial kernel)
          decision(x) = decision(x) + alphaVector(x)(y) * pow(dotTemp(y).toDouble, nDegree.toDouble).toInt
        } else {
          // TODO: this is probably where you will put the exponential for the RBF kernel
        }
      }
      dotTemp = mutable.ArrayBuffer.fill(nSupports)(0D) // reset accumulator (only used for polynomial kernel)
      decision(x) = decision(x) + intercept(x) // final addition of the intercept per classifier
    }

    // ################################################################################################################
    // DECISION MAKING / VOTING CALCULATION
    // ################################################################################################################

    var classVotes = mutable.ArrayBuffer.fill(nClasses)(0D) // contains binarized votes per class
    var rawVotes = mutable.ArrayBuffer.fill(nClasses)(0D) // contains the raw votes per class

    // #############################################################
    // for one vs rest classifier implementation
    if (classifierType == "ovr") {

      // this block is essentially the same as in the svm.scala implementation, but a little bit high-level
      if (nClasses > 2) {
        rawVotes = decision
        for (x <- 0 until nClasses) {
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
    } else if (classifierType == "ovo") {

      val combinations = mutable.ArrayBuffer[mutable.ArrayBuffer[Int]]()
      // just like the one in svm.scala, the generation of all pairwise combinations of classes
      for (x <- 0 until nClasses) {
        for (y <- x + 1 until nClasses) {
          combinations += mutable.ArrayBuffer(x, y)
        }
      }

      for (x <- alphaVector.indices) {
        // similar structure with svm.scala, although a little high level (thus shorter)
        // can possibly be optimized?
        if (decision(x) > 0) {
          if (nClasses > 2) {
            classVotes(combinations(x)(0)) = classVotes(combinations(x)(0)) + 1
            rawVotes(combinations(x)(0)) = rawVotes(combinations(x)(0)) + decision(x)
          } else {
            classVotes(combinations(x)(1)) = classVotes(combinations(x)(1)) + 1
            rawVotes(combinations(x)(1)) = rawVotes(combinations(x)(1)) + decision(x)
          }
        } else {
          if (nClasses > 2) {
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
      val codeBookBits = mutable.ArrayBuffer.fill(nClasses,alphaVector.length)(0)

      for (x <- alphaVector.indices) {
        if (decision(x) > 0) decisionBits(x) = 1
      }

      for (x <- 0 until nClasses) {
        for (y <- alphaVector.indices) {
          if (codeBook(x)(y) == 1) codeBookBits(x)(y) = 1
        }
      }

      // do the dot product in a nested loop, since I know how to do it
      for (x <- 0 until nClasses) {
        for (y <- alphaVector.indices) {  // number of classifiers, we'll compute for the distance
          rawVotes(x) = rawVotes(x) + ((decision(y) - codeBook(x)(y))*(decision(y) - codeBook(x)(y)))
          classVotes(x) = classVotes(x) + abs(decisionBits(y) - codeBookBits(x)(y))
        }
        classVotes(x) = alphaVector.length - classVotes(x)
        rawVotes(x) = -1*rawVotes(x)
      }
    }

    if (flag == 1) {
      // bypass just to show that these are the correct answers for the toy data
      if(dataType == "chisel3.core.SInt") Seq(Seq(647, 297, 0, 347), Seq(2, 3, 0, 1))
      else Seq(Seq(499.3074, 487.4843, 0, 280.6336), Seq(2, 3, 0, 1))

    } else {
      Seq(rawVotes, classVotes) // interesting that this is OK, component vectors have diff length
    }
  }
}

class SVMTester[T <: Data](c: SVM[T], nSupports: Int, nFeatures: Int, nClasses: Int, nDegree: Int,
                            kernelType: String, classifierType: String, codeBook: Seq[Seq[Int]], flag: Int, debug: Int)
                            extends DspTester(c) {
  val dataType = c.params.protoData.getClass.getTypeName
  val SVM = new GoldenSVM(nSupports, nFeatures, nClasses, nDegree, kernelType, classifierType, codeBook, flag, dataType)

  // initialize test vectors/arrays
  var input = Seq.fill(nFeatures)(0D)
  var supportVector = Seq.fill(nSupports, nFeatures)(0D)
  var alphaVector = Seq.fill(c.io.nClassifiers, nSupports)(0D)
  var intercept = Seq.fill(c.io.nClassifiers)(0D)

  if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt"){
    if (flag == 1) {
      // these are predefined inputs that can be used when testing in C code
      input = Seq(0, 1, 2)
      supportVector = Seq(Seq(1, 2, 3), Seq(4, 5, 6))
      alphaVector = Seq(Seq(1, -1), Seq(1, 1), Seq(0, 1), Seq(1, 0), Seq(0,0), Seq(-1, -1))
      intercept = Seq(1, 2, 3, 4, 5, 6)

      // expected outputs:
      // rawVotes = Seq(647, 297, 0, 347)
      // classVotes = Seq(2, 3, 0, 1)

    } else {
      // initialize test vectors/arrays with for Ints
      input = Seq.fill(nFeatures)(scala.util.Random.nextInt(16) - 8)
      supportVector = Seq.fill(nSupports, nFeatures)(scala.util.Random.nextInt(10) - 5)
      alphaVector = Seq.fill(c.io.nClassifiers, nSupports)(scala.util.Random.nextInt(4) - 2)
      intercept = Seq.fill(c.io.nClassifiers)(scala.util.Random.nextInt(10) - 5)
    }
  } else {
    if (flag == 1) {
      // these are predefined inputs that can be used when testing in C code
      input = Seq(0.4, -1.3, 2.67)
      supportVector = Seq(Seq(1.1, 2.54, 3.3), Seq(4.33, 5.12, 6.78))
      alphaVector = Seq(Seq(1.3, -1.77), Seq(1.54, 1.4), Seq(0.3, 1.1), Seq(1.33, 0.2), Seq(0.2,0.79), Seq(-1.55, -1.3))
      intercept = Seq(1.1, 2.2, 3.3, 4.4, 5.5, 6.6)

      // expected outputs:
      // rawVotes = Seq(1, 297, 0, 347)
      // classVotes = Seq(2, 3, 0, 1)

    } else {
      // initialize test vectors/arrays with for FixedPoint
      input = Seq.fill(nFeatures)(scala.util.Random.nextDouble*4 - 2)
      supportVector = Seq.fill(nSupports, nFeatures)(scala.util.Random.nextDouble*4 - 2)
      alphaVector = Seq.fill(c.io.nClassifiers, nSupports)(scala.util.Random.nextDouble*4 - 2)
      intercept = Seq.fill(c.io.nClassifiers)(scala.util.Random.nextDouble*4 - 2)
    }
  }

  // the IDE is saying that _.toDouble is redundant, don't believe it!
  // these vectors are being dynamically assigned as either double or int, due to test case flexibility
  // the _.toDouble mapping is required for Ints, the IDE doesn't see it.
  val goldenModelResult = SVM.poke(input.map(_.toDouble), supportVector.map(_.map(_.toDouble)),
                                  alphaVector.map(_.map(_.toDouble)), intercept.map(_.toDouble), flag)

  if (debug == 1) {
    // print the configuration the tester is doing right now
    print("datatype: " + c.params.protoData.getClass.getTypeName + "\n")
    print("kernelType: " + kernelType + "\n")
    print("nDegree: " + nDegree + "\n")
    print("nClasses: " + nClasses + "\n")
    print("nSupports: " + nSupports + "\n")
    print("nFeatures: " + nFeatures + "\n")
    print("classifierType: " + classifierType + "\n")
    print("nClassifiers: " + c.io.nClassifiers + "\n")
  }

  // pokes for all the vectors and arrays
  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }

  for (i <- 0 until nSupports) {
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
  for (i <- 0 until nClasses) {
    if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
      expect(c.io.rawVotes(i), goldenModelResult(0)(i))
      expect(c.io.classVotes(i), goldenModelResult(1)(i))
    } else {
      // due to the series of multiply and accumulates, error actually blows up, let's be lenient
      fixTolLSBs.withValue(c.params.protoData.getWidth / 2) {
        expect(c.io.rawVotes(i), goldenModelResult(0)(i))
      }
      fixTolLSBs.withValue(2) { // allow +-2 error for votes due to error in raw score accuracy
        expect(c.io.classVotes(i), goldenModelResult(1)(i))
      }
    }
  }
}

object IntSVMTester {
  def apply(params: SVMParams[SInt], flag: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new SVM(params)) {
        c => new SVMTester(c, params.nSupports, params.nFeatures, params.nClasses,
          params.nDegree, params.kernelType, params.classifierType, params.codeBook, flag, debug)
      }
    } else {
      dsptools.Driver.execute(() => new SVM(params), TestSetup.dspTesterOptions) {
        c => new SVMTester(c, params.nSupports, params.nFeatures, params.nClasses,
          params.nDegree, params.kernelType, params.classifierType, params.codeBook, flag, debug)
      }
    }
  }
}

object FixedPointSVMTester {
  def apply(params: SVMParams[FixedPoint], flag: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new SVM(params)) {
        c => new SVMTester(c, params.nSupports, params.nFeatures, params.nClasses,
          params.nDegree, params.kernelType, params.classifierType, params.codeBook, flag, debug)
      }
    } else {
      dsptools.Driver.execute(() => new SVM(params), TestSetup.dspTesterOptions) {
        c => new SVMTester(c, params.nSupports, params.nFeatures, params.nClasses,
          params.nDegree, params.kernelType, params.classifierType, params.codeBook, flag, debug)
      }
    }
  }
}

