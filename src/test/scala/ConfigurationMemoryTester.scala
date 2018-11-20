package wellness

import breeze.numerics.pow
import chisel3._
import dsptools.DspTester
import memorybuffer._

import scala.collection.mutable

class ConfigurationMemoryTester[T <: chisel3.Data](c: ConfigurationMemory[SInt], params: ConfigurationMemoryParams[SInt]) extends DspTester(c) {
  val PCAVectorMemoryBuffer = new GoldenMemoryBuffer(c.pcaVectorMemoryParams.nColumns,c.pcaVectorMemoryParams.nRows)
  val SVMSupportVectorMemoryBuffer = new GoldenMemoryBuffer(c.svmSupportVectorMemoryParams.nColumns,c.svmSupportVectorMemoryParams.nRows)
  val SVMAlphaVectorMemoryBuffer = new GoldenMemoryBuffer(c.svmAlphaVectorMemoryParams.nColumns,c.svmAlphaVectorMemoryParams.nRows)
  val SVMInterceptMemoryBuffer = new GoldenMemoryBuffer(c.svmInterceptMemoryParams.nColumns,c.svmInterceptMemoryParams.nRows)

  for(i <- 0 until ( (c.pcaVectorMemoryParams.nRows*c.pcaVectorMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20)
    val addr = 0

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.poke(input)
    val goldenModelResultSVMSupportVector = SVMSupportVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMAlphaVector = SVMAlphaVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMIntercept = SVMInterceptMemoryBuffer.idlePoke(input)

    val inputBundle = new ConfigurationMemoryBundle[SInt](params) {
      override val wrdata: SInt = input.asSInt()
      override val wraddr = addr.asUInt()
    }
    poke(c.io.in.bits.wrdata, inputBundle.wrdata)
    poke(c.io.in.bits.wraddr, inputBundle.wraddr)
    poke(c.io.in.valid, true)

    step(1)

    for(x <- 0 until c.pcaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.pcaVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confPCAVector(x)(y), goldenModelResultPCAVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmSupportVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmSupportVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMSupportVector(x)(y), goldenModelResultSVMSupportVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmAlphaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmAlphaVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMAlphaVector(x)(y), goldenModelResultSVMAlphaVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.svmInterceptMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMIntercept(y), goldenModelResultSVMIntercept.regs(x)(y))
      }
    }
  }

  for(i <- 0 until ( (c.svmSupportVectorMemoryParams.nRows*c.svmSupportVectorMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20) - 10
    val addr = 1

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMSupportVector = SVMSupportVectorMemoryBuffer.poke(input)
    val goldenModelResultSVMAlphaVector = SVMAlphaVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMIntercept = SVMInterceptMemoryBuffer.idlePoke(input)

    val inputBundle = new ConfigurationMemoryBundle[SInt](params) {
      override val wrdata: SInt = input.asSInt()
      override val wraddr = addr.asUInt()
    }
    poke(c.io.in.bits.wrdata, inputBundle.wrdata)
    poke(c.io.in.bits.wraddr, inputBundle.wraddr)
    poke(c.io.in.valid, true)

    step(1)

    for(x <- 0 until c.pcaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.pcaVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confPCAVector(x)(y), goldenModelResultPCAVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmSupportVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmSupportVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMSupportVector(x)(y), goldenModelResultSVMSupportVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmAlphaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmAlphaVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMAlphaVector(x)(y), goldenModelResultSVMAlphaVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.svmInterceptMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMIntercept(y), goldenModelResultSVMIntercept.regs(x)(y))
      }
    }
  }

  for(i <- 0 until ( (c.svmInterceptMemoryParams.nRows*c.svmInterceptMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20) - 10
    val addr = 2

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMSupportVector = SVMSupportVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMAlphaVector = SVMAlphaVectorMemoryBuffer.poke(input)
    val goldenModelResultSVMIntercept = SVMInterceptMemoryBuffer.idlePoke(input)

    val inputBundle = new ConfigurationMemoryBundle[SInt](params) {
      override val wrdata: SInt = input.asSInt()
      override val wraddr = addr.asUInt()
    }
    poke(c.io.in.bits.wrdata, inputBundle.wrdata)
    poke(c.io.in.bits.wraddr, inputBundle.wraddr)
    poke(c.io.in.valid, true)

    step(1)

    for(x <- 0 until c.pcaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.pcaVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confPCAVector(x)(y), goldenModelResultPCAVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmSupportVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmSupportVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMSupportVector(x)(y), goldenModelResultSVMSupportVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmAlphaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmAlphaVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMAlphaVector(x)(y), goldenModelResultSVMAlphaVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.svmInterceptMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMIntercept(y), goldenModelResultSVMIntercept.regs(x)(y))
      }
    }
  }

  for(i <- 0 until ( (c.svmAlphaVectorMemoryParams.nRows*c.svmAlphaVectorMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20) - 10
    val addr = 3

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMSupportVector = SVMSupportVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMAlphaVector = SVMAlphaVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMIntercept = SVMInterceptMemoryBuffer.poke(input)

    val inputBundle = new ConfigurationMemoryBundle[SInt](params) {
      override val wrdata: SInt = input.asSInt()
      override val wraddr = addr.asUInt()
    }
    poke(c.io.in.bits.wrdata, inputBundle.wrdata)
    poke(c.io.in.bits.wraddr, inputBundle.wraddr)
    poke(c.io.in.valid, true)

    step(1)

    for(x <- 0 until c.pcaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.pcaVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confPCAVector(x)(y), goldenModelResultPCAVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmSupportVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmSupportVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMSupportVector(x)(y), goldenModelResultSVMSupportVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmAlphaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmAlphaVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMAlphaVector(x)(y), goldenModelResultSVMAlphaVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.svmInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.svmInterceptMemoryParams.nRows) {
        expect(c.io.out.bits.confSVMIntercept(y), goldenModelResultSVMIntercept.regs(x)(y))
      }
    }
  }
}

object ConfigurationMemoryTester {
  def apply(params: ConfigurationMemoryParams[SInt]): Boolean = {
    //chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConfigurationMemory(params)) {
    dsptools.Driver.execute(() => new ConfigurationMemory(params), TestSetup.dspTesterOptions) {
      c => new ConfigurationMemoryTester(c, params)
    }
  }
}