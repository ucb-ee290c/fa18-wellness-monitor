# Bandpower

## Overview
This bandpower block calculates the average power of the FFT input signal in a parameterizable frequency range.

## Parameters
The Bandpower generator has the following configurable parameters:

```
trait BandpowerParams[T <: Data] {
  val idxStartBin: Int
  val idxEndBin: Int
  val nBins: Int
  val genIn: DspComplex[T]
  val genOut: T
}
```

* `idxStartBin` sets the index of the lower frequency bound of the frequency range of interest.
* `idxEndBin` sets the index of the upper frequency bound of the frequency range of interest.
  * Finding the index that corresponds to the target frequency is done in software at generation time.
  * `idxEndBin` is required to be (strictly) greater than `idxStartBin`
  * The number of bins in the frequency range of interest is required to be a power of 2 (see Implementation Details below).
* `nBins` sets the length of the FFT input signal.
* `genIn` sets the input data type.
  * Since `genIn` is a single FFT bin, it is a `DspComplex` to contain both real and imaginary components such that its magnitude/power can actually be calculated by the Bandpower block.
* `genOut` sets the output data type.
  * `genOut` is a simple scalar since bandpower is a simple number.

## Input and Output Ports
The Bandpower generator has one input and one output:

```
class BandpowerIO[T <: Data](params: BandpowerParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nBins, params.genIn.cloneType)))
  val out = ValidWithSync(params.genOut.cloneType)
}
```

These ports are of the [ValidWithSync](https://github.com/ucb-bar/dsptools/blob/master/rocket/doc/stream.md) interface. The input data (`bits`) is a vector with `nBins` elements and type set by `genIn` (`DspComplex[T]`). The output data (`bits`) is a simple scalar with type set by `genOut`.

## Implementation Details
First, the two-sided spectrum `p2` is calculated by taking the magnitude squared of each point of the input. Next, the single-sided spectrum `p1` is computed. With the exception of the DC and Nyquist frequency elements (the first element and the "central" element of `p2`), the values are doubled. Then, the values in the bins of interest are squared and the summed to find the energy in the band of interest. The energy is then divided by the number of bins in the range of interest to calculate the average power. Division is performed by a simple bit shift to reduce complexity, so the number of bins in the frequency range of interest is required to be a power of 2.
