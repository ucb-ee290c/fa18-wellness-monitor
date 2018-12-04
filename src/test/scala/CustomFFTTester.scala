package fft

import wellness._

import chisel3._
import chisel3.core.FixedPoint
import chisel3.util.log2Ceil
import dsptools._
import freechips.rocketchip.config.Parameters

import scala.util.Random
import breeze.math.Complex
import breeze.linalg.DenseVector
import breeze.signal.fourierTr

/**
  * Class that actually performs Fourier transform
  *
  * @param n    Num of FFT pts
  *
  * input       Incoming time series signal
  * (Return)    Fourier transform
  */
class GoldenDoubleFFT(n: Int) {
  def poke(tone: Seq[Complex]): Seq[Complex] = {
    fourierTr(DenseVector(tone.toArray)).toArray
  }
}

/**
  * Runs FFT test by comparing Chisel and reference
  *
  * @param c        Chisel FFT block instance
  * @param config   Chisel FFT config
  * @param dataBP   Binary point for FixedPoint for tolerance adjustment
  * @tparam T
  */
class CustomFFTTester[T <: Data](c: FFT[T], config: FFTConfig[FixedPoint], dataBP: Int) extends DspTester(c) {
  // Instantiates class performing Fourier transform calc
  val fft = new GoldenDoubleFFT(config.n)

  // For each random input
  for (i <- 0 until 10) {
    // Random input
    val tone = (0 until config.n).map(x => Complex(Random.nextDouble() * 100 - 50, 0.0))
    // Get reference Fourier transform result using poke function of above class
    val expected = fft.poke(tone)

    // Poke Chisel
    tone.zip(c.io.in.bits).foreach { case (sig, port) => poke(port, sig) }
    poke(c.io.in.valid, value = 1)
    step(1)


    // Compare Chisel and reference pt by pt
    for (i <- c.io.out.bits.indices) {
      val tolerance = 0.1
      fixTolLSBs.withValue(log2Ceil((expected(i).abs*tolerance).toInt+1)+dataBP+1) {
        expect(c.io.out.bits(i), expected(i))
      }
    }
  }
}
object FixedPointFFTTester{
  def apply(config: FFTConfig[FixedPoint], dataBP: Int, debug: Int): Boolean = {
    implicit val p: Parameters = null
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new FFT(config)) {
        c => new CustomFFTTester(c, config, dataBP)
      }
    } else {
      dsptools.Driver.execute(() => new FFT(config), TestSetup.dspTesterOptions) {
        c => new CustomFFTTester(c, config, dataBP)
      }
    }
  }
}