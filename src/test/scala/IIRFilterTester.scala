

package iirFilter

import wellness._
import chisel3.core.UInt
import dsptools.DspTester


class GoldenIntIIRFilter(taps_A: Seq[Int], taps_B: Seq[Int]) {
    var pseudoRegisters = List.fill(taps_A.length)(0)
    var topWire = 0
    var accumulator_A = 0
    var accumulator_B = 0
    
    def poke(value: Int): Int = {
        
        topWire = value + accumulator_A
        pseudoRegisters = topWire :: pseudoRegisters.take(taps_A.length - 1)

        accumulator_A = 0
        for(i <- taps_A.indices) {
            accumulator_A += taps_A(i) * pseudoRegisters(i)
        }
        topWire = value + accumulator_A
        
        accumulator_B = topWire * taps_B(0)
        for(i <- 1 until taps_B.length) {
            accumulator_B += taps_B(i) * pseudoRegisters(i-1)
        }
        accumulator_B
  }
}

/**
  * Case class holding information needed to run an individual test
  */
case class XYZ(
                // input x, y and z
                xin: Double,
                yin: Double,
                zin: Double,
                // mode
                vectoring: Boolean,
                // optional outputs
                // if None, then don't check the result
                // if Some(...), check that the result matches
                xout: Option[Double] = None,
                yout: Option[Double] = None,
                zout: Option[Double] = None
              )

/**
  * DspTester for FixedIterativeCordic
  *
  * Run each trial in @trials
  */
class IIRFilterTester[T <: chisel3.Data](c: ConstantCoefficientIIRFilter[T], coefficients_A: Seq[Int], coefficients_B: Seq[Int]) extends DspTester(c) {
  val filter = new GoldenIntIIRFilter(coefficients_A, coefficients_B)

  for(i <- 0 until 4) {
    val input = scala.util.Random.nextInt(8)

    val goldenModelResult = filter.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)

    step(1)

    expect(c.io.out.bits, goldenModelResult, s"i $i, input $input, gm $goldenModelResult, ${peek(c.io.out.bits)}")
  }
}
object UIntIIRFilterTester {
  def apply(params: IIRFilterParams[UInt], coefficients_A: Seq[Int], coefficients_B: Seq[Int]): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientIIRFilter(params)) {
    dsptools.Driver.execute(() => new ConstantCoefficientIIRFilter(params), TestSetup.dspTesterOptions) {
      c => new IIRFilterTester(c, coefficients_A,coefficients_B)
    }
  }
}

