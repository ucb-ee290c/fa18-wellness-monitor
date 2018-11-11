package firFilter

import wellness._
import chisel3.core._
import dsptools.DspTester
import dsptools.numbers.ConvertableTo

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

class FIRFilterFloatTester[T <: chisel3.Data](c: ConstantCoefficientFIRFilter[T], coefficients: Seq[Double], dataWidth: Int, dataBP: Int, testType: Int) extends DspTester(c) {
  val filter = new GoldenDoubleFIRFilter(coefficients)

  //print(s"Coefficients: ")
  //for(i <- coefficients.indices) {
  //  print(s"Coeff:${coefficients(i)} - ")
  //  print(s"Tap: ${peek(c.params.taps(i))}\n")
  //}
  //print(s"\n------------\n")

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
    //print(s"Got: ${peek(c.io.out.bits)}\n")
    //print(s"Expected: $goldenModelResult\n")
    //print(s"--\n")

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
  def apply(params: FIRFilterParams[UInt], coefficients: Seq[Int]): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
    dsptools.Driver.execute(() => new ConstantCoefficientFIRFilter(params), TestSetup.dspTesterOptions) {
      //c => new FIRFilterIntTester(c, coefficients)
      c => new FIRFilterFloatTester(c, coefficients.map(_.toDouble), 0, 0, 0)
    }
  }
}
object SIntFIRFilterTester {
  def apply(params: FIRFilterParams[SInt], coefficients: Seq[Int]): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
    dsptools.Driver.execute(() => new ConstantCoefficientFIRFilter(params), TestSetup.dspTesterOptions) {
      //c => new FIRFilterIntTester(c, coefficients)
      c => new FIRFilterFloatTester(c, coefficients.map(_.toDouble), 0, 0, 0)
    }
  }
}
object FixedPointFIRFilterTester {
  def apply(params: FIRFilterParams[FixedPoint], coefficients: Seq[Double], dataWidth: Int, dataBP: Int): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConstantCoefficientFIRFilter(params)) {
    dsptools.Driver.execute(() => new ConstantCoefficientFIRFilter(params), TestSetup.dspTesterOptions) {
      c => new FIRFilterFloatTester(c, coefficients, dataWidth, dataBP, 1)
    }
  }
}
