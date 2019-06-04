
package randomforest

import wellness._
import chisel3._
import dsptools.numbers._
import dsptools.DspTester
import chisel3.core.FixedPoint

import scala.collection._

import chisel3.util.log2Ceil


class GoldenRandomForest(nFeatures: Int, nDepth: Int, nTrees: Int, featureSelect: Seq[Seq[Int]]) {

  def poke(input: Seq[Double], thresholds: Seq[Seq[Double]], leafVotes: Seq[Seq[Double]]): Double = {

    val tableVotes = mutable.ArrayBuffer.fill(nTrees)(0D) // contains binarized votes per class
    for (i <- 0 until nTrees) { // for every tree

      if (nDepth == 1){ // depth of 1, vector length 1
        // first check the feature that must be compared, do the comparison, the select the corresponding vote from leaf
        if (input(featureSelect(i)(0)) > thresholds(i)(0))        tableVotes(i) = leafVotes(i)(1)
        else                                                      tableVotes(i) = leafVotes(i)(0)


      } else if (nDepth == 2){ // depth of 2, vector length 3

        if (input(featureSelect(i)(0)) > thresholds(i)(0)) {
          if (input(featureSelect(i)(1)) > thresholds(i)(1))      tableVotes(i) = leafVotes(i)(1)
          else                                                    tableVotes(i) = leafVotes(i)(0)
        } else {
          if (input(featureSelect(i)(2)) > thresholds(i)(2))      tableVotes(i) = leafVotes(i)(3)
          else                                                    tableVotes(i) = leafVotes(i)(2)
        }

      } else if (nDepth == 3){ // depth of 3, vector length 7

        if (input(featureSelect(i)(0)) > thresholds(i)(0)) {
          if (input(featureSelect(i)(1)) > thresholds(i)(1)) {
            if (input(featureSelect(i)(3)) > thresholds(i)(3))    tableVotes(i) = leafVotes(i)(1)
            else                                                  tableVotes(i) = leafVotes(i)(0)
          } else {
            if (input(featureSelect(i)(4)) > thresholds(i)(4))    tableVotes(i) = leafVotes(i)(3)
            else                                                  tableVotes(i) = leafVotes(i)(2)
          }
        } else {
          if (input(featureSelect(i)(2)) > thresholds(i)(2)) {
            if (input(featureSelect(i)(5)) > thresholds(i)(5))    tableVotes(i) = leafVotes(i)(5)
            else                                                  tableVotes(i) = leafVotes(i)(4)
          } else {
            if (input(featureSelect(i)(6)) > thresholds(i)(6))    tableVotes(i) = leafVotes(i)(7)
            else                                                  tableVotes(i) = leafVotes(i)(6)
          }
        }

      } else { // I can do this all day...

        if (input(featureSelect(i)(0)) > thresholds(i)(0)) {
          if (input(featureSelect(i)(1)) > thresholds(i)(1)) {
            if (input(featureSelect(i)(3)) > thresholds(i)(3)) {
              if (input(featureSelect(i)(7)) > thresholds(i)(7))    tableVotes(i) = leafVotes(i)(1)
              else                                                  tableVotes(i) = leafVotes(i)(0)
            } else {
              if (input(featureSelect(i)(8)) > thresholds(i)(8))    tableVotes(i) = leafVotes(i)(3)
              else                                                  tableVotes(i) = leafVotes(i)(2)
            }
          } else {
            if (input(featureSelect(i)(4)) > thresholds(i)(4)) {
              if (input(featureSelect(i)(9)) > thresholds(i)(9))    tableVotes(i) = leafVotes(i)(5)
              else                                                  tableVotes(i) = leafVotes(i)(4)
            } else {
              if (input(featureSelect(i)(10)) > thresholds(i)(10))  tableVotes(i) = leafVotes(i)(7)
              else                                                  tableVotes(i) = leafVotes(i)(6)
            }
          }
        } else {
          if (input(featureSelect(i)(2)) > thresholds(i)(2)) {
            if (input(featureSelect(i)(5)) > thresholds(i)(5)) {
              if (input(featureSelect(i)(11)) > thresholds(i)(11))  tableVotes(i) = leafVotes(i)(9)
              else                                                  tableVotes(i) = leafVotes(i)(8)
            } else {
              if (input(featureSelect(i)(12)) > thresholds(i)(12))  tableVotes(i) = leafVotes(i)(11)
              else                                                  tableVotes(i) = leafVotes(i)(10)
            }
          } else {
            if (input(featureSelect(i)(6)) > thresholds(i)(6)) {
              if (input(featureSelect(i)(13)) > thresholds(i)(13))  tableVotes(i) = leafVotes(i)(13)
              else                                                  tableVotes(i) = leafVotes(i)(12)
            } else {
              if (input(featureSelect(i)(14)) > thresholds(i)(14))  tableVotes(i) = leafVotes(i)(15)
              else                                                  tableVotes(i) = leafVotes(i)(14)
            }
          }
        }

      } // Can you check for a pattern instead?
    }

    tableVotes.sum
  }
}

