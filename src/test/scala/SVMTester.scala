package svm

import chisel3._
import dsptools.numbers._
import dsptools.DspTester
import scala.collection._

class GoldenIntSVM(params: SVMParams[SInt]) {
  def poke(input: Seq[Int], supportVector: Seq[Seq[Int]], alphaVector: Seq[Seq[Int]], intercept: Seq[Int]): Seq[Seq[Int]] = {

    val probeCheck = mutable.ArrayBuffer.fill(alphaVector.length)(0)

    val combinations = mutable.ArrayBuffer[mutable.ArrayBuffer[Int]]()
    val classVotes = mutable.ArrayBuffer.fill(params.nClasses)(0)

    for (x <- 0 until params.nClasses) {
      for (y <- x + 1 until params.nClasses) {
        combinations += mutable.ArrayBuffer(x, y)
      }
    }

    for (x <- alphaVector.indices) { // classifiers
      for (y <- supportVector.indices) {
        // number of support vectors

        for (z <- supportVector(0).indices) { // number of features
          probeCheck(x) = probeCheck(x) + alphaVector(x)(y) * input(z) * supportVector(y)(z)
        }
      }
      probeCheck(x) = probeCheck(x) + intercept(x)

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
  val input = Seq.fill(params.nFeatures)(scala.util.Random.nextInt())

  val nClassifiers = (params.nClasses*(params.nClasses - 1))/2
  val supportVector = Seq.fill(params.nSupports,params.nFeatures)(scala.util.Random.nextInt())
  val alphaVector = Seq.fill(nClassifiers,params.nSupports)(scala.util.Random.nextInt())
  val intercept = Seq.fill(nClassifiers)(scala.util.Random.nextInt())

  val goldenModelResult = SVM.poke(input, supportVector, alphaVector, intercept)

  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }

  for (i <- 0 until params.nSupports) {
    supportVector(i).zip(c.io.supportVector(i)).foreach { case (sig, port) => poke(port, sig) }
  }

  for (i <- 0 until nClassifiers) {
    alphaVector(i).zip(c.io.alphaVector(i)).foreach { case (sig, port) => poke(port, sig) }
  }

  intercept.zip(c.io.intercept).foreach { case(sig, port) => poke(port, sig) }


  poke(c.io.in.valid, value = 1)
  step(1)

  for (i <- 0 until nClassifiers) {
    expect(c.io.rawVotes(i), goldenModelResult(0)(i), msg = s"Golden: $goldenModelResult, ${peek(c.io.rawVotes(i))}")
  }

  for (i <- 0 until params.nClasses) {
    expect(c.io.rawSums(i), goldenModelResult(1)(i), msg = s"Golden: $goldenModelResult, ${peek(c.io.rawSums(i))}")
  }
}

object SVMTester {
  def apply(params: SVMParams[SInt]): Boolean = {
    chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new SVM(params)) {
      c => new SVMTester(c, params)
    }
  }
}

