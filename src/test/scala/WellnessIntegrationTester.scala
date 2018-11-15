import breeze.numerics.{abs, floor}
import wellness._
import chisel3.core._
import dsptools.DspTester
import dsptools.numbers.ConvertableTo

import scala.collection.mutable

class GoldenDoubleLineLength(windowSize: Int) {
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
    floor(accumulator/windowSize)
  }
}

class lineLengthFloatTester[T <: chisel3.Data](c: lineLength[T], windowSize: Int, testType: Int) extends DspTester(c) {
  val filter = new GoldenDoubleLineLength(windowSize)

  for(i <- 0 until 100) {
    var input = scala.util.Random.nextFloat*32
    if (testType == 0) {
      input = scala.util.Random.nextInt(32)
    }

    val goldenModelResult = filter.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)
    //print(s"Input: ${peek(c.io.in.bits)}\n")

    step(1)

    if (testType == 0) {
      expect(c.io.out.bits, goldenModelResult, s"i $i, input $input, gm $goldenModelResult, ${peek(c.io.out.bits)}")
    } else {
      fixTolLSBs.withValue(c.params.protoData.getWidth / 2) {
        expect(c.io.out.bits, goldenModelResult, s"i $i, input $input, gm $goldenModelResult, ${peek(c.io.out.bits)}")
      }
    }

  }
}

object UIntLineLengthTester {
  def apply(params: lineLengthParams[UInt], windowSize: Int): Boolean = {
    dsptools.Driver.execute(() => new lineLength(params), TestSetup.dspTesterOptions) {
      c => new lineLengthFloatTester(c, windowSize, 0)
    }
  }
}
object SIntLineLengthTester {
  def apply(params: lineLengthParams[SInt], windowSize: Int): Boolean = {
    dsptools.Driver.execute(() => new lineLength(params), TestSetup.dspTesterOptions) {
      c => new lineLengthFloatTester(c, windowSize,  0)
    }
  }
}
object FixedPointLineLengthTester {
  def apply(params: lineLengthParams[FixedPoint], windowSize: Int): Boolean = {
    dsptools.Driver.execute(() => new lineLength(params), TestSetup.dspTesterOptions) {
      c => new lineLengthFloatTester(c, windowSize, 1)
    }
  }
}
