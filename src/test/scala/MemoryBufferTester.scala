package memorybuffer

import wellness._
import chisel3._
import chisel3.core.FixedPoint
import chisel3.util.log2Ceil
import dsptools.numbers._
import dsptools.DspTester

import scala.collection.mutable

class outBundle(nColumns:Int, nRows:Int) {
  val regs = mutable.Buffer.fill(nColumns,nRows)(0.toDouble)
  var valid : Boolean = false
}

class GoldenMemoryBuffer(nColumns:Int, nRows:Int) {
  val totalSize = nRows * nColumns
  var pseudoRegisters = List.fill(totalSize)(0.toDouble)

  val out = new outBundle(nColumns, nRows)

  var counter = 0
  def poke(value: Double): outBundle = {
    pseudoRegisters = value :: pseudoRegisters.take(totalSize - 1)

    for(x <- 0 until nColumns) {
      for (y <- 0 until nRows) {
        out.regs(x)(y) = pseudoRegisters((x * nRows) + y)
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
  def idlePoke(value: Double): outBundle = {

    for(x <- 0 until nColumns) {
      for (y <- 0 until nRows) {
        out.regs(x)(y) = pseudoRegisters((x * nRows) + y)
      }
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

class MemoryBufferTester[T <: chisel3.Data](c: MemoryBuffer[T], params: MemoryBufferParams[T], dataBP: Int, testType: Int) extends DspTester(c) {
  val MemoryBuffer = new GoldenMemoryBuffer(params.nColumns, params.nRows)

  for(i <- 0 until (params.nRows*params.nColumns + 1)) {
    var input = scala.util.Random.nextFloat*20
    if (testType == 0) {
      input = scala.util.Random.nextInt(20)
    }

    val goldenModelResult = MemoryBuffer.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, true)

    step(1)

    expect(c.io.out.valid, goldenModelResult.valid)
    for(x <- 0 until params.nColumns) {
      for (y <- 0 until params.nRows) {
        if (testType == 0) {
          expect(c.io.out.bits(x)(y), goldenModelResult.regs(x)(y))
        } else {
          val tolerance = 0
          fixTolLSBs.withValue(log2Ceil((goldenModelResult.regs(x)(y).abs*tolerance).toInt+1)+dataBP+1) {
            expect(c.io.out.bits(x)(y), goldenModelResult.regs(x)(y))
          }
        }
      }
    }
  }
}

object UIntMemoryBufferTester {
  def apply(params: MemoryBufferParams[SInt], debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new MemoryBuffer(params)) {
        c => new MemoryBufferTester(c, params, 0,0)
      }
    } else {
      dsptools.Driver.execute(() => new MemoryBuffer(params), TestSetup.dspTesterOptions) {
        c => new MemoryBufferTester(c, params, 0,0)
      }
    }
  }
}

object FixedPointMemoryBufferTester {
  def apply(params: MemoryBufferParams[FixedPoint], dataBP: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new MemoryBuffer(params)) {
        c => new MemoryBufferTester(c, params, dataBP, 1)
      }
    } else {
      dsptools.Driver.execute(() => new MemoryBuffer(params), TestSetup.dspTesterOptions) {
        c => new MemoryBufferTester(c, params, dataBP,1)
      }
    }
  }
}