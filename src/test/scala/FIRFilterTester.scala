package firFilter

import wellness._
import chisel3.core._
import dsptools.DspTester

class GoldenDoubleFIRFilter(taps: Seq[Double]) {
  var pseudoRegisters = List.fill(taps.length)(0.toDouble)

  def poke(value: Double): Double = {
    pseudoRegisters = value :: pseudoRegisters.take(taps.length - 1)
    var accumulator : Double = 0
    for(i <- taps.indices) {
      accumulator += taps(i) * pseudoRegisters(i)
    }
    accumulator
  }
}

class FIRFilterFloatTester[T <: chisel3.Data](c: ConstantCoefficientFIRFilter[T], coefficients: Seq[Double], testType: Int) extends DspTester(c) {
  val filter = new GoldenDoubleFIRFilter(coefficients)

  for(i <- 0 until 100) {
    var input = scala.util.Random.nextFloat*8
    if (testType == 0) {
      input = scala.util.Random.nextInt(8)
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

object UIntFIRFilterTester {
  def apply(params: FIRFilterParams[UInt], coefficients: Seq[Int], debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
        c => new FIRFilterFloatTester(c, coefficients.map(_.toDouble), 0)
      }
    } else {
      dsptools.Driver.execute(() => new ConstantCoefficientFIRFilter(params), TestSetup.dspTesterOptions) {
        c => new FIRFilterFloatTester(c, coefficients.map(_.toDouble), 0)
      }
    }
  }
}
object SIntFIRFilterTester {
  def apply(params: FIRFilterParams[SInt], coefficients: Seq[Int], debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
        c => new FIRFilterFloatTester(c, coefficients.map(_.toDouble), 0)
      }
    } else {
      dsptools.Driver.execute(() => new ConstantCoefficientFIRFilter(params), TestSetup.dspTesterOptions) {
        c => new FIRFilterFloatTester(c, coefficients.map(_.toDouble), 0)
      }
    }
  }
}
object FixedPointFIRFilterTester {
  def apply(params: FIRFilterParams[FixedPoint], coefficients: Seq[Double], debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
        c => new FIRFilterFloatTester(c, coefficients, 1)
      }
    } else {
      dsptools.Driver.execute(() => new ConstantCoefficientFIRFilter(params), TestSetup.dspTesterOptions) {
        c => new FIRFilterFloatTester(c, coefficients, 1)
      }
    }
  }
}
