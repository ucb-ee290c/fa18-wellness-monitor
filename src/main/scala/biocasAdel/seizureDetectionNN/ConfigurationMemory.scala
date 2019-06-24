/*
package wellness

import memorybuffer._
import chisel3._
import dspjunctions.ValidWithSync
import dsptools.numbers._

trait ConfigurationMemoryParams[T <: Data] {
  val protoData: T
  val nFeatures: Int // number of dimensions in input data
  val nNeurons: Int // number of neurons in each hidden layer
  val nLayers: Int // number of hidden layers
}

class ConfigurationMemoryBundle[T <: Data](params: ConfigurationMemoryParams[T]) extends Bundle {
  val wrdata: T = params.protoData
  val wraddr = UInt(3.W)

  override def cloneType: this.type = ConfigurationMemoryBundle(params).asInstanceOf[this.type]
}
object ConfigurationMemoryBundle {
  def apply[T <: Data](params: ConfigurationMemoryParams[T]): ConfigurationMemoryBundle[T] = new ConfigurationMemoryBundle(params)
}

class ConfigurationMemoryIO[T <: Data](params: ConfigurationMemoryParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(ConfigurationMemoryBundle(params)))
  val out = ValidWithSync(WellnessConfigurationBundle(params))

  override def cloneType: this.type = ConfigurationMemoryIO(params).asInstanceOf[this.type]
}
object ConfigurationMemoryIO {
  def apply[T <: Data](params: ConfigurationMemoryParams[T]): ConfigurationMemoryIO[T] =
    new ConfigurationMemoryIO(params)
}

class ConfigurationMemory[T <: chisel3.Data : Real : Order : BinaryRepresentation](val params: ConfigurationMemoryParams[T]) extends Module {
  require(params.nFeatures >= 1, "nFeatures must be at least 1")
  require(params.nNeurons >= 1, "nNeurons must be at least 1")
  require(params.nLayers >= 1, "nLayers must be at least 1")
  val io = IO(ConfigurationMemoryIO[T](params))
  // These signals are actually not important for this block. They are there for easy integration into the feature
  // datapaths, if it's ever necessary.
  io.out.sync := false.B
  io.out.valid := true.B

  // MemoryBuffers inside ConfigurationMemory are address mapped. If the write address matches the address of a memory,
  // the data is shifted into that memory.
  val addr = io.in.bits.wraddr
  val neuralNetsinputWeightsMemoryAddr = 0.U
  val neuralNetsmidAndOutputWeightsMemoryAddr = 1.U
  val neuralNetsbiasVecsMemoryAddr = 2.U
  val neuralNetsoutputBiasMemoryAddr = 3.U
  val inputMuxSelAddr = 4.U

  //MemoryBuffer definition for Random Forest weightMatrix
  val neuralNetsinputWeightsMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nFeatures
    override val nColumns: Int = params.nNeurons
  }
  val neuralNetsinputWeightsMemory = Module(new MemoryBuffer[T](neuralNetsinputWeightsMemoryParams))
  neuralNetsinputWeightsMemory.io.in.bits := io.in.bits.wrdata
  neuralNetsinputWeightsMemory.io.in.sync := false.B
  neuralNetsinputWeightsMemory.io.in.valid := io.in.valid && (addr === neuralNetsinputWeightsMemoryAddr)
  io.out.bits.confneuralNetsinputWeights := neuralNetsinputWeightsMemory.io.out.bits

  //MemoryBuffer definition for Random Forest Leaf Votes
  val neuralNetsmidAndOutputWeightsMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nNeurons
    override val nColumns: Int = params.nNeurons * (params.nLayers - 1) + 1
  }
  val neuralNetsmidAndOutputWeightsMemory = Module(new MemoryBuffer[T](neuralNetsmidAndOutputWeightsMemoryParams))
  neuralNetsmidAndOutputWeightsMemory.io.in.bits := io.in.bits.wrdata
  neuralNetsmidAndOutputWeightsMemory.io.in.sync := false.B
  neuralNetsmidAndOutputWeightsMemory.io.in.valid := io.in.valid && (addr === neuralNetsmidAndOutputWeightsMemoryAddr)
  io.out.bits.confneuralNetsmidAndOutputWeights := neuralNetsmidAndOutputWeightsMemory.io.out.bits(0)

  val neuralNetsbiasVecsMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nNeurons
    override val nColumns: Int = params.nLayers
  }
  val neuralNetsbiasVecsMemory = Module(new MemoryBuffer[T](neuralNetsbiasVecsMemoryParams))
  neuralNetsbiasVecsMemory.io.in.bits := io.in.bits.wrdata
  neuralNetsbiasVecsMemory.io.in.sync := false.B
  neuralNetsbiasVecsMemory.io.in.valid := io.in.valid && (addr === neuralNetsbiasVecsMemoryAddr)
  io.out.bits.confneuralNetsbiasVecs := neuralNetsbiasVecsMemory.io.out.bits(0)

  //MemoryBuffer definition for Random Forest Leaf Votes
  val neuralNetsoutputBiasMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = 1
    override val nColumns: Int = 1
  }
  val neuralNetsoutputBiasMemory = Module(new MemoryBuffer[T](neuralNetsoutputBiasMemoryParams))
  neuralNetsoutputBiasMemory.io.in.bits := io.in.bits.wrdata
  neuralNetsoutputBiasMemory.io.in.sync := false.B
  neuralNetsoutputBiasMemory.io.in.valid := io.in.valid && (addr === neuralNetsoutputBiasMemoryAddr)
  io.out.bits.confneuralNetsoutputBias := neuralNetsoutputBiasMemory.io.out.bits(0)


  //No need for a MemoryBuffer for a single bit. Addressing is similar to others though.
  val inputMuxSel = RegInit(false.B)
  when(io.in.valid && (addr === inputMuxSelAddr)){inputMuxSel := io.in.bits.wrdata.asUInt()(0)}
  io.out.bits.confInputMuxSel := inputMuxSel

}
*/