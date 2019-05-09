package wellness

import chisel3._
import dsptools.DspTester
import memorybuffer._

class ConfigurationMemoryTester[T <: chisel3.Data](c: ConfigurationMemory[SInt], params: ConfigurationMemoryParams[SInt]) extends DspTester(c) {
  val PCAVectorMemoryBuffer = new GoldenMemoryBuffer(c.pcaVectorMemoryParams.nColumns,c.pcaVectorMemoryParams.nRows)
  val PCANormalizationMemoryBuffer = new GoldenMemoryBuffer(c.pcaNormalizationMemoryParams.nColumns,c.pcaNormalizationMemoryParams.nRows)
  val logisticWeightsVectorMemoryBuffer = new GoldenMemoryBuffer(c.logisticWeightsVectorMemoryParams.nColumns,c.logisticWeightsVectorMemoryParams.nRows)
  val logisticInterceptMemoryBuffer = new GoldenMemoryBuffer(c.logisticInterceptMemoryParams.nColumns,c.logisticInterceptMemoryParams.nRows)
  val InputMuxSelMemoryBuffer = new GoldenMemoryBuffer(1,1)

  for(i <- 0 until ( (c.pcaVectorMemoryParams.nRows*c.pcaVectorMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20)
    val addr = 0

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.poke(input)
    val goldenModelResultLogisticWeightsVector = logisticWeightsVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultLogisticInterceptVector = logisticInterceptMemoryBuffer.idlePoke(input)
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
    for(x <- 0 until c.logisticWeightsVectorMemoryParams.nColumns) {
      for (y <- 0 until c.logisticWeightsVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confLogisticWeightsVector(x)(y), goldenModelResultLogisticWeightsVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.logisticInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.logisticInterceptMemoryParams.nRows) {
        expect(c.io.out.bits.confLogisticIntercept(x)(y), goldenModelResultLogisticInterceptVector.regs(x)(y))
      }
    }
    expect(c.io.out.bits.confInputMuxSel, goldenModelResultInputMuxSel.regs(0)(0))
    for(x <- 0 until c.pcaNormalizationMemoryParams.nColumns) {
      for (y <- 0 until c.pcaNormalizationMemoryParams.nRows) {
        expect(c.io.out.bits.confPCANormalizationData(x)(y), goldenModelResultPCANormalization.regs(x)(y))
      }
    }
  }

  for(i <- 0 until ( (c.logisticWeightsVectorMemoryParams.nRows*c.logisticWeightsVectorMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20) - 10
    val addr = 1

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultLogisticWeightsVector = logisticWeightsVectorMemoryBuffer.poke(input)
    val goldenModelResultLogisticIntercept = logisticInterceptMemoryBuffer.idlePoke(input)
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
    for(x <- 0 until c.logisticWeightsVectorMemoryParams.nColumns) {
      for (y <- 0 until c.logisticWeightsVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confLogisticWeightsVector(x)(y), goldenModelResultLogisticWeightsVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.logisticInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.logisticInterceptMemoryParams.nRows) {
        expect(c.io.out.bits.confLogisticIntercept(x)(y), goldenModelResultLogisticIntercept.regs(x)(y))
      }
    }
    expect(c.io.out.bits.confInputMuxSel, goldenModelResultInputMuxSel.regs(0)(0))
    for(x <- 0 until c.pcaNormalizationMemoryParams.nColumns) {
      for (y <- 0 until c.pcaNormalizationMemoryParams.nRows) {
        expect(c.io.out.bits.confPCANormalizationData(x)(y), goldenModelResultPCANormalization.regs(x)(y))
      }
    }
  }

  for(i <- 0 until ( (c.logisticInterceptMemoryParams.nRows*c.logisticInterceptMemoryParams.nColumns)*10 + 1)) {
    val input = scala.util.Random.nextInt(20) - 10
    val addr = 2

    val goldenModelResultPCAVector = PCAVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultLogisticWeightsVector = logisticWeightsVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultLogisticIntercept = logisticInterceptMemoryBuffer.idlePoke(input)
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
    for(x <- 0 until c.logisticWeightsVectorMemoryParams.nColumns) {
      for (y <- 0 until c.logisticWeightsVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confLogisticWeightsVector(x)(y), goldenModelResultLogisticWeightsVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.logisticInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.logisticInterceptMemoryParams.nRows) {
        expect(c.io.out.bits.confLogisticIntercept(x)(y), goldenModelResultLogisticIntercept.regs(x)(y))
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
    val goldenModelResultLogisticWeightsVector = logisticWeightsVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultLogisticIntercept = logisticInterceptMemoryBuffer.idlePoke(input)
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
    for(x <- 0 until c.logisticWeightsVectorMemoryParams.nColumns) {
      for (y <- 0 until c.logisticWeightsVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confLogisticWeightsVector(x)(y), goldenModelResultLogisticWeightsVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.logisticInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.logisticInterceptMemoryParams.nRows) {
        expect(c.io.out.bits.confLogisticIntercept(x)(y), goldenModelResultLogisticIntercept.regs(x)(y))
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
    val goldenModelResultLogisticWeightsVector = logisticWeightsVectorMemoryBuffer.idlePoke(input)
    val goldenModelResultLogisticIntercept = logisticInterceptMemoryBuffer.idlePoke(input)
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
    for(x <- 0 until c.logisticWeightsVectorMemoryParams.nColumns) {
      for (y <- 0 until c.logisticWeightsVectorMemoryParams.nRows) {
        expect(c.io.out.bits.confLogisticWeightsVector(x)(y), goldenModelResultLogisticWeightsVector.regs(x)(y))
      }
    }
    for(x <- 0 until c.logisticInterceptMemoryParams.nColumns) {
      for (y <- 0 until c.logisticInterceptMemoryParams.nRows) {
        expect(c.io.out.bits.confLogisticIntercept(x)(y), goldenModelResultLogisticIntercept.regs(x)(y))
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