package pca

import chisel3._
import org.scalatest.{FlatSpec, Matchers}
import chisel3.core.FixedPoint

class PCASpec extends FlatSpec with Matchers {
  behavior of "PCA"

  it should "work with random Ints" in {
    val debug = 0

    for (i <- 0 until 15) {
      val params = new PCAParams[SInt] {
        val protoData = SInt(32.W)
        val nDimensions = scala.util.Random.nextInt(10) + 5 // input dimension, must be greater than nFeatures
        val nFeatures = scala.util.Random.nextInt(5) + 1   // output dimension to SVM, minimum 1
      }
      IntPCATester(params, debug) should be(true)
    }
  }

  it should "work with random Floats" in {
    val debug = 1

    for (i <- 0 until 15) {
      val params = new PCAParams[FixedPoint] {
        val protoData = FixedPoint(64.W,16.BP)
        val nDimensions = scala.util.Random.nextInt(10) + 5 // input dimension, must be greater than nFeatures
        val nFeatures = scala.util.Random.nextInt(5) + 1   // output dimension to SVM, minimum 1
      }
      FixedPointPCATester(params, debug) should be(true)
    }
  }
}