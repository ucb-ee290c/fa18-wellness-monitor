package wellness

import firFilter._
import iirFilter._
import fft._
import features._
import pca._
import svm._

import chisel3._
import chisel3.core.FixedPoint
import chisel3.util._
import dspblocks._
import dspjunctions.ValidWithSync
import dsptools.numbers._

import freechips.rocketchip.amba.axi4stream._
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.subsystem._

import scala.collection._


trait wellnessGenParams[T <: Data] {
  val dataType: T
}


// For RocketChip integration
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
  def apply[T <: Data](params: ConfigurationMemoryParams[T]): WellnessConfigurationBundle[T]
    = new WellnessConfigurationBundle(params)
}


class wellnessGenModuleIO[T <: Data : Real : Order : BinaryRepresentation]
(genParams: wellnessGenParams[T],
 pcaParams: PCAParams[T],
 svmParams: SVMParams[T],
 configurationMemoryParams: ConfigurationMemoryParams[T])
extends Bundle {
  var nClassifiers = svmParams.nClasses  // one vs rest default
  if (svmParams.classifierType == "ovr") {
    if (svmParams.nClasses == 2) nClassifiers = svmParams.nClasses - 1
  } else if (svmParams.classifierType == "ovo") {   // one vs one
    nClassifiers = (svmParams.nClasses*(svmParams.nClasses - 1))/2
  } else if (svmParams.classifierType == "ecoc") {  // error correcting output code
    nClassifiers = svmParams.codeBook.head.length // # columns = # classifiers
  }

  val streamIn = Flipped(ValidWithSync(genParams.dataType.cloneType))
  val in = Flipped(DecoupledIO(genParams.dataType.cloneType))
  val inConf = Flipped(ValidWithSync(WellnessConfigurationBundle(configurationMemoryParams)))
  val out = ValidWithSync(Bool())
  val rawVotes = Output(Vec(svmParams.nClasses, svmParams.protoData))
  val classVotes = Output(Vec(svmParams.nClasses,UInt((log2Ceil(nClassifiers)+1).W)))

  override def cloneType: this.type = wellnessGenModuleIO(
    genParams: wellnessGenParams[T],
    pcaParams: PCAParams[T],
    svmParams: SVMParams[T],
    configurationMemoryParams: ConfigurationMemoryParams[T]).asInstanceOf[this.type]
}
object wellnessGenModuleIO {
  def apply[T <: chisel3.Data : Real : Order : BinaryRepresentation](
    genParams: wellnessGenParams[T],
    pcaParams: PCAParams[T],
    svmParams: SVMParams[T],
    configurationMemoryParams: ConfigurationMemoryParams[T]):
  wellnessGenModuleIO[T] = new wellnessGenModuleIO(
    genParams: wellnessGenParams[T],
    pcaParams: PCAParams[T],
    svmParams: SVMParams[T],
    configurationMemoryParams: ConfigurationMemoryParams[T])
}


class wellnessGenModule[T <: chisel3.Data : Real : Order : BinaryRepresentation]
(val genParams: wellnessGenParams[T],
 val pcaParams: PCAParams[T],
 val svmParams: SVMParams[T],
 val configurationMemoryParams: ConfigurationMemoryParams[T])
