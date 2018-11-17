package wellness

import breeze.numerics.pow
import chisel3._
import dsptools.DspTester
import memorybuffer._

import scala.collection.mutable

class ConfigurationMemoryTester[T <: chisel3.Data](c: ConfigurationMemory[SInt], params: ConfigurationMemoryParams[SInt]) extends DspTester(c) {
  val PCAVectorMemoryBuffer = new GoldenIntMemoryBuffer(c.pcaVectorMemoryParams)
  val SVMSupportVectorMemoryBuffer = new GoldenIntMemoryBuffer(c.svmSupportVectorMemoryParams)
  val SVMAlphaVectorMemoryBuffer = new GoldenIntMemoryBuffer(c.svmAlphaVectorMemoryParams)
  val SVMInterceptMemoryBuffer = new GoldenIntMemoryBuffer(c.svmInterceptMemoryParams)

  for(i <- 0 until ( (c.pcaVectorMemoryParams.nRows*c.pcaVectorMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20)

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.poke(input)
    val goldenModelResultSVMSupportVector = SVMSupportVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMAlphaVector = SVMAlphaVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMIntercept = SVMInterceptMemoryBuffer.idlePoke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, true)

    step(1)

    expect(c.io.memOutPCAVector.valid, goldenModelResultPCAVector.valid)
    for(x <- 0 until c.pcaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.pcaVectorMemoryParams.nRows) {
        expect(c.io.memOutPCAVector.bits(x)(y), goldenModelResultPCAVector.regs(x)(y))
      }
    }
    expect(c.io.memOutSVMSupportVector.valid, goldenModelResultSVMSupportVector.valid)
    for(x <- 0 until c.svmSupportVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmSupportVectorMemoryParams.nRows) {
        expect(c.io.memOutSVMSupportVector.bits(x)(y), goldenModelResultSVMSupportVector.regs(x)(y))
      }
    }
    expect(c.io.memOutSVMAlphaVector.valid, goldenModelResultSVMAlphaVector.valid)
    for(x <- 0 until c.svmAlphaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmAlphaVectorMemoryParams.nRows) {
        expect(c.io.memOutSVMAlphaVector.bits(x)(y), goldenModelResultSVMAlphaVector.regs(x)(y))
      }
    }
    //expect(c.io.memOutSVMIntercept.valid, goldenModelResultSVMIntercept.valid)
    for(x <- 0 until c.svmInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.svmInterceptMemoryParams.nRows) {
        expect(c.io.memOutSVMIntercept.bits(y), goldenModelResultSVMIntercept.regs(x)(y))
      }
    }
  }

  for(i <- 0 until ( (c.svmSupportVectorMemoryParams.nRows*c.svmSupportVectorMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20) + (1 * pow(2,30))

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMSupportVector = SVMSupportVectorMemoryBuffer.poke(input)
    val goldenModelResultSVMAlphaVector = SVMAlphaVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMIntercept = SVMInterceptMemoryBuffer.idlePoke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, true)

    step(1)

    expect(c.io.memOutPCAVector.valid, goldenModelResultPCAVector.valid)
    for(x <- 0 until c.pcaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.pcaVectorMemoryParams.nRows) {
        expect(c.io.memOutPCAVector.bits(x)(y), goldenModelResultPCAVector.regs(x)(y))
      }
    }
    expect(c.io.memOutSVMSupportVector.valid, goldenModelResultSVMSupportVector.valid)
    for(x <- 0 until c.svmSupportVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmSupportVectorMemoryParams.nRows) {
        expect(c.io.memOutSVMSupportVector.bits(x)(y), goldenModelResultSVMSupportVector.regs(x)(y))
      }
    }
    expect(c.io.memOutSVMAlphaVector.valid, goldenModelResultSVMAlphaVector.valid)
    for(x <- 0 until c.svmAlphaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmAlphaVectorMemoryParams.nRows) {
        expect(c.io.memOutSVMAlphaVector.bits(x)(y), goldenModelResultSVMAlphaVector.regs(x)(y))
      }
    }
    //expect(c.io.memOutSVMIntercept.valid, goldenModelResultSVMIntercept.valid)
    for(x <- 0 until c.svmInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.svmInterceptMemoryParams.nRows) {
        expect(c.io.memOutSVMIntercept.bits(y), goldenModelResultSVMIntercept.regs(x)(y))
      }
    }
  }

  for(i <- 0 until ( (c.svmInterceptMemoryParams.nRows*c.svmInterceptMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20) + (3 * pow(2,30))

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMSupportVector = SVMSupportVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMAlphaVector = SVMAlphaVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMIntercept = SVMInterceptMemoryBuffer.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, true)

    step(1)

    expect(c.io.memOutPCAVector.valid, goldenModelResultPCAVector.valid)
    for(x <- 0 until c.pcaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.pcaVectorMemoryParams.nRows) {
        expect(c.io.memOutPCAVector.bits(x)(y), goldenModelResultPCAVector.regs(x)(y))
      }
    }
    expect(c.io.memOutSVMSupportVector.valid, goldenModelResultSVMSupportVector.valid)
    for(x <- 0 until c.svmSupportVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmSupportVectorMemoryParams.nRows) {
        expect(c.io.memOutSVMSupportVector.bits(x)(y), goldenModelResultSVMSupportVector.regs(x)(y))
      }
    }
    expect(c.io.memOutSVMAlphaVector.valid, goldenModelResultSVMAlphaVector.valid)
    for(x <- 0 until c.svmAlphaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmAlphaVectorMemoryParams.nRows) {
        expect(c.io.memOutSVMAlphaVector.bits(x)(y), goldenModelResultSVMAlphaVector.regs(x)(y))
      }
    }
    //expect(c.io.memOutSVMIntercept.valid, goldenModelResultSVMIntercept.valid)
    for(x <- 0 until c.svmInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.svmInterceptMemoryParams.nRows) {
        expect(c.io.memOutSVMIntercept.bits(y), goldenModelResultSVMIntercept.regs(x)(y))
      }
    }
  }

  for(i <- 0 until ( (c.svmAlphaVectorMemoryParams.nRows*c.svmAlphaVectorMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20) + (2 * pow(2,30))

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMSupportVector = SVMSupportVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMAlphaVector = SVMAlphaVectorMemoryBuffer.poke(input)
    val goldenModelResultSVMIntercept = SVMInterceptMemoryBuffer.idlePoke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, true)

    step(1)

    expect(c.io.memOutPCAVector.valid, goldenModelResultPCAVector.valid)
    for(x <- 0 until c.pcaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.pcaVectorMemoryParams.nRows) {
        expect(c.io.memOutPCAVector.bits(x)(y), goldenModelResultPCAVector.regs(x)(y))
      }
    }
    expect(c.io.memOutSVMSupportVector.valid, goldenModelResultSVMSupportVector.valid)
    for(x <- 0 until c.svmSupportVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmSupportVectorMemoryParams.nRows) {
        expect(c.io.memOutSVMSupportVector.bits(x)(y), goldenModelResultSVMSupportVector.regs(x)(y))
      }
    }
    expect(c.io.memOutSVMAlphaVector.valid, goldenModelResultSVMAlphaVector.valid)
    for(x <- 0 until c.svmAlphaVectorMemoryParams.nColumns) {
      for (y <- 0 until c.svmAlphaVectorMemoryParams.nRows) {
        expect(c.io.memOutSVMAlphaVector.bits(x)(y), goldenModelResultSVMAlphaVector.regs(x)(y))
      }
    }
    //expect(c.io.memOutSVMIntercept.valid, goldenModelResultSVMIntercept.valid)
    for(x <- 0 until c.svmInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.svmInterceptMemoryParams.nRows) {
        expect(c.io.memOutSVMIntercept.bits(y), goldenModelResultSVMIntercept.regs(x)(y))
      }
    }
  }
}

object ConfigurationMemoryTester {
  def apply(params: ConfigurationMemoryParams[SInt]): Boolean = {
    chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConfigurationMemory(params)) {
    //dsptools.Driver.execute(() => new ConfigurationMemory(params), TestSetup.dspTesterOptions) {
      c => new ConfigurationMemoryTester(c, params)
    }
  }
}