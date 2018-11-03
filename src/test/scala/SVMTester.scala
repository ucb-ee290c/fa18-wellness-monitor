package svm

import chisel3._
import dsptools.numbers._
import dsptools.DspTester
import scala.collection._
import scala.math.pow

class GoldenIntSVM(params: SVMParams[SInt]) {
  def poke(input: Seq[Int], supportVector: Seq[Seq[Int]], alphaVector: Seq[Seq[Int]], intercept: Seq[Int]): Seq[Seq[Int]] = {

    val probeCheck = mutable.ArrayBuffer.fill(alphaVector.length)(0)

    val combinations = mutable.ArrayBuffer[mutable.ArrayBuffer[Int]]()
    val classVotes = mutable.ArrayBuffer.fill(params.nClasses)(0)

    // just like the one in svm.scala, the generation of all pairwise combinations of classes
    for (x <- 0 until params.nClasses) {
      for (y <- x + 1 until params.nClasses) {
        combinations += mutable.ArrayBuffer(x, y)
      }
    }
    var dotTemp = mutable.ArrayBuffer.fill(params.nSupports)(0)
    // perform dot product, manually (that's why it's a nested for loop)
    // if you understand the required operations for the dot product, this loop shouldn't be that hard to understand

    for (x <- alphaVector.indices) { // number of classifiers
      for (y <- supportVector.indices) { // number of support vectors
        for (z <- supportVector(0).indices) { // number of features
          // kernel computation depends on the type: polynomial or rbf
          if(params.kernelType == 0) { // for polynomial kernel, get the dot product first
            dotTemp(y) = dotTemp(y) + input(z)*supportVector(y)(z)
          } else { // for rbf kernel, solve for the exponent value first
            probeCheck(x) = probeCheck(x) + alphaVector(x)(y) * (input(z) - supportVector(y)(z))*(input(z) - supportVector(y)(z))
          }
        }
        if (params.kernelType == 0) { // multiply the dot product by itself (only used by polynomial kernel)
          probeCheck(x) = probeCheck(x) + alphaVector(x)(y)*pow(dotTemp(y).toDouble,params.nDegree.toDouble).toInt
        } else {
          // TODO: this is probably where you will put the exponential for the RBF kernel
        }
      }
      dotTemp = mutable.ArrayBuffer.fill(params.nSupports)(0) // reset accumulator (only used for polynomial kernel)
      probeCheck(x) = probeCheck(x) + intercept(x) // final addition of the intercept per classifier

      // similar structure with svm.scala, can possibly be optimized?
      if (probeCheck(x) > 0) {
        if(params.nClasses > 2) {
          classVotes(combinations(x)(0)) = classVotes(combinations(x)(0)) + 1
        } else {
          classVotes(combinations(x)(1)) = classVotes(combinations(x)(1)) + 1
        }
      } else {
        if(params.nClasses > 2) {
          classVotes(combinations(x)(1)) = classVotes(combinations(x)(1)) + 1
        } else {
          classVotes(combinations(x)(0)) = classVotes(combinations(x)(0)) + 1
        }
      }
    }

    Seq(probeCheck, classVotes) // interesting that this is OK, component vectors have diff length
  }
}

class SVMTester[T <: Data](c: SVM[T], params: SVMParams[SInt]) extends DspTester(c) {
  val SVM = new GoldenIntSVM(params)
  val input = Seq.fill(params.nFeatures)(scala.util.Random.nextInt(16)-8)

  val nClassifiers = (params.nClasses*(params.nClasses - 1))/2
  val supportVector = Seq.fill(params.nSupports,params.nFeatures)(scala.util.Random.nextInt(10)-5)
  val alphaVector = Seq.fill(nClassifiers,params.nSupports)(scala.util.Random.nextInt(4)-2)
  val intercept = Seq.fill(nClassifiers)(scala.util.Random.nextInt(10)-5)

  val goldenModelResult = SVM.poke(input, supportVector, alphaVector, intercept)

  print(params.kernelType, params.nDegree)

  // pokes for all the vectors and arrays
  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }

  for (i <- 0 until params.nSupports) {
    supportVector(i).zip(c.io.supportVector(i)).foreach { case (sig, port) => poke(port, sig) }
  }

  for (i <- 0 until nClassifiers) {
    alphaVector(i).zip(c.io.alphaVector(i)).foreach { case (sig, port) => poke(port, sig) }
  }

  intercept.zip(c.io.intercept).foreach { case(sig, port) => poke(port, sig) }

  // start!
  poke(c.io.in.valid, value = 1)
  step(1) // not really needed for now since everything is combinational

  // check for computational accuracy
  for (i <- 0 until nClassifiers) {
    expect(c.io.rawVotes(i), goldenModelResult(0)(i))
  }

  for (i <- 0 until params.nClasses) {
    expect(c.io.rawSums(i), goldenModelResult(1)(i))
  }
}

object SVMTester {
  def apply(params: SVMParams[SInt]): Boolean = {
    chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new SVM(params)) {
      c => new SVMTester(c, params)
    }
  }
}

