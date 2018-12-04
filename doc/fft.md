# FFT

## Overview
This FFT generator is based on [ucb-art/fft](https://github.com/ucb-art/fft/tree/diplomacyPort2) (diplomacyPort2 branch). This FFT block is restricted to signal lengths of powers of 2, but that should be fine for our application (at least for now). The only modifications were to include unscrambling (see the FFT repo) and add a pipeline register at the output for system critical path concerns.

## Parameters
The FFT generator has the following configurable parameters:

```
case class FFTConfig[T <: Data](
  genIn: DspComplex[T],
  genOut: DspComplex[T],
  n: Int = 16, // n-point FFT
  pipelineDepth: Int = 0,
  lanes: Int = 8,
  quadrature: Boolean = true
)
```

* `genIn` sets the input type (_e.g._, UInt, FixedPoint, etc.).
* `genOut` sets the output type.
* `n` sets the number of points for the FFT.
  * `n` is required to be 4 or more.
  * `n` is also required to be a power of 2.
* `pipelineDepth` sets the number of pipeline stages.
  * `pipelineDepth` is required to be non-negative.
  * It is unclear whether this feature is functional. Pipelined FFTs do not appear to pass tests. In the Wellness Monitor, `pipelineDepth` is always 0.
* `lanes` sets the number of points for the FFT.
  * For simplicity, in Wellness Monitor, `lanes` is currently always equal to `n`.
* `quadrature` sets the use of quadrature mode.
  * In the Wellness Monitor, `quadrature` is always set to false. This feature is not necessary for the Wellness Monitor. (Quadrature mode as written is incompatible with unscrambling, and thus it was avoided to minimize changes to the original FFT generator, thereby avoiding further inconsistencies.)

## Input and Output Ports
The FFT generator has two inputs and two outputs:

```
class FFTIO[T<:Data:Real](lanes: Int, genIn: DspComplex[T], genOut: DspComplex[T])(implicit val p: Parameters) extends Bundle {
  val in = Input(ValidWithSync(Vec(lanes, genIn)))
  val out = Output(ValidWithSync(Vec(lanes, genOut)))

  val data_set_end_status = Output(Bool())
  val data_set_end_clear = Input(Bool())
}
```

The key ports are `in` and `out`. These ports are of the [ValidWithSync](https://github.com/ucb-bar/dsptools/blob/master/rocket/doc/stream.md) interface. The data (`bits`) are vectors where the number of elements (which is the same for both) is set by the `lanes` parameters. Each element is of type `DspComplex[T]`, as set by `genIn` for the input and `genOut` for the output.

## Testing
The FFT generator has been [unit tested](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/src/test/scala/CustomFFTSpec.scala) for `FixedPoint` using a Scala/Breeze [reference](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/src/test/scala/CustomFFTTester.scala) with various parameters (number of FFT points/lanes, total width, and fractional bits).

## To Do
It would be nice to have an FFT block with fewer restrictions. For example, it would be nice to perform an FFT on a time series window that is not a power of 2. Moreover, this FFT block has some bugs. For example, it is unclear whether the pipelining feature actually works (hence the added output pipeline register).
