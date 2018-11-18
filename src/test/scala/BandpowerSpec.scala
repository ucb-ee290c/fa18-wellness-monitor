package features

import chisel3._
import chisel3.core.FixedPoint
import org.scalatest.{FlatSpec, Matchers}

class BandpowerSpec extends FlatSpec with Matchers {
  behavior of "Bandpower"

  it should "sum squares of inputs (UInt)" in {
    val params = new BandpowerParams[UInt] {
      val idxStartBin = 0
      val idxEndBin = 63
      val nBins = 64
      val protoData = UInt(16.W)
    }

    UIntBandpowerTester(params) should be (true)
  }

  it should "sum squares of inputs (FixedPoint)" in {
    val params = new BandpowerParams[FixedPoint] {
      val idxStartBin = 0
      val idxEndBin = 63
      val nBins = 64
      val protoData = FixedPoint(35.W, 19.BP)
    }

    FixedPointBandpowerTester(params) should be (true)
  }
}