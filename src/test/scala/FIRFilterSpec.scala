package firFilter

import chisel3._
import chisel3.core.FixedPoint
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._
import org.scalatest.{FlatSpec, Matchers}

import scala.collection.mutable

class FIRFilterSpec extends FlatSpec with Matchers {
  behavior of "ConstantCoefficientFIRFilter"

  it should "multiply its input stream with correct coefficients at correct timesteps (UInt)" in {

    for(i <- 0 until 15) {
      val tap_count = scala.util.Random.nextInt(50) + 1

      val coefficients = mutable.ArrayBuffer[Int]()
      for(j <- 0 until tap_count) coefficients += scala.util.Random.nextInt(16)
      val params = new FIRFilterParams[UInt] {
        val protoData = UInt(16.W)
        val taps = coefficients.map(_.asUInt(16.W))
      }

      UIntFIRFilterTester(params, coefficients) should be (true)
    }
  }

  it should "multiply its input stream with correct coefficients at correct timesteps (SInt)" in {

    for(i <- 0 until 15) {
      val tap_count = scala.util.Random.nextInt(50) + 1

      val coefficients = mutable.ArrayBuffer[Int]()
      for(j <- 0 until tap_count) coefficients += (-32 + scala.util.Random.nextInt(64))
      val params = new FIRFilterParams[SInt] {
        val protoData = SInt(16.W)
        val taps = coefficients.map(_.asSInt(16.W))
      }

      SIntFIRFilterTester(params, coefficients) should be (true)
    }
  }

  it should "multiply its input stream with correct coefficients at correct timesteps (FixedPoint)" in {

    for(i <- 0 until 15) {
      val tap_count = scala.util.Random.nextInt(50) + 1
      val dataWidth = 32 + 2*i
      val dataBP = 16 + i

      val coefficients = mutable.ArrayBuffer[Double]()
      for(j <- 0 until tap_count) coefficients += (-32 + scala.util.Random.nextFloat * 64)
      val params = new FIRFilterParams[FixedPoint] {
        val protoData = FixedPoint(dataWidth.W,dataBP.BP)
        val taps = coefficients.toList.map(ConvertableTo[FixedPoint].fromDouble(_))
      }

      FixedPointFIRFilterTester(params, coefficients, dataWidth, dataBP) should be (true)
    }
  }
}