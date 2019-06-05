
package wellness

import chisel3._
import chisel3.util._
import dspblocks._
import dspjunctions.ValidWithSync
import dsptools.numbers._
import firFilter._
import features._
import neuralNet._
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

/**
  * Bundle that contains runtime configuration signals of the Wellness Module.
  * This bundle is used to easily connect the configuration signals from Configuration
  * Memory to Wellness Module.
  * @param params is explained at wellness.ConfigurationMemory
  */
class WellnessConfigurationBundle[T <: Data](params: ConfigurationMemoryParams[T]) extends Bundle {
  val confneuralNetsweightMatrix = Vec(params.nNeurons, Vec(params.nFeatures, params.protoData))
  val confneuralNetsweightVec = Vec(params.nNeurons, params.protoData)
  val confneuralNetsbiasVec = Vec(params.nNeurons, params.protoData)
  val confneuralNetsbiasScalar = Vec(1,params.protoData)
  val confInputMuxSel = Bool()

  override def cloneType: this.type = WellnessConfigurationBundle(params).asInstanceOf[this.type]
}
object WellnessConfigurationBundle {
  def apply[T <: Data](params: ConfigurationMemoryParams[T]): WellnessConfigurationBundle[T] = new WellnessConfigurationBundle(params)
}

//TODO Update comment definition to reflect new generator
/**
  * I/O Bundle of the Wellness Module
  * streamIn: Input stream from the ADC
  * in: Test input stream from the RISC-V Core
  * inConf: Configuration signals from Configuration Memory
  * out: Currently unused
  * rawVotes: Raw Votes from SVM
  * classVotes: Class Votes from SVM
  */
class WellnessModuleIO[T <: Data : Real : Order : BinaryRepresentation](filter1Params: FIRFilterParams[T],
                                                                        lineLength1Params: lineLengthParams[T],
                                                                        filterAlphaParams: FIRFilterParams[T],
                                                                        filterBetaParams: FIRFilterParams[T],
                                                                        filterGammaParams: FIRFilterParams[T],
                                                                        bandpowerParams: sumSquaresParams[T],
                                                                        neuralNetsParams: NeuralNetParams[T],
                                                                        configurationMemoryParams: ConfigurationMemoryParams[T]) extends Bundle {

  val streamIn = Flipped(ValidWithSync(filter1Params.protoData.cloneType)) // Streaming Input from external source
  val in = Flipped(DecoupledIO(filter1Params.protoData.cloneType)) // Test Input from RISC-V core
  val inConf = Flipped(ValidWithSync(WellnessConfigurationBundle(configurationMemoryParams))) // Configuration input from Configuration Memory
  val out = ValidWithSync(Bool()) // Not used right now
  val rawVotes = Output(neuralNetsParams.protoData)
  val lineOut = Output(lineLength1Params.protoData) // Not used in actual implementation, only for debug purposes
  val bandpower1Out = Output(bandpowerParams.protoData) // Not used in actual implementation, only for debug purposes
  val bandpower2Out = Output(bandpowerParams.protoData) // Not used in actual implementation, only for debug purposes
  val bandpower3Out = Output(bandpowerParams.protoData) // Not used in actual implementation, only for debug purposes
  val filterOut = Output(filter1Params.protoData) // Not used in actual implementation, only for debug purposes

  override def cloneType: this.type = WellnessModuleIO( filter1Params: FIRFilterParams[T],
    lineLength1Params: lineLengthParams[T],
    filterAlphaParams: FIRFilterParams[T],
    filterBetaParams: FIRFilterParams[T],
    filterGammaParams: FIRFilterParams[T],
    bandpowerParams: sumSquaresParams[T],
    neuralNetsParams: NeuralNetParams[T],
    configurationMemoryParams: ConfigurationMemoryParams[T]).asInstanceOf[this.type]
}
object WellnessModuleIO {
  def apply[T <: chisel3.Data : Real : Order : BinaryRepresentation](filter1Params: FIRFilterParams[T],
                                                                     lineLength1Params: lineLengthParams[T],
                                                                     filterAlphaParams: FIRFilterParams[T],
                                                                     filterBetaParams: FIRFilterParams[T],
                                                                     filterGammaParams: FIRFilterParams[T],
                                                                     bandpowerParams: sumSquaresParams[T],
                                                                     neuralNetsParams: NeuralNetParams[T],
                                                                     configurationMemoryParams: ConfigurationMemoryParams[T]): WellnessModuleIO[T] =
    new WellnessModuleIO(filter1Params: FIRFilterParams[T],
      lineLength1Params: lineLengthParams[T],
      filterAlphaParams: FIRFilterParams[T],
      filterBetaParams: FIRFilterParams[T],
      filterGammaParams: FIRFilterParams[T],
      bandpowerParams: sumSquaresParams[T],
      neuralNetsParams: NeuralNetParams[T],
      configurationMemoryParams: ConfigurationMemoryParams[T])
}

