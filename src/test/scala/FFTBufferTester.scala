package fft

import wellness._
import chisel3.core.UInt
import dsptools.DspTester

import scala.collection.mutable

class outBundle(lanes: Int) {
  val regs = mutable.Buffer.fill(lanes)(0)
  var valid : Boolean = false
}

class GoldenIntFFTBuffer(lanes: Int) {
  var pseudoRegisters = List.fill(lanes)(0)

  val out = new outBundle(lanes)

  var counter = 0
  def poke(value: Int): outBundle = {
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

class FFTBufferTester[T <: chisel3.Data](c: FFTBuffer[T], lanes: Int) extends DspTester(c) {
  val fftBuffer = new GoldenIntFFTBuffer(lanes)

  for(i <- 0 until 50) {
    val input = scala.util.Random.nextInt(8)

    val goldenModelResult = fftBuffer.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, true)

    step(1)

    expect(c.io.out.valid, goldenModelResult.valid, s"i $i, input $input, gm ${goldenModelResult.valid}, ${peek(c.io.out.valid)}")
    for(i <- 0 until lanes) {
      expect(c.io.out.bits(i), goldenModelResult.regs(i), s"i $i, input $input, gm ${goldenModelResult.regs}, ${peek(c.io.out.bits)}")
    }
  }
}
object UIntFFTBufferTester {
  def apply(params: FFTBufferParams[UInt], lanes: Int): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new FFTBuffer(params)) {
    dsptools.Driver.execute(() => new FFTBuffer(params), TestSetup.dspTesterOptions) {
      c => new FFTBufferTester(c, lanes)
    }
  }
}