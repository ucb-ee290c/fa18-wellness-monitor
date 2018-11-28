package wellness

import breeze.math.Complex
import chisel3._
import chisel3.experimental.FixedPoint
import chisel3.util.log2Ceil
import dsptools.DspTester
import dsptools.numbers._
import firFilter._
import fft._
import features._
import pca._
import memorybuffer._
import svm._
import freechips.rocketchip.config.Parameters

import scala.collection.mutable.ArrayBuffer
import scala.collection.{Seq, mutable}

class wellnessGenTester[T <: chisel3.Data](c: wellnessGenModule[T],
                                           goldenModelParameters: wellnessGenIntegrationParameterBundle,
                                           dataBP: Int, testType: Int) extends DspTester(c) {

  // Instantiate golden models
  val wellnessGenParams1 = new wellnessGenParams[SInt] {
    val protoData = SInt(64.W)
  }
  //val datapathSeq = Seq((0,filter1Params), (1,lineLength1Params))
  // follow same process as wellnessGen
  val pathSeq = Seq(("FIR",goldenModelParameters.filter1Params),("lineLength",goldenModelParameters.lineLength1Params))
  val FIRBucket = mutable.ArrayBuffer[GoldenDoubleFIRFilter]()
  val lineLengthBucket = mutable.ArrayBuffer[GoldenDoubleLineLength]()

  val FIRResultBucket = mutable.ArrayBuffer[Double]()
  val IIRResultBucket = mutable.ArrayBuffer[Double]()
  val FFTResultBucket = mutable.ArrayBuffer[Double]()
  val lineLengthResultBucket = mutable.ArrayBuffer[Double]()

  val datapathSeq : mutable.ArrayBuffer[(Int,Int)] = mutable.ArrayBuffer()
  val bucketSeq = Seq(FIRBucket,FIRBucket,FIRBucket,lineLengthBucket)
  val resultSeq : Seq[mutable.ArrayBuffer[Double]] = Seq(FIRResultBucket,IIRResultBucket,FFTResultBucket,lineLengthBucket)


  for (i <- 0 until pathSeq.length)
    {
      pathSeq(i)._1 match
      {
        case "FIR" =>
        { // FIR
          FIRBucket += new GoldenDoubleFIRFilter(pathSeq(i)._2.asInstanceOf[Seq[Double]])
          datapathSeq += ((0,FIRBucket.length))
          FIRResultBucket += 0.toDouble
        }
        case "lineLength" =>
        { // lineLength
          lineLengthBucket += new GoldenDoubleLineLength(pathSeq(i)._2.asInstanceOf[Int],wellnessGenParams1.protoData.getClass.getTypeName)
          datapathSeq += ((3,lineLengthBucket.length))
          lineLengthResultBucket += 0.toDouble
        }
      }
    }

  // val filter1 = new GoldenDoubleFIRFilter(goldenModelParameters.filter1Params.taps)
  // var filter1Result = filter1.poke(0)

  for (i <- 0 until 100)
  {
    val input = scala.util.Random.nextDouble * 16

    for (j <- (datapathSeq.length - 1) to 0 by -1)
      {
        val modi = datapathSeq(j)._1
        val modj = datapathSeq(j)._2
        if (j == (datapathSeq.length - 1))
        {
          val guava = Seq(ArrayBuffer[Double]()).getClass
          modi match
          {
            case 0 =>
            {
              resultSeq(modi)(modj) match {
                case _: Double => val temp = bucketSeq(modi)(modj).asInstanceOf[GoldenDoubleFIRFilter].poke(input)
              }
            }
            case 1 =>
            {
              val temp = bucketSeq(modi)(modj).asInstanceOf[GoldenDoubleFIRFilter].poke(input)
              resultSeq(modi)(modj) = bucketSeq(modi)(modj).asInstanceOf[GoldenDoubleLineLength].poke(input)
            }
          }
        }
        else
        {
          val prev_modi = datapathSeq(j+1)._1
          val prev_modj = datapathSeq(j+1)._2
          modi match
          {
            case 0 =>
            {
              val temp = bucketSeq(modi)(modj).asInstanceOf[GoldenDoubleFIRFilter].poke(input)
              resultSeq(modi)(modj) = bucketSeq(modi)(modj).asInstanceOf[GoldenDoubleFIRFilter].poke(resultSeq(prev_modi)(prev_modj).asInstanceOf[Double])
            }
            case 1 =>
            {
              val temp = bucketSeq(modi)(modj).asInstanceOf[GoldenDoubleFIRFilter].poke(input)
              resultSeq(modi)(modj) = bucketSeq(modi)(modj).asInstanceOf[GoldenDoubleLineLength].poke(resultSeq(prev_modi)(prev_modj).asInstanceOf[Double])
            }
          }
        }
      }

    poke(c.io.in.bits, input)
    poke(c.io.in.valid, 1)
    step(1)

    // expect(c.io.out.bits, filter1Result)
  }
}


object wellnessGenIntegrationTesterSInt {
  implicit val p: Parameters = null
  def apply(wellnessGenParams1: wellnessGenParams[SInt],
            goldenModelParameters: wellnessGenIntegrationParameterBundle, debug: Int): Boolean = {
    if (debug == 1) {
      chisel3.iotesters.Driver.execute(Array("-tbn", "firrtl", "-fiwv"), () => new wellnessGenModule(
        wellnessGenParams1: wellnessGenParams[SInt])) {
        c => new wellnessGenTester(c, goldenModelParameters, 0,0)
      }
    } else {
      dsptools.Driver.execute(() => new wellnessGenModule(
        wellnessGenParams1: wellnessGenParams[SInt]),
        TestSetup.dspTesterOptions) {
        c => new wellnessGenTester(c, goldenModelParameters, 0, 0)
      }
    }
  }
}