(implicit val p: Parameters)
extends Module {
  val io = IO(wellnessGenModuleIO[T](
    genParams: wellnessGenParams[T],
    pcaParams: PCAParams[T],
    svmParams: SVMParams[T],
    configurationMemoryParams: ConfigurationMemoryParams[T]))

  // SInt
//  var windowLength = 4
//
//  var coefficients1 = Seq(2.0, 2.0)
//
//  val filter1Params = new FIRFilterParams[SInt] {
//    val protoData = SInt(64.W)
//    val taps = coefficients1.map(ConvertableTo[SInt].fromDouble(_))
//  }
//
//  val fftBufferParams = new FFTBufferParams[SInt] {
//    val protoData = SInt(64.W)
//    val lanes = windowLength
//  }
//
//  val fftConfig = FFTConfig(
//    genIn = DspComplex(SInt(64.W), SInt(64.W)),
//    genOut = DspComplex(SInt(64.W), SInt(64.W)),
//    n = windowLength,
//    lanes = windowLength,
//    pipelineDepth = 0,
//    quadrature = false,
//  )
//
//  val lineLength1Params = new lineLengthParams[SInt] {
//    val protoData = SInt(64.W)
//    val windowSize = windowLength
//  }
//
//  val bandpower1Params = new BandpowerParams[SInt] {
//    val idxStartBin = 0
//    val idxEndBin = 2
//    val nBins = windowLength
//    val genIn = DspComplex(SInt(64.W), SInt(64.W))
//    val genOut = SInt(64.W)
//  }
//  val bandpower2Params = new BandpowerParams[SInt] {
//    val idxStartBin = 0
//    val idxEndBin = 2
//    val nBins = windowLength
//    val genIn = DspComplex(SInt(64.W), SInt(64.W))
//    val genOut = SInt(64.W)
//  }
  // End SInt

  // FixedPoint
//  var windowLength = 32
//
//  var dataWidth = 32
//  var dataBP = 8
//
//  var coefficients1 = Seq(3.0, 4.0, -5.0, 2.0, -1.0, -2.2, 3.3, -3.4)
//
//  val filter1Params = new FIRFilterParams[FixedPoint] {
//    val protoData = FixedPoint(dataWidth.W, dataBP.BP)
//    val taps = coefficients1.map(ConvertableTo[FixedPoint].fromDouble(_))
//  }
//
//  val fftBufferParams = new FFTBufferParams[FixedPoint] {
//    val protoData = FixedPoint(dataWidth.W, dataBP.BP)
//    val lanes = windowLength
//  }
//
//  val fftConfig = FFTConfig(
//    genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP)),
//    genOut = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP)),
//    n = windowLength,
//    lanes = windowLength,
//    pipelineDepth = 0,
//    quadrature = false,
//  )
//
//  val lineLength1Params = new lineLengthParams[FixedPoint] {
//    val protoData = FixedPoint(dataWidth.W, dataBP.BP)
//    val windowSize = windowLength
//  }
//
//  val bandpower1Params = new BandpowerParams[FixedPoint] {
//    val idxStartBin = 0
//    val idxEndBin = 2
//    val nBins = windowLength
//    val genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP))
//    val genOut = FixedPoint(dataWidth.W, dataBP.BP)
//  }
//  val bandpower2Params = new BandpowerParams[FixedPoint] {
//    val idxStartBin = 0
//    val idxEndBin = 2
//    val nBins = windowLength
//    val genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP))
//    val genOut = FixedPoint(dataWidth.W, dataBP.BP)
//  }
  // End FixedPoint

  // C test
  var windowLength = 4

  var dataWidth = 32
  var dataBP = 8

  var coefficients1 = Seq(1, 2, 3, 4, 5, 0).map(ConvertableTo[FixedPoint].fromDouble(_))

  val filter1Params = new FIRFilterParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W, dataBP.BP)
    val taps = coefficients1
  }

  val fftBufferParams = new FFTBufferParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W, dataBP.BP)
    val lanes = windowLength
  }

  val fftConfig = FFTConfig(
    genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP)),
    genOut = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP)),
    n = windowLength,
    lanes = windowLength,
    pipelineDepth = 0,
    quadrature = false,
  )

  val lineLength1Params = new lineLengthParams[FixedPoint] {
    val protoData = FixedPoint(dataWidth.W, dataBP.BP)
    val windowSize = windowLength
  }

  val bandpower1Params = new BandpowerParams[FixedPoint] {
    val idxStartBin = 0
    val idxEndBin = 2
    val nBins = windowLength
    val genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP))
    val genOut = FixedPoint(dataWidth.W, dataBP.BP)
  }
  val bandpower2Params = new BandpowerParams[FixedPoint] {
    val idxStartBin = 0
    val idxEndBin = 2
    val nBins = windowLength
    val genIn = DspComplex(FixedPoint(dataWidth.W, dataBP.BP), FixedPoint(dataWidth.W, dataBP.BP))
    val genOut = FixedPoint(dataWidth.W, dataBP.BP)
  }
  // End C test

  val inStream = Wire(ValidWithSync(genParams.dataType))
  inStream.bits := Mux(io.inConf.bits.confInputMuxSel,io.streamIn.bits.asTypeOf(genParams.dataType),io.in.bits.asTypeOf(genParams.dataType))
  inStream.valid := Mux(io.inConf.bits.confInputMuxSel,io.streamIn.valid,io.in.valid)
  inStream.sync := Mux(io.inConf.bits.confInputMuxSel,io.streamIn.sync,false.B)


  // Ch x (params): seq of param datapaths
  // Each param datapath: seq of (block type, block params)
  // val datapathParamsSeqs = Seq(Seq(("FIR",filter1Params), ("lineLength",lineLength1Params)),
  //   Seq(("FIR",filter1Params), ("lineLength",lineLength1Params)),
  //   Seq(("FIR",filter1Params), ("lineLength",lineLength1Params)))
  val datapathParamsSeqs = Seq(Seq(("FIR",filter1Params), ("lineLength",lineLength1Params)),
    Seq(("FIR",filter1Params),("FFTBuffer",fftBufferParams), ("FFT",fftConfig),("bandpower",bandpower1Params)),
    Seq(("FIR",filter1Params),("FFTBuffer",fftBufferParams), ("FFT",fftConfig),("bandpower",bandpower2Params)))
  // Ch x (modules): arr of module datapaths
  // Each module datapath: arr of (block type, gen'd module)
  val generatedDatapaths: mutable.ArrayBuffer[mutable.ArrayBuffer[(String,Module)]] = mutable.ArrayBuffer()

  // Just a var instantiation
  var singlePathParamsSeq = Seq(("FIR",filter1Params), ("lineLength",lineLength1Params))

  // Gen ch x's seq of module datapaths from param datapaths
  // For each (ith) param datapath in ch x (params)
  for (i <- 0 until datapathParamsSeqs.length)
  {
    // Param datapath i
    singlePathParamsSeq = datapathParamsSeqs(i)
    // Module datapath (i)
    val generatedSinglePath: mutable.ArrayBuffer[(String,Module)] = mutable.ArrayBuffer()

    // For each (jth) param in param datapath i
    for(j <- 0 until singlePathParamsSeq.length)
    {
      // Param j
      singlePathParamsSeq(j)._1 match
      {
        case "FIR" =>
        {
          generatedSinglePath += (("FIR",Module(new ConstantCoefficientFIRFilter(singlePathParamsSeq(j)._2.asInstanceOf[FIRFilterParams[T]]))))
        }
        case "IIR" =>
        {
          generatedSinglePath += (("IIR",Module(new ConstantCoefficientIIRFilter(singlePathParamsSeq(j)._2.asInstanceOf[IIRFilterParams[T]]))))
        }
        case "FFTBuffer" =>
        {
          generatedSinglePath += (("FFTBuffer",Module(new FFTBuffer(singlePathParamsSeq(j)._2.asInstanceOf[FFTBufferParams[T]]))))
        }
        case "FFT" =>
        {
          generatedSinglePath += (("FFT",Module(new FFT(singlePathParamsSeq(j)._2.asInstanceOf[FFTConfig[T]]))))
        }
        case "lineLength" =>
        {
          generatedSinglePath += (("lineLength",Module(new lineLength(singlePathParamsSeq(j)._2.asInstanceOf[lineLengthParams[T]]))))
        }
        case "bandpower" =>
        {
          generatedSinglePath += (("bandpower",Module(new Bandpower(singlePathParamsSeq(j)._2.asInstanceOf[BandpowerParams[T]]))))
        }
      }
    }
    // Add (jth) module datapath to ch x (modules)
    generatedDatapaths += generatedSinglePath
  }

  val pcaInVector = Wire(Vec(pcaParams.nDimensions, pcaParams.protoData))
  val pcaInValVec = Wire(Vec(pcaParams.nDimensions, Bool()))
  // For each (ith) module datapath in ch x, connect up modules
  for(i <- 0 until generatedDatapaths.length)
    {
      // Module datapath i
      val genDatapath = generatedDatapaths(i)
      // For each (jth) module in module datapath i
      for(j <- 0 until genDatapath.length)
      {
        // Connect first module to input
        if (j == 0)
        {
          genDatapath(j)._1 match
          {
            case "FIR" =>
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.valid := inStream.valid
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.bits  := inStream.bits
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.sync  := inStream.sync
            case "IIR" =>
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.valid := inStream.valid
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.bits  := inStream.bits
              genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.sync  := inStream.sync
            case "FFTBuffer" =>
              genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.valid := inStream.valid
              genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.bits  := inStream.bits
              genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.sync  := inStream.sync
          }
        }
        // Other than first module, connect module to previous module
        else
        {
          genDatapath(j)._1 match
          {
            case "FIR" =>
            {
              genDatapath(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.valid := genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.bits  := genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.in.sync  := false.B
                }
              }
            }
            case "IIR" =>
            {
              genDatapath(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.valid := genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.bits  := genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.in.sync  := false.B
                }
              }
            }
            case "FFTBuffer" =>
            {
              genDatapath(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[FFTBuffer[T]].io.in.sync  :=  false.B
                }
              }
            }
            case "FFT" =>
            {
              // FFT Buffers to FFTs
              genDatapath(j)._2.asInstanceOf[FFT[T]].io.in.valid := genDatapath(j-1)._2.asInstanceOf[FFTBuffer[T]].io.out.valid
              genDatapath(j)._2.asInstanceOf[FFT[T]].io.in.sync  := false.B
              for (i <- genDatapath(j)._2.asInstanceOf[FFT[T]].io.in.bits.indices) {
                genDatapath(j)._2.asInstanceOf[FFT[T]].io.in.bits(i).real := genDatapath(j-1)._2.asInstanceOf[FFTBuffer[T]].io.out.bits(i).asTypeOf(genDatapath(j)._2.asInstanceOf[FFT[T]].io.in.bits(i).real)
              }
              genDatapath(j)._2.asInstanceOf[FFT[T]].io.in.bits.foreach(_.imag := ConvertableTo[T].fromInt(0))

              genDatapath(j)._2.asInstanceOf[FFT[T]].io.data_set_end_clear := false.B

            }
            case "lineLength" =>
            {
              genDatapath(j-1)._1 match
              {
                case "FIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.sync  :=  false.B
                }
                case "IIR" =>
                {
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.valid :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.valid
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.bits  :=  genDatapath(j-1)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.bits
                  genDatapath(j)._2.asInstanceOf[lineLength[T]].io.in.sync  :=  false.B
                }
              }
            }
            case "bandpower" =>
            {
              genDatapath(j)._2.asInstanceOf[Bandpower[T]].io.in.valid := genDatapath(j-1)._2.asInstanceOf[FFT[T]].io.out.valid
              genDatapath(j)._2.asInstanceOf[Bandpower[T]].io.in.bits  := genDatapath(j-1)._2.asInstanceOf[FFT[T]].io.out.bits
              genDatapath(j)._2.asInstanceOf[Bandpower[T]].io.in.sync  := false.B
            }
          }
        }
        // Connect output to last module
        if (j == genDatapath.length-1)
        {
          genDatapath(j)._1 match
          {
            case "FIR" =>
            {
              pcaInValVec(i) := genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.valid
              pcaInVector(i) := genDatapath(j)._2.asInstanceOf[ConstantCoefficientFIRFilter[T]].io.out.bits
            }
            case "IIR" =>
            {
              pcaInValVec(i) := genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.valid
              pcaInVector(i) := genDatapath(j)._2.asInstanceOf[ConstantCoefficientIIRFilter[T]].io.out.bits
            }
            case "lineLength" =>
            {
              pcaInValVec(i) := genDatapath(j)._2.asInstanceOf[lineLength[T]].io.out.valid
              pcaInVector(i) := genDatapath(j)._2.asInstanceOf[lineLength[T]].io.out.bits
            }
            case "bandpower" =>
            {
              pcaInValVec(i) := genDatapath(j)._2.asInstanceOf[Bandpower[T]].io.out.valid
              pcaInVector(i) := genDatapath(j)._2.asInstanceOf[Bandpower[T]].io.out.bits
            }
          }
        }
      }
    }

  // PCA (datapaths to PCA)
  val pca = Module(new PCA(pcaParams))
  pca.io.PCAVector := io.inConf.bits.confPCAVector
  pca.io.in.valid := pcaInValVec.asUInt().andR()
  pca.io.in.bits := pcaInVector
  pca.io.in.sync := false.B

  // SVM (PCA to SVM)
  val svm = Module(new SVM(svmParams))
  // Configure SVM
  svm.io.supportVector := io.inConf.bits.confSVMSupportVector
  svm.io.alphaVector := io.inConf.bits.confSVMAlphaVector
  svm.io.intercept := io.inConf.bits.confSVMIntercept
  // Connect PCA to SVM
  svm.io.in.valid := pca.io.out.valid
  svm.io.in.bits := pca.io.out.bits
  svm.io.in.sync := false.B
  // SVM to Output
  io.out.valid := svm.io.out.valid
  io.out.sync := svm.io.out.sync
  io.out.bits := false.B
  io.rawVotes := svm.io.rawVotes
  io.classVotes := svm.io.classVotes

  io.in.ready := true.B
}

