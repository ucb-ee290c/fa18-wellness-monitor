package svm

import chisel3._
import org.scalatest.{FlatSpec, Matchers}

class SVMSpec extends FlatSpec with Matchers {
  behavior of "SVM"

  it should "UInt orange" in {

    for (i <- 0 until 15) {
      val params = new SVMParams[SInt] {
        val protoData = SInt(32.W)
        val nSupports = scala.util.Random.nextInt(10) + 1
        val nFeatures = scala.util.Random.nextInt(10) + 1
        val nClasses = scala.util.Random.nextInt(4) + 2
        val nDegree = scala.util.Random.nextInt(1) + 1

      }
      SVMTester(params) should be(true)
    }
  }
}