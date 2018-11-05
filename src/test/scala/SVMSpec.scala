package svm

import chisel3._
import scala.collection._
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
        //val classifierType = scala.util.Random.nextInt(3) // 0 = one vs rest, 1 = one vs one, 2 = error correcting
        val classifierType = 1  // testing, using one vs one
        val codeBook = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // -1 and 1
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
      val classifierType = 1
      val codeBook = Seq(Seq(1), Seq(2)) // ignored for this test case
    }
    SVMTester(params, 1) should be(true)
  }
}