package firFilter

import chisel3._
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._
import org.scalatest.{FlatSpec, Matchers}

import scala.collection.mutable

class FIRFilterSpec extends FlatSpec with Matchers {
  behavior of "ConstantCoefficientFIRFilter"

  it should "UInt tomato" in {

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


}
