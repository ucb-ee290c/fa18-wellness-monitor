package features

import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers.DspComplex
import org.scalatest.{FlatSpec, Matchers}

class BandpowerSpec extends FlatSpec with Matchers {
  behavior of "Bandpower"

  it should "sum squares of inputs (UInt)" in {
    val debug = 0

    val params = new BandpowerParams[UInt] {
      val idxStartBin = 0
      val idxEndBin = 64
      val nBins = 128
      val genIn = DspComplex(UInt(16.W), UInt(16.W))
      val genOut = UInt(16.W)
    }

    UIntBandpowerTester(params, debug) should be (true)
  }

  it should "sum squares of inputs (FixedPoint)" in {
    val debug = 0

    val dataWidth = 35
    val dataBP = 19
    val params = new BandpowerParams[FixedPoint] {
      val idxStartBin = 0
      val idxEndBin = 64
      val nBins = 128
      val genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP))
      val genOut = FixedPoint(dataWidth.W, dataBP.BP)
    }

    FixedPointBandpowerTester(params, dataBP, debug) should be (true)
  }
}