package fft

import chisel3._
import chisel3.experimental.FixedPoint
import dsptools.numbers.DspComplex
import org.scalatest.{FlatSpec, Matchers}

class CustomFFTSpec extends FlatSpec with Matchers {
  behavior of "FFT"

  // FFT points, lanes, total width, fractional bits, pipeline depth
  val test = Seq(8, 8, 35, 19, 0)
  val totalWidth = test(2)
  val fractionalBits = test(3)

  implicit object FixedTypeclass extends dsptools.numbers.FixedPointReal {
    override def fromDouble(x: Double): FixedPoint = {
      FixedPoint.fromDouble(x, width = totalWidth.W, binaryPoint = fractionalBits.BP)
    }
  }
  val config = FFTConfig(
    genIn = DspComplex(FixedPoint(totalWidth.W, fractionalBits.BP), FixedPoint(totalWidth.W, fractionalBits.BP)),
    genOut = DspComplex(FixedPoint(totalWidth.W, fractionalBits.BP), FixedPoint(totalWidth.W, fractionalBits.BP)),
    n = test(0),
    lanes = test(1),
    pipelineDepth = test(4),
    quadrature = false,
  )

  it should "FFT" in {
    FixedPointFFTTester(config) should be (true)
  }
}