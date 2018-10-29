package pca

import chisel3._
import org.scalatest.{FlatSpec, Matchers}

class PCASpec extends FlatSpec with Matchers {
  behavior of "PCA"

  it should "UInt apple" in {

    for (i <- 0 until 15) {
      val params = new PCAParams[UInt] {
        val protoData = UInt(32.W)
        val nDimensions = scala.util.Random.nextInt(10) + 1
        val nFeatures = scala.util.Random.nextInt(10) + 1

      }
      PCATester(params) should be(true)
    }
  }
}