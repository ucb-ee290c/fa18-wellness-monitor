package features

import chisel3._
import org.scalatest.{FlatSpec, Matchers}

class BandpowerSpec extends FlatSpec with Matchers {
  behavior of "Bandpower"

  val params = new BandpowerParams[UInt] {
    val idxStartBin = 0
    val idxEndBin = 63
    val nBins = 64
    val protoData = UInt(16.W)
  }

  it should "sum squares of inputs (UInt)" in {
    UIntBandpowerTester(params) should be (true)
  }
}