abstract class wellnessGenDataPathBlock[D, U, EO, EI, B <: Data, T <: Data : Real : Order : BinaryRepresentation]
(
  val genParams: wellnessGenParams[T],
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
    val wellnessGen = Module(new wellnessGenModule(
      genParams: wellnessGenParams[T],
      pcaParams: PCAParams[T],
      svmParams: SVMParams[T],
      configurationMemoryParams: ConfigurationMemoryParams[T]))

    val configurationMemory = Module(new ConfigurationMemory(configurationMemoryParams))
    val streamIn = IO(Flipped(ValidWithSync(genParams.dataType.cloneType)))

    wellnessGen.io.streamIn.bits := streamIn.bits
    wellnessGen.io.streamIn.valid := streamIn.valid
    wellnessGen.io.streamIn.sync := streamIn.sync

    in.ready := wellnessGen.io.in.ready
    // Input to Wellness
    wellnessGen.io.in.valid := in.valid
    wellnessGen.io.in.bits := in.bits.data.asTypeOf(genParams.dataType)
    // Wellness to Output
    out.valid := wellnessGen.io.out.valid
    out.bits.data := Cat(wellnessGen.io.rawVotes(1).asUInt(),wellnessGen.io.rawVotes(0).asUInt())

    inConf.ready := true.B
    configurationMemory.io.in.valid := inConf.valid
    configurationMemory.io.in.sync := false.B
    configurationMemory.io.in.bits.wrdata := inConf.bits.data(configurationMemory.io.in.bits.wrdata.getWidth-1,0).asTypeOf(configurationMemory.io.in.bits.wrdata)
    configurationMemory.io.in.bits.wraddr := inConf.bits.data(configurationMemory.io.in.bits.wrdata.getWidth+2,configurationMemory.io.in.bits.wrdata.getWidth).asTypeOf(configurationMemory.io.in.bits.wraddr)
    wellnessGen.io.inConf := configurationMemory.io.out
  }
}