class RandomForestTester[T <: Data](c: RandomForest[T], nFeatures: Int, nDepth: Int, nTrees: Int, featureSelect: Seq[Seq[Int]],
                                    dataBP: Int, debug: Int)
  extends DspTester(c) {
  val dataType = c.params.protoData.getClass.getTypeName
  val RandomForest = new GoldenRandomForest(nFeatures, nDepth, nTrees, featureSelect)

  // initialize test vectors/arrays
  var input = Seq.fill(nFeatures)(0D)
  var thresholds = Seq.fill(nTrees,(1 << nDepth) - 1)(0D)
  var leafVotes = Seq.fill(nTrees,1 << nDepth)(0D)

  if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt"){
    // initialize test vectors/arrays with for Ints
    input = Seq.fill(nFeatures)(scala.util.Random.nextInt(16) - 8)
    thresholds = Seq.fill(nTrees,(1 << nDepth) - 1)(scala.util.Random.nextInt(16) - 8)
    leafVotes = Seq.fill(nTrees,1 << nDepth)(scala.util.Random.nextInt(16) - 8)
  } else {
    // initialize test vectors/arrays with for FixedPoint
    input = Seq.fill(nFeatures)(scala.util.Random.nextDouble*4 - 2)
    thresholds = Seq.fill(nTrees,(1 << nDepth) - 1)(scala.util.Random.nextDouble*4 - 2)
    leafVotes = Seq.fill(nTrees,1 << nDepth)(scala.util.Random.nextInt(16) - 8)
  }

  if (debug == 1) {
    // print the configuration the tester is doing right now
    print("datatype: " + c.params.protoData.getClass.getTypeName + "\n")
    print("nFeatures: " + nFeatures + "\n")
    print("nDepth: " + nDepth + "\n")
  }

  // the IDE is saying that _.toDouble is redundant, don't believe it!
  // these vectors are being dynamically assigned as either double or int, due to test case flexibility
  // the _.toDouble mapping is required for Ints, the IDE doesn't see it.
  val goldenModelResult = RandomForest.poke(input.map(_.toDouble), thresholds.map(_.map(_.toDouble)), leafVotes.map(_.map(_.toDouble)))

  // pokes for all the vectors and arrays
  input.zip(c.io.in.bits).foreach { case (sig, port) => poke(port, sig) }
  for (i <- 0 until nTrees) thresholds(i).zip(c.io.thresholds(i)).foreach { case (sig, port) => poke(port, sig) }
  for (i <- 0 until nTrees) leafVotes(i).zip(c.io.leafVotes(i)).foreach { case (sig, port) => poke(port, sig) }

  poke(c.io.in.valid, value = 1)
  step(1) // not really needed for now since everything is combinational

  // check for computational accuracy
  if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
    expect(c.io.rawVotes, goldenModelResult)

  } else {
    val tolerance = 0.1
    fixTolLSBs.withValue(log2Ceil((goldenModelResult.abs * tolerance).toInt + 1) + dataBP - 1) {
      expect(c.io.rawVotes, goldenModelResult)
    }
    // strict check for the class votes
    //expect(c.io.out.bits, goldenModelResult(0)(1))
  }

}

object IntRandomForestTester {
  def apply(params: RandomForestParams[SInt], debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new RandomForest(params)) {
        c => new RandomForestTester(c, params.nFeatures, params.nDepth, params.nTrees, params.featureSelect,
          0, debug)
      }
    } else {
      dsptools.Driver.execute(() => new RandomForest(params), TestSetup.dspTesterOptions) {
        c => new RandomForestTester(c, params.nFeatures, params.nDepth, params.nTrees, params.featureSelect,
          0, debug)
      }
    }
  }
}

object FixedPointRandomForestTester {
  def apply(params: RandomForestParams[FixedPoint], dataBP: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new RandomForest(params)) {
        c => new RandomForestTester(c, params.nFeatures, params.nDepth, params.nTrees, params.featureSelect,
          dataBP, debug)
      }
    } else {
      dsptools.Driver.execute(() => new RandomForest(params), TestSetup.dspTesterOptions) {
        c => new RandomForestTester(c, params.nFeatures, params.nDepth, params.nTrees, params.featureSelect,
          dataBP, debug)
      }
    }
  }
}

