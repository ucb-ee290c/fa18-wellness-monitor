package wellness

import chisel3._
import chisel3.util._
import dspblocks._
import dspjunctions.ValidWithSync
import dsptools.numbers._
import firFilter._
import fft._
import features._
import pca._
import svm._
import freechips.rocketchip.amba.axi4stream._
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.subsystem._

import scala.collection.Seq

abstract class WriteQueue
(
  val depth: Int = 8,
  val streamParameters: AXI4StreamMasterParameters = AXI4StreamMasterParameters()
)(implicit p: Parameters) extends LazyModule with HasCSR {
  // stream node, output only
  val streamNode = AXI4StreamMasterNode(streamParameters)

  lazy val module = new LazyModuleImp(this) {
    require(streamNode.out.length == 1)

    // get the output bundle associated with the AXI4Stream node
    val out = streamNode.out(0)._1
    // width (in bits) of the output interface
    val width = out.params.n * 8
    // instantiate a queue
    val streamInQueue = Module(new Queue(UInt(out.params.dataBits.W), depth))
    // connect queue output to streaming output
    out.valid := streamInQueue.io.deq.valid
    out.bits.data := streamInQueue.io.deq.bits
    // don't use last
    out.bits.last := false.B
    streamInQueue.io.deq.ready := out.ready

    regmap(
      // each write adds an entry to the Stream In Queue
      0x0 -> Seq(RegField.w(width, streamInQueue.io.enq)),
      // read the number of entries in the Stream In Queue
      (width+7)/8 -> Seq(RegField.r(width, streamInQueue.io.count)),
    )
  }
}

class TLWriteQueue
(
  depth: Int = 8,
  csrAddress: AddressSet = AddressSet(0x2000, 0xff),
  beatBytes: Int = 8,
)(implicit p: Parameters) extends WriteQueue(depth) with TLHasCSR {
  val devname = "tlQueueIn"
  val devcompat = Seq("ucb-art", "dsptools")
  val device = new SimpleDevice(devname, devcompat) {
    override def describe(resources: ResourceBindings): Description = {
      val Description(name, mapping) = super.describe(resources)
      Description(name, mapping)
    }
  }
  // make diplomatic TL node for regmap
  override val mem = Some(TLRegisterNode(address = Seq(csrAddress), device = device, beatBytes = beatBytes))
}

abstract class ReadQueue
(
  val depth: Int = 8,
  val streamParameters: AXI4StreamSlaveParameters = AXI4StreamSlaveParameters()
)(implicit p: Parameters) extends LazyModule with HasCSR {
  val streamNode = AXI4StreamSlaveNode(streamParameters)

  lazy val module = new LazyModuleImp(this) {
    require(streamNode.in.length == 1)

    // get the input bundle associated with the AXI4Stream node
    val in = streamNode.in(0)._1
    // width (in bits) of the input interface
    val width = in.params.n * 8
    // instantiate a queue
    val queue = Module(new Queue(UInt(in.params.dataBits.W), depth))
    // connect queue input to streaming input
    in.ready := queue.io.enq.ready
    queue.io.enq.bits := in.bits.data
    queue.io.enq.valid := in.valid

    regmap(
      // each write adds an entry to the queue
      0x0 -> Seq(RegField.r(width, queue.io.deq)),
      // read the number of entries in the queue
      (width+7)/8 -> Seq(RegField.r(width, queue.io.count)),
    )
  }
}

class TLReadQueue
(
  depth: Int = 8,
  csrAddress: AddressSet = AddressSet(0x2100, 0xff),
  beatBytes: Int = 8
)(implicit p: Parameters) extends ReadQueue(depth) with TLHasCSR {
  val devname = "tlQueueOut"
  val devcompat = Seq("ucb-art", "dsptools")
  val device = new SimpleDevice(devname, devcompat) {
    override def describe(resources: ResourceBindings): Description = {
      val Description(name, mapping) = super.describe(resources)
      Description(name, mapping)
    }
  }
  // make diplomatic TL node for regmap
  override val mem = Some(TLRegisterNode(address = Seq(csrAddress), device = device, beatBytes = beatBytes))

}

