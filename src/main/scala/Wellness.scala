package wellness

import chisel3._
import chisel3.util._
import chisel3.experimental.FixedPoint
import dspblocks._
import dspjunctions.ValidWithSync
import dsptools.numbers._
import firFilter._
import fft._
import features._
import pca._
import memorybuffer._
import svm._
import freechips.rocketchip.amba.axi4stream._
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.subsystem._

import scala.collection.Seq


/**
  * The memory interface writes entries into the queue.
  * They stream out the streaming interface
  * @param depth number of entries in the queue
  * @param streamParameters parameters for the stream node
  * @param p
  */
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

/**
  * TLDspBlock specialization of WriteQueue
  * @param depth number of entries in the queue
  * @param csrAddress address range for peripheral
  * @param beatBytes beatBytes of TL interface
  * @param p
  */
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

/**
  * The streaming interface adds elements into the queue.
  * The memory interface can read elements out of the queue.
  * @param depth number of entries in the queue
  * @param streamParameters parameters for the stream node
  * @param p
  */
abstract class ReadQueue
(
  val depth: Int = 8,
  val streamParameters: AXI4StreamSlaveParameters = AXI4StreamSlaveParameters()
)(implicit p: Parameters) extends LazyModule with HasCSR {
  val streamNode = AXI4StreamSlaveNode(streamParameters)

  lazy val module = new LazyModuleImp(this) {
    require(streamNode.in.length == 1)

    // TODO

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

/**
  * TLDspBlock specialization of ReadQueue
  * @param depth number of entries in the queue
  * @param csrAddress address range
  * @param beatBytes beatBytes of TL interface
  * @param p
  */
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

  override def cloneType: this.type = WellnessConfigurationBundle(params).asInstanceOf[this.type]
}
object WellnessConfigurationBundle {
  def apply[T <: Data](params: ConfigurationMemoryParams[T]): WellnessConfigurationBundle[T] = new WellnessConfigurationBundle(params)
}

class WellnessModuleIO[T <: Data : Real : Order : BinaryRepresentation](filter1Params: FIRFilterParams[T],
                                                 filter2Params: FIRFilterParams[T],
                                                 filter3Params: FIRFilterParams[T],
                                                 fftBufferParams: FFTBufferParams[T],
                                                 fftConfig: FFTConfig[T],
                                                 bandpower1Params: BandpowerParams[T],
                                                 bandpower2Params: BandpowerParams[T],
                                                 bandpower3Params: BandpowerParams[T],
                                                 pcaParams: PCAParams[T],
                                                 svmParams: SVMParams[T],
                                                 pcaVectorBufferParams: MemoryBufferParams[T],
                                                 configurationMemoryParams: ConfigurationMemoryParams[T]) extends Bundle {
  var nClassifiers = svmParams.nClasses  // one vs rest default
  if (svmParams.classifierType == "ovr") {
    if (svmParams.nClasses == 2) nClassifiers = svmParams.nClasses - 1
  } else if (svmParams.classifierType == "ovo") {   // one vs one
    nClassifiers = (svmParams.nClasses*(svmParams.nClasses - 1))/2
  } else if (svmParams.classifierType == "ecoc") {  // error correcting output code
    nClassifiers = svmParams.codeBook.head.length // # columns = # classifiers
  }
  val in = Flipped(DecoupledIO(filter1Params.protoData.cloneType))
  val inConf = Flipped(ValidWithSync(WellnessConfigurationBundle(configurationMemoryParams)))
  val out = ValidWithSync(Bool())
  val rawVotes = Output(Vec(svmParams.nClasses, svmParams.protoData))
  val classVotes = Output(Vec(svmParams.nClasses,UInt((log2Ceil(nClassifiers)+1).W)))

  override def cloneType: this.type = WellnessModuleIO( filter1Params: FIRFilterParams[T],
                                                        filter2Params: FIRFilterParams[T],
                                                        filter3Params: FIRFilterParams[T],
                                                        fftBufferParams: FFTBufferParams[T],
                                                        fftConfig: FFTConfig[T],
                                                        bandpower1Params: BandpowerParams[T],
                                                        bandpower2Params: BandpowerParams[T],
                                                        bandpower3Params: BandpowerParams[T],
                                                        pcaParams: PCAParams[T],
                                                        svmParams: SVMParams[T],
                                                        pcaVectorBufferParams: MemoryBufferParams[T],
                                                        configurationMemoryParams: ConfigurationMemoryParams[T]).asInstanceOf[this.type]
}
object WellnessModuleIO {
  def apply[T <: chisel3.Data : Real : Order : BinaryRepresentation](filter1Params: FIRFilterParams[T],
                                      filter2Params: FIRFilterParams[T],
                                      filter3Params: FIRFilterParams[T],
                                      fftBufferParams: FFTBufferParams[T],
                                      fftConfig: FFTConfig[T],
                                      bandpower1Params: BandpowerParams[T],
                                      bandpower2Params: BandpowerParams[T],
                                      bandpower3Params: BandpowerParams[T],
                                      pcaParams: PCAParams[T],
                                      svmParams: SVMParams[T],
                                      pcaVectorBufferParams: MemoryBufferParams[T],
                                      configurationMemoryParams: ConfigurationMemoryParams[T]): WellnessModuleIO[T] =
    new WellnessModuleIO(filter1Params: FIRFilterParams[T],
      filter2Params: FIRFilterParams[T],
      filter3Params: FIRFilterParams[T],
      fftBufferParams: FFTBufferParams[T],
      fftConfig: FFTConfig[T],
      bandpower1Params: BandpowerParams[T],
      bandpower2Params: BandpowerParams[T],
      bandpower3Params: BandpowerParams[T],
      pcaParams: PCAParams[T],
      svmParams: SVMParams[T],
      pcaVectorBufferParams: MemoryBufferParams[T],
      configurationMemoryParams: ConfigurationMemoryParams[T])
}

class WellnessModule[T <: chisel3.Data : Real : Order : BinaryRepresentation]
( val filter1Params: FIRFilterParams[T],
  val filter2Params: FIRFilterParams[T],
  val filter3Params: FIRFilterParams[T],
  val fftBufferParams: FFTBufferParams[T],
  val fftConfig: FFTConfig[T],
  val bandpower1Params: BandpowerParams[T],
  val bandpower2Params: BandpowerParams[T],
  val bandpower3Params: BandpowerParams[T],
  val pcaParams: PCAParams[T],
  val svmParams: SVMParams[T],
  val pcaVectorBufferParams: MemoryBufferParams[T],
  val configurationMemoryParams: ConfigurationMemoryParams[T])(implicit val p: Parameters) extends Module {
  val io = IO(WellnessModuleIO[T](  filter1Params: FIRFilterParams[T],
                                    filter2Params: FIRFilterParams[T],
                                    filter3Params: FIRFilterParams[T],
                                    fftBufferParams: FFTBufferParams[T],
                                    fftConfig: FFTConfig[T],
                                    bandpower1Params: BandpowerParams[T],
                                    bandpower2Params: BandpowerParams[T],
                                    bandpower3Params: BandpowerParams[T],
                                    pcaParams: PCAParams[T],
                                    svmParams: SVMParams[T],
                                    pcaVectorBufferParams: MemoryBufferParams[T],
                                    configurationMemoryParams: ConfigurationMemoryParams[T]) )

  // Block instantiation
  val filter1 = Module(new ConstantCoefficientFIRFilter(filter1Params))
  val filter2 = Module(new ConstantCoefficientFIRFilter(filter2Params))
  val filter3 = Module(new ConstantCoefficientFIRFilter(filter3Params))
  val fftBuffer = Module(new FFTBuffer(fftBufferParams))
  val fft = Module(new FFT(fftConfig))
  val bandpower1 = Module(new Bandpower(bandpower1Params))
  val bandpower2 = Module(new Bandpower(bandpower2Params))
  val bandpower3 = Module(new Bandpower(bandpower3Params))
  val pca = Module(new PCA(pcaParams))
  val svm = Module(new SVM(svmParams))
  //val pcaVectorBuffer = Module(new MemoryBuffer(pcaVectorBufferParams))

  io.in.ready := true.B

  // Input to Filters
  filter1.io.in.valid := io.in.valid
  filter1.io.in.sync := false.B
  filter1.io.in.bits := io.in.bits.asTypeOf(filter1Params.protoData)

  filter2.io.in.valid := io.in.valid
  filter2.io.in.sync := false.B
  filter2.io.in.bits := io.in.bits.asTypeOf(filter2Params.protoData)

  filter3.io.in.valid := io.in.valid
  filter3.io.in.sync := false.B
  filter3.io.in.bits := io.in.bits.asTypeOf(filter3Params.protoData)

  // TOP LEVEL INTEGRATION TRIALS
  val pcaInVector = Wire(Vec(3,pcaParams.protoData))
  pcaInVector(0) := filter1.io.out.bits
  pcaInVector(1) := filter2.io.out.bits
  pcaInVector(2) := filter3.io.out.bits
  pca.io.PCAVector := io.inConf.bits.confPCAVector
  pca.io.in.bits := pcaInVector
  pca.io.in.sync := false.B
  pca.io.in.valid := filter1.io.out.valid

  // FIR Filters to FFT Buffers
  fftBuffer.io.in.valid := filter1.io.out.valid
  fftBuffer.io.in.sync := false.B
  fftBuffer.io.in.bits := filter1.io.out.bits

  // FFT Buffers to FFTs
  fft.io.in.valid := fftBuffer.io.out.valid
  fft.io.in.sync := false.B
  for (i <- fft.io.in.bits.indices) {
    fft.io.in.bits(i).real := fftBuffer.io.out.bits(i).asTypeOf(fft.io.in.bits(i).real)
  }
  fft.io.in.bits.foreach(_.imag := Ring[T].zero)
  fft.io.data_set_end_clear := false.B

  // FFTs to Bandpowers
  bandpower1.io.in.valid := fft.io.out.valid
  bandpower1.io.in.sync := false.B
  bandpower1.io.in.bits := fft.io.out.bits.map(_.real.asTypeOf(bandpower1.io.in.bits(0)))

  bandpower2.io.in.valid := fft.io.out.valid
  bandpower2.io.in.sync := false.B
  bandpower2.io.in.bits := fft.io.out.bits.map(_.real.asTypeOf(bandpower2.io.in.bits(0)))

  bandpower3.io.in.valid := fft.io.out.valid
  bandpower3.io.in.sync := false.B
  bandpower3.io.in.bits := fft.io.out.bits.map(_.real.asTypeOf(bandpower3.io.in.bits(0)))

  // TODO: Bandpowers to PCA

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
}


abstract class WellnessDataPathBlock[D, U, EO, EI, B <: Data, T <: Data : Real : Order : BinaryRepresentation]
(
  val filter1Params: FIRFilterParams[T],
  val filter2Params: FIRFilterParams[T],
  val filter3Params: FIRFilterParams[T],
  val fftBufferParams: FFTBufferParams[T],
  val fftConfig: FFTConfig[T],
  val bandpower1Params: BandpowerParams[T],
  val bandpower2Params: BandpowerParams[T],
  val bandpower3Params: BandpowerParams[T],
  val pcaParams: PCAParams[T],
  val svmParams: SVMParams[T],
  val pcaVectorBufferParams: MemoryBufferParams[T],
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
      filter2Params: FIRFilterParams[T],
      filter3Params: FIRFilterParams[T],
      fftBufferParams: FFTBufferParams[T],
      fftConfig: FFTConfig[T],
      bandpower1Params: BandpowerParams[T],
      bandpower2Params: BandpowerParams[T],
      bandpower3Params: BandpowerParams[T],
      pcaParams: PCAParams[T],
      svmParams: SVMParams[T],
      pcaVectorBufferParams: MemoryBufferParams[T],
      configurationMemoryParams: ConfigurationMemoryParams[T]))

    val configurationMemory = Module(new ConfigurationMemory(configurationMemoryParams))

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
    configurationMemory.io.in.bits.wrdata := inConf.bits.data.asUInt()(configurationMemory.io.in.bits.wrdata.getWidth-1,0).asSInt()
    configurationMemory.io.in.bits.wraddr := inConf.bits.data.asUInt()(configurationMemory.io.in.bits.wrdata.getWidth+1,configurationMemory.io.in.bits.wrdata.getWidth)
    wellness.io.inConf := configurationMemory.io.out
  }
}

