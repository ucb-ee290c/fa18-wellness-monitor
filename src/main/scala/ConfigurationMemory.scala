package wellness

import memorybuffer._
import chisel3._
import dspjunctions.ValidWithSync
import dsptools.numbers._

/**
  * Configuration Memory
  * @trait ConfigurationMemoryParams containts parameter definitions
  * @class ConfigurationMemoryBundle is the write input bundle for Configuration Memory
  * @class ConfigurationMemoryIO is the IO bundle for ConfigurationMemory
  * @class ConfigurationMemory is the generator definition
  *       @param protoData is the prototype data used for PCA and SVM vector elements
  *       @param nDimensions is the number of dimensions that are input to the PCA
  *       @param nFeatures is the number of feature outputs from PCA, to the SVM
  *       @param nSupports is the number of elements in the support vector of the SVM
  *       @param nClassifiers is the number of classifiers in the SVM
  */

trait ConfigurationMemoryParams[T <: Data] {
  val protoData: T
  val nDimensions: Int
  val nFeatures: Int
  val nSupports: Int
  val nClassifiers: Int
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
  require(params.nDimensions >= 1, "nDimensions must be at least 1")
  require(params.nFeatures >= 1, "nFeatures must be at least 1")
  require(params.nSupports >= 1, "nSupports must be at least 1")
  require(params.nClassifiers >= 1, "nClassifiers must be at least 1")
  val io = IO(ConfigurationMemoryIO[T](params))
  // These signals are actually not important for this block. They are there for easy integration into the feature
  // datapaths, if it's ever necessary.
  io.out.sync := false.B
  io.out.valid := true.B

  // MemoryBuffers inside ConfigurationMemory are address mapped. If the write address matches the address of a memory,
  // the data is shifted into that memory.
  val addr = io.in.bits.wraddr
  val pcaVectorMemoryAddr = 0.U
  val svmSupportVectorMemoryAddr = 1.U
  val svmAlphaVectorMemoryAddr = 2.U
  val svmInterceptMemoryAddr = 3.U
  val inputMuxSelAddr = 4.U
  val pcaNormalizationMemoryAddr = 5.U

  //MemoryBuffer definition for PCA
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

  //MemoryBuffer definition for PCA Normalization
  val pcaNormalizationMemoryParams = new MemoryBufferParams[T] {
    override val protoData: T = params.protoData.cloneType
    override val nRows: Int = 2
    override val nColumns: Int = params.nDimensions
  }
  val pcaNormalizationMemory = Module(new MemoryBuffer[T](pcaNormalizationMemoryParams))
  pcaNormalizationMemory.io.in.bits := io.in.bits.wrdata
  pcaNormalizationMemory.io.in.sync := false.B
  pcaNormalizationMemory.io.in.valid := io.in.valid && (addr === pcaNormalizationMemoryAddr)
  io.out.bits.confPCANormalizationData := pcaNormalizationMemory.io.out.bits

  //MemoryBuffer definition for SVM Support Vector
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

  //MemoryBuffer definition for SVM Alpha Vector
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

  //MemoryBuffer definition for SVM Intercept
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

  //No need for a MemoryBuffer for a single bit. Addressing is similar to others though.
  val inputMuxSel = RegInit(false.B)
  when(io.in.valid && (addr === inputMuxSelAddr)){inputMuxSel := io.in.bits.wrdata.asUInt()(0)}
  io.out.bits.confInputMuxSel := inputMuxSel

}