class WellnessConfigurationBundle[T <: Data](params: ConfigurationMemoryParams[T]) extends Bundle {
  val confPCAVector = Vec(params.nFeatures,Vec(params.nDimensions,params.protoData))
  val confSVMSupportVector = Vec(params.nSupports,Vec(params.nFeatures,params.protoData))
  val confSVMAlphaVector = Vec(params.nClassifiers,Vec(params.nSupports,params.protoData))
  val confSVMIntercept = Vec(params.nClassifiers,params.protoData)
  val confInputMuxSel = Bool()

  override def cloneType: this.type = WellnessConfigurationBundle(params).asInstanceOf[this.type]
}
object WellnessConfigurationBundle {
  def apply[T <: Data](params: ConfigurationMemoryParams[T]): WellnessConfigurationBundle[T] = new WellnessConfigurationBundle(params)
}

class WellnessModuleIO[T <: Data : Real : Order : BinaryRepresentation](filter1Params: FIRFilterParams[T],
                                                 lineLength1Params: lineLengthParams[T],
                                                 fftBufferParams: FFTBufferParams[T],
                                                 fftConfig: FFTConfig[T],
                                                 bandpower1Params: BandpowerParams[T],
                                                 bandpower2Params: BandpowerParams[T],
                                                 pcaParams: PCAParams[T],
                                                 svmParams: SVMParams[T],
                                                 configurationMemoryParams: ConfigurationMemoryParams[T]) extends Bundle {
  var nClassifiers = svmParams.nClasses  // one vs rest default
  if (svmParams.classifierType == "ovr") {
    if (svmParams.nClasses == 2) nClassifiers = svmParams.nClasses - 1
  } else if (svmParams.classifierType == "ovo") {   // one vs one
    nClassifiers = (svmParams.nClasses*(svmParams.nClasses - 1))/2
  } else if (svmParams.classifierType == "ecoc") {  // error correcting output code
    nClassifiers = svmParams.codeBook.head.length // # columns = # classifiers
  }
  val streamIn = Flipped(ValidWithSync(filter1Params.protoData.cloneType))
  val in = Flipped(DecoupledIO(filter1Params.protoData.cloneType))
  val inConf = Flipped(ValidWithSync(WellnessConfigurationBundle(configurationMemoryParams)))
  val out = ValidWithSync(Bool())
  val rawVotes = Output(Vec(svmParams.nClasses, svmParams.protoData))
  val classVotes = Output(Vec(svmParams.nClasses,UInt((log2Ceil(nClassifiers)+1).W)))
  val lineOut = Output(lineLength1Params.protoData)
  val fftBufferOut = Output(Vec(fftBufferParams.lanes, fftBufferParams.protoData))
  val fftOut = Output(Vec(fftConfig.lanes, fftConfig.genOut))
  val bandpower1Out = Output(bandpower1Params.genOut)
  val bandpower2Out = Output(bandpower2Params.genOut)
  val filterOut = Output(filter1Params.protoData)
  val pcaOut = Output(Vec(pcaParams.nFeatures, pcaParams.protoData))

  override def cloneType: this.type = WellnessModuleIO( filter1Params: FIRFilterParams[T],
                                                        lineLength1Params: lineLengthParams[T],
                                                        fftBufferParams: FFTBufferParams[T],
                                                        fftConfig: FFTConfig[T],
                                                        bandpower1Params: BandpowerParams[T],
                                                        bandpower2Params: BandpowerParams[T],
                                                        pcaParams: PCAParams[T],
                                                        svmParams: SVMParams[T],
                                                        configurationMemoryParams: ConfigurationMemoryParams[T]).asInstanceOf[this.type]
}
object WellnessModuleIO {
  def apply[T <: chisel3.Data : Real : Order : BinaryRepresentation](filter1Params: FIRFilterParams[T],
                                      lineLength1Params: lineLengthParams[T],
                                      fftBufferParams: FFTBufferParams[T],
                                      fftConfig: FFTConfig[T],
                                      bandpower1Params: BandpowerParams[T],
                                      bandpower2Params: BandpowerParams[T],
                                      pcaParams: PCAParams[T],
                                      svmParams: SVMParams[T],
                                      configurationMemoryParams: ConfigurationMemoryParams[T]): WellnessModuleIO[T] =
    new WellnessModuleIO(filter1Params: FIRFilterParams[T],
      lineLength1Params: lineLengthParams[T],
      fftBufferParams: FFTBufferParams[T],
      fftConfig: FFTConfig[T],
      bandpower1Params: BandpowerParams[T],
      bandpower2Params: BandpowerParams[T],
      pcaParams: PCAParams[T],
      svmParams: SVMParams[T],
      configurationMemoryParams: ConfigurationMemoryParams[T])
}

