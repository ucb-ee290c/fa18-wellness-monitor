package bandpower

import chisel3._
import org.scalatest.{FlatSpec, Matchers}

class BandpowerSpec extends FlatSpec with Matchers {
  behavior of "Bandpower"

  val params = new BandpowerParams[UInt] {
    val indStartBin = 13
    val indEndBin = 37
    val nBins = 64
    val genIn = UInt(16.W)
    val genOut = UInt(16.W)
  }

  it should "UInt bandpower (sum)" in {
    UIntBandpowerTester(params) should be (true)
  }
}