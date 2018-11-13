package features

import chisel3._
import org.scalatest.{FlatSpec, Matchers}

class BandpowerSpec extends FlatSpec with Matchers {
  behavior of "Bandpower"

  val params = new BandpowerParams[UInt] {
    val idxStartBin = 13
    val idxEndBin = 37
    val nBins = 64
    val protoData = UInt(16.W)
  }

  it should "sum squares of inputs (UInt)" in {
    UIntBandpowerTester(params) should be (true)
  }
}