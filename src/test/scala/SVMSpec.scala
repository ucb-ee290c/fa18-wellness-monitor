package svm

import chisel3._
import org.scalatest.{FlatSpec, Matchers}

class SVMSpec extends FlatSpec with Matchers {
  behavior of "SVM"

  it should "work with random Ints as parameters" in {

    for (i <- 0 until 15) {
      val params = new SVMParams[SInt] {
        val protoData = SInt(32.W)
        val nSupports = scala.util.Random.nextInt(10) + 1 // minimum 1 support vector
        val nFeatures = scala.util.Random.nextInt(10) + 1 // minimum 1 feature
        val nClasses = scala.util.Random.nextInt(4) + 2   // minimum 2 classes
        val nDegree = scala.util.Random.nextInt(3) + 1    // minimum degree 1 (linear kernel)
        val kernelType = scala.util.Random.nextInt(2)     // 0 (polynomial) or 1 (rbf)
      }
      SVMTester(params, 0) should be(true)
    }
  }

  it should "work for predefined test for C code reference" in {

    val params = new SVMParams[SInt] {
      val protoData = SInt(32.W)
      val nSupports = 2
      val nFeatures = 3
      val nClasses = 4
      val nDegree = 2
      val kernelType = 0
    }
    SVMTester(params, 1) should be(true)
  }
}