/*
package wellness

import memorybuffer._
import chisel3._
import dspjunctions.ValidWithSync
import dsptools.numbers._

trait ConfigurationMemoryParams[T <: Data] {
  val protoData: T
  val nFeatures: Int // number of dimensions in input data
  val nNeurons: Int // number of neurons in hidden layer
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
  val io = IO(ConfigurationMemoryIO[T](params))
  // These signals are actually not important for this block. They are there for easy integration into the feature
  // datapaths, if it's ever necessary.
  io.out.sync := false.B
  io.out.valid := true.B

  // MemoryBuffers inside ConfigurationMemory are address mapped. If the write address matches the address of a memory,
  // the data is shifted into that memory.
  val addr = io.in.bits.wraddr
  val neuralNetsweightMatrixMemoryAddr = 0.U
  val neuralNetsweightVecMemoryAddr = 1.U
  val neuralNetsbiasVecMemoryAddr = 2.U
  val neuralNetsbiasScalarMemoryAddr = 3.U
  val inputMuxSelAddr = 4.U

  //MemoryBuffer definition for Random Forest weightMatrix
  val neuralNetsweightMatrixMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nFeatures
    override val nColumns: Int = params.nNeurons
  }
  val neuralNetsweightMatrixMemory = Module(new MemoryBuffer[T](neuralNetsweightMatrixMemoryParams))
  neuralNetsweightMatrixMemory.io.in.bits := io.in.bits.wrdata
  neuralNetsweightMatrixMemory.io.in.sync := false.B
  neuralNetsweightMatrixMemory.io.in.valid := io.in.valid && (addr === neuralNetsweightMatrixMemoryAddr)
  io.out.bits.confneuralNetsweightMatrix := neuralNetsweightMatrixMemory.io.out.bits

  //MemoryBuffer definition for Random Forest Leaf Votes
  val neuralNetsweightVecMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nNeurons
    override val nColumns: Int = 1
  }
  val neuralNetsweightVecMemory = Module(new MemoryBuffer[T](neuralNetsweightVecMemoryParams))
  neuralNetsweightVecMemory.io.in.bits := io.in.bits.wrdata
  neuralNetsweightVecMemory.io.in.sync := false.B
  neuralNetsweightVecMemory.io.in.valid := io.in.valid && (addr === neuralNetsweightVecMemoryAddr)
  io.out.bits.confneuralNetsweightVec := neuralNetsweightVecMemory.io.out.bits

  val neuralNetsbiasVecMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nNeurons
    override val nColumns: Int = 1
  }
  val neuralNetsbiasVecMemory = Module(new MemoryBuffer[T](neuralNetsweightMatrixMemoryParams))
  neuralNetsbiasVecMemory.io.in.bits := io.in.bits.wrdata
  neuralNetsbiasVecMemory.io.in.sync := false.B
  neuralNetsbiasVecMemory.io.in.valid := io.in.valid && (addr === neuralNetsbiasVecMemoryAddr)
  io.out.bits.confneuralNetsbiasVec := neuralNetsbiasVecMemory.io.out.bits

  //MemoryBuffer definition for Random Forest Leaf Votes
  val neuralNetsbiasScalarMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = 1
    override val nColumns: Int = 1
  }
  val neuralNetsbiasScalarMemory = Module(new MemoryBuffer[T](neuralNetsweightVecMemoryParams))
  neuralNetsbiasScalarMemory.io.in.bits := io.in.bits.wrdata
  neuralNetsbiasScalarMemory.io.in.sync := false.B
  neuralNetsbiasScalarMemory.io.in.valid := io.in.valid && (addr === neuralNetsbiasScalarMemoryAddr)
  io.out.bits.confneuralNetsbiasScalar := neuralNetsbiasScalarMemory.io.out.bits


  //No need for a MemoryBuffer for a single bit. Addressing is similar to others though.
  val inputMuxSel = RegInit(false.B)
  when(io.in.valid && (addr === inputMuxSelAddr)){inputMuxSel := io.in.bits.wrdata.asUInt()(0)}
  io.out.bits.confInputMuxSel := inputMuxSel

}
*/
