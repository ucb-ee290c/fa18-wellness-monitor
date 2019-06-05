package neuralNet

import chisel3._
import org.scalatest.{FlatSpec, Matchers}
import chisel3.core.FixedPoint

class NeuralNetSpec extends FlatSpec with Matchers {
  behavior of "NeuralNet"

  it should "work with random Floats" in {
    val debug = 1

    val dataWidth = 32
    val dataBP = 8

    for (i <- 0 until 15) {
      val params = new NeuralNetParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W,dataBP.BP)
        val nFeatures = scala.util.Random.nextInt(5) + 1
        val nNeurons = scala.util.Random.nextInt(20) + 1
      }
      FixedPointNeuralNetTester(params, dataBP, debug) should be(true)
    }
  }

}
