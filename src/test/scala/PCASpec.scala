package pca

import chisel3._
import org.scalatest.{FlatSpec, Matchers}

class PCASpec extends FlatSpec with Matchers {
  behavior of "PCA"

  it should "UInt apple" in {

    for (i <- 0 until 15) {
      val params = new PCAParams[SInt] {
        val protoData = SInt(32.W)
        val nDimensions = scala.util.Random.nextInt(10) + 1 // input dimension, minimum 1
        val nFeatures = scala.util.Random.nextInt(10) + 1   // output dimension to SVM, minimum 1

      }
      PCATester(params) should be(true)
    }
  }
}