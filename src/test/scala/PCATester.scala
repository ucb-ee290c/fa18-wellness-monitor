package pca

import wellness._
import chisel3._
import dsptools.numbers._
import dsptools.DspTester

import scala.collection._
import chisel3.core.FixedPoint
import chisel3.util.log2Ceil

class GoldenIntPCA(nDimensions: Int, nFeatures: Int) {
  def poke(input: Seq[Double], PCAVector: Seq[Seq[Double]]): Seq[Double] = {
    val answer = mutable.ArrayBuffer.fill(nFeatures)(0D)

    for (x <- 0 until nFeatures) {
      answer(x) = input.zip(PCAVector(x)).map{ case(a, b) => a * b }.sum
    }
    answer
  }
}

class PCATester[T <: Data](c: PCA[T], nDimensions: Int, nFeatures: Int, dataBP: Int) extends DspTester(c) {
  val PCA = new GoldenIntPCA(nDimensions,nFeatures)

  var input = Seq.fill(nDimensions)(0D)
  var PCAVector = Seq.fill(nFeatures, nDimensions)(0D)

  if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
    // initialize test vectors/arrays with random ints
    input = Seq.fill(nDimensions)(scala.util.Random.nextInt(16) - 8)
    PCAVector = Seq.fill(nFeatures, nDimensions)(scala.util.Random.nextInt(16) - 8)
  } else {
    // initialize test vectors/arrays with random floats
    input = Seq.fill(nDimensions)(scala.util.Random.nextDouble*16 - 8)
    PCAVector = Seq.fill(nFeatures, nDimensions)(scala.util.Random.nextDouble*16 - 8)
  }

  // the IDE is saying that _.toDouble is redundant, don't believe it!
  // these vectors are being dynamically assigned as either double or int, due to test case flexibility
  // the _.toDouble mapping is required for Ints, the IDE doesn't see it.
  val goldenModelResult = PCA.poke(input.map(_.toDouble), PCAVector.map(_.map(_.toDouble)))

  // pokes for all the vectors and arrays
  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }

  for (i <- 0 until nFeatures) {
    PCAVector(i).zip(c.io.PCAVector(i)).foreach { case (sig, port) => poke(port, sig) }
  }

  poke(c.io.in.valid, value = 1)
  step(1)

  for (i <- 0 until nFeatures) {
    if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
      expect(c.io.out.bits(i), goldenModelResult(i))
    } else {
      val tolerance = 0.1
      // due to the series of multiply and accumulates, error actually blows up, let's be lenient
      fixTolLSBs.withValue(log2Ceil((goldenModelResult(i).abs*tolerance).toInt+1)+dataBP+1) { // at least the integer part must match
        expect(c.io.out.bits(i), goldenModelResult(i))
      }
    }
  }
}

object IntPCATester {
  def apply(params: PCAParams[SInt], debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new PCA(params)) {
        c => new PCATester(c, params.nDimensions, params.nFeatures, 0)
      }
    } else {
      dsptools.Driver.execute(() => new PCA(params), TestSetup.dspTesterOptions) {
        c => new PCATester(c, params.nDimensions, params.nFeatures, 0)
      }
    }
  }
}

object FixedPointPCATester {
  def apply(params: PCAParams[FixedPoint], dataBP: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new PCA(params)) {
        c => new PCATester(c, params.nDimensions, params.nFeatures, dataBP)
      }
    } else {
      dsptools.Driver.execute(() => new PCA(params), TestSetup.dspTesterOptions) {
        c => new PCATester(c, params.nDimensions, params.nFeatures, dataBP)
      }
    }
  }
}