class TLWellnessGenDataPathBlock[T <: Data : Real : Order : BinaryRepresentation]
(
  genParams: wellnessGenParams[T],
  pcaParams: PCAParams[T],
  svmParams: SVMParams[T],
  configurationMemoryParams: ConfigurationMemoryParams[T]
)(implicit p: Parameters) extends
  wellnessGenDataPathBlock[TLClientPortParameters, TLManagerPortParameters, TLEdgeOut, TLEdgeIn, TLBundle, T](
    genParams,
    pcaParams, svmParams,
    configurationMemoryParams)
  with TLDspBlock


class wellnessGenThing[T <: Data : Real : Order : BinaryRepresentation]
(
  val genParams: wellnessGenParams[T],
  val pcaParams: PCAParams[T],
  val svmParams: SVMParams[T],
  val configurationMemoryParams: ConfigurationMemoryParams[T],
  val depth: Int = 32
)(implicit p: Parameters) extends LazyModule {
  // Instantiate lazy modules
  val writeQueue = LazyModule(new TLWriteQueue(depth))
  val configurationBaseAddr = AddressSet(0x2200, 0xff)
  val writeConfigurationQueue = LazyModule(new TLWriteQueue(depth,configurationBaseAddr))
  val wellness = LazyModule(new TLWellnessGenDataPathBlock(
    genParams,
    pcaParams,
    svmParams,
    configurationMemoryParams))
  val readQueue = LazyModule(new TLReadQueue(depth))

  // Connect streamNodes of queues and wellness monitor
  readQueue.streamNode := wellness.streamNode := writeQueue.streamNode
  wellness.streamNode := writeConfigurationQueue.streamNode

  lazy val module = new LazyModuleImp(this) {
    val streamIn = IO(Flipped(ValidWithSync(genParams.dataType.cloneType)))

    wellness.module.streamIn.bits := streamIn.bits
    wellness.module.streamIn.valid := streamIn.valid
    wellness.module.streamIn.sync := streamIn.sync
  }
}

trait HasPeripheryWellness extends BaseSubsystem {

  val wellnessParams = FixedPointWellnessParams

  // Instantiate wellness monitor
  val wellness = LazyModule(new wellnessGenThing(
    wellnessParams.wellnessGenParams1,
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

  val streamIn = IO(Flipped(ValidWithSync(outer.wellnessParams.wellnessGenParams1.dataType.cloneType)))

  outer.wellness.module.streamIn.sync := streamIn.sync
  outer.wellness.module.streamIn.valid := streamIn.valid
  outer.wellness.module.streamIn.bits := streamIn.bits

}