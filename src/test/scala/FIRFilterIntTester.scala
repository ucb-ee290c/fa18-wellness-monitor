package firFilter

import wellness._
import chisel3.core._
import dsptools.DspTester
import dsptools.numbers.ConvertableTo

class GoldenIntFIRFilter(taps: Seq[Int]) {
  var pseudoRegisters = List.fill(taps.length)(0)

  def poke(value: Int): Int = {
    pseudoRegisters = value :: pseudoRegisters.take(taps.length - 1)
    var accumulator = 0
    for(i <- taps.indices) {
      accumulator += taps(i) * pseudoRegisters(i)
    }
    accumulator
  }
}

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

class FIRFilterIntTester[T <: chisel3.Data](c: ConstantCoefficientFIRFilter[T], coefficients: Seq[Int]) extends DspTester(c) {
  val filter = new GoldenIntFIRFilter(coefficients)

  for(i <- 0 until 100) {
    val input = scala.util.Random.nextInt(8)

    val goldenModelResult = filter.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)

    step(1)

    expect(c.io.out.bits, goldenModelResult, s"i $i, input $input, gm $goldenModelResult, ${peek(c.io.out.bits)}")
  }
}

class FIRFilterFloatTester[T <: chisel3.Data](c: ConstantCoefficientFIRFilter[T], coefficients: Seq[Double], dataWidth: Int, dataBP: Int) extends DspTester(c) {
  val filter = new GoldenDoubleFIRFilter(coefficients)

  for(i <- 0 until 100) {
    val input = scala.util.Random.nextFloat*8

    val goldenModelResult = filter.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)

    step(1)

    fixTolLSBs.withValue(9) {
      expect(c.io.out.bits, goldenModelResult, s"i $i, input $input, gm $goldenModelResult, ${peek(c.io.out.bits)}")
    }

    //expect(c.io.out.bits, goldenModelResult, s"i $i, input $input, gm $goldenModelResult, ${peek(c.io.out.bits)}")
  }
}

object UIntFIRFilterTester {
  def apply(params: FIRFilterParams[UInt], coefficients: Seq[Int]): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
    dsptools.Driver.execute(() => new ConstantCoefficientFIRFilter(params), TestSetup.dspTesterOptions) {
      c => new FIRFilterIntTester(c, coefficients)
    }
  }
}
object SIntFIRFilterTester {
  def apply(params: FIRFilterParams[SInt], coefficients: Seq[Int]): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
    dsptools.Driver.execute(() => new ConstantCoefficientFIRFilter(params), TestSetup.dspTesterOptions) {
      c => new FIRFilterIntTester(c, coefficients)
    }
  }
}
object FixedPointFIRFilterTester {
  def apply(params: FIRFilterParams[FixedPoint], coefficients: Seq[Double], dataWidth: Int, dataBP: Int): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
    dsptools.Driver.execute(() => new ConstantCoefficientFIRFilter(params), TestSetup.dspTesterOptions) {
      c => new FIRFilterFloatTester(c, coefficients, dataWidth, dataBP)
    }
  }
}
