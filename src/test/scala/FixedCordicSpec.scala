package cordic

import dsptools.numbers._
import org.scalatest.{FlatSpec, Matchers}

class FixedCordicSpec extends FlatSpec with Matchers {
  behavior of "FixedIterativeCordic"

  val params = FixedCordicParams(
    xyWidth = 10,
    zWidth = 16,
    correctGain = true,
    stagesPerCycle = 1
  )
  it should "rotate" in {
    val baseTrial = XYZ(xin=1.0, yin=0.0, zin=0.0, vectoring=false)
    val angles = Seq(-1, -0.5, 0, 0.25, 0.5, 1)
    val trials = angles.map { phi => baseTrial.copy(zin = phi, xout = Some(math.cos(phi))) }
    FixedCordicTester(params, trials) should be (true)
  }

  behavior of "RealIterativeCordic"

  val realParams = new CordicParams[DspReal] {
    val protoXY = DspReal()
    val protoZ = DspReal()
    val nStages = 28
    val correctGain = true
    val stagesPerCycle = 1
  }
  it should "rotate" in {
    val baseTrial = XYZ(xin=1.0, yin=0.0, zin=0.0, vectoring=false)
    val angles = Seq(-1, -0.5, 0, 0.25, 0.5, 1)
    val trials = angles.map { phi => baseTrial.copy(zin = phi, xout = Some(math.cos(phi))) }
    RealCordicTester(realParams, trials) should be (true)
  }

}
