package svm

import chisel3._
import dsptools.numbers._
import dsptools.DspTester

class GoldenIntSVM(params: SVMParams[SInt]) {
  def poke(input: Seq[Int], supportVector: Seq[Seq[Int]], alphaVector: Seq[Int], intercept: Int): Seq[Int] = {
    var answer = 0

    for (x <- alphaVector.indices) { // number of support vectors
      for (y <- input.indices) { // number of features
        answer = answer + alphaVector(x) * input(y) * supportVector(x)(y)
      }
    }
    val decision = answer + intercept

    if (decision > 0) {
      answer = 1
    } else {
      answer = 0
    }

    Seq(decision, answer)
  }
}

class SVMTester[T <: Data](c: SVM[T], params: SVMParams[SInt]) extends DspTester(c) {
  val SVM = new GoldenIntSVM(params)
  val input = Seq.fill(params.nFeatures)(scala.util.Random.nextInt())
  val supportVector = Seq.fill(params.nSupports,params.nFeatures)(scala.util.Random.nextInt())
  val alphaVector = Seq.fill(params.nSupports)(scala.util.Random.nextInt())
  val intercept = scala.util.Random.nextInt()
  val goldenModelResult = SVM.poke(input, supportVector, alphaVector, intercept)

  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }
  for (i <- 0 until params.nSupports) {
    supportVector(i).zip(c.io.supportVector(i)).foreach { case (sig, port) => poke(port, sig) }
  }
  alphaVector.zip(c.io.alphaVector).foreach { case(sig, port) => poke(port, sig) }
  poke(c.io.intercept, intercept)

  poke(c.io.in.valid, value = 1)
  step(1)
  expect(c.io.rawOut, goldenModelResult(0), msg = s"Input: $input, Golden: $goldenModelResult, ${peek(c.io.rawOut)}")
  expect(c.io.out.bits, goldenModelResult(1), msg = s"Input: $input, Golden: $goldenModelResult, ${peek(c.io.out.bits)}")
}

object SVMTester {
  def apply(params: SVMParams[SInt]): Boolean = {
    chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new SVM(params)) {
      c => new SVMTester(c, params)
    }
  }
}

