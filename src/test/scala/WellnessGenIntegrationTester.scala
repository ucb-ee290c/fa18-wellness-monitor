package wellness

import breeze.math.Complex
import chisel3._
import chisel3.experimental.FixedPoint
import chisel3.util.log2Ceil
import dsptools.DspTester
import dsptools.numbers._
import firFilter._
import fft._
import features._
import pca._
import memorybuffer._
import svm._
import freechips.rocketchip.config.Parameters

import scala.collection.mutable.ArrayBuffer
import scala.collection.Seq

class wellnessGenTester[T <: chisel3.Data](c: wellnessGenModule[T],
                                           goldenModelParameters: wellnessGenIntegrationParameterBundle,
                                           dataBP: Int, testType: Int) extends DspTester(c) {

  // Instantiate golden models
  val filter1 = new GoldenDoubleFIRFilter(goldenModelParameters.filter1Params.taps)
  var filter1Result = filter1.poke(0)

  for (i <- 0 until 100) {
    val input = scala.util.Random.nextInt(16)
    filter1Result = filter1.poke(input)

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)
    step(1)

    expect(c.io.out.bits, filter1Result)
  }
}


object wellnessGenIntegrationTesterSInt {
  implicit val p: Parameters = null
  def apply(filter1Params: FIRFilterParams[SInt],
            x: Int,
            goldenModelParameters: wellnessGenIntegrationParameterBundle, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new wellnessGenModule(
        filter1Params: FIRFilterParams[SInt],
        x: Int)) {
        c => new wellnessGenTester(c, goldenModelParameters, 0,0)
      }
    } else {
      dsptools.Driver.execute(() => new wellnessGenModule(
        filter1Params: FIRFilterParams[SInt],
        x: Int),
        TestSetup.dspTesterOptions) {
        c => new wellnessGenTester(c, goldenModelParameters, 0, 0)
      }
    }
  }
}
