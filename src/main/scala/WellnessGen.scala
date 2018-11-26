package wellness

import chisel3._
import chisel3.core.FixedPoint
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
import scala.collection._



// Right now wellnessGen is just a testbed for making a high level scala generator class
// First up is generating an arbitrary number of filters and driving them with the same input

class wellnessGenModuleIO[T <: Data : Real : Order : BinaryRepresentation](filter1Params: FIRFilterParams[T])  extends Bundle {
  val in = Flipped(DecoupledIO(filter1Params.protoData.cloneType))
  // add loop to have appropriate number of outputs?
  val out = ValidWithSync(filter1Params.protoData.cloneType)
  val otherOut = Output(filter1Params.protoData)

  override def cloneType: this.type = wellnessGenModuleIO(filter1Params: FIRFilterParams[T]).asInstanceOf[this.type]
}

object wellnessGenModuleIO {
  def apply[T <: chisel3.Data : Real : Order : BinaryRepresentation](filter1Params: FIRFilterParams[T]):
  wellnessGenModuleIO[T] = new wellnessGenModuleIO(filter1Params: FIRFilterParams[T])
}

class wellnessGenModule[T <: chisel3.Data : Real : Order : BinaryRepresentation]
( val filter1Params: FIRFilterParams[T], val x : Int)(implicit val p: Parameters) extends Module {
  val io = IO(wellnessGenModuleIO[T](filter1Params: FIRFilterParams[T]))

  val testFilter = Module(new ConstantCoefficientFIRFilter(filter1Params))
  io.in.ready := true.B
  testFilter.io.in.valid := io.in.valid
  testFilter.io.in.sync := false.B
  testFilter.io.in.bits := io.in.bits.asTypeOf(filter1Params.protoData)

  io.otherOut := testFilter.io.out.bits

  val modules = mutable.ArrayBuffer[ConstantCoefficientFIRFilter[T]]()
  val tap_count = 3


  for (i <- 0 until x) {

    val coefficients = mutable.ArrayBuffer[Int]()
    for (j <- 0 until tap_count) coefficients += (-32 + scala.util.Random.nextInt(64))

    val params = new FIRFilterParams[UInt] {
      val protoData = UInt(16.W)
      val taps = coefficients.map(_.asUInt(16.W))
    }

    modules += Module(new ConstantCoefficientFIRFilter(filter1Params))
    modules(i).io.in.valid := io.in.valid
    modules(i).io.in.sync := false.B
    modules(i).io.in.bits := io.in.bits.asTypeOf(filter1Params.protoData)
  }

  io.out.valid := modules(0).io.out.valid
  io.out.sync := modules(0).io.out.sync
  io.out.bits := modules(0).io.out.bits
}


abstract class wellnessGenDataPathBlock[D, U, EO, EI, B <: Data, T <: Data : Real : Order : BinaryRepresentation]
(
  val filter1Params: FIRFilterParams[T],
  val x: Int
)(implicit p: Parameters) extends DspBlock[D, U, EO, EI, B] {
  val streamNode = AXI4StreamNexusNode(
    masterFn = { seq => AXI4StreamMasterPortParameters()},
    slaveFn  = { seq => AXI4StreamSlavePortParameters()}
  )
  val mem = None

  lazy val module = new LazyModuleImp(this) {
    require(streamNode.in.length == 1)
    require(streamNode.out.length == 1)

    val in = streamNode.in.head._1
    val out = streamNode.out.head._1

    // Block instantiation
    val wellness = Module(new wellnessGenModule(filter1Params:
      FIRFilterParams[T], x: Int))

    in.ready := wellness.io.in.ready
    // Input to Wellness
    wellness.io.in.valid := in.valid
    wellness.io.in.bits := in.bits.data.asTypeOf(filter1Params.protoData)

    // Wellness to Output
    out.valid := wellness.io.out.valid
    out.bits := wellness.io.out.bits
  }
}


class TLWellnessGenDataPathBlock[T <: Data : Real : Order : BinaryRepresentation]
(
  filter1Params: FIRFilterParams[T],
  x: Int
)(implicit p: Parameters) extends
  wellnessGenDataPathBlock[TLClientPortParameters, TLManagerPortParameters, TLEdgeOut, TLEdgeIn, TLBundle, T](
    filter1Params, x)
  with TLDspBlock


class wellnessGenThing[T <: Data : Real : Order : BinaryRepresentation]
(
  val filter1Params: FIRFilterParams[T],
  val x: Int,
  val depth: Int = 32
)(implicit p: Parameters) extends LazyModule {
  // Instantiate lazy modules
  val writeQueue = LazyModule(new TLWriteQueue(depth))
  val wellness = LazyModule(new TLWellnessGenDataPathBlock(
    filter1Params,
    x))
  val readQueue = LazyModule(new TLReadQueue(depth))

  // Connect streamNodes of queues and wellness monitor
  readQueue.streamNode := wellness.streamNode := writeQueue.streamNode

  lazy val module = new LazyModuleImp(this)
}


object SIntWellnessGenParams {
  val filter1Params = new FIRFilterParams[SInt] {
    val protoData = SInt(32.W)
    val taps = Seq(1.S, 2.S, 3.S, 4.S, 5.S, 0.S)
  }
  val protoData = filter1Params.protoData.cloneType
}


trait HasPeripheryWellnessGen extends BaseSubsystem {

  val wellnessParams = SIntWellnessGenParams

  // Instantiate wellness monitor
  val wellness = LazyModule(new wellnessGenThing(
    wellnessParams.filter1Params,
    3
  ))
  // Connect memory interfaces to pbus
  pbus.toVariableWidthSlave(Some("wellnessWrite")) { wellness.writeQueue.mem.get }
  pbus.toVariableWidthSlave(Some("wellnessRead")) { wellness.readQueue.mem.get }
}