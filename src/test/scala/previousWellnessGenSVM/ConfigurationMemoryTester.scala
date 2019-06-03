/*
package wellness

import chisel3._
import dsptools.DspTester
import memorybuffer._

class ConfigurationMemoryTester[T <: chisel3.Data](c: ConfigurationMemory[SInt], params: ConfigurationMemoryParams[SInt]) extends DspTester(c) {
  val PCAVectorMemoryBuffer = new GoldenMemoryBuffer(c.pcaVectorMemoryParams.nColumns,c.pcaVectorMemoryParams.nRows)
  val PCANormalizationMemoryBuffer = new GoldenMemoryBuffer(c.pcaNormalizationMemoryParams.nColumns,c.pcaNormalizationMemoryParams.nRows)
  val SVMSupportVectorMemoryBuffer = new GoldenMemoryBuffer(c.svmSupportVectorMemoryParams.nColumns,c.svmSupportVectorMemoryParams.nRows)
  val SVMAlphaVectorMemoryBuffer = new GoldenMemoryBuffer(c.svmAlphaVectorMemoryParams.nColumns,c.svmAlphaVectorMemoryParams.nRows)
  val SVMInterceptMemoryBuffer = new GoldenMemoryBuffer(c.svmInterceptMemoryParams.nColumns,c.svmInterceptMemoryParams.nRows)
  val InputMuxSelMemoryBuffer = new GoldenMemoryBuffer(1,1)

  for(i <- 0 until ( (c.pcaVectorMemoryParams.nRows*c.pcaVectorMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20)
    val addr = 0

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.poke(input)
    val goldenModelResultSVMSupportVector = SVMSupportVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMAlphaVector = SVMAlphaVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMIntercept = SVMInterceptMemoryBuffer.idlePoke(input)
    val goldenModelResultInputMuxSel = InputMuxSelMemoryBuffer.idlePoke(input)
    val goldenModelResultPCANormalization = PCANormalizationMemoryBuffer.idlePoke(input)

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
    expect(c.io.out.bits.confInputMuxSel, goldenModelResultInputMuxSel.regs(0)(0))
    for(x <- 0 until c.pcaNormalizationMemoryParams.nColumns) {
      for (y <- 0 until c.pcaNormalizationMemoryParams.nRows) {
        expect(c.io.out.bits.confPCANormalizationData(x)(y), goldenModelResultPCANormalization.regs(x)(y))
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
    val goldenModelResultInputMuxSel = InputMuxSelMemoryBuffer.idlePoke(input)
    val goldenModelResultPCANormalization = PCANormalizationMemoryBuffer.idlePoke(input)

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
    expect(c.io.out.bits.confInputMuxSel, goldenModelResultInputMuxSel.regs(0)(0))
    for(x <- 0 until c.pcaNormalizationMemoryParams.nColumns) {
      for (y <- 0 until c.pcaNormalizationMemoryParams.nRows) {
        expect(c.io.out.bits.confPCANormalizationData(x)(y), goldenModelResultPCANormalization.regs(x)(y))
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
    val goldenModelResultInputMuxSel = InputMuxSelMemoryBuffer.idlePoke(input)
    val goldenModelResultPCANormalization = PCANormalizationMemoryBuffer.idlePoke(input)

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
    expect(c.io.out.bits.confInputMuxSel, goldenModelResultInputMuxSel.regs(0)(0))
    for(x <- 0 until c.pcaNormalizationMemoryParams.nColumns) {
      for (y <- 0 until c.pcaNormalizationMemoryParams.nRows) {
        expect(c.io.out.bits.confPCANormalizationData(x)(y), goldenModelResultPCANormalization.regs(x)(y))
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
    val goldenModelResultInputMuxSel = InputMuxSelMemoryBuffer.idlePoke(input)
    val goldenModelResultPCANormalization = PCANormalizationMemoryBuffer.idlePoke(input)

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
    expect(c.io.out.bits.confInputMuxSel, goldenModelResultInputMuxSel.regs(0)(0))
    for(x <- 0 until c.pcaNormalizationMemoryParams.nColumns) {
      for (y <- 0 until c.pcaNormalizationMemoryParams.nRows) {
        expect(c.io.out.bits.confPCANormalizationData(x)(y), goldenModelResultPCANormalization.regs(x)(y))
      }
    }
  }

  for(i <- 0 until 11 ) {
    val input = scala.util.Random.nextInt(2)
    val addr = 4

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMSupportVector = SVMSupportVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMAlphaVector = SVMAlphaVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMIntercept = SVMInterceptMemoryBuffer.idlePoke(input)
    val goldenModelResultInputMuxSel = InputMuxSelMemoryBuffer.poke(input)
    val goldenModelResultPCANormalization = PCANormalizationMemoryBuffer.idlePoke(input)

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
    expect(c.io.out.bits.confInputMuxSel, goldenModelResultInputMuxSel.regs(0)(0))
    for(x <- 0 until c.pcaNormalizationMemoryParams.nColumns) {
      for (y <- 0 until c.pcaNormalizationMemoryParams.nRows) {
        expect(c.io.out.bits.confPCANormalizationData(x)(y), goldenModelResultPCANormalization.regs(x)(y))
      }
    }
  }

  for(i <- 0 until 11 ) {
    val input = scala.util.Random.nextInt(2)
    val addr = 5

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMSupportVector = SVMSupportVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMAlphaVector = SVMAlphaVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultSVMIntercept = SVMInterceptMemoryBuffer.idlePoke(input)
    val goldenModelResultInputMuxSel = InputMuxSelMemoryBuffer.idlePoke(input)
    val goldenModelResultPCANormalization = PCANormalizationMemoryBuffer.poke(input)

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
    expect(c.io.out.bits.confInputMuxSel, goldenModelResultInputMuxSel.regs(0)(0))
    for(x <- 0 until c.pcaNormalizationMemoryParams.nColumns) {
      for (y <- 0 until c.pcaNormalizationMemoryParams.nRows) {
        expect(c.io.out.bits.confPCANormalizationData(x)(y), goldenModelResultPCANormalization.regs(x)(y))
      }
    }
  }
}

object ConfigurationMemoryTester {
  def apply(params: ConfigurationMemoryParams[SInt], debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new ConfigurationMemory(params)) {
        c => new ConfigurationMemoryTester(c, params)
      }
    } else {
      dsptools.Driver.execute(() => new ConfigurationMemory(params), TestSetup.dspTesterOptions) {
        c => new ConfigurationMemoryTester(c, params)
      }
    }
  }
}
*/