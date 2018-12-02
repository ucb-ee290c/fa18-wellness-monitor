package wellness

import chisel3._
import freechips.rocketchip.config.Parameters
import freechips.rocketchip.devices.debug.Debug
import freechips.rocketchip.diplomacy.LazyModule
import freechips.rocketchip.util.GeneratorApp

class TestHarness()(implicit p: Parameters) extends Module {
  val io = IO(new Bundle {
    val success = Output(Bool())
  })

  val dut = Module(LazyModule(new ExampleTopWithWellness).module)
  dut.reset := reset.toBool() | dut.debug.ndreset

  dut.dontTouchPorts()
  dut.tieOffInterrupts()
  dut.connectSimAXIMem()
  Debug.connectDebug(dut.debug, clock, reset.toBool(), io.success)

  dut.streamIn.valid := true.B
  dut.streamIn.sync := true.B
  dut.streamIn.bits := 0.asSInt()//.asUInt().asFixedPoint(8.BP)
}

object Generator extends GeneratorApp {
  val longName = names.configProject + "." + names.configs
  generateFirrtl
  generateAnno
  generateTestSuiteMakefrags
  generateROMs
  generateArtefacts
}