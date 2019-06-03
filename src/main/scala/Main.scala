/*
package wellness

import chisel3._
import dsptools.numbers._
import freechips.rocketchip.amba.axi4stream._
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.diplomacy._

import scala.collection.mutable.ArrayBuffer

object StandaloneWellness extends App {
  implicit val p: Parameters = Parameters.empty

  chisel3.Driver.execute(args, () => LazyModule(new TLWellnessGenDataPathBlock(
    genParams = FixedPointWellnessParams.wellnessGenParams1,
    datapathParamsArr = FixedPointWellnessGenParams.datapathsArr,
    heritageArray = ArrayBuffer(),
    pcaParams = FixedPointWellnessParams.pcaParams,
    logisticParams = FixedPointWellnessParams.logisticParams,
    configurationMemoryParams = FixedPointWellnessParams.configurationMemoryParams
  ) with dspblocks.TLStandaloneBlock {
    val ioInNode2 = BundleBridgeSource(() => new AXI4StreamBundle(AXI4StreamBundleParameters(n = 8)))

    streamNode := BundleBridgeToAXI4Stream(AXI4StreamMasterParameters()) :=
      ioInNode2

    val in2 = InModuleBody { ioInNode2.makeIO() }
  }).module)
}
*/