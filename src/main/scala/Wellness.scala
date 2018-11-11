package wellness

import chisel3._
import chisel3.util._
import chisel3.experimental.FixedPoint
import dspblocks._
import dsptools.numbers._
import firFilter._
import fft._
import bandpower._
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


abstract class WellnessDataPathBlock[D, U, EO, EI, B <: Data, T <: Data : Real]
(
  val filter1Params: FIRFilterParams[T],
  val filter2Params: FIRFilterParams[T],
  val filter3Params: FIRFilterParams[T],
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
    val filter1 = Module(new ConstantCoefficientFIRFilter(filter1Params))
    val filter2 = Module(new ConstantCoefficientFIRFilter(filter2Params))
    val filter3 = Module(new ConstantCoefficientFIRFilter(filter3Params))
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

    in.ready := true.B

    // Input to Filters
    filter1.io.in.valid := in.valid
    filter1.io.in.sync := false.B
    filter1.io.in.bits := in.bits.data.asTypeOf(filter1Params.protoData)

    filter2.io.in.valid := in.valid
    filter2.io.in.sync := false.B
    filter2.io.in.bits := in.bits.data.asTypeOf(filter2Params.protoData)

    filter3.io.in.valid := in.valid
    filter3.io.in.sync := false.B
    filter3.io.in.bits := in.bits.data.asTypeOf(filter3Params.protoData)

    // TOP LEVEL INTEGRATION TRIALS
    val pcaInVector = Wire(Vec(3,pcaParams.protoData))
    pcaInVector(0) := filter1.io.out.bits
    pcaInVector(1) := filter2.io.out.bits
    pcaInVector(2) := filter3.io.out.bits
    pca.io.PCAVector := PCAVector
    pca.io.in.bits := pcaInVector
    pca.io.in.sync := false.B
    pca.io.in.valid := filter1.io.out.valid


    // Filter to FFT
    // TODO: JUSTIN TO CONNECT THIS

    // FFT to Band Power
    // TODO: JUSTIN TO CONNECT THIS
    // Band Power to PCA



    // PCA to SVM
    svm.io.in.valid := pca.io.out.valid
    svm.io.in.bits := pca.io.out.bits
    svm.io.in.sync := false.B
    svm.io.supportVector := SVMSupportVector
    svm.io.alphaVector := SVMAlphaVector
    svm.io.intercept := SVMIntercept
    // SVM to Output
    // TODO: ADEL TO CONNECT THESE



    out.valid := svm.io.out.valid
    out.bits.data := Cat(svm.io.rawVotes(0).asUInt(),svm.io.rawVotes(1).asUInt())
  }
}

class TLWellnessDataPathBlock[T <: Data : Real]
(
  filter1Params: FIRFilterParams[T],
  filter2Params: FIRFilterParams[T],
  filter3Params: FIRFilterParams[T],
  pcaParams: PCAParams[T],
  svmParams: SVMParams[T],
  pcaVectorBufferParams: MemoryBufferParams[T]
)(implicit p: Parameters) extends
  WellnessDataPathBlock[TLClientPortParameters, TLManagerPortParameters, TLEdgeOut, TLEdgeIn, TLBundle, T](filter1Params, filter2Params, filter3Params, pcaParams, svmParams, pcaVectorBufferParams)
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
class WellnessThing[T <: Data : Real]
(
  val filter1Params: FIRFilterParams[T],
  val filter2Params: FIRFilterParams[T],
  val filter3Params: FIRFilterParams[T],
  val pcaParams: PCAParams[T],
  val svmParams: SVMParams[T],
  val pcaVectorBufferParams: MemoryBufferParams[T],
  val depth: Int = 32
)(implicit p: Parameters) extends LazyModule {
  // Instantiate lazy modules
  val writeQueue = LazyModule(new TLWriteQueue(depth))
  val wellness = LazyModule(new TLWellnessDataPathBlock(filter1Params, filter2Params, filter3Params, pcaParams, svmParams, pcaVectorBufferParams))
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
  val inWidth: Int = 16
  val inBP: Int = 8
  val outWidth: Int = inWidth
  val outBP: Int = inBP

  val filter1Params = new FIRFilterParams[SInt] {
    override val protoData = SInt(32.W)
    override val taps = Seq(0.S, 1.S, 2.S, 3.S, 4.S, 5.S)
  }

  val filter2Params = new FIRFilterParams[SInt] {
    override val protoData = SInt(32.W)
    override val taps = Seq(5.S, 4.S, 3.S, 2.S, 1.S, 0.S)
  }

  val filter3Params = new FIRFilterParams[SInt] {
    override val protoData = SInt(32.W)
    override val taps = Seq(0.S, 1.S, 2.S, 2.S, 1.S, 0.S)
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
  val wellness = LazyModule(new WellnessThing(filter1Params, filter2Params, filter3Params, pcaParams, svmParams, pcaVectorBufferParams))
  // Connect memory interfaces to pbus
  pbus.toVariableWidthSlave(Some("wellnessWrite")) { wellness.writeQueue.mem.get }
  pbus.toVariableWidthSlave(Some("wellnessRead")) { wellness.readQueue.mem.get }
}