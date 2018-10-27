package svm

import chisel3._
import org.scalatest.{FlatSpec, Matchers}

class SVMSpec extends FlatSpec with Matchers {
  behavior of "SVM"

  it should "UInt orange" in {

    for (i <- 0 until 15) {
      val params = new SVMParams[UInt] {
        val protoData = UInt(32.W)
        val nSupports = scala.util.Random.nextInt(10) + 1
        val nFeatures = scala.util.Random.nextInt(10) + 1

      }
      SVMTester(params) should be(true)
    }
  }
}