class WellnessModule[T <: chisel3.Data : Real : Order : BinaryRepresentation]
( val filter1Params: FIRFilterParams[T],
  val lineLength1Params: lineLengthParams[T],
  val fftBufferParams: FFTBufferParams[T],
  val fftConfig: FFTConfig[T],
  val bandpower1Params: BandpowerParams[T],
  val bandpower2Params: BandpowerParams[T],
  val pcaParams: PCAParams[T],
  val svmParams: SVMParams[T],
  val configurationMemoryParams: ConfigurationMemoryParams[T])(implicit val p: Parameters) extends Module {
  val io = IO(WellnessModuleIO[T](  filter1Params: FIRFilterParams[T],
                                    lineLength1Params: lineLengthParams[T],
                                    fftBufferParams: FFTBufferParams[T],
                                    fftConfig: FFTConfig[T],
                                    bandpower1Params: BandpowerParams[T],
                                    bandpower2Params: BandpowerParams[T],
                                    pcaParams: PCAParams[T],
                                    svmParams: SVMParams[T],
                                    configurationMemoryParams: ConfigurationMemoryParams[T]) )

  // Block instantiation
  val filter1 = Module(new ConstantCoefficientFIRFilter(filter1Params))
  val lineLength1 = Module(new lineLength(lineLength1Params))
  val fftBuffer = Module(new FFTBuffer(fftBufferParams))
  val fft = Module(new FFT(fftConfig))
  val bandpower1 = Module(new Bandpower(bandpower1Params))
  val bandpower2 = Module(new Bandpower(bandpower2Params))
  val pca = Module(new PCA(pcaParams))
  val svm = Module(new SVM(svmParams))




  val inStream = Wire(ValidWithSync(filter1Params.protoData))
  inStream.bits := Mux(io.inConf.bits.confInputMuxSel,io.streamIn.bits.asTypeOf(filter1Params.protoData),io.in.bits.asTypeOf(filter1Params.protoData))
  inStream.valid := Mux(io.inConf.bits.confInputMuxSel,io.streamIn.valid,io.in.valid)
  inStream.sync := Mux(io.inConf.bits.confInputMuxSel,io.streamIn.sync,false.B)

  // Input to Filters
  filter1.io.in.valid := inStream.valid
  filter1.io.in.sync := inStream.sync
  filter1.io.in.bits := inStream.bits

  // FIR Filters to Line length blocks
  lineLength1.io.in.valid := filter1.io.out.valid
  lineLength1.io.in.sync := false.B
  lineLength1.io.in.bits := filter1.io.out.bits.asTypeOf(lineLength1Params.protoData)

  // FIR Filters to FFT Buffers
  fftBuffer.io.in.valid := filter1.io.out.valid
  fftBuffer.io.in.sync := false.B
  fftBuffer.io.in.bits := filter1.io.out.bits.asTypeOf(fftBufferParams.protoData)

  // FFT Buffers to FFTs
  fft.io.in.valid := fftBuffer.io.out.valid
  fft.io.in.sync := false.B
  for (i <- fft.io.in.bits.indices) {
    fft.io.in.bits(i).real := fftBuffer.io.out.bits(i).asTypeOf(fft.io.in.bits(i).real)
  }
  fft.io.in.bits.foreach(_.imag := ConvertableTo[T].fromInt(0))

  fft.io.data_set_end_clear := false.B

  // FFTs to Bandpowers
  bandpower1.io.in.valid := fft.io.out.valid
  bandpower1.io.in.sync := false.B
  bandpower1.io.in.bits := fft.io.out.bits

  bandpower2.io.in.valid := fft.io.out.valid
  bandpower2.io.in.sync := false.B
  bandpower2.io.in.bits := fft.io.out.bits

  // Features to PCA
  val pcaInVector = Wire(Vec(3,pcaParams.protoData))
  pcaInVector(0) := lineLength1.io.out.bits.asTypeOf(pcaParams.protoData)
  pcaInVector(1) := bandpower1.io.out.bits.asTypeOf(pcaParams.protoData)
  pcaInVector(2) := bandpower2.io.out.bits.asTypeOf(pcaParams.protoData)
  pca.io.PCAVector := io.inConf.bits.confPCAVector
  pca.io.in.bits := pcaInVector
  pca.io.in.sync := false.B
  pca.io.in.valid := (lineLength1.io.out.valid && bandpower1.io.out.valid && bandpower2.io.out.valid)

  // PCA to SVM
  svm.io.in.valid := pca.io.out.valid
  svm.io.in.bits := pca.io.out.bits
  svm.io.in.sync := false.B
  svm.io.supportVector := io.inConf.bits.confSVMSupportVector
  svm.io.alphaVector := io.inConf.bits.confSVMAlphaVector
  svm.io.intercept := io.inConf.bits.confSVMIntercept

  // SVM to Output
  io.out.valid := svm.io.out.valid
  io.out.sync := svm.io.out.sync
  io.out.bits := false.B
  io.rawVotes := svm.io.rawVotes
  io.classVotes := svm.io.classVotes

  // pinned out outputs for debug purposes
  io.filterOut := filter1.io.out.bits
  io.lineOut := lineLength1.io.out.bits
  io.fftBufferOut := fftBuffer.io.out.bits
  io.fftOut := fft.io.out.bits
  io.bandpower1Out := bandpower1.io.out.bits
  io.bandpower2Out := bandpower2.io.out.bits
  io.pcaOut := pca.io.out.bits
}


