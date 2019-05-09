package wellness

import chisel3._
import org.scalatest.{FlatSpec, Matchers}

class ConfigurationMemorySpec extends FlatSpec with Matchers {
  behavior of "Memory Buffer"

  it should "work" in {
    val debug = 0

    for(i <- 0 until 5) {
      val params = new ConfigurationMemoryParams[SInt] {
        val protoData = SInt(32.W)
        val nDimensions = scala.util.Random.nextInt(8)+2
        val nFeatures = scala.util.Random.nextInt(6)+2
      }

      ConfigurationMemoryTester(params, debug) should be (true)
    }
  }
}