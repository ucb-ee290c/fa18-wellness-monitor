// See LICENSE for license details.

package dwt.test

import chisel3._
import chisel3.iotesters.{ChiselFlatSpec, PeekPokeTester}
import dsptools.numbers.{DspComplex, Real}
import dwt.Decimator


class DecimatorTester[T <: chisel3.Data: Real](c: Decimator[T]) extends PeekPokeTester(c) {
  poke(c.io.in.valid, 0)
  poke(c.io.out.ready, 1)
  step(1)

  // Test that it accepts
  poke(c.io.in.valid, 1)
  poke(c.io.in.bits.asUInt, 555)
  step(1)
  expect(c.io.out.valid, 1)
  expect(c.io.out.bits.asUInt, 555)

  // Then drops
  poke(c.io.in.valid, 1)
  poke(c.io.in.bits.asUInt, 12345)
  step(1)
  expect(c.io.out.valid, 0)

  // Test that it accepts again
  poke(c.io.in.valid, 1)
  poke(c.io.in.bits.asUInt, 10)
  step(1)
  expect(c.io.out.valid, 1)
  expect(c.io.out.bits.asUInt, 10)

  // Then drops
  poke(c.io.in.valid, 1)
  poke(c.io.in.bits.asUInt, 123456)
  step(1)
  expect(c.io.out.valid, 0)

  // Test that it doesn't acccept if out.ready is low
  poke(c.io.out.ready, 0)
  step(1)
  expect(c.io.out.valid, 0)
  step(1)
  expect(c.io.out.valid, 0)

}

class DecimatorSpec extends ChiselFlatSpec {
  behavior of "Decimator"

  it should "work" in {
    chisel3.iotesters.Driver(() => new Decimator[UInt](UInt(32.W)), "firrtl") {
      c => new DecimatorTester[UInt](c)
    } should be (true)
  }
}