abstract class WellnessDataPathBlock[D, U, EO, EI, B <: Data, T <: Data : Real : Order : BinaryRepresentation]
(
  val filter1Params: FIRFilterParams[T],
  val lineLength1Params: lineLengthParams[T],
  val fftBufferParams: FFTBufferParams[T],
  val fftConfig: FFTConfig[T],
  val bandpower1Params: BandpowerParams[T],
  val bandpower2Params: BandpowerParams[T],
  val pcaParams: PCAParams[T],
  val svmParams: SVMParams[T],
  val configurationMemoryParams: ConfigurationMemoryParams[T]
)(implicit p: Parameters) extends DspBlock[D, U, EO, EI, B] {
  val streamNode = AXI4StreamNexusNode(
    masterFn = { seq => AXI4StreamMasterPortParameters()},
    slaveFn  = { seq => AXI4StreamSlavePortParameters()}
  )
  val mem = None

  lazy val module = new LazyModuleImp(this) {
    require(streamNode.in.length == 2)
    require(streamNode.out.length == 1)

    val in = streamNode.in.head._1
    val inConf = streamNode.in(1)._1
    val out = streamNode.out.head._1

    // Block instantiation
    val wellness = Module(new WellnessModule(filter1Params:
      FIRFilterParams[T],
      lineLength1Params: lineLengthParams[T],
      fftBufferParams: FFTBufferParams[T],
      fftConfig: FFTConfig[T],
      bandpower1Params: BandpowerParams[T],
      bandpower2Params: BandpowerParams[T],
      pcaParams: PCAParams[T],
      svmParams: SVMParams[T],
      configurationMemoryParams: ConfigurationMemoryParams[T]))

    val configurationMemory = Module(new ConfigurationMemory(configurationMemoryParams))
    val streamIn = IO(Flipped(ValidWithSync(filter1Params.protoData.cloneType)))

    wellness.io.streamIn.bits := streamIn.bits
    wellness.io.streamIn.valid := streamIn.valid
    wellness.io.streamIn.sync := streamIn.sync

    in.ready := wellness.io.in.ready
    // Input to Wellness
    wellness.io.in.valid := in.valid
    wellness.io.in.bits := in.bits.data.asTypeOf(filter1Params.protoData)
    // Wellness to Output
    out.valid := wellness.io.out.valid
    out.bits.data := Cat(wellness.io.rawVotes(1).asUInt(),wellness.io.rawVotes(0).asUInt())

    inConf.ready := true.B
    configurationMemory.io.in.valid := inConf.valid
    configurationMemory.io.in.sync := false.B
    configurationMemory.io.in.bits.wrdata := inConf.bits.data(configurationMemory.io.in.bits.wrdata.getWidth-1,0).asTypeOf(configurationMemory.io.in.bits.wrdata)
    configurationMemory.io.in.bits.wraddr := inConf.bits.data(configurationMemory.io.in.bits.wrdata.getWidth+2,configurationMemory.io.in.bits.wrdata.getWidth).asTypeOf(configurationMemory.io.in.bits.wraddr)
    wellness.io.inConf := configurationMemory.io.out
  }
}

