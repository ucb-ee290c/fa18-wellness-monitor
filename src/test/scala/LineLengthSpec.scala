package features

import breeze.numerics.pow
import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._
import org.scalatest.{FlatSpec, Matchers}

import scala.collection.mutable

class LineLengthSpec extends FlatSpec with Matchers {
  behavior of "lineLength"

  it should "multiply its input stream with correct coefficients at correct timesteps (UInt)" in {

    for(i <- 0 until 15) {
      val window_size = pow(2,scala.util.Random.nextInt(6) + 1)

      val params = new lineLengthParams[UInt] {
        val protoData = UInt(16.W)
        val windowSize = window_size
      }

      UIntLineLengthTester(params, window_size) should be (true)
    }
  }

  it should "multiply its input stream with correct coefficients at correct timesteps (SInt)" in {

    for(i <- 0 until 15) {
      val window_size = pow(2,scala.util.Random.nextInt(6) + 1)

      val params = new lineLengthParams[SInt] {
        val protoData = SInt(16.W)
        val windowSize = window_size
      }

      SIntLineLengthTester(params, window_size) should be (true)
    }
  }

  it should "multiply its input stream with correct coefficients at correct timesteps (FixedPoint)" in {

    for(i <- 0 until 15) {
      val window_size = pow(2,scala.util.Random.nextInt(6) + 1)
      val dataWidth = 32 + 2*i
      val dataBP = 16 + i

      val params = new lineLengthParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W,dataBP.BP)
        val windowSize = window_size
      }

      FixedPointLineLengthTester(params, window_size) should be (true)
    }
  }
}