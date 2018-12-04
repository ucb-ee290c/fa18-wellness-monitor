package features

import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers.DspComplex
import org.scalatest.{FlatSpec, Matchers}

class BandpowerSpec extends FlatSpec with Matchers {
  behavior of "Bandpower"

  it should "calc average bandpower in slice (UInt)" in {
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

  it should "calc average bandpower 1 in slice (FixedPoint)" in {
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

  it should "calc average bandpower 2 in slice (FixedPoint)" in {
    val debug = 0

    val dataWidth = 35
    val dataBP = 19
    val params = new BandpowerParams[FixedPoint] {
      val idxStartBin = 32
      val idxEndBin = 64
      val nBins = 128
      val genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP))
      val genOut = FixedPoint(dataWidth.W, dataBP.BP)
    }

    FixedPointBandpowerTester(params, dataBP, debug) should be (true)
  }

  it should "calc average bandpower 3 in slice (FixedPoint)" in {
    val debug = 0

    val dataWidth = 35
    val dataBP = 19
    val params = new BandpowerParams[FixedPoint] {
      val idxStartBin = 25
      val idxEndBin = 89
      val nBins = 256
      val genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP))
      val genOut = FixedPoint(dataWidth.W, dataBP.BP)
    }

    FixedPointBandpowerTester(params, dataBP, debug) should be (true)
  }
}