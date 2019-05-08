package logistic

import chisel3._
import chisel3.util.{RegEnable, log2Ceil}
import dsptools.numbers._
import dspjunctions.ValidWithSync
import breeze.numerics.logit

import scala.collection._

trait LogisticParams[T <: Data] {
  val protoData: T
  val onlineLearn: Int          // online learning activation switch
  val nFeatures: Int            // the number of reduced dimensions, coming from PCA if ever

  val nThresholds: Int          // the number of threshold points for logit estimation
  
  val nWindow: Int         // the training window for ictal segments
  val nInterCount: Int         // the training window for interictal segments
  
  val ictalIndex: Int       // the index wrt threshold, for the online learning scheme
  val interIndex: Int  // same as above, but for interictal training

  val learningRate: Double // learning rate for online logistic
}

object Constants {
  // create the thresholds of the dot products that will correspond to the different probability divisions
  def logitTable(i: Double, thresholds: Int) = logit(i/(thresholds.toDouble+1))

  // the lookup table generator for the logistic function
  def probabilities(thresholds: Int) = for (i <- 0 until thresholds + 2) yield i.toDouble/(thresholds.toDouble + 1)
}

class LogisticIO[T <: Data](params: LogisticParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nFeatures, params.protoData)))
  val out = ValidWithSync(UInt(1.W))

  val weights = Input(Vec(params.nFeatures, params.protoData))
  val intercept = Input(params.protoData)

  // these are some probe points, to ensure computational accuracy
  val rawVotes = Output(params.protoData)
  val dotProduct = Output(params.protoData)
  val weightProbe = Output(Vec(params.nFeatures,params.protoData))

  override def cloneType: this.type = LogisticIO(params).asInstanceOf[this.type]
}
object LogisticIO {
  def apply[T <: Data](params: LogisticParams[T]): LogisticIO[T] = new LogisticIO(params)
}

class Logistic[T <: chisel3.Data : Real](val params: LogisticParams[T]) extends Module {
  require(params.nFeatures >= 1, f"Must have at least 1 feature, currently ${params.nFeatures}")
  require(params.onlineLearn == 1 || params.onlineLearn == 0, "onlineLearn parameter can either be 0 or 1")
  require(params.nThresholds >= 1, f"Must have at least 1 threshold, currently ${params.nThresholds}")
  require(params.nWindow >= 1 && params.nWindow % 2 == 1, f"Window length must be an odd number ${params.nWindow}")
  require(params.nInterCount >= 1, "Must have more than 1 interictal window")
  require(params.ictalIndex >= 1 && params.ictalIndex <= params.nThresholds,
    f"Threshold must be within the number of thresholds, currently ${params.ictalIndex}")
  require(params.interIndex >= 1 && params.interIndex <= params.nThresholds,
    f"Threshold must be within the number of thresholds, currently ${params.interIndex}")

  val io = IO(new LogisticIO[T](params))


  // if we are doing online learning, the weights are being dynamically updated
  // this is the register container for the weights
  val weightsOnline = RegInit(Vec(params.nFeatures, params.protoData),
    VecInit(List.fill(params.nFeatures)(ConvertableTo[T].fromInt(0))))

  val initState = RegInit(0.U) // initial state identifier, for the preload
  if (params.onlineLearn == 1) initState := 1.U // only trasition if we are doing online learning

  // choose between the config memory data or the dynamic weight being updated by online learning
  val weightsMux = Mux((initState == 1.U).asBool(),weightsOnline,io.weights)

  // compute for the dot product of weights and the feature values, plus the intercept
  val reduced = io.in.bits.zip(weightsMux).map { case (a, b) => a * b }.reduce(_ + _) + io.intercept

  // now we want to output probabilities if we can, we create a pseudo lookup table for this
  // this contains the cutoff points for rounding off the probabilities
  val boundaries = Seq.fill(params.nThresholds+1)(Wire(params.protoData))
  for (i <- 0 until params.nThresholds + 1)
    boundaries(i) := ConvertableTo[T].fromDouble(Constants.logitTable(i.toDouble+0.5,params.nThresholds))

  // this is the actual precomputed (low resolution) probability value, we use Vec so we can index easily
  val probabilities = VecInit(Constants.probabilities(params.nThresholds).map(ConvertableTo[T].fromDouble(_)))