class TLWellnessDataPathBlock[T <: Data : Real : Order : BinaryRepresentation]
(
  filter1Params: FIRFilterParams[T],
  lineLength1Params: lineLengthParams[T],
  fftBufferParams: FFTBufferParams[T],
  fftConfig: FFTConfig[T],
  bandpower1Params: BandpowerParams[T],
  bandpower2Params: BandpowerParams[T],
  pcaParams: PCAParams[T],
  svmParams: SVMParams[T],
  configurationMemoryParams: ConfigurationMemoryParams[T]
)(implicit p: Parameters) extends
  WellnessDataPathBlock[TLClientPortParameters, TLManagerPortParameters, TLEdgeOut, TLEdgeIn, TLBundle, T](
    filter1Params,
    lineLength1Params,
    fftBufferParams,
    fftConfig,
    bandpower1Params, bandpower2Params,
    pcaParams, svmParams,
    configurationMemoryParams)
  with TLDspBlock


class WellnessThing[T <: Data : Real : Order : BinaryRepresentation]
(
  val filter1Params: FIRFilterParams[T],
  val lineLength1Params: lineLengthParams[T],
  val fftBufferParams: FFTBufferParams[T],
  val fftConfig: FFTConfig[T],
  val bandpower1Params: BandpowerParams[T],
  val bandpower2Params: BandpowerParams[T],
  val pcaParams: PCAParams[T],
  val svmParams: SVMParams[T],
  val configurationMemoryParams: ConfigurationMemoryParams[T],
  val depth: Int = 32
)(implicit p: Parameters) extends LazyModule {
  // Instantiate lazy modules
  val writeQueue = LazyModule(new TLWriteQueue(depth))
  val configurationBaseAddr = AddressSet(0x2200, 0xff)
  val writeConfigurationQueue = LazyModule(new TLWriteQueue(depth,configurationBaseAddr))
  val wellness = LazyModule(new TLWellnessDataPathBlock(
    filter1Params,
    lineLength1Params,
    fftBufferParams,
    fftConfig,
    bandpower1Params, bandpower2Params,
    pcaParams, svmParams,
    configurationMemoryParams))
  val readQueue = LazyModule(new TLReadQueue(depth))

  // Connect streamNodes of queues and wellness monitor
  readQueue.streamNode := wellness.streamNode := writeQueue.streamNode
  wellness.streamNode := writeConfigurationQueue.streamNode

  lazy val module = new LazyModuleImp(this) {
    val streamIn = IO(Flipped(ValidWithSync(filter1Params.protoData.cloneType)))

    wellness.module.streamIn.bits := streamIn.bits
    wellness.module.streamIn.valid := streamIn.valid
    wellness.module.streamIn.sync := streamIn.sync
  }
}

trait HasPeripheryWellness extends BaseSubsystem {

  val wellnessParams = FixedPointModelWellnessParams

  // Instantiate wellness monitor
  val wellness = LazyModule(new WellnessThing(
    wellnessParams.filter1Params,
    wellnessParams.lineLength1Params,
    wellnessParams.fftBufferParams,
    wellnessParams.fftConfig,
    wellnessParams.bandpower1Params,
    wellnessParams.bandpower2Params,
    wellnessParams.pcaParams,
    wellnessParams.svmParams,
    wellnessParams.configurationMemoryParams))
  // Connect memory interfaces to pbus
  pbus.toVariableWidthSlave(Some("wellnessWrite")) { wellness.writeQueue.mem.get }
  pbus.toVariableWidthSlave(Some("wellnessConfigurationWrite")) { wellness.writeConfigurationQueue.mem.get }
  pbus.toVariableWidthSlave(Some("wellnessRead")) { wellness.readQueue.mem.get }
}

trait HasPeripheryWellnessModuleImp extends LazyModuleImp {
  implicit val p: Parameters
  val outer: HasPeripheryWellness

  val streamIn = IO(Flipped(ValidWithSync(outer.wellnessParams.filter1Params.protoData.cloneType)))

  outer.wellness.module.streamIn.sync := streamIn.sync
  outer.wellness.module.streamIn.valid := streamIn.valid
  outer.wellness.module.streamIn.bits := streamIn.bits

}