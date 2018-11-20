# FIR Filter
This FIR Filter Generator takes a set of coefficients of any desired length and type and generates an FIR filter with a `ValidWithSync` interface for input/output streams. This version generates an FIR filter with constant coefficients as it is only intended as a Low Pass/Band Pass filter generator with constant corner frequencies.

# SVM

## Overview

The SVM block performs classification using the Support Vector Machine algorithm. [`svm_reference.py`](../scripts/svm_reference.py) models the whole chain (from training all the way to inference/classification). This reference file already implements the final SVM algorithm to be implemented for this project (parameterizable number of classes, different kernel support, and variable number of features). Understanding what the script does requires some background on how to do inference using SVM. I have written a [`comprehensive tutorial`](svm_tutorial.md) regarding that. Please read that first.

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

