package pca

import chisel3._
import chisel3.core.FixedPoint
import org.scalatest.{FlatSpec, Matchers}

class PCANormalizerSpec extends FlatSpec with Matchers {
  behavior of "PCA"

  it should "work with random Ints" in {
    val debug = 0

    for (i <- 0 until 15) {
      val params = new PCAParams[SInt] {
        val protoData = SInt(32.W)
        val nDimensions = scala.util.Random.nextInt(10) + 5 // input dimension, must be greater than nFeatures
        val nFeatures = scala.util.Random.nextInt(5) + 1   // output dimension to SVM, minimum 1
      }
      IntPCANormalizerTester(params, debug) should be(true)
    }
  }

  it should "work with random Floats" in {
    val debug = 0

    val dataWidth = 32
    val dataBP = 8

    for (i <- 0 until 15) {
      val params = new PCAParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W,dataBP.BP)
        val nDimensions = scala.util.Random.nextInt(10) + 5 // input dimension, must be greater than nFeatures
        val nFeatures = scala.util.Random.nextInt(5) + 1   // output dimension to SVM, minimum 1
      }
      FixedPointPCANormalizerTester(params, dataBP, debug) should be(true)
    }
  }
}