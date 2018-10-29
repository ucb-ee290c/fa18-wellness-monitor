package fft

import chisel3.core.UInt
import dsptools.DspTester

class outBundle(lanes: Int) {
  var regs = Seq.fill(lanes)(0)
  var valid = new Boolean
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
      out.valid = true
    }
    else {
      counter = counter + 1
      out.valid = false
    }
    out
  }
}

class FFTBufferTester[T <: chisel3.Data](c: FFTBuffer[T], lanes: Int) extends DspTester(c) {
  val fftBuffer = new GoldenIntFFTBuffer(lanes)

  for(i <- 0 until 300) {
    val input = scala.util.Random.nextInt(8)

    val goldenModelResult = fftBuffer.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)

    step(1)

    for(i <- 0 until lanes) {
      expect(c.io.out.valid, goldenModelResult.valid, s"i $i, input $input, gm ${goldenModelResult.valid}, ${peek(c.io.out.valid)}")
      expect(c.io.out.bits(i), goldenModelResult.regs(i), s"i $i, input $input, gm ${goldenModelResult.regs}, ${peek(c.io.out.bits)}")
    }
  }
}
object UIntFFTBufferTester {
  def apply(params: FFTBufferParams[UInt], lanes: Int): Boolean = {
    chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new FFTBuffer(params)) {
      c => new FFTBufferTester(c, lanes)
    }
  }
}