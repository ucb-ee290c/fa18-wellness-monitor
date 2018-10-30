package memorybuffer

import chisel3._
import org.scalatest.{FlatSpec, Matchers}

class MemoryBufferSpec extends FlatSpec with Matchers {
  behavior of "Memory Buffer"

  it should "UInt peach" in {

    for(i <- 0 until 15) {
      val params = new MemoryBufferParams[SInt] {
        val protoData = SInt(32.W)
        val nRows = scala.util.Random.nextInt(15) + 1
        val nColumns = scala.util.Random.nextInt(15) + 1
      }

      MemoryBufferTester(params) should be (true)
    }
  }
}