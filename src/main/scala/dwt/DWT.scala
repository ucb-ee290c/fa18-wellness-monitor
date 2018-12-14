package dwt

import chisel3._
import chisel3.util.Decoupled
import dspjunctions.ValidWithSync
import dsptools.numbers._
import firFilter._

class DWTIO[T <: Data](val params: DWTParams[T], val num_levels: Int) extends Bundle {
  val in = Flipped(ValidWithSync(params.protoData.cloneType))
  val approx_coeffs = Vec(num_levels, ValidWithSync(params.protoData.cloneType)) // each level of the DWT generates one set of detail coeffs, while the very last level generates both detail coeffs and approx coeffs
  val detail_coeffs = Vec(num_levels, ValidWithSync(params.protoData.cloneType)) // each level of the DWT generates one set of detail coeffs, while the very last level generates both detail coeffs and approx coeffs

  //val DWTVector = Input(Vec(params.nFeatures, Vec(params.nDimensions, params.protoData)))

  override def cloneType: this.type = DWTSubblockIO(params).asInstanceOf[this.type]
}

object DWT {
  def apply[T <: Data : Real](params: DWTParams[T], num_levels: Int): DWT[T] = new DWT[T](params, num_levels)
}

class DWT[T <: Data : Real](val params: DWTParams[T], val num_levels: Int) extends Module {
  //require(params.nDimensions >= params.nFeatures,
  // f"Number of projected dimensions ${params.nFeatures} should be at most the number of original dimensions ${params.nDimensions}")

  val io = IO(new DWTIO[T](params, num_levels))

  // Generate all hardware at once.
  // TODO (future optimization) implement as FSM for runtime variable number of DWT filter stages

  val blocks: Seq[DWTSubblock[T]] = (0 until num_levels).map { _ =>
    Module(new DWTSubblock[T](params))
  }

  for (i <- 0 until num_levels) {
    blocks(i).io.in <> (if (i == 0) {
      io.in
    } else {
      blocks(i - 1).io.approx_coeff_out
    })
    io.approx_coeffs(i) <> blocks(i).io.approx_coeff_out
    io.detail_coeffs(i) <> blocks(i).io.detail_coeff_out
  }
}