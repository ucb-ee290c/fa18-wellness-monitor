package logistic

import wellness._
import chisel3._
import dsptools.numbers._
import dsptools.DspTester
import chisel3.core.FixedPoint

import scala.collection._
import scala.math._
import breeze.numerics.sigmoid
import chisel3.util.log2Ceil

class GoldenLogistic(nFeatures: Int, nThresholds: Int, learningRate: Double, ictalIndex: Int, interIndex: Int,
                     nWindow: Int, nInterCount: Int, onlineLearn: Int, dataType: String) {

  var ictalWindow = List.fill(nWindow)(0.toDouble)
  var interWindow = List.fill(nWindow)(0.toDouble)
  var weightsOnline = List.fill(nFeatures)(0.toDouble)
  var initState = 0D
  var interCount = 0D

  def poke(input: Seq[Double], weights: Seq[Double], intercept: Double): Seq[Seq[Double]] = {

    val ictalThreshold = Constants.logitTable(ictalIndex.toDouble,nThresholds)
    val interThreshold = Constants.logitTable(interIndex.toDouble,nThresholds)

    var weightsMux = List.fill(nFeatures)(0.toDouble)
    if (initState == 0D) weightsMux = weights.toList
    else weightsMux = weightsOnline

    val reduced = input.zip(weightsMux).map{ case (a,b) => a * b}.sum + intercept

    if (reduced >= ictalThreshold) ictalWindow = 1D :: ictalWindow.take(nWindow - 1)
    else ictalWindow = 0D :: ictalWindow.take(nWindow - 1)

    if (reduced <= interThreshold) interWindow = 1D :: interWindow.take(nWindow - 1)
    else interWindow = 0D :: interWindow.take(nWindow - 1)

    val probability = round(sigmoid(reduced)*(nThresholds+1)).toDouble/(nThresholds+1) // epic approximation
    val prediction = if (reduced >= 0) 1D else 0D

    val deltaWeights = input.map(_ * learningRate * (prediction - probability)).toList

    var newWeights = List.fill(nFeatures)(0.toDouble)

    if ((ictalWindow.sum == nWindow) || (interCount == nInterCount)) {
      newWeights = weightsOnline.zip(deltaWeights).map { case (a, b) => a + b }
      interCount = 0D
    } else if (interWindow.sum == nWindow) {
      interCount = interCount + 1D
      newWeights = weightsOnline
    } else {
      newWeights = weightsOnline
      interCount = 0D
    }

    if (initState == 0D) weightsOnline = weights.toList
    else weightsOnline = newWeights

    if (onlineLearn == 1) initState = 1D

    Seq(Seq(probability, prediction, reduced), weightsMux) // interesting that this is OK, component vectors have diff length
  }
}

