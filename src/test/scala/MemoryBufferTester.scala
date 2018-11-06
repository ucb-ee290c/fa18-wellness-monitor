package memorybuffer

import chisel3._
import dsptools.numbers._
import dsptools.DspTester

import scala.collection.mutable

class outBundle(params: MemoryBufferParams[SInt]) {
  val regs = mutable.Buffer.fill(params.nColumns,params.nRows)(0)
  var valid : Boolean = false
}

class GoldenIntMemoryBuffer(params: MemoryBufferParams[SInt]) {
  val totalSize = params.nRows * params.nColumns
  var pseudoRegisters = List.fill(totalSize)(0)

  val out = new outBundle(params)

  var counter = 0
  def poke(value: Int): outBundle = {
    pseudoRegisters = value :: pseudoRegisters.take(totalSize - 1)

    for(x <- 0 until params.nColumns) {
      for (y <- 0 until params.nRows) {
        out.regs(x)(y) = pseudoRegisters((x * params.nRows) + y)
      }
    }

    if(counter == totalSize) {
      counter = 1
    }
    else {
      counter = counter + 1
    }

    if(counter == totalSize) {
      out.valid = true
    }
    else {
      out.valid = false
    }
    out
  }
}

class MemoryBufferTester[T <: chisel3.Data](c: MemoryBuffer[T], params: MemoryBufferParams[SInt]) extends DspTester(c) {
  val MemoryBuffer = new GoldenIntMemoryBuffer(params)

  for(i <- 0 until (params.nRows*params.nColumns + 1)) {
    val input = scala.util.Random.nextInt(20)-10

    val goldenModelResult = MemoryBuffer.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, true)

    step(1)

    expect(c.io.out.valid, goldenModelResult.valid)
    for(x <- 0 until params.nColumns) {
      for (y <- 0 until params.nRows) {
        expect(c.io.out.bits(x)(y), goldenModelResult.regs(x)(y))
      }
    }
  }
}
object MemoryBufferTester {
  def apply(params: MemoryBufferParams[SInt]): Boolean = {
    chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new MemoryBuffer(params)) {
      c => new MemoryBufferTester(c, params)
    }
  }
}