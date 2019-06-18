package neuralNet

import chisel3._
import chisel3.util.RegEnable
import dsptools.numbers._
import dspjunctions.ValidWithSync


trait NeuralNetParams[T <: Data] {
  val protoData: T
  val nFeatures: Int // number of dimensions in input data
  val nNeurons: Int // number of neurons in each hidden layer
  val nLayers: Int // number of hidden layers
}

class NeuralNetIO[T <: Data](params: NeuralNetParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nFeatures, params.protoData)))
  val out = ValidWithSync(UInt(1.W))

  val inputWeights = Input(Vec(params.nNeurons, Vec(params.nFeatures, params.protoData)))
  val midAndOutputWeights = Input(Vec(params.nNeurons * (params.nLayers - 1) + 1,
    Vec(params.nNeurons, params.protoData)))
  val biasVecs = Input(Vec(params.nLayers, Vec(params.nNeurons, params.protoData)))
  val outputBias = Input(params.protoData)

  // non-normalized neural network output for debugging
  val rawVotes = Output(params.protoData)

  override def cloneType: this.type = NeuralNetIO(params).asInstanceOf[this.type]
}

object NeuralNetIO {
  def apply[T <: Data](params: NeuralNetParams[T]): NeuralNetIO[T] = new NeuralNetIO(params)
}

class NeuralNet[T <: chisel3.Data : Real](val params: NeuralNetParams[T]) extends Module {
  require(params.nFeatures >= 1, f"Must have at least 1 feature, currently ${params.nFeatures}")
  require(params.nNeurons >= 1, f"Must have at least 1 neuron, currently ${params.nNeurons}")
  require(params.nLayers >= 1, f"Must have at least 1 hidden layer, currently ${params.nLayers}")

  val io = IO(new NeuralNetIO[T](params))

  val hiddenLayers = Wire(Vec(params.nLayers, Vec(params.nNeurons, params.protoData)))

  // compute first hidden layer

  for (i <- 0 until params.nNeurons) {
    val linearCombo = io.in.bits.zip(io.inputWeights(i)).map{ case (a,b) => a * b}.reduce(_ + _) +
      io.biasVecs(0)(i)
    hiddenLayers(0)(i) := Mux(linearCombo > 0, linearCombo, ConvertableTo[T].fromInt(0))
  }

  // compute remaining hidden layers, if they exist

  for (i <- 1 until params.nLayers) {
    for (j <- 0 until params.nNeurons) {
      val linearCombo = hiddenLayers(i-1).zip(io.midAndOutputWeights((i-1)*params.nNeurons+j)).map
      { case (a,b) => a * b}.reduce(_ + _) + io.biasVecs(i)(j)
      hiddenLayers(i)(j) := Mux(linearCombo > 0, linearCombo, ConvertableTo[T].fromInt(0))
    }
  }

  // compute output layer

  val linearOut = hiddenLayers(params.nLayers-1).zip(
    io.midAndOutputWeights((params.nLayers-1)*params.nNeurons)).map{ case (a,b) => a * b}.reduce(_ + _) +
    io.outputBias

  val actualVotes = Mux(linearOut > 0, linearOut, ConvertableTo[T].fromInt(0))
  val finalPredict = Mux(actualVotes > 0, 1.U, 0.U)

  // output probing
  val rawVotesReg = RegEnable(actualVotes, io.in.valid)
  val outReg = RegEnable(finalPredict, io.in.valid)
  val valReg = RegNext(io.in.valid)
  val syncReg = RegNext(io.in.sync)

  // final output assignment
  io.rawVotes := rawVotesReg
  io.out.bits := outReg
  io.out.valid := valReg
  io.out.sync := syncReg

}