/**
  * Wellness Module
  * A prototype wellness module definition with 1 Line Length and 2 Band Power features.
  * @param filter1Params Parameters of the FIR filter before Line Length Extractor
  * @param lineLength1Params Parameters of the Line Length Extractor
  * @param neuralNetsParams Parameters of the SVM
  * @param configurationMemoryParams Parameters of the Configuration Memory
  *                                  Note that configuration memory is not actually inside the Wellness Module,
  *                                  but Wellness Module requires this parameter bundle to properly connect to Conf Mem
  */
class WellnessModule[T <: chisel3.Data : Real : Order : BinaryRepresentation]
( val filter1Params: FIRFilterParams[T],
  val lineLength1Params: lineLengthParams[T],
  val filterAlphaParams: FIRFilterParams[T],
  val filterBetaParams: FIRFilterParams[T],
  val filterGammaParams: FIRFilterParams[T],
  val bandpowerParams: sumSquaresParams[T],
  val neuralNetsParams: NeuralNetParams[T],
  val configurationMemoryParams: ConfigurationMemoryParams[T])(implicit val p: Parameters) extends Module {
  val io = IO(WellnessModuleIO[T](  filter1Params: FIRFilterParams[T],
    lineLength1Params: lineLengthParams[T],
    filterAlphaParams: FIRFilterParams[T],
    filterBetaParams: FIRFilterParams[T],
    filterGammaParams: FIRFilterParams[T],
    bandpowerParams: sumSquaresParams[T],
    neuralNetsParams: NeuralNetParams[T],
    configurationMemoryParams: ConfigurationMemoryParams[T]) )

  // Block instantiation
  val filter1 = Module(new ConstantCoefficientFIRFilter(filter1Params))
  val lineLength1 = Module(new lineLength(lineLength1Params))

  val filterAlpha = Module(new ConstantCoefficientFIRFilter(filterAlphaParams))
  val filterBeta = Module(new ConstantCoefficientFIRFilter(filterBetaParams))
  val filterGamma = Module(new ConstantCoefficientFIRFilter(filterGammaParams))

  val bandpowerAlpha = Module(new sumSquares(bandpowerParams))
  val bandpowerBeta = Module(new sumSquares(bandpowerParams))
  val bandpowerGamma = Module(new sumSquares(bandpowerParams))

  val neuralNets = Module(new NeuralNet(neuralNetsParams))

  io.in.ready := true.B

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

  // FIR Filter to Bandpass FIR Filter
  filterAlpha.io.in.valid := filter1.io.out.valid
  filterAlpha.io.in.sync := false.B
  filterAlpha.io.in.bits := filter1.io.out.bits.asTypeOf(filterAlphaParams.protoData)

  filterBeta.io.in.valid := filter1.io.out.valid
  filterBeta.io.in.sync := false.B
  filterBeta.io.in.bits := filter1.io.out.bits.asTypeOf(filterAlphaParams.protoData)

  filterGamma.io.in.valid := filter1.io.out.valid
  filterGamma.io.in.sync := false.B
  filterGamma.io.in.bits := filter1.io.out.bits.asTypeOf(filterAlphaParams.protoData)

  // Bandpass FIR Filter to Sum of Squares

  bandpowerAlpha.io.in.valid := filterAlpha.io.out.valid
  bandpowerAlpha.io.in.sync := false.B
  bandpowerAlpha.io.in.bits := filterAlpha.io.out.bits

  bandpowerBeta.io.in.valid := filterBeta.io.out.valid
  bandpowerBeta.io.in.sync := false.B
  bandpowerBeta.io.in.bits := filterBeta.io.out.bits

  bandpowerGamma.io.in.valid := filterGamma.io.out.valid
  bandpowerGamma.io.in.sync := false.B
  bandpowerGamma.io.in.bits := filterGamma.io.out.bits

  // Extra pipeline registers for linelength to align with bandpower delay
  // we need one register since its Linelength vs Filter - Bandpower
  val lineLength1Reg1 = RegNext(lineLength1.io.out.bits.asTypeOf(neuralNetsParams.protoData))
  //val lineLength1Reg2 = RegNext(lineLength1Reg1)
  val lineLength1Valid1 = RegNext(lineLength1.io.out.valid)
  //val lineLength1Valid2 = RegNext(lineLength1Valid1)

  // TODO: Delete this block once normalization has been integrated with C
  // do feature normalization before going to the PCA, (feature_val - mean)/ std
  // mean and std values are already computed by the Python script from the training data
  // val norm_mean = utilities.readCSV("scripts/generated_files/normalization_mean.csv").flatMap(_.map(_.toDouble))
  // val norm_invstd = utilities.readCSV("scripts/generated_files/normalization_recipvar.csv").flatMap(_.map(_.toDouble))

  // Features to Classifier
  val FeatureVector = Wire(Vec(4,neuralNetsParams.protoData))
  FeatureVector(0) := bandpowerAlpha.io.out.bits.asTypeOf(neuralNetsParams.protoData)
  FeatureVector(1) := bandpowerBeta.io.out.bits.asTypeOf(neuralNetsParams.protoData)
  FeatureVector(2) := bandpowerGamma.io.out.bits.asTypeOf(neuralNetsParams.protoData)
  FeatureVector(3) := lineLength1Reg1.asTypeOf(neuralNetsParams.protoData)

  neuralNets.io.in.valid := (lineLength1Valid1 && bandpowerAlpha.io.out.valid && bandpowerBeta.io.out.valid && bandpowerGamma.io.out.valid)
  neuralNets.io.in.bits := FeatureVector
  neuralNets.io.in.sync := false.B

  neuralNets.io.weightMatrix := io.inConf.bits.confneuralNetsweightMatrix
  neuralNets.io.weightVec := io.inConf.bits.confneuralNetsweightVec
  neuralNets.io.biasVec := io.inConf.bits.confneuralNetsbiasVec
  neuralNets.io.biasScalar := io.inConf.bits.confneuralNetsbiasScalar(0)

  // SVM to Output
  io.out.valid := neuralNets.io.out.valid
  io.out.sync := neuralNets.io.out.sync
  io.out.bits := neuralNets.io.out.bits
  io.rawVotes := neuralNets.io.rawVotes

  // pinned out outputs for debug purposes
  io.filterOut := filter1.io.out.bits
  io.lineOut := lineLength1.io.out.bits
  io.bandpower1Out := bandpowerAlpha.io.out.bits
  io.bandpower2Out := bandpowerBeta.io.out.bits
  io.bandpower3Out := bandpowerGamma.io.out.bits
}

