
package randomforest

import chisel3._
import org.scalatest.{FlatSpec, Matchers}
import chisel3.core.FixedPoint

class RandomForestSpec extends FlatSpec with Matchers {
  behavior of "RandomForest"

  it should "work with random Ints" in {
    val debug = 0

    for (i <- 0 until 10) {
      val params = new RandomForestParams[SInt] {
        val protoData = SInt(32.W)
        val nFeatures = scala.util.Random.nextInt(10) + 5
        val nDepth = scala.util.Random.nextInt(4) + 1
        val nTrees = scala.util.Random.nextInt(50) + 2

        val featureSelect = Seq.fill(nTrees, (1 << nDepth) - 1)(scala.util.Random.nextInt(nFeatures))
        // this selects which feature (indexed by array) is being checked for the threshold declared earlier
      }
      IntRandomForestTester(params, debug) should be(true)
    }
  }

  /*
  // Due to thresholding and bit precision limitations, it's a little tricky to exactly check the value of final votes
  // But this works, most of the time
  it should "work with random Floats" in {
    val debug = 0

    val dataWidth = 32
    val dataBP = 8

    for (i <- 0 until 10) {
      val params = new RandomForestParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W,dataBP.BP)
        val nFeatures = scala.util.Random.nextInt(10) + 5
        val nDepth = scala.util.Random.nextInt(4) + 1
        val nTrees = scala.util.Random.nextInt(50) + 2

        val featureSelect = Seq.fill(nTrees, (1 << nDepth) - 1)(scala.util.Random.nextInt(nFeatures))
      }
      FixedPointRandomForestTester(params, dataBP, debug) should be(true)
    }
  }
  */

}
