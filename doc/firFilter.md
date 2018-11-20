# FIR Filter
This FIR Filter Generator takes a set of coefficients of any desired length and type and generates an FIR filter with a `ValidWithSync` interface for input/output streams. This version generates an FIR filter with constant coefficients as it is only intended as a Low Pass/Band Pass filter generator with constant corner frequencies.

## Parameters

The SVM generator has the following configurable parameters:

```
trait FIRFilterParams[T <: Data] {
  val protoData: T
  val taps: Seq[T]          
}
```

* `taps` corresponds to the coefficients of the FIR filter, expressed in terms of the input data type. The number of multiplication units is inferred from the given sequence. 

## Input and Output Ports

The generated FIR Filter has one input and one output port. Both of these are standard `ValidWithSync` interfaces. Internally, `valid` is used to enable the shift register chain, and is also propagated through the block to preserve data validity information. `sync` pin is not internally used but is propagated to provide syncronization information for later blocks.

