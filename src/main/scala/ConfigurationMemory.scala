package wellness

import memorybuffer._
import chisel3._
import chisel3.util.{RegEnable, log2Ceil}
import dspblocks.ShiftRegisterWithReset
import dspjunctions.ValidWithSync
import dsptools.numbers._

import scala.collection._

trait ConfigurationMemoryParams[T <: Data] {
  val protoData: T
  val nDimensions: Int
  val nFeatures: Int
  val nSupports: Int
  val nClassifiers: Int
}

class ConfigurationMemoryBundle[T <: Data](params: ConfigurationMemoryParams[T]) extends Bundle {
  val wrdata: T = params.protoData
  val wraddr = UInt(2.W)

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
  require(params.nDimensions >= 1, "nDimensions must be at least 1")
  require(params.nFeatures >= 1, "nFeatures must be at least 1")
  require(params.nSupports >= 1, "nSupports must be at least 1")
  require(params.nClassifiers >= 1, "nClassifiers must be at least 1")
  val io = IO(ConfigurationMemoryIO[T](params))
  io.out.sync := false.B
  io.out.valid := true.B

  val addr = io.in.bits.wraddr
  val pcaVectorMemoryAddr = 0.U
  val svmSupportVectorMemoryAddr = 1.U
  val svmAlphaVectorMemoryAddr = 2.U
  val svmInterceptMemoryAddr = 3.U

  val pcaVectorMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nDimensions
    override val nColumns: Int = params.nFeatures
  }

  val pcaVectorMemory = Module(new MemoryBuffer[T](pcaVectorMemoryParams))
  pcaVectorMemory.io.in.bits := io.in.bits.wrdata
  pcaVectorMemory.io.in.sync := false.B
  pcaVectorMemory.io.in.valid := io.in.valid && (addr === pcaVectorMemoryAddr)
  io.out.bits.confPCAVector := pcaVectorMemory.io.out.bits

  val svmSupportVectorMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nFeatures
    override val nColumns: Int = params.nSupports
  }

  val svmSupportVectorMemory = Module(new MemoryBuffer[T](svmSupportVectorMemoryParams))
  svmSupportVectorMemory.io.in.bits := io.in.bits.wrdata
  svmSupportVectorMemory.io.in.sync := false.B
  svmSupportVectorMemory.io.in.valid := io.in.valid && (addr === svmSupportVectorMemoryAddr)
  io.out.bits.confSVMSupportVector := svmSupportVectorMemory.io.out.bits

  val svmAlphaVectorMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nSupports
    override val nColumns: Int = params.nClassifiers
  }

  val svmAlphaVectorMemory = Module(new MemoryBuffer[T](svmAlphaVectorMemoryParams))
  svmAlphaVectorMemory.io.in.bits := io.in.bits.wrdata
  svmAlphaVectorMemory.io.in.sync := false.B
  svmAlphaVectorMemory.io.in.valid := io.in.valid && (addr === svmAlphaVectorMemoryAddr)
  io.out.bits.confSVMAlphaVector := svmAlphaVectorMemory.io.out.bits

  val svmInterceptMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nClassifiers
    override val nColumns: Int = 1
  }

  val svmInterceptMemory = Module(new MemoryBuffer[T](svmInterceptMemoryParams))
  svmInterceptMemory.io.in.bits := io.in.bits.wrdata
  svmInterceptMemory.io.in.sync := false.B
  svmInterceptMemory.io.in.valid := io.in.valid && (addr === svmInterceptMemoryAddr)
  io.out.bits.confSVMIntercept := svmInterceptMemory.io.out.bits.head

}
