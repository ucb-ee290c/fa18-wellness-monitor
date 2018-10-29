package pca

import chisel3._
import dsptools.numbers._
import dsptools.DspTester
import scala.collection._

class GoldenIntPCA(params: PCAParams[UInt]) {
  def poke(input: Seq[Int], PCAVector: Seq[Seq[Int]]): Seq[Int] = {
    val answer = mutable.ArrayBuffer[Int]()
    var dotProduct = 0

    for (x <- PCAVector.indices) { // number of features
      dotProduct = 0
      for (y <- input.indices) {
        dotProduct = dotProduct + (input(y) * PCAVector(x)(y))
      }
      answer += dotProduct
    }
    answer
  }
}

class PCATester[T <: Data](c: PCA[T], params: PCAParams[UInt]) extends DspTester(c) {
  val PCA = new GoldenIntPCA(params)
  val input = Seq.fill(params.nDimensions)(scala.util.Random.nextInt(16))
  val PCAVector = Seq.fill(params.nFeatures,params.nDimensions)(scala.util.Random.nextInt(16))
  val goldenModelResult = PCA.poke(input, PCAVector)

  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }
  for (i <- 0 until params.nFeatures) {
    PCAVector(i).zip(c.io.PCAVector(i)).foreach { case (sig, port) => poke(port, sig) }
  }

  poke(c.io.in.valid, value = 1)
  step(1)

  for (i <- 0 until params.nFeatures) {
    expect(c.io.out.bits(i), goldenModelResult(i), msg = s"Input: $input, Golden: $goldenModelResult, ${peek(c.io.out.bits(i))}")
  }
}

object PCATester {
  def apply(params: PCAParams[UInt]): Boolean = {
    chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new PCA(params)) {
      c => new PCATester(c, params)
    }
  }
}

