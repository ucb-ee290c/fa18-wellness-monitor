package features

import wellness._
import chisel3._
import chisel3.core.FixedPoint
import dsptools.numbers._
import dsptools.DspTester
import breeze.math.Complex
import breeze.numerics.floor
import chisel3.util.log2Ceil

import scala.util.Random

class GoldenDoubleBandpower(nBins: Int, idxStartBin: Int, idxEndBin: Int, dataType: String) {
  def poke(input: Seq[Complex]): Double = {
    // Take mag squared of FFT output
    val p2 = input.map{ case x => x.abs * x.abs}
    // Except for DC and sampling freq, 2x for 2-sided to 1-sided
    val p1Scaled = p2.slice(1, nBins / 2).map(_ * 2)
    // Concatenate back in unscaled DC and sampling freq elems
    val p1 = Seq(p2(0)) ++ p1Scaled ++ Seq(p2(nBins / 2))
    // Sum and divide by num of bins of interest squared
    val output = p1.slice(idxStartBin, idxEndBin).sum

    if ((dataType == "chisel3.core.SInt") || (dataType == "chisel3.core.UInt")) floor(output/((idxEndBin - idxStartBin) * (idxEndBin - idxStartBin)))
    else output/((idxEndBin - idxStartBin) * (idxEndBin - idxStartBin))
  }
}

class BandpowerTester[T <: Data](c: Bandpower[T], params: BandpowerParams[T], dataBP: Int) extends DspTester(c) {
  val nBins = params.nBins
  val idxStartBin = params.idxStartBin
  val idxEndBin = params.idxEndBin
  val dataType = c.params.genOut.getClass.getTypeName
  val bandpower = new GoldenDoubleBandpower(nBins, idxStartBin, idxEndBin, dataType)

  var input = Seq.fill(nBins)(Complex(Random.nextDouble(), Random.nextDouble()))
  if ((dataType == "chisel3.core.SInt") || (dataType == "chisel3.core.UInt")) { // UInt
    input = Seq.fill(nBins)(Complex(Random.nextInt(16), Random.nextInt(16)))
  }

  val goldenModelResult = bandpower.poke(input)

  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }
  poke(c.io.in.valid, value = 1)
  step(1)


  if ((dataType == "chisel3.core.SInt") || (dataType == "chisel3.core.UInt")) {
    expect(c.io.out.bits, goldenModelResult, msg = s"Input: $input, Golden: $goldenModelResult, ${peek(c.io.out.bits)}")
  } else {
    val tolerance = 0.1
    fixTolLSBs.withValue(log2Ceil((goldenModelResult.abs*tolerance).toInt+1)+dataBP+1) {
      expect(c.io.out.bits, goldenModelResult, msg = s"Input: $input, Golden: $goldenModelResult, ${peek(c.io.out.bits)}")
    }
  }
}
object UIntBandpowerTester {
  def apply(params: BandpowerParams[UInt], debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new Bandpower(params)){
        c => new BandpowerTester(c, params, 0)
      }
    } else {
      dsptools.Driver.execute(() => new Bandpower(params), TestSetup.dspTesterOptions) {
        c => new BandpowerTester(c, params, 0)
      }
    }
  }
}
object FixedPointBandpowerTester {
  def apply(params: BandpowerParams[FixedPoint], dataBP: Int, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new Bandpower(params)){
        c => new BandpowerTester(c, params, dataBP)
      }
    } else {
      dsptools.Driver.execute(() => new Bandpower(params), TestSetup.dspTesterOptions) {
        c => new BandpowerTester(c, params, dataBP)
      }
    }
  }
}