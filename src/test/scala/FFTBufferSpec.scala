package fft

import chisel3._
import chisel3.core.FixedPoint
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._
import org.scalatest.{FlatSpec, Matchers}

import scala.collection.mutable

class FFTBufferSpec extends FlatSpec with Matchers {
  behavior of "FFT Buffer"

  it should "convert from stream to parallel (UInt)" in {

    for(i <- 0 until 15) {
      val laneCount = scala.util.Random.nextInt(15) + 1

      val params = new FFTBufferParams[UInt] {
        val protoData = UInt(16.W)
        val lanes = laneCount
      }

      UIntFFTBufferTester(params, laneCount) should be (true)
    }
  }

  it should "convert from stream to parallel (Fixed Point)" in {

    for(i <- 0 until 15) {
      val laneCount = scala.util.Random.nextInt(15) + 1

      val params = new FFTBufferParams[FixedPoint] {
        val protoData = FixedPoint(32.W,8.BP)
        val lanes = laneCount
      }

      FixedPointFFTBufferTester(params, laneCount) should be (true)
    }
  }
}