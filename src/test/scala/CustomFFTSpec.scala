package fft

import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers.DspComplex
import org.scalatest.{FlatSpec, Matchers}

class CustomFFTSpec extends FlatSpec with Matchers {
  behavior of "FFT"

  // FFT points, lanes, total width, fractional bits, pipeline depth
  val test = Seq(8, 8, 35, 19, 0)
  val totalWidth = test(2)
  val fractionalBits = test(3)

  val config = FFTConfig(
    genIn = DspComplex(FixedPoint(totalWidth.W, fractionalBits.BP), FixedPoint(totalWidth.W, fractionalBits.BP)),
    genOut = DspComplex(FixedPoint(totalWidth.W, fractionalBits.BP), FixedPoint(totalWidth.W, fractionalBits.BP)),
    n = test(0),
    lanes = test(1),
    pipelineDepth = test(4),
    quadrature = false,
  )

  it should "FFT" in {
    val debug = 0
    FixedPointFFTTester(config, debug) should be (true)
  }
}