class TLWellnessDataPathBlock[T <: Data : Real : Order : BinaryRepresentation]
(
  filter1Params: FIRFilterParams[T],
  filter2Params: FIRFilterParams[T],
  filter3Params: FIRFilterParams[T],
  fftBufferParams: FFTBufferParams[T],
  fftConfig: FFTConfig[T],
  bandpower1Params: BandpowerParams[T],
  bandpower2Params: BandpowerParams[T],
  bandpower3Params: BandpowerParams[T],
  pcaParams: PCAParams[T],
  svmParams: SVMParams[T],
  pcaVectorBufferParams: MemoryBufferParams[T],
  configurationMemoryParams: ConfigurationMemoryParams[T]
)(implicit p: Parameters) extends
  WellnessDataPathBlock[TLClientPortParameters, TLManagerPortParameters, TLEdgeOut, TLEdgeIn, TLBundle, T](
    filter1Params, filter2Params, filter3Params,
    fftBufferParams,
    fftConfig,
    bandpower1Params, bandpower2Params, bandpower3Params,
    pcaParams, svmParams, pcaVectorBufferParams,
    configurationMemoryParams)
  with TLDspBlock

/**
  * TLChain is the "right way" to do this, but the dspblocks library seems to be broken.
  * In the interim, this should work.
  * @param filterParams parameters for filter
  * @param fftConfig config for FFT
  * @param bandpowerParams parameters for fbandpower
  * @param depth depth of queues
  * @param ev$1
  * @param ev$2
  * @param ev$3
  * @param p
  * @tparam T Type parameter, i.e. FixedPoint or DspReal
  */
