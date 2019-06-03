package features

import breeze.numerics.pow
import chisel3._
import chisel3.core.FixedPoint
import org.scalatest.{FlatSpec, Matchers}

class sumSquaresSpec extends FlatSpec with Matchers {
  behavior of "sumSquares"

  it should "multiply its input stream with correct coefficients at correct timesteps (UInt)" in {
    val debug = 0

    for(i <- 0 until 15) {
      val window_size = pow(2,scala.util.Random.nextInt(6) + 1)

      val params = new sumSquaresParams[UInt] {
        val protoData = UInt(16.W)
        val windowSize = window_size
      }

      UIntSumSquaresTester(params, window_size, debug) should be (true)
    }
  }

  it should "multiply its input stream with correct coefficients at correct timesteps (SInt)" in {
    val debug = 0

    for(i <- 0 until 15) {
      val window_size = pow(2,scala.util.Random.nextInt(6) + 1)

      val params = new sumSquaresParams[SInt] {
        val protoData = SInt(16.W)
        val windowSize = window_size
      }

      SIntSumSquaresTester(params, window_size, debug) should be (true)
    }
  }

  it should "multiply its input stream with correct coefficients at correct timesteps (FixedPoint)" in {
    val debug = 0

    for(i <- 0 until 15) {
      val window_size = pow(2,scala.util.Random.nextInt(6) + 1)
      val dataWidth = 32 + 2*i
      val dataBP = 16 + i

      val params = new sumSquaresParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W,dataBP.BP)
        val windowSize = window_size
      }

      FixedPointSumSquaresTester(params, window_size, dataBP, debug) should be (true)
    }
  }
}