class LogisticTester[T <: Data](c: Logistic[T], nFeatures: Int, nThresholds: Int, learningRate: Double, ictalIndex: Int,
                                interIndex: Int, nWindow: Int, nInterCount: Int, onlineLearn: Int,
                                dataBP: Int, onlineIterations: Int, debug: Int)
  extends DspTester(c) {
  val dataType = c.params.protoData.getClass.getTypeName
  val Logistic = new GoldenLogistic(nFeatures, nThresholds, learningRate, ictalIndex, interIndex, nWindow, nInterCount, onlineLearn, dataType)

  // initialize test vectors/arrays
  var input = Seq.fill(onlineIterations,nFeatures)(0D)
  var weights = Seq.fill(nFeatures)(0D)
  var intercept = 0D

  if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt"){
    // initialize test vectors/arrays with for Ints
    input = Seq.fill(onlineIterations,nFeatures)(scala.util.Random.nextInt(16) - 8)
    weights = Seq.fill(nFeatures)(scala.util.Random.nextInt(16) - 8)
    intercept = scala.util.Random.nextInt(10) - 5
  } else {
    // initialize test vectors/arrays with for FixedPoint
    input = Seq.fill(onlineIterations,nFeatures)(scala.util.Random.nextDouble*4 - 2)
    weights = Seq.fill(nFeatures)(scala.util.Random.nextDouble*4 - 2)
    intercept = scala.util.Random.nextDouble*4 - 2
  }

  if (debug == 1) {
    // print the configuration the tester is doing right now
    print("datatype: " + c.params.protoData.getClass.getTypeName + "\n")
    print("nFeatures: " + nFeatures + "\n")
    print("nThresholds: " + nThresholds + "\n")
  }

  for (i <- 0 until onlineIterations) {

    // the IDE is saying that _.toDouble is redundant, don't believe it!
    // these vectors are being dynamically assigned as either double or int, due to test case flexibility
    // the _.toDouble mapping is required for Ints, the IDE doesn't see it.
    val goldenModelResult = Logistic.poke(input(i).map(_.toDouble), weights.map(_.toDouble), intercept.toDouble)

    // pokes for all the vectors and arrays
    input(i).zip(c.io.in.bits).foreach { case (sig, port) => poke(port, sig) }
    weights.zip(c.io.weights).foreach { case (sig, port) => poke(port, sig) }
    poke(c.io.intercept, intercept)

    poke(c.io.in.valid, value = 1)
    step(1) // not really needed for now since everything is combinational

    // check for computational accuracy
    if (i == 0 || i == onlineIterations-1) {
      if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
        expect(c.io.rawVotes, goldenModelResult(0)(0))
        expect(c.io.out.bits, goldenModelResult(0)(1))
        expect(c.io.dotProduct, goldenModelResult(0)(2))
        expect(c.io.weightProbe(0), goldenModelResult(1)(0))
        expect(c.io.weightProbe(1), goldenModelResult(1)(1))
        expect(c.io.weightProbe(2), goldenModelResult(1)(2))
      } else {
        val tolerance = 0.1
        fixTolLSBs.withValue(log2Ceil((goldenModelResult(0)(0).abs * tolerance).toInt + 1) + dataBP - 1) {
          expect(c.io.rawVotes, goldenModelResult(0)(0))
          expect(c.io.dotProduct, goldenModelResult(0)(2))
          expect(c.io.weightProbe(0), goldenModelResult(1)(0))
          expect(c.io.weightProbe(1), goldenModelResult(1)(1))
          expect(c.io.weightProbe(2), goldenModelResult(1)(2))
        }
        // strict check for the class votes
        expect(c.io.out.bits, goldenModelResult(0)(1))
      }
    }
  }
}

object IntLogisticTester {
  def apply(params: LogisticParams[SInt], flag: Int, onlineIterations: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new Logistic(params)) {
        c => new LogisticTester(c, params.nFeatures, params.nThresholds, params.learningRate, params.ictalIndex,
          params.interIndex, params.nWindow, params.nInterCount, params.onlineLearn,
          0, onlineIterations, debug)
      }
    } else {
      dsptools.Driver.execute(() => new Logistic(params), TestSetup.dspTesterOptions) {
        c => new LogisticTester(c, params.nFeatures, params.nThresholds, params.learningRate, params.ictalIndex,
          params.interIndex, params.nWindow, params.nInterCount, params.onlineLearn,
          0, onlineIterations, debug)
      }
    }
  }
}

object FixedPointLogisticTester {
  def apply(params: LogisticParams[FixedPoint], dataBP: Int, flag: Int, onlineIterations: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new Logistic(params)) {
        c => new LogisticTester(c, params.nFeatures, params.nThresholds, params.learningRate, params.ictalIndex,
          params.interIndex, params.nWindow, params.nInterCount, params.onlineLearn,
          dataBP, onlineIterations, debug)
      }
    } else {
      dsptools.Driver.execute(() => new Logistic(params), TestSetup.dspTesterOptions) {
        c => new LogisticTester(c, params.nFeatures, params.nThresholds, params.learningRate, params.ictalIndex,
          params.interIndex, params.nWindow, params.nInterCount, params.onlineLearn,
          dataBP, onlineIterations, debug)
      }
    }
  }
}