class WellnessThing[T <: Data : Real : Order : BinaryRepresentation]
(
  val filter1Params: FIRFilterParams[T],
  val filter2Params: FIRFilterParams[T],
  val filter3Params: FIRFilterParams[T],
  val fftBufferParams: FFTBufferParams[T],
  val fftConfig: FFTConfig[T],
  val bandpower1Params: BandpowerParams[T],
  val bandpower2Params: BandpowerParams[T],
  val bandpower3Params: BandpowerParams[T],
  val pcaParams: PCAParams[T],
  val svmParams: SVMParams[T],
  val pcaVectorBufferParams: MemoryBufferParams[T],
  val configurationMemoryParams: ConfigurationMemoryParams[T],
  val depth: Int = 32
)(implicit p: Parameters) extends LazyModule {
  // Instantiate lazy modules
  val writeQueue = LazyModule(new TLWriteQueue(depth))
  val configurationBaseAddr = AddressSet(0x2200, 0xff)
  val writeConfigurationQueue = LazyModule(new TLWriteQueue(depth,configurationBaseAddr))
  val wellness = LazyModule(new TLWellnessDataPathBlock(
    filter1Params, filter2Params, filter3Params,
    fftBufferParams,
    fftConfig,
    bandpower1Params, bandpower2Params, bandpower3Params,
    pcaParams, svmParams, pcaVectorBufferParams,
    configurationMemoryParams))
  val readQueue = LazyModule(new TLReadQueue(depth))

  // Connect streamNodes of queues and wellness monitor
  readQueue.streamNode := wellness.streamNode := writeQueue.streamNode
  wellness.streamNode := writeConfigurationQueue.streamNode

  lazy val module = new LazyModuleImp(this)
}

