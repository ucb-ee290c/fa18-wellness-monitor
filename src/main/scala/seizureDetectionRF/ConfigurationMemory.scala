/*
package wellness

import memorybuffer._
import chisel3._
import dspjunctions.ValidWithSync
import dsptools.numbers._

trait ConfigurationMemoryParams[T <: Data] {
  val protoData: T
  val nTrees: Int
  val nDepth: Int
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
  require(params.nTrees >= 1, "nTrees must be at least 1")
  require(params.nDepth >= 1, "nDepth must be at least 1")
  val io = IO(ConfigurationMemoryIO[T](params))
  // These signals are actually not important for this block. They are there for easy integration into the feature
  // datapaths, if it's ever necessary.
  io.out.sync := false.B
  io.out.valid := true.B

  // MemoryBuffers inside ConfigurationMemory are address mapped. If the write address matches the address of a memory,
  // the data is shifted into that memory.
  val addr = io.in.bits.wraddr
  val randomForestThresholdsMemoryAddr = 0.U
  val randomForestLeafVotesMemoryAddr = 1.U
  val inputMuxSelAddr = 2.U

  //MemoryBuffer definition for Random Forest Thresholds
  val randomForestThresholdsMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = (1 << params.nDepth) - 1
    override val nColumns: Int = params.nTrees
  }
  val randomForestThresholdsMemory = Module(new MemoryBuffer[T](randomForestThresholdsMemoryParams))
  randomForestThresholdsMemory.io.in.bits := io.in.bits.wrdata
  randomForestThresholdsMemory.io.in.sync := false.B
  randomForestThresholdsMemory.io.in.valid := io.in.valid && (addr === randomForestThresholdsMemoryAddr)
  io.out.bits.confrandomForestThresholds := randomForestThresholdsMemory.io.out.bits

  //MemoryBuffer definition for Random Forest Leaf Votes
  val randomForestLeafVotesMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = 1 << params.nDepth
    override val nColumns: Int = params.nTrees
  }
  val randomForestLeafVotesMemory = Module(new MemoryBuffer[T](randomForestLeafVotesMemoryParams))
  randomForestLeafVotesMemory.io.in.bits := io.in.bits.wrdata
  randomForestLeafVotesMemory.io.in.sync := false.B
  randomForestLeafVotesMemory.io.in.valid := io.in.valid && (addr === randomForestLeafVotesMemoryAddr)
  io.out.bits.confrandomForestLeafVotes := randomForestLeafVotesMemory.io.out.bits.head

  //No need for a MemoryBuffer for a single bit. Addressing is similar to others though.
  val inputMuxSel = RegInit(false.B)
  when(io.in.valid && (addr === inputMuxSelAddr)){inputMuxSel := io.in.bits.wrdata.asUInt()(0)}
  io.out.bits.confInputMuxSel := inputMuxSel

}
*/
