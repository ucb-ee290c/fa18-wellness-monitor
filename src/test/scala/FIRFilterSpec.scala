package firFilter

import chisel3._
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._
import org.scalatest.{FlatSpec, Matchers}

class FIRFilterSpec extends FlatSpec with Matchers {
  behavior of "ConstantCoefficientFIRFilter"

  val params = new FIRFilterParams[UInt] {
    val protoData = UInt(16.W)
    val taps = Seq(3.U, 1.U, 2.U, 5.U)
  }
  it should "UInt tomato" in {
    val coefficients = Seq(3,1,2,5)
    UIntFIRFilterTester(params, coefficients) should be (true)
  }




}