/**
  * Mixin for top-level rocket to add a PWM
  *
  */
trait HasPeripheryWellness extends BaseSubsystem {
  val nPts = 4

  val filter1Params = new FIRFilterParams[SInt] {
    override val protoData = SInt(32.W)
    override val taps = Seq(1.S, 2.S, 3.S, 4.S, 5.S, 0.S)
  }

  val filter2Params = new FIRFilterParams[SInt] {
    override val protoData = SInt(32.W)
    override val taps = Seq(5.S, 4.S, 3.S, 2.S, 1.S, 0.S)
  }

  val filter3Params = new FIRFilterParams[SInt] {
    override val protoData = SInt(32.W)
    override val taps = Seq(0.S, 1.S, 2.S, 2.S, 1.S, 0.S)
  }

  // FFTBufferParams
  val fftBufferParams = new FFTBufferParams[SInt] {
    val protoData = SInt(32.W)
    val lanes = nPts
  }

  // FFTConfigs
  val fftConfig = FFTConfig(
    genIn = DspComplex(SInt(32.W), SInt(32.W)),
    genOut = DspComplex(SInt(32.W), SInt(32.W)),
    n = nPts,
    lanes = nPts,
    pipelineDepth = 0,
    quadrature = false,
  )

  // BandpowerParams
  val bandpower1Params = new BandpowerParams[SInt] {
    val idxStartBin = 0
    val idxEndBin = nPts-1
    val nBins = nPts
    val protoData = SInt(32.W)
  }
  val bandpower2Params = new BandpowerParams[SInt] {
    val idxStartBin = 0
    val idxEndBin = nPts-1
    val nBins = nPts
    val protoData = SInt(32.W)
  }
  val bandpower3Params = new BandpowerParams[SInt] {
    val idxStartBin = 0
    val idxEndBin = nPts-1
    val nBins = nPts
    val protoData = SInt(32.W)
  }