/**
  * TLDspBlock specialization of WellnessModule
  * @param filter1Params Parameters of the FIR filter before Line Length Extractor
  * @param lineLength1Params Parameters of the Line Length Extractor
  * @param neuralNetsParams Parameters of the SVM
  * @param configurationMemoryParams Parameters of the Configuration Memory
  */
abstract class WellnessDataPathBlock[D, U, EO, EI, B <: Data, T <: Data : Real : Order : BinaryRepresentation]
(
  val filter1Params: FIRFilterParams[T],
  val lineLength1Params: lineLengthParams[T],
  val filterAlphaParams: FIRFilterParams[T],
  val filterBetaParams: FIRFilterParams[T],
  val filterGammaParams: FIRFilterParams[T],
  val bandpowerParams: sumSquaresParams[T],
  val neuralNetsParams: NeuralNetParams[T],
  val configurationMemoryParams: ConfigurationMemoryParams[T]
)(implicit p: Parameters) extends DspBlock[D, U, EO, EI, B] {
  val streamNode = AXI4StreamNexusNode(
    masterFn = { seq => AXI4StreamMasterPortParameters()}, // Master Port for stream data transfer (Read/Write)
    slaveFn  = { seq => AXI4StreamSlavePortParameters()} // Slave Port for configuration data transfer (Write only)
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
      filterAlphaParams: FIRFilterParams[T],
      filterBetaParams: FIRFilterParams[T],
      filterGammaParams: FIRFilterParams[T],
      bandpowerParams: sumSquaresParams[T],
      neuralNetsParams: NeuralNetParams[T],
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
    out.bits.data := Cat(wellness.io.out.bits.asUInt(),wellness.io.rawVotes.asUInt())

    // Configuration memory connections.
    // Conf Mem uses the 3 MSB bits to decode the address of the data that is being written.
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
  filterAlphaParams: FIRFilterParams[T],
  filterBetaParams: FIRFilterParams[T],
  filterGammaParams: FIRFilterParams[T],
  bandpowerParams: sumSquaresParams[T],
  neuralNetsParams: NeuralNetParams[T],
  configurationMemoryParams: ConfigurationMemoryParams[T]
)(implicit p: Parameters) extends
  WellnessDataPathBlock[TLClientPortParameters, TLManagerPortParameters, TLEdgeOut, TLEdgeIn, TLBundle, T](
    filter1Params,
    lineLength1Params,
    filterAlphaParams, filterBetaParams, filterGammaParams, bandpowerParams,
    neuralNetsParams,
    configurationMemoryParams)
  with TLDspBlock


class WellnessThing[T <: Data : Real : Order : BinaryRepresentation]
(
  val filter1Params: FIRFilterParams[T],
  val lineLength1Params: lineLengthParams[T],
  val filterAlphaParams: FIRFilterParams[T],
  val filterBetaParams: FIRFilterParams[T],
  val filterGammaParams: FIRFilterParams[T],
  val bandpowerParams: sumSquaresParams[T],
  val neuralNetsParams: NeuralNetParams[T],
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
    filterAlphaParams, filterBetaParams, filterGammaParams, bandpowerParams,
    neuralNetsParams,
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

  val wellnessParams = FixedPointWellnessParams

  // Instantiate wellness monitor
  val wellness = LazyModule(new WellnessThing(
    wellnessParams.filter1Params,
    wellnessParams.lineLength1Params,
    wellnessParams.filterAlphaParams,
    wellnessParams.filterBetaParams,
    wellnessParams.filterGammaParams,
    wellnessParams.bandpowerParams,
    wellnessParams.neuralNetsParams,
    wellnessParams.configurationMemoryParams))
  // Connect memory interfaces to pbus
  pbus.toVariableWidthSlave(Some("wellnessWrite")) { wellness.writeQueue.mem.get }
  pbus.toVariableWidthSlave(Some("wellnessConfigurationWrite")) { wellness.writeConfigurationQueue.mem.get }
  pbus.toVariableWidthSlave(Some("wellnessRead")) { wellness.readQueue.mem.get }
}

trait HasPeripheryWellnessModuleImp extends LazyModuleImp {
  val outer: HasPeripheryWellness

  val streamIn = IO(Flipped(ValidWithSync(outer.wellnessParams.filter1Params.protoData.cloneType)))

  outer.wellness.module.streamIn.sync := streamIn.sync
  outer.wellness.module.streamIn.valid := streamIn.valid
  outer.wellness.module.streamIn.bits := streamIn.bits

}
