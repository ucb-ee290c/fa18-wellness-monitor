package neuralNet

import chisel3._
import chisel3.util.RegEnable
import dsptools.numbers._
import dspjunctions.ValidWithSync


trait NeuralNetParams[T <: Data] {
  val protoData: T
  val nFeatures: Int // number of dimensions in input data
  val nNeurons: Int // number of neurons in hidden layer
}

class NeuralNetIO[T <: Data](params: NeuralNetParams[T]) extends Bundle {
  // for all matrices/vectors, assume that chisel Vec shape is like an array, so
  // that Vec(n, params.protoData) declares a row vector of shape (1, n)

  // input row vector, shape: (1, params.nFeatures)
  val in = Flipped(ValidWithSync(Vec(params.nFeatures, params.protoData)))
  // output classification
  val out = ValidWithSync(UInt(1.W))

  // weight matrix to connect to hidden layer, shape: (params.nFeatures, params.nNeurons)
  val weightMatrix = Input(Vec(params.nNeurons, Vec(params.nFeatures, params.protoData)))
  // weight column vector to connect to output layer, shape: (params.nNeurons, 1)
  val weightVec = Input(Vec(params.nNeurons, params.protoData))

  // bias row vector, shape: (1, params.nNeurons). this is the transpose of the sklearn implementation
  val biasVec = Input(Vec(params.nNeurons, params.protoData))
  val biasScalar = Input(params.protoData)

  // non-normalized neural network output for debugging
  val rawVotes = Output(params.protoData)

  override def cloneType: this.type = NeuralNetIO(params).asInstanceOf[this.type]
}

object NeuralNetIO {
  def apply[T <: Data](params: NeuralNetParams[T]): NeuralNetIO[T] = new NeuralNetIO(params)
}

class NeuralNet[T <: chisel3.Data : Real](val params: NeuralNetParams[T]) extends Module {
  require(params.nNeurons >= 1, f"Must have at least 1 neuron, currently ${params.nNeurons}")

  val io = IO(new NeuralNetIO[T](params))


  // multiply input vector by weight matrix
  val inputWeighted = Wire(Vec(params.nNeurons, params.protoData)) // shape: (1, params.nNeurons)
  for (i <- 0 until params.nNeurons) {
    inputWeighted(i) := io.in.bits.zip(io.weightMatrix(i)).map{ case (a,b) => a * b}.reduce(_ + _)
  }

  // add bias vector to weight matrix multiplication result
  val biased = Wire(Vec(params.nNeurons, params.protoData))
  biased := inputWeighted.zip(io.biasVec).map{ case (a,b) => a + b}

  // apply ReLU for final hidden layer
  val hiddenLayer = Wire(Vec(params.nNeurons, params.protoData))
  for (i <- 0 until params.nNeurons) {
    hiddenLayer(i) := Mux(biased(i) > 0, biased(i), ConvertableTo[T].fromInt(0))
  }

  // compute dot product of hidden layer and weight vector
  val dotProduct = Wire(params.protoData)
  for (i <- 0 until params.nFeatures) {
    dotProduct := hiddenLayer.zip(io.weightVec).map{ case (a,b) => a * b}.reduce(_ + _)
  }

  val actualPreReLU = Wire(params.protoData)
  actualPreReLU := dotProduct + io.biasScalar
  val actualVotes = Wire(params.protoData)
  // apply ReLU for raw neural net output
  actualVotes := Mux(actualPreReLU > 0, actualPreReLU, ConvertableTo[T].fromInt(0))

  val finalPredict = Wire(UInt(1.W))
  finalPredict := Mux(actualVotes > 0, 1.U, 0.U)

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
