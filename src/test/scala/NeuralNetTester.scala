package neuralNet

import wellness._
import chisel3._
import dsptools.numbers._
import dsptools.DspTester
import chisel3.core.FixedPoint

import scala.collection._
import scala.math.max
import chisel3.util.log2Ceil

class GoldenNeuralNet(nFeatures: Int, nNeurons: Int) {
  def poke(input: Seq[Double], weight0: Seq[Seq[Double]], weight1: Seq[Double],
           bias0: Seq[Double], bias1: Double): Double = {

    val hiddenLayer = mutable.ArrayBuffer.fill(nNeurons)(0D)
    for (i <- 0 until nNeurons) {
      hiddenLayer(i) = input.zip(weight0(i)).map{ case (a,b) => a * b}.reduce(_ + _)
    }
    for (i <- 0 until nNeurons) {
      hiddenLayer(i) = if (hiddenLayer(i) + bias0(i) > 0) hiddenLayer(i) + bias0(i) else 0
    }

    val linearOut = hiddenLayer.zip(weight1).map{ case (a,b) => a * b}.reduce(_ + _)
    val nonlinearOut = if (linearOut + bias1 > 0) linearOut + bias1 else 0

    nonlinearOut
  }
}

class NeuralNetTester[T <: Data](c: NeuralNet[T], nFeatures: Int, nNeurons: Int, dataBP: Int) extends DspTester(c) {
  val NN = new GoldenNeuralNet(nFeatures, nNeurons)

  val rangeMin = -10
  val rangeMax = 10

  var input = Seq.fill(nFeatures)(scala.util.Random.nextDouble() * (rangeMax - rangeMin) + rangeMin)
  var weight0 = Seq.fill(nNeurons, nFeatures)(scala.util.Random.nextDouble() * (rangeMax - rangeMin) + rangeMin)
  var weight1 = Seq.fill(nNeurons)(scala.util.Random.nextDouble() * (rangeMax - rangeMin) + rangeMin)
  var bias0 = Seq.fill(nNeurons)(scala.util.Random.nextDouble() * (rangeMax - rangeMin) + rangeMin)
  var bias1 = scala.util.Random.nextDouble() * (rangeMax - rangeMin) + rangeMin

  val goldenModelResult = NN.poke(input, weight0, weight1, bias0, bias1)

  // pokes for all the vectors and arrays
  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }
  for (i <- 0 until nNeurons) {
    weight0(i).zip(c.io.weightMatrix(i)).foreach { case (sig, port) => poke(port, sig) }
    weight1.zip(c.io.weightVec).foreach { case (sig, port) => poke(port, sig) }
    bias0.zip(c.io.biasVec).foreach { case (sig, port) => poke(port, sig) }
  }
  poke(c.io.biasScalar, bias1)
  poke(c.io.in.valid, value = 1)
  step(1)

  val tolerance = 0.1
  // at least the integer part must match
  fixTolLSBs.withValue(log2Ceil((goldenModelResult.abs*tolerance).toInt+1)+dataBP+1) {
    expect(c.io.rawVotes, goldenModelResult)
  }

}

object FixedPointNeuralNetTester {
  def apply(params: NeuralNetParams[FixedPoint], dataBP: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new NeuralNet(params)) {
        c => new NeuralNetTester(c, params.nFeatures, params.nNeurons, dataBP)
      }
    } else {
      dsptools.Driver.execute(() => new NeuralNet(params), TestSetup.dspTesterOptions) {
        c => new NeuralNetTester(c, params.nFeatures, params.nNeurons, dataBP)
      }
    }
  }
}