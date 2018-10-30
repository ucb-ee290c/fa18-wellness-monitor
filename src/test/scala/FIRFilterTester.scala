package firFilter

import chisel3.core._
import dsptools.DspTester

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

class FIRFilterTester[T <: chisel3.Data](c: ConstantCoefficientFIRFilter[T], coefficients: Seq[Int]) extends DspTester(c) {
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
object UIntFIRFilterTester {
  def apply(params: FIRFilterParams[UInt], coefficients: Seq[Int]): Boolean = {
    chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
      c => new FIRFilterTester(c, coefficients)
    }
  }
}
object SIntFIRFilterTester {
  def apply(params: FIRFilterParams[SInt], coefficients: Seq[Int]): Boolean = {
    chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
      c => new FIRFilterTester(c, coefficients)
    }
  }
}
