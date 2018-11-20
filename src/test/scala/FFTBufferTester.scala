package fft

import wellness._
import chisel3.core.{FixedPoint, UInt}
import dsptools.DspTester

import scala.collection.mutable

class outBundle(lanes: Int) {
  val regs = mutable.Buffer.fill(lanes)(0.toDouble)
  var valid : Boolean = false
}

class GoldenFFTBuffer(lanes: Int) {
  var pseudoRegisters = List.fill(lanes)(0.toDouble)

  val out = new outBundle(lanes)

  var counter = 0
  def poke(value: Double): outBundle = {
    pseudoRegisters = value :: pseudoRegisters.take(lanes - 1)

    for(i <- 0 until lanes) {
      out.regs(i) = pseudoRegisters(i)
    }
    if(counter == lanes) {
      counter = 1
    }
    else {
      counter = counter + 1
    }
    if(counter == lanes) {
      out.valid = true
    }
    else {
      out.valid = false
    }
    out
  }
}

class FFTBufferTester[T <: chisel3.Data](c: FFTBuffer[T], lanes: Int, testType: Int) extends DspTester(c) {
  val fftBuffer = new GoldenFFTBuffer(lanes)

  for(i <- 0 until 50) {
    val input = scala.util.Random.nextInt(8)

    val goldenModelResult = fftBuffer.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, true)

    step(1)

    expect(c.io.out.valid, goldenModelResult.valid, s"i $i, input $input, gm ${goldenModelResult.valid}, ${peek(c.io.out.valid)}")
    for(i <- 0 until lanes) {
      if (testType == 0) {
        expect(c.io.out.bits(i), goldenModelResult.regs(i))
      } else {
        fixTolLSBs.withValue(c.params.protoData.getWidth / 8) {
          expect(c.io.out.bits(i), goldenModelResult.regs(i))
        }
      }
    }

  }
}

object UIntFFTBufferTester {
  def apply(params: FFTBufferParams[UInt], lanes: Int): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new FFTBuffer(params)) {
    dsptools.Driver.execute(() => new FFTBuffer(params), TestSetup.dspTesterOptions) {
      c => new FFTBufferTester(c, lanes, 0)
    }
  }
}

object FixedPointFFTBufferTester {
  def apply(params: FFTBufferParams[FixedPoint], lanes: Int): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new FFTBuffer(params)) {
    dsptools.Driver.execute(() => new FFTBuffer(params), TestSetup.dspTesterOptions) {
      c => new FFTBufferTester(c, lanes, 1)
    }
  }
}