package features

import wellness._

import chisel3._
import chisel3.core.FixedPoint
import chisel3.util.log2Ceil
import dsptools.numbers._
import dsptools.DspTester
import breeze.numerics.pow

import scala.util.Random
import breeze.math.Complex
import breeze.numerics.floor

/**
  * Class that actually performs bandpower calc
  *
  * @param nBins          Length of incoming FFT signal
  * @param idxStartBin    Index of lower freq bound of freq range of interest (inclusive)
  * @param idxEndBin      Index of upper freq bound of freq range of interest (exclusive!)
  * @param dataType       Chisel data type (to floor output if UInt/SInt)
  *
  * input                 Incoming FFT signal
  * (Return)              Scalar average bandpower output
  */
class GoldenDoubleBandpower(nBins: Int, idxStartBin: Int, idxEndBin: Int, dataType: String) {
  def poke(input: Seq[Complex]): Double = {

    // Also do division by 2^23 to minimize dynamic range of output values
    // Check https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/scripts/features.py
    val band_normalize = pow(2,23).toDouble

    // Take mag squared of FFT output
    val p2 = input.map{ case x => x.abs * x.abs}
    // Except for DC and sampling freq, 2x for 2-sided to 1-sided
    val p1Scaled = p2.slice(1, nBins / 2).map(_ * 2)
    // Concatenate back in unscaled DC and sampling freq elems
    val p1 = Seq(p2(0)) ++ p1Scaled ++ Seq(p2(nBins / 2))
    // Sum and divide by num of bins of interest squared
    val output = p1.slice(idxStartBin, idxEndBin).sum

    //println(output.toString)
    //println((idxEndBin - idxStartBin).toString)
    //println(band_normalize.toString)
    //println((((idxEndBin - idxStartBin).toDouble * (idxEndBin - idxStartBin).toDouble)*band_normalize).toString)
    //println((output/(((idxEndBin - idxStartBin) * (idxEndBin - idxStartBin))*band_normalize)).toString)
    if ((dataType == "chisel3.core.SInt") || (dataType == "chisel3.core.UInt")) {
      floor(output/(((idxEndBin - idxStartBin) * (idxEndBin - idxStartBin))*band_normalize))
    } else {
      output/(((idxEndBin - idxStartBin) * (idxEndBin - idxStartBin))*band_normalize)
    }
  }
}

/**
  * Runs bandpower test by comparing Chisel and reference
  *
  * @param c        Chisel Bandpower block instance
  * @param params   Chisel Bandpower params
  * @param dataBP   Binary point for FixedPoint for tolerance adjustment
  * @tparam T
  */
class BandpowerTester[T <: Data](c: Bandpower[T], params: BandpowerParams[T], dataBP: Int) extends DspTester(c) {
  // Just using new vals to shorten code and increase readability
  val nBins = params.nBins
  val idxStartBin = params.idxStartBin
  val idxEndBin = params.idxEndBin
  val dataType = c.params.genOut.getClass.getTypeName

  // Instantiates class performing reference bandpower calc
  val bandpower = new GoldenDoubleBandpower(nBins, idxStartBin, idxEndBin, dataType)

  // Random input (Double for FixedPoint, Int for UInt/SInt)
  var input = Seq.fill(nBins)(Complex(Random.nextDouble(), Random.nextDouble()))
  if ((dataType == "chisel3.core.UInt") || (dataType == "chisel3.core.SInt")) {
    input = Seq.fill(nBins)(Complex(Random.nextInt(16), Random.nextInt(16)))
  }

  // Get reference average bandpower result using poke function of class above
  val goldenModelResult = bandpower.poke(input)

  // Poke Chisel
  input.zip(c.io.in.bits).foreach { case(sig, port) => poke(port, sig) }
  poke(c.io.in.valid, value = 1)
  step(1)


  // Compare Chisel and reference (with different tolerances for different Chisel types)
  if ((dataType == "chisel3.core.SInt") || (dataType == "chisel3.core.UInt")) {
    expect(c.io.out.bits, goldenModelResult, msg = s"Input: $input, Golden: $goldenModelResult, ${peek(c.io.out.bits)}")
  } else {
    val tolerance = 0.1
    fixTolLSBs.withValue(log2Ceil((goldenModelResult.abs * tolerance).toInt + 1) + dataBP + 1) {
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