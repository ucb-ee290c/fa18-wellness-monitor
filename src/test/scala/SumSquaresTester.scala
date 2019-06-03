package features

import breeze.numerics.{abs, floor, pow}
import wellness._
import chisel3.core._
import chisel3.util.log2Ceil
import dsptools.DspTester

import scala.collection.mutable

class GoldenDoublesumSquares(windowSize: Int, dataType: String) {
  var pseudoRegisters : List[Double] = List.fill(windowSize)(0.toDouble)
  var sumSquaress : mutable.ArrayBuffer[Double] = List.fill(windowSize-1)(0.toDouble).to[mutable.ArrayBuffer]

  // Also do division by 8 to minimize dynamic range of output values
  // Check https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/scripts/features.py
  val line_normalize = pow(2,3).toDouble

  def poke(value: Double): Double = {
    pseudoRegisters = value :: pseudoRegisters.take(windowSize - 1)
    for(i <- 0 until windowSize-1) {
      sumSquaress(i) = pseudoRegisters(i) * pseudoRegisters(i)
    }
    var accumulator : Double = 0
    for(i <- 0 until windowSize-1) {
      accumulator += sumSquaress(i)
    }
    if ((dataType == "chisel3.core.SInt") || (dataType == "chisel3.core.UInt"))  floor(accumulator/(windowSize*line_normalize))
    else accumulator/(windowSize*line_normalize)
  }
}

class SumSquaresFloatTester[T <: chisel3.Data](c: sumSquares[T], windowSize: Int, dataBP: Int) extends DspTester(c) {
  val dataType = c.params.protoData.getClass.getTypeName
  val filter = new GoldenDoublesumSquares(windowSize, dataType)

  for(i <- 0 until 100) {
    var input = scala.util.Random.nextFloat*32
    if ((dataType == "chisel3.core.SInt") || (dataType == "chisel3.core.UInt")) {
      input = scala.util.Random.nextInt(32)
    }

    val goldenModelResult = filter.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)
    //print(s"Input: ${peek(c.io.in.bits)}\n")

    step(1)

    if ((dataType == "chisel3.core.SInt") || (dataType == "chisel3.core.UInt")) {
      expect(c.io.out.bits, goldenModelResult, s"i $i, input $input, gm $goldenModelResult, ${peek(c.io.out.bits)}")
    } else {
      val tolerance = 0.1
      fixTolLSBs.withValue(log2Ceil((goldenModelResult.abs*tolerance).toInt+1)+dataBP+1) {
        expect(c.io.out.bits, goldenModelResult, s"i $i, input $input, gm $goldenModelResult, ${peek(c.io.out.bits)}")
      }
    }

  }
}

object UIntSumSquaresTester {
  def apply(params: sumSquaresParams[UInt], windowSize: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new sumSquares(params)) {
        c => new SumSquaresFloatTester(c, windowSize, 0)
      }
    } else {
      dsptools.Driver.execute(() => new sumSquares(params), TestSetup.dspTesterOptions) {
        c => new SumSquaresFloatTester(c, windowSize, 0)
      }
    }
  }
}
object SIntSumSquaresTester {
  def apply(params: sumSquaresParams[SInt], windowSize: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new sumSquares(params)) {
        c => new SumSquaresFloatTester(c, windowSize, 0)
      }
    } else {
      dsptools.Driver.execute(() => new sumSquares(params), TestSetup.dspTesterOptions) {
        c => new SumSquaresFloatTester(c, windowSize, 0)
      }
    }
  }
}
object FixedPointSumSquaresTester {
  def apply(params: sumSquaresParams[FixedPoint], windowSize: Int, dataBP: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new sumSquares(params)) {
        c => new SumSquaresFloatTester(c, windowSize, dataBP)
      }
    } else {
      dsptools.Driver.execute(() => new sumSquares(params), TestSetup.dspTesterOptions) {
        c => new SumSquaresFloatTester(c, windowSize, dataBP)
      }
    }
  }
}
