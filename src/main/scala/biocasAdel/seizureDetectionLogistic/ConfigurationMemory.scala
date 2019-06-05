/*
package wellness

import memorybuffer._
import chisel3._
import dspjunctions.ValidWithSync
import dsptools.numbers._

trait ConfigurationMemoryParams[T <: Data] {
  val protoData: T
  val nFeatures: Int
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
  val io = IO(ConfigurationMemoryIO[T](params))
  // These signals are actually not important for this block. They are there for easy integration into the feature
  // datapaths, if it's ever necessary.
  io.out.sync := false.B
  io.out.valid := true.B

  // MemoryBuffers inside ConfigurationMemory are address mapped. If the write address matches the address of a memory,
  // the data is shifted into that memory.
  val addr = io.in.bits.wraddr
  val logisticWeightsVectorMemoryAddr = 0.U
  val logisticInterceptMemoryAddr = 1.U
  val inputMuxSelAddr = 2.U

  //MemoryBuffer definition for Logistic Weights Vector
  val logisticWeightsVectorMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nFeatures
    override val nColumns: Int = 1
  }
  val logisticWeightsVectorMemory = Module(new MemoryBuffer[T](logisticWeightsVectorMemoryParams))
  logisticWeightsVectorMemory.io.in.bits := io.in.bits.wrdata
  logisticWeightsVectorMemory.io.in.sync := false.B
  logisticWeightsVectorMemory.io.in.valid := io.in.valid && (addr === logisticWeightsVectorMemoryAddr)
  io.out.bits.conflogisticWeightsVector := logisticWeightsVectorMemory.io.out.bits

  //MemoryBuffer definition for Logistic Intercept
  val logisticInterceptMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = 1
    override val nColumns: Int = 1
  }
  val logisticInterceptMemory = Module(new MemoryBuffer[T](logisticInterceptMemoryParams))
  logisticInterceptMemory.io.in.bits := io.in.bits.wrdata
  logisticInterceptMemory.io.in.sync := false.B
  logisticInterceptMemory.io.in.valid := io.in.valid && (addr === logisticInterceptMemoryAddr)
  io.out.bits.conflogisticIntercept := logisticInterceptMemory.io.out.bits.head

  //No need for a MemoryBuffer for a single bit. Addressing is similar to others though.
  val inputMuxSel = RegInit(false.B)
  when(io.in.valid && (addr === inputMuxSelAddr)){inputMuxSel := io.in.bits.wrdata.asUInt()(0)}
  io.out.bits.confInputMuxSel := inputMuxSel

}

 */