  val pcaParams = new PCAParams[SInt] {
    override val protoData = SInt(32.W)
    override val nDimensions = 3 // input dimension, minimum 1
    override val nFeatures = 2   // output dimension to SVM, minimum 1
  }

  val svmParams = new SVMParams[SInt] {
    val protoData = pcaParams.protoData.cloneType
    val nSupports = 2
    val nFeatures = pcaParams.nFeatures
    val nClasses = 2
    val nDegree = 1
    val kernelType = "poly"
    val classifierType = "ovo"
    val codeBook = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
  }

  val pcaVectorBufferParams = new MemoryBufferParams[SInt] {
    override val protoData = pcaParams.protoData.cloneType
    override val nRows:Int = pcaParams.nFeatures
    override val nColumns:Int = pcaParams.nDimensions
  }
  val configurationMemoryParams = new ConfigurationMemoryParams[SInt] {
    object computeNClassifiers {
      def apply(params: SVMParams[chisel3.SInt] with Object {
        val nClasses: Int
        val codeBook: Seq[Seq[Int]]
        val classifierType: String
      }): Int =
        if (params.classifierType == "ovr") {
          if (params.nClasses == 2) params.nClasses - 1
          else 1
        }
        else if (params.classifierType == "ovo") {
          (params.nClasses*(params.nClasses - 1))/2
        }
        else if (params.classifierType == "ecoc") {
          params.codeBook.head.length
        }
        else 1
    }
    override val protoData = pcaParams.protoData.cloneType
    override val nDimensions: Int = pcaParams.nDimensions
    override val nFeatures: Int = pcaParams.nFeatures
    override val nSupports: Int = svmParams.nSupports
    override val nClassifiers: Int = computeNClassifiers(svmParams)
  }

  // Instantiate wellness monitor
  val wellness = LazyModule(new WellnessThing(
    filter1Params, filter2Params, filter3Params,
    fftBufferParams,
    fftConfig,
    bandpower1Params, bandpower2Params, bandpower3Params,
    pcaParams, svmParams, pcaVectorBufferParams,
    configurationMemoryParams))
  // Connect memory interfaces to pbus
  pbus.toVariableWidthSlave(Some("wellnessWrite")) { wellness.writeQueue.mem.get }
  pbus.toVariableWidthSlave(Some("wellnessConfigurationWrite")) { wellness.writeConfigurationQueue.mem.get }
  pbus.toVariableWidthSlave(Some("wellnessRead")) { wellness.readQueue.mem.get }
}