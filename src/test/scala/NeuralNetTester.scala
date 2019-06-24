package neuralNet

import wellness._
import chisel3._
import dsptools.numbers._
import dsptools.DspTester
import chisel3.core.FixedPoint

import scala.collection._
import scala.math.max
import chisel3.util.log2Ceil

class GoldenNeuralNet(nFeatures: Int, nNeurons: Int, nLayers: Int) {
  def poke(input: Seq[Double], inputWeights: Seq[Seq[Double]], midAndOutputWeights: Seq[Seq[Double]],
           biasVecs: Seq[Seq[Double]], outputBias: Double): Double = {

    val hiddenLayers = mutable.ArrayBuffer.fill(nLayers)(mutable.ArrayBuffer.fill(nNeurons)(0D))

    for (i <- 0 until nNeurons) {
      val linearCombo = input.zip(inputWeights(i)).map{ case (a,b) => a * b}.reduce(_ + _) + biasVecs(0)(i)
      hiddenLayers(0)(i) = max(linearCombo, 0)
    }


    for (i <- 1 until nLayers) {
      for (j <- 0 until nNeurons) {
        val linearCombo = hiddenLayers(i-1).zip(midAndOutputWeights((i-1)*nNeurons+j)).map
        { case (a,b) => a * b}.reduce(_ + _) + biasVecs(i)(j)
        hiddenLayers(i)(j) = max(linearCombo, 0)
      }
    }

    val linearOut = hiddenLayers(nLayers-1).zip(
      midAndOutputWeights((nLayers-1)*nNeurons)).map{ case (a,b) => a * b}.reduce(_ + _) +
      outputBias
    val nonlinearOut = max(linearOut, 0)

    nonlinearOut
  }
}

class NeuralNetTester[T <: Data](c: NeuralNet[T], nFeatures: Int, nNeurons: Int, nLayers: Int,
                                 dataBP: Int) extends DspTester(c) {
  val NN = new GoldenNeuralNet(nFeatures, nNeurons, nLayers)

  val rangeMin = -10
  val rangeMax = 10

  var input = Seq.fill(nFeatures)(scala.util.Random.nextDouble() * (rangeMax - rangeMin) + rangeMin)
  var inputWeights = Seq.fill(nNeurons, nFeatures)(scala.util.Random.nextDouble() * (rangeMax - rangeMin) + rangeMin)
  var midAndOutputWeights = Seq.fill(nNeurons * (nLayers - 1) + 1, nNeurons)(
    scala.util.Random.nextDouble() * (rangeMax - rangeMin) + rangeMin)
  var biasVecs = Seq.fill(nLayers, nNeurons)(scala.util.Random.nextDouble() * (rangeMax - rangeMin) + rangeMin)
  var outputBias = scala.util.Random.nextDouble() * (rangeMax - rangeMin) + rangeMin

  val goldenModelResult = NN.poke(input, inputWeights, midAndOutputWeights, biasVecs, outputBias)

  // pokes for all the vectors and arrays
  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }
  for (i <- 0 until nNeurons) {
    inputWeights(i).zip(c.io.inputWeights(i)).foreach { case (sig, port) => poke(port, sig) }
  }
  for (i <- 0 until nNeurons * (nLayers - 1) + 1) {
    midAndOutputWeights(i).zip(c.io.midAndOutputWeights(i)).foreach { case (sig, port) => poke(port, sig) }
  }
  for (i <- 0 until nLayers) {
    biasVecs(i).zip(c.io.biasVecs(i)).foreach { case (sig, port) => poke(port, sig) }
  }
  poke(c.io.outputBias, outputBias)
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
        c => new NeuralNetTester(c, params.nFeatures, params.nNeurons, params.nLayers, dataBP)
      }
    } else {
      dsptools.Driver.execute(() => new NeuralNet(params), TestSetup.dspTesterOptions) {
        c => new NeuralNetTester(c, params.nFeatures, params.nNeurons, params.nLayers, dataBP)
      }
    }
  }
}