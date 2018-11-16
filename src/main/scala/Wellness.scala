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
                                                 pcaVectorBufferParams: MemoryBufferParams[T]) extends Bundle {
  var nClassifiers = svmParams.nClasses  // one vs rest default
  if (svmParams.classifierType == "ovr") {
    if (svmParams.nClasses == 2) nClassifiers = svmParams.nClasses - 1
  } else if (svmParams.classifierType == "ovo") {   // one vs one
    nClassifiers = (svmParams.nClasses*(svmParams.nClasses - 1))/2
  } else if (svmParams.classifierType == "ecoc") {  // error correcting output code
    nClassifiers = svmParams.codeBook.head.length // # columns = # classifiers
  }
  val in = Flipped(DecoupledIO(filter1Params.protoData.cloneType))
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
                                                        pcaVectorBufferParams: MemoryBufferParams[T]).asInstanceOf[this.type]
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
                                      pcaVectorBufferParams: MemoryBufferParams[T]): WellnessModuleIO[T] =
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
      pcaVectorBufferParams: MemoryBufferParams[T])
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
  val pcaVectorBufferParams: MemoryBufferParams[T])(implicit val p: Parameters) extends Module {
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
                                    pcaVectorBufferParams: MemoryBufferParams[T]) )

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

  val referencePCAVector = Seq(Seq(5, 0, -2), Seq(1, 2, 3))
  val PCAVector = Wire(Vec(2, Vec(3, pcaParams.protoData)))
  for(i <- 0 until 2) {
    PCAVector(i) := VecInit(referencePCAVector(i).map(ConvertableTo[T].fromInt(_)))
  }

  val referenceSVMSupportVector = Seq(Seq(1, 2), Seq(3, 4))
  val SVMSupportVector = Wire(Vec(2, Vec(2, svmParams.protoData)))
  for(i <- 0 until 2) {
    SVMSupportVector(i) := VecInit(referenceSVMSupportVector(i).map(ConvertableTo[T].fromInt(_)))
  }

  val referenceSVMAlphaVector = Seq(Seq(7, 3))
  val SVMAlphaVector = Wire(Vec(1, Vec(2, svmParams.protoData)))
  for(i <- 0 until 1) {
    SVMAlphaVector(i) := VecInit(referenceSVMAlphaVector(i).map(ConvertableTo[T].fromInt(_)))
  }

  val referenceSVMIntercept = Seq(4)
  val SVMIntercept = VecInit(referenceSVMIntercept.map(ConvertableTo[T].fromInt(_)))
  //for(i <- 0 until 1) {
  //  SVMIntercept(i) := VecInit(ConvertableTo[T].fromInt(referenceSVMIntercept(i)))
  //}

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
  pca.io.PCAVector := PCAVector
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
  svm.io.supportVector := SVMSupportVector
  svm.io.alphaVector := SVMAlphaVector
  svm.io.intercept := SVMIntercept
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
  val pcaVectorBufferParams: MemoryBufferParams[T]
)(implicit p: Parameters) extends DspBlock[D, U, EO, EI, B] {
  val streamNode = AXI4StreamIdentityNode()
  val mem = None

  lazy val module = new LazyModuleImp(this) {
    require(streamNode.in.length == 1)
    require(streamNode.out.length == 1)

    val in = streamNode.in.head._1
    val out = streamNode.out.head._1

    // Block instantiation
    val wellness = Module(new WellnessModule(filter1Params: FIRFilterParams[T],
    filter2Params: FIRFilterParams[T],
    filter3Params: FIRFilterParams[T],
    fftBufferParams: FFTBufferParams[T],
    fftConfig: FFTConfig[T],
    bandpower1Params: BandpowerParams[T],
    bandpower2Params: BandpowerParams[T],
    bandpower3Params: BandpowerParams[T],
    pcaParams: PCAParams[T],
    svmParams: SVMParams[T],
    pcaVectorBufferParams: MemoryBufferParams[T]))

    in.ready := wellness.io.in.ready

    // Input to Wellness
    wellness.io.in.valid := in.valid
    wellness.io.in.bits := in.bits.data.asTypeOf(filter1Params.protoData)

    // Wellness to Output
    out.valid := wellness.io.out.valid
    out.bits.data := Cat(wellness.io.rawVotes(1).asUInt(),wellness.io.rawVotes(0).asUInt())
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
  pcaVectorBufferParams: MemoryBufferParams[T]
)(implicit p: Parameters) extends
  WellnessDataPathBlock[TLClientPortParameters, TLManagerPortParameters, TLEdgeOut, TLEdgeIn, TLBundle, T](
    filter1Params, filter2Params, filter3Params,
    fftBufferParams,
    fftConfig,
    bandpower1Params, bandpower2Params, bandpower3Params,
    pcaParams, svmParams, pcaVectorBufferParams)
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
  val depth: Int = 32
)(implicit p: Parameters) extends LazyModule {
  // Instantiate lazy modules
  val writeQueue = LazyModule(new TLWriteQueue(depth))
  val wellness = LazyModule(new TLWellnessDataPathBlock(
    filter1Params, filter2Params, filter3Params,
    fftBufferParams,
    fftConfig,
    bandpower1Params, bandpower2Params, bandpower3Params,
    pcaParams, svmParams, pcaVectorBufferParams))
  val readQueue = LazyModule(new TLReadQueue(depth))

  // Connect streamNodes of queues and wellness monitor
  readQueue.streamNode := wellness.streamNode := writeQueue.streamNode

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
    val protoData = SInt(32.W)
    val nSupports = 2
    val nFeatures = pcaParams.nFeatures
    val nClasses = 2
    val nDegree = 1
    val kernelType = "poly"
    val classifierType = "ovo"
    val codeBook = Seq.fill(nClasses, nClasses*2)((scala.util.Random.nextInt(2)*2)-1) // ignored for this test case
  }

  val pcaVectorBufferParams = new MemoryBufferParams[SInt] {
    override val protoData = SInt(32.W)
    override val nRows:Int = pcaParams.nFeatures
    override val nColumns:Int = pcaParams.nDimensions
  }

  // Instantiate wellness monitor
  val wellness = LazyModule(new WellnessThing(
    filter1Params, filter2Params, filter3Params,
    fftBufferParams,
    fftConfig,
    bandpower1Params, bandpower2Params, bandpower3Params,
    pcaParams, svmParams, pcaVectorBufferParams))
  // Connect memory interfaces to pbus
  pbus.toVariableWidthSlave(Some("wellnessWrite")) { wellness.writeQueue.mem.get }
  pbus.toVariableWidthSlave(Some("wellnessRead")) { wellness.readQueue.mem.get }
}