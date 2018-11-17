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
  val memOutPCAVector = ValidWithSync(Vec(params.nDimensions,Vec(params.nFeatures,params.protoData)))
  val memOutSVMSupportVector = ValidWithSync(Vec(params.nSupports,Vec(params.nFeatures,params.protoData)))
  val memOutSVMAlphaVector = ValidWithSync(Vec(params.nClassifiers,Vec(params.nSupports,params.protoData)))
  val memOutSVMIntercept = ValidWithSync(Vec(params.nClassifiers,params.protoData))
  // TODO: SVM Intercept "valid" does not work. Fix it from inside "MemoryBuffer.scala" (probably)

  override def cloneType: this.type = ConfigurationMemoryIO(params).asInstanceOf[this.type]
}
object ConfigurationMemoryIO {
  def apply[T <: Data](params: ConfigurationMemoryParams[T]): ConfigurationMemoryIO[T] =
    new ConfigurationMemoryIO(params)
}

class ConfigurationMemory[T <: chisel3.Data : Real : Order : BinaryRepresentation](val params: ConfigurationMemoryParams[T]) extends Module {
  require(params.nDimensions >= 1)
  require(params.nFeatures >= 1)
  require(params.nSupports >= 1)
  require(params.nClassifiers >= 1)
  val io = IO(ConfigurationMemoryIO[T](params))

  val addr = io.in.bits.wraddr
  val pcaVectorMemoryAddr = 0.U
  val svmSupportVectorMemoryAddr = 1.U
  val svmAlphaVectorMemoryAddr = 2.U
  val svmInterceptMemoryAddr = 3.U

  val pcaVectorMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nFeatures
    override val nColumns: Int = params.nDimensions
  }

  val pcaVectorMemory = Module(new MemoryBuffer[T](pcaVectorMemoryParams))
  pcaVectorMemory.io.in.bits := io.in.bits.wrdata
  pcaVectorMemory.io.in.sync := false.B
  pcaVectorMemory.io.in.valid := io.in.valid && (addr === pcaVectorMemoryAddr)
  io.memOutPCAVector.bits := pcaVectorMemory.io.out.bits
  io.memOutPCAVector.sync := false.B
  io.memOutPCAVector.valid := pcaVectorMemory.io.out.valid

  val svmSupportVectorMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nFeatures
    override val nColumns: Int = params.nSupports
  }

  val svmSupportVectorMemory = Module(new MemoryBuffer[T](svmSupportVectorMemoryParams))
  svmSupportVectorMemory.io.in.bits := io.in.bits.wrdata
  svmSupportVectorMemory.io.in.sync := false.B
  svmSupportVectorMemory.io.in.valid := io.in.valid && (addr === svmSupportVectorMemoryAddr)
  io.memOutSVMSupportVector.bits := svmSupportVectorMemory.io.out.bits
  io.memOutSVMSupportVector.sync := false.B
  io.memOutSVMSupportVector.valid := svmSupportVectorMemory.io.out.valid

  val svmAlphaVectorMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nSupports
    override val nColumns: Int = params.nClassifiers
  }

  val svmAlphaVectorMemory = Module(new MemoryBuffer[T](svmAlphaVectorMemoryParams))
  svmAlphaVectorMemory.io.in.bits := io.in.bits.wrdata
  svmAlphaVectorMemory.io.in.sync := false.B
  svmAlphaVectorMemory.io.in.valid := io.in.valid && (addr === svmAlphaVectorMemoryAddr)
  io.memOutSVMAlphaVector.bits := svmAlphaVectorMemory.io.out.bits
  io.memOutSVMAlphaVector.sync := false.B
  io.memOutSVMAlphaVector.valid := svmAlphaVectorMemory.io.out.valid

  val svmInterceptMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = params.nClassifiers
    override val nColumns: Int = 1
  }

  val svmInterceptMemory = Module(new MemoryBuffer[T](svmInterceptMemoryParams))
  svmInterceptMemory.io.in.bits := io.in.bits.wrdata
  svmInterceptMemory.io.in.sync := false.B
  svmInterceptMemory.io.in.valid := io.in.valid && (addr === svmInterceptMemoryAddr)
  io.memOutSVMIntercept.bits := svmInterceptMemory.io.out.bits.head
  io.memOutSVMIntercept.sync := false.B
  io.memOutSVMIntercept.valid := svmInterceptMemory.io.out.valid

}
