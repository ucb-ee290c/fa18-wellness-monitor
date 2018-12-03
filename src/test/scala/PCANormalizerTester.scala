package pca

import wellness._
import chisel3._
import dsptools.numbers._
import dsptools.DspTester

import scala.collection._
import chisel3.core.FixedPoint
import chisel3.util.log2Ceil

class GoldenIntPCANormalizer(nDimensions: Int) {
  def poke(input: Seq[Double], PCANormalizationData: Seq[Seq[Double]]): Seq[Double] = {
    val answer = input.zip(PCANormalizationData).map{ case(a, b) => (a-b(0))*b(1) }
    answer
  }
}

class PCANormalizerTester[T <: Data](c: PCANormalizer[T], nDimensions: Int, dataBP: Int) extends DspTester(c) {
  val PCANormalizer = new GoldenIntPCANormalizer(nDimensions)

  val input : Seq[Double] = if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
    Seq.fill(nDimensions)(scala.util.Random.nextInt(16).toDouble - 8)
  } else {
    Seq.fill(nDimensions)(scala.util.Random.nextDouble*16 - 8)
  }

  val PCANormalizationData : Seq[Seq[Double]] = if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
    Seq.fill(nDimensions, 2)(scala.util.Random.nextInt(16).toDouble - 8)
  } else {
    Seq.fill(nDimensions, 2)(scala.util.Random.nextDouble*16 - 8)
  }

  val goldenModelResult = PCANormalizer.poke(input, PCANormalizationData)

  // pokes for all the vectors and arrays
  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }

  for (i <- 0 until nDimensions) {
    PCANormalizationData(i).zip(c.io.PCANormalizationData(i)).foreach { case (sig, port) => poke(port, sig) }
  }

  poke(c.io.in.valid, value = 1)
  step(1)

  for (i <- 0 until nDimensions) {
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

object IntPCANormalizerTester {
  def apply(params: PCAParams[SInt], debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new PCANormalizer(params)) {
        c => new PCANormalizerTester(c, params.nDimensions, 0)
      }
    } else {
      dsptools.Driver.execute(() => new PCANormalizer(params), TestSetup.dspTesterOptions) {
        c => new PCANormalizerTester(c, params.nDimensions, 0)
      }
    }
  }
}

object FixedPointPCANormalizerTester {
  def apply(params: PCAParams[FixedPoint], dataBP: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new PCANormalizer(params)) {
        c => new PCANormalizerTester(c, params.nDimensions, dataBP)
      }
    } else {
      dsptools.Driver.execute(() => new PCANormalizer(params), TestSetup.dspTesterOptions) {
        c => new PCANormalizerTester(c, params.nDimensions, dataBP)
      }
    }
  }
}

