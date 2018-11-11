package svm

import chisel3._
import scala.collection._
import chisel3.core.FixedPoint
import org.scalatest.{FlatSpec, Matchers}

class SVMSpec extends FlatSpec with Matchers {
  behavior of "SVM"

  it should "work with random Ints" in {

    for (i <- 0 until 10) {
      val classifierTypenum = scala.util.Random.nextInt(3)
      val kernelTypenum = scala.util.Random.nextInt(2)

      val params = new SVMParams[SInt] {
        val protoData = SInt(64.W)
        val nSupports = scala.util.Random.nextInt(10) + 2 // minimum 1 support vector
        val nFeatures = scala.util.Random.nextInt(10) + 1 // minimum 1 feature
        val nClasses = scala.util.Random.nextInt(2) + 2   // minimum 2 classes
        val nDegree = scala.util.Random.nextInt(3) + 1    // minimum degree 1 (linear kernel)
        val kernelType = if(kernelTypenum == 0) "poly" else "rbf"
        val classifierType = if(classifierTypenum == 0) "ovr" else if (classifierTypenum == 1) "ovo" else "ecoc"
        val codeBook = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // -1 and 1
      }

      IntSVMTester(params, 0) should be(true)
    }
  }

  it should "work with random Floats" in {

    for (i <- 0 until 10) {
      val classifierTypenum = scala.util.Random.nextInt(3)
      val kernelTypenum = scala.util.Random.nextInt(2)

      val params = new SVMParams[FixedPoint] {
        val protoData = FixedPoint(64.W,16.BP)
        val nSupports = scala.util.Random.nextInt(3) + 2 // minimum 1 support vector
        val nFeatures = scala.util.Random.nextInt(3) + 1 // minimum 1 feature
        val nClasses = scala.util.Random.nextInt(2) + 2   // minimum 2 classes
        val nDegree = scala.util.Random.nextInt(2) + 1    // minimum degree 1 (linear kernel)
        val kernelType = if(kernelTypenum == 0) "poly" else "rbf"
        val classifierType = if(classifierTypenum == 0) "ovr" else if (classifierTypenum == 1) "ovo" else "ecoc"
        val codeBook = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // -1 and 1
      }
      FixedPointSVMTester(params, 0) should be(true)
    }
  }

  it should "work for predefined Float test" in {

    val params = new SVMParams[FixedPoint] {
      val protoData = FixedPoint(64.W,16.BP)
      val nSupports = 2
      val nFeatures = 3
      val nClasses = 4
      val nDegree = 2
      val kernelType = "poly"
      val classifierType = "ovo"
      val codeBook = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
    }
    FixedPointSVMTester(params, 1) should be(true)
  }

  it should "work for predefined Int test" in {

    val params = new SVMParams[SInt] {
      val protoData = SInt(32.W)
      val nSupports = 2
      val nFeatures = 3
      val nClasses = 4
      val nDegree = 2
      val kernelType = "poly"
      val classifierType = "ovo"
      val codeBook = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
    }
    IntSVMTester(params, 1) should be(true)
  }
}