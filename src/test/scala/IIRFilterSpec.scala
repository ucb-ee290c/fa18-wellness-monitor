package iirFilter

import chisel3._
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._
import org.scalatest.{FlatSpec, Matchers}

import scala.collection.mutable

class IIRFilterSpec extends FlatSpec with Matchers {
  behavior of "ConstantCoefficientIIRFilter"

  it should "UInt banana" in {

    for(i <- 0 until 4) {
      val tap_count = scala.util.Random.nextInt(8) + 1

      val coefficientsA = mutable.ArrayBuffer[Int]()
      val coefficientsB = mutable.ArrayBuffer[Int]()

      for(j <- 0 until tap_count) coefficientsA += scala.util.Random.nextInt(16)
      for(j <- 0 until (tap_count+1)) coefficientsB += scala.util.Random.nextInt(16)
      val params = new IIRFilterParams[UInt] {
        val protoData = UInt(32.W)
        val consts_A = coefficientsA.map(_.asUInt(32.W))
        val consts_B = coefficientsB.map(_.asUInt(32.W))
      }

      UIntIIRFilterTester(params, coefficientsA, coefficientsB) should be (true)
    }
  }


}
