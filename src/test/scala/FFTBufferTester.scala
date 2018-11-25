package fft

import wellness._
import chisel3.core._
import chisel3.util.log2Ceil
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

class FFTBufferTester[T <: chisel3.Data](c: FFTBuffer[T], lanes: Int, dataBP: Int) extends DspTester(c) {
  val fftBuffer = new GoldenFFTBuffer(lanes)

  for(i <- 0 until 50) {
    var input = scala.util.Random.nextDouble
    if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
      input = scala.util.Random.nextInt(8)
    }

    val goldenModelResult = fftBuffer.poke(input.toDouble)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, true)
    poke(c.io.in.sync, true)

    step(1)

    expect(c.io.out.valid, goldenModelResult.valid, s"i $i, input $input, gm ${goldenModelResult.valid}, ${peek(c.io.out.valid)}")
    for(i <- 0 until lanes) {
      if (c.params.protoData.getClass.getTypeName == "chisel3.core.SInt") {
        expect(c.io.out.bits(i), goldenModelResult.regs(i), s"i $i, input $input, gm ${goldenModelResult.regs}, ${peek(c.io.out.bits)}")
      } else {
        // due to the series of multiply and accumulates, error actually blows up, let's be lenient
        val tolerance = 0.1
        fixTolLSBs.withValue(log2Ceil((goldenModelResult.regs(i).abs*tolerance).toInt+1)+dataBP+1) { // at least the integer part must match
          expect(c.io.out.bits(i), goldenModelResult.regs(i), s"i $i, input $input, gm ${goldenModelResult.regs}, ${peek(c.io.out.bits)}")
        }
      }
    }
  }
}
object SIntFFTBufferTester {
  def apply(params: FFTBufferParams[SInt], lanes: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new FFTBuffer(params)) {
        c => new FFTBufferTester(c, lanes, 0)
      }
    } else {
      dsptools.Driver.execute(() => new FFTBuffer(params), TestSetup.dspTesterOptions) {
        c => new FFTBufferTester(c, lanes, 0)
      }
    }
  }
}

object FixedPointFFTBufferTester {
  def apply(params: FFTBufferParams[FixedPoint], lanes: Int, dataBP: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new FFTBuffer(params)) {
        c => new FFTBufferTester(c, lanes, dataBP)
      }
    } else {
      dsptools.Driver.execute(() => new FFTBuffer(params), TestSetup.dspTesterOptions) {
        c => new FFTBufferTester(c, lanes, dataBP)
      }
    }
  }
}