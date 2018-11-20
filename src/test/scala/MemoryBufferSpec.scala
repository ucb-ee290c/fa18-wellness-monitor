package memorybuffer

import chisel3._
import chisel3.core.FixedPoint
import org.scalatest.{FlatSpec, Matchers}

class MemoryBufferSpec extends FlatSpec with Matchers {
  behavior of "Memory Buffer"

  it should "UInt Buffer" in {

    for(i <- 0 until 15) {
      val params = new MemoryBufferParams[SInt] {
        val protoData = SInt(32.W)
        val nRows = scala.util.Random.nextInt(15) + 1
        val nColumns = scala.util.Random.nextInt(15) + 1
      }

      UIntMemoryBufferTester(params) should be (true)
    }
  }

  it should "FixedPoint Buffer" in {

    for(i <- 0 until 15) {
      val params = new MemoryBufferParams[FixedPoint] {
        val protoData = FixedPoint(32.W,8.BP)
        val nRows = scala.util.Random.nextInt(15) + 1
        val nColumns = scala.util.Random.nextInt(15) + 1
      }

      FixedPointMemoryBufferTester(params) should be (true)
    }
  }
}