  // this compares the dot product with the boundary points for rounding off
  val thermometerCode = Seq.fill(params.nThresholds+1)(Wire(UInt(1.W)))
  for (i <- boundaries.indices) thermometerCode(i) := Mux(reduced >= boundaries(i), 1.U, 0.U)

  // using the generated thermometer code, we identify the corresponding probability for that
  val actualVotes = probabilities(thermometerCode.reduce(_ +& _)) // this is epic

  // of course, the only relevant value that we check is the classifier output, 0 (no seizure) or 1 (seizure)
  val finalPredict = Mux(reduced >= 0, 1.U, 0.U)

  // put for output probing and checking for computation accuracy, pipelined at the output
  val rawVotesReg = RegEnable(actualVotes, io.in.valid)
  val dotProductReg = RegEnable(reduced, io.in.valid)
  val weightProbeReg = RegEnable(weightsMux, io.in.valid)
  val outReg = RegEnable(finalPredict, io.in.valid)
  val valReg = RegNext(io.in.valid)
  val syncReg = RegNext(io.in.sync)

  // final output assignment
  io.rawVotes := rawVotesReg
  io.dotProduct := dotProductReg
  io.weightProbe := weightProbeReg
  io.out.bits := outReg
  io.out.valid := valReg
  io.out.sync := syncReg

  // ###################################################################################################################
  // the following stuff is for the online learning support

  val learningRate = ConvertableTo[T].fromDouble(params.learningRate)
  val ictalThreshold = ConvertableTo[T].fromDouble(Constants.logitTable(params.ictalIndex.toDouble,params.nThresholds))
  val interThreshold = ConvertableTo[T].fromDouble(Constants.logitTable(params.interIndex.toDouble,params.nThresholds))

  val ictalWindow = RegInit(Vec(params.nWindow, UInt(1.W)), VecInit(List.fill(params.nWindow)(0.U)))
  val interWindow = RegInit(Vec(params.nWindow, UInt(1.W)), VecInit(List.fill(params.nWindow)(0.U)))
  val featureWindow = Reg(Vec(params.nWindow, Vec(params.nFeatures, params.protoData)))

  val interCount = RegInit(0.U(6.W))

  for(i <- ictalWindow.indices) {
    when(io.in.valid === true.B) {
      if (i == 0) ictalWindow(i) := Mux(reduced >= ictalThreshold, 1.U, 0.U)
      else ictalWindow(i) := ictalWindow(i - 1)
    } .otherwise {
      ictalWindow(i) := ictalWindow(i)
    }
  }
  val ictalSum = ictalWindow.reduce(_ +& _)

  for(i <- interWindow.indices) {
    when(io.in.valid === true.B) {
      if (i == 0) interWindow(i) := Mux(reduced <= interThreshold, 1.U, 0.U)
      else interWindow(i) := interWindow(i - 1)
    } .otherwise {
      interWindow(i) := interWindow(i)
    }
  }
  val interSum = interWindow.reduce(_ +& _)

  for(i <- ictalWindow.indices) {
    when(io.in.valid === true.B) {
      if (i == 0) featureWindow(i) := io.in.bits
      else featureWindow(i) := featureWindow(i - 1)
    } .otherwise {
      featureWindow(i) := featureWindow(i)
    }
  }
  //val featureSum = featureWindow.reduce(_ + _).map( _ >> log2Ceil(params.nWindow))
  //val featureSum = featureWindow.reduce(_.zip(_))

  val predict = Mux(reduced >= 0, ConvertableTo[T].fromInt(1), ConvertableTo[T].fromInt(0))
  val deltaWeights = io.in.bits.map(_ * learningRate * (predict - actualVotes))

  val newWeights = Wire(Vec(params.nFeatures,params.protoData))

  when ((ictalSum === params.nWindow.asUInt()) || (interCount === params.nInterCount.asUInt())) {
    newWeights := weightsOnline.zip(deltaWeights).map { case (a, b) => a + b }
    interCount := 0.U
  } .elsewhen (interSum === params.nWindow.asUInt()) {
    interCount := interCount + 1
    newWeights := weightsOnline
  } .otherwise {
    newWeights := weightsOnline
    interCount := 0.U
  }

  when (initState === 0.U) { // only for the initial state, get the weights
    weightsOnline := io.weights
  } .otherwise {
    weightsOnline := newWeights
  }

}