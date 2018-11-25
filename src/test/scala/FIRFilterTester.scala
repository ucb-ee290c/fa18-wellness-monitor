package firFilter

import wellness._
import chisel3.core._
import chisel3.util.log2Ceil
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

class FIRFilterFloatTester[T <: chisel3.Data](c: ConstantCoefficientFIRFilter[T], coefficients: Seq[Double], dataBP: Int) extends DspTester(c) {
  val filter = new GoldenDoubleFIRFilter(coefficients)

  for(i <- 0 until 100) {
    var input = scala.util.Random.nextFloat*8
    if ((c.params.protoData.getClass.getTypeName == "chisel3.core.UInt") || (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt")) {
      input = scala.util.Random.nextInt(8)
    }

    val goldenModelResult = filter.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)
    //print(s"Input: ${peek(c.io.in.bits)}\n")

    step(1)

    if ((c.params.protoData.getClass.getTypeName == "chisel3.core.UInt") || (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt")) {
      expect(c.io.out.bits, goldenModelResult, s"i $i, input $input, gm $goldenModelResult, ${peek(c.io.out.bits)}")
    } else {
      val tolerance = 0.1
      fixTolLSBs.withValue(log2Ceil((goldenModelResult.abs*tolerance).toInt+1)+dataBP+1) {
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
  def apply(params: FIRFilterParams[FixedPoint], coefficients: Seq[Double], dataBP: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
        c => new FIRFilterFloatTester(c, coefficients, dataBP)
      }
    } else {
      dsptools.Driver.execute(() => new ConstantCoefficientFIRFilter(params), TestSetup.dspTesterOptions) {
        c => new FIRFilterFloatTester(c, coefficients, dataBP)
      }
    }
  }
}
