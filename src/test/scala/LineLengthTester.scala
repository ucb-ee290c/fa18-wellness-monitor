package features

import breeze.numerics.{abs, floor}
import wellness._
import chisel3.core._
import chisel3.util.log2Ceil
import dsptools.DspTester

import scala.collection.mutable

class GoldenDoubleLineLength(windowSize: Int, dataType: String) {
  var pseudoRegisters : List[Double] = List.fill(windowSize)(0.toDouble)
  var lineLengths : mutable.ArrayBuffer[Double] = List.fill(windowSize-1)(0.toDouble).to[mutable.ArrayBuffer]

  def poke(value: Double): Double = {
    pseudoRegisters = value :: pseudoRegisters.take(windowSize - 1)
    for(i <- 0 until windowSize-1) {
      lineLengths(i) = abs(pseudoRegisters(i) - pseudoRegisters(i+1))
    }
    var accumulator : Double = 0
    for(i <- 0 until windowSize-1) {
      accumulator += lineLengths(i)
    }
    if ((dataType == "chisel3.core.SInt") || (dataType == "chisel3.core.UInt"))  floor(accumulator/windowSize)
    else accumulator/windowSize
  }
}

class lineLengthFloatTester[T <: chisel3.Data](c: lineLength[T], windowSize: Int, dataBP: Int) extends DspTester(c) {
  val dataType = c.params.protoData.getClass.getTypeName
  val filter = new GoldenDoubleLineLength(windowSize, dataType)

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

object UIntLineLengthTester {
  def apply(params: lineLengthParams[UInt], windowSize: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new lineLength(params)) {
        c => new lineLengthFloatTester(c, windowSize, 0)
      }
    } else {
      dsptools.Driver.execute(() => new lineLength(params), TestSetup.dspTesterOptions) {
        c => new lineLengthFloatTester(c, windowSize, 0)
      }
    }
  }
}
object SIntLineLengthTester {
  def apply(params: lineLengthParams[SInt], windowSize: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new lineLength(params)) {
        c => new lineLengthFloatTester(c, windowSize, 0)
      }
    } else {
      dsptools.Driver.execute(() => new lineLength(params), TestSetup.dspTesterOptions) {
        c => new lineLengthFloatTester(c, windowSize, 0)
      }
    }
  }
}
object FixedPointLineLengthTester {
  def apply(params: lineLengthParams[FixedPoint], windowSize: Int, dataBP: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new lineLength(params)) {
        c => new lineLengthFloatTester(c, windowSize, dataBP)
      }
    } else {
      dsptools.Driver.execute(() => new lineLength(params), TestSetup.dspTesterOptions) {
        c => new lineLengthFloatTester(c, windowSize, dataBP)
      }
    }
  }
}
