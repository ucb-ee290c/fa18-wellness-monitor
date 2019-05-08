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

class GoldenLogistic(nFeatures: Int, nThresholds: Int,
                dataType: String) {

  def poke(input: Seq[Double], weights: Seq[Double], intercept: Double): Seq[Double] = {

    val reduced = input.zip(weights).map{ case (a,b) => a * b}.sum + intercept

    val probability = round(sigmoid(reduced)*(nThresholds+1)).toDouble/(nThresholds+1) // epic approximation
    val prediction = if (reduced >= 0) 1D else 0D

    Seq(probability, prediction, reduced) // interesting that this is OK, component vectors have diff length
  }
}

class LogisticTester[T <: Data](c: Logistic[T], nFeatures: Int, nThresholds: Int,
                                dataBP: Int, debug: Int)
  extends DspTester(c) {
  val dataType = c.params.protoData.getClass.getTypeName
  val Logistic = new GoldenLogistic(nFeatures, nThresholds, dataType)

  // initialize test vectors/arrays
  var input = Seq.fill(nFeatures)(0D)
  var weights = Seq.fill(nFeatures)(0D)
  var intercept = 0D

  if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt"){
    // initialize test vectors/arrays with for Ints
    input = Seq.fill(nFeatures)(scala.util.Random.nextInt(16) - 8)
    weights = Seq.fill(nFeatures)(scala.util.Random.nextInt(16) - 8)
    intercept = scala.util.Random.nextInt(10) - 5
  } else {
    // initialize test vectors/arrays with for FixedPoint
    input = Seq.fill(nFeatures)(scala.util.Random.nextDouble*4 - 2)
    weights = Seq.fill(nFeatures)(scala.util.Random.nextDouble*4 - 2)
    intercept = scala.util.Random.nextDouble*4 - 2
  }

  // the IDE is saying that _.toDouble is redundant, don't believe it!
  // these vectors are being dynamically assigned as either double or int, due to test case flexibility
  // the _.toDouble mapping is required for Ints, the IDE doesn't see it.
  val goldenModelResult = Logistic.poke(input.map(_.toDouble), weights.map(_.toDouble), intercept.toDouble)

  if (debug == 1) {
    // print the configuration the tester is doing right now
    print("datatype: " + c.params.protoData.getClass.getTypeName + "\n")
    print("nFeatures: " + nFeatures + "\n")
    print("nThresholds: " + nThresholds + "\n")
  }

  // pokes for all the vectors and arrays
  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }
  weights.zip(c.io.weights).foreach { case(sig, port) => poke(port, sig) }
  poke(c.io.intercept,intercept)

  poke(c.io.in.valid, value = 1)
  step(1) // not really needed for now since everything is combinational

  // check for computational accuracy
  if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
    expect(c.io.rawVotes, goldenModelResult(0))
    expect(c.io.out.bits, goldenModelResult(1))
    expect(c.io.dotProduct, goldenModelResult(2))
  } else {
    val tolerance = 0.1
    fixTolLSBs.withValue(log2Ceil((goldenModelResult(0).abs*tolerance).toInt+1)+dataBP-1) {
      expect(c.io.rawVotes, goldenModelResult(0))
      expect(c.io.dotProduct, goldenModelResult(2))
    }
    // strict check for the class votes
    expect(c.io.out.bits, goldenModelResult(1))
  }
}

object IntLogisticTester {
  def apply(params: LogisticParams[SInt], flag: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new Logistic(params)) {
        c => new LogisticTester(c, params.nFeatures, params.nThresholds,
          0, debug)
      }
    } else {
      dsptools.Driver.execute(() => new Logistic(params), TestSetup.dspTesterOptions) {
        c => new LogisticTester(c, params.nFeatures, params.nThresholds,
          0, debug)
      }
    }
  }
}

object FixedPointLogisticTester {
  def apply(params: LogisticParams[FixedPoint], dataBP: Int, flag: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new Logistic(params)) {
        c => new LogisticTester(c, params.nFeatures, params.nThresholds,
          dataBP, debug)
      }
    } else {
      dsptools.Driver.execute(() => new Logistic(params), TestSetup.dspTesterOptions) {
        c => new LogisticTester(c, params.nFeatures, params.nThresholds,
          dataBP, debug)
      }
    }
  }
}

