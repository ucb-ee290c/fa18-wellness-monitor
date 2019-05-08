package logistic

import chisel3._
import org.scalatest.{FlatSpec, Matchers}
import chisel3.core.FixedPoint

class LogisticSpec extends FlatSpec with Matchers {
  behavior of "Logistic"

  it should "work with random Ints (offline learning only)" in {
    val debug = 0
    val onlineIterations = 10

    for (i <- 0 until 15) {
      val params = new LogisticParams[SInt] {
        val protoData = SInt(32.W)
        val nFeatures = scala.util.Random.nextInt(10) + 5            // the number of reduced dimensions, coming from PCA if ever
        val nThresholds = scala.util.Random.nextInt(10) + 5          // the number of threshold points for logit estimation

        val onlineLearn = 0          // online learning activation switch
        val nWindow = 5              // the training window for ictal segments
        val nInterCount = 60         // the training window for interictal segments

        val ictalIndex = nThresholds       // the index wrt threshold, for the online learning scheme
        val interIndex = 1       // same as above, but for interictal training

        val learningRate = 0.01
      }
      IntLogisticTester(params, 0, onlineIterations, debug) should be(true)
    }
  }

  it should "work with random Floats (offline learning only)" in {
    val debug = 0
    val onlineIterations = 10

    val dataWidth = 32
    val dataBP = 8

    for (i <- 0 until 15) {
      val params = new LogisticParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W,dataBP.BP)
        val nFeatures = scala.util.Random.nextInt(10) + 5            // the number of reduced dimensions, coming from PCA if ever
        val nThresholds = scala.util.Random.nextInt(10) + 5          // the number of threshold points for logit estimation

        val onlineLearn = 0          // online learning activation switch
        val nWindow = 5              // the training window for ictal segments
        val nInterCount = 60         // the training window for interictal segments

        val ictalIndex = nThresholds       // the index wrt threshold, for the online learning scheme
        val interIndex = 1       // same as above, but for interictal training

        val learningRate = 0.01
      }
      FixedPointLogisticTester(params, dataBP, 0, onlineIterations, debug) should be(true)
    }
  }

  it should "work with random Ints (online learning)" in {
    val debug = 0
    val onlineIterations = 20

    for (i <- 0 until 15) {
      val params = new LogisticParams[SInt] {
        val protoData = SInt(32.W)
        val nFeatures = scala.util.Random.nextInt(10) + 5            // the number of reduced dimensions, coming from PCA if ever
        val nThresholds = scala.util.Random.nextInt(10) + 5          // the number of threshold points for logit estimation

        val onlineLearn = 0          // online learning activation switch
        val nWindow = 5              // the training window for ictal segments
        val nInterCount = 60         // the training window for interictal segments

        val ictalIndex = nThresholds       // the index wrt threshold, for the online learning scheme
        val interIndex = 1       // same as above, but for interictal training

        val learningRate = 0.01
      }
      IntLogisticTester(params, 0, onlineIterations, debug) should be(true)
    }
  }

  it should "work with random Floats (online learning)" in {
    val debug = 0
    val onlineIterations = 20

    val dataWidth = 32
    val dataBP = 8

    for (i <- 0 until 15) {
      val params = new LogisticParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W,dataBP.BP)
        val nFeatures = scala.util.Random.nextInt(10) + 5            // the number of reduced dimensions, coming from PCA if ever
        val nThresholds = scala.util.Random.nextInt(10) + 5          // the number of threshold points for logit estimation

        val onlineLearn = 0          // online learning activation switch
        val nWindow = 5              // the training window for ictal segments
        val nInterCount = 60         // the training window for interictal segments

        val ictalIndex = nThresholds       // the index wrt threshold, for the online learning scheme
        val interIndex = 1       // same as above, but for interictal training

        val learningRate = 0.01
      }
      FixedPointLogisticTester(params, dataBP, 0, onlineIterations, debug) should be(true)
    }
  }
}