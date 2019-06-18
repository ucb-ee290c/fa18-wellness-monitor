package neuralNet

import chisel3._
import org.scalatest.{FlatSpec, Matchers}
import chisel3.core.FixedPoint

class NeuralNetSpec extends FlatSpec with Matchers {
  behavior of "NeuralNet"

  it should "work with random Floats, more than one hidden layer" in {
    val debug = 0

    val dataWidth = 32
    val dataBP = 8

    for (i <- 0 until 10) {
      val params = new NeuralNetParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W,dataBP.BP)
        val nFeatures = scala.util.Random.nextInt(5) + 1
        val nNeurons = scala.util.Random.nextInt(20) + 1
        val nLayers = scala.util.Random.nextInt(5) + 2
      }
      FixedPointNeuralNetTester(params, dataBP, debug) should be(true)
    }
  }

  it should "work with random Floats, one hidden layer" in {
    val debug = 0

    val dataWidth = 32
    val dataBP = 8

    for (i <- 0 until 10) {
      val params = new NeuralNetParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W,dataBP.BP)
        val nFeatures = scala.util.Random.nextInt(5) + 1
        val nNeurons = scala.util.Random.nextInt(20) + 1
        val nLayers = 1
      }
      FixedPointNeuralNetTester(params, dataBP, debug) should be(true)
    }
  }

}
