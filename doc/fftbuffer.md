# FFT Buffer
This is a generator that allows streaming interfaces to communicate with a multi-lane block.

## Parameters

The FFT Buffer generator has the following configurable parameters:

```
trait FIRFilterParams[T <: Data] {
  val protoData: T
  val lanes: Int    
}
```

* `lanes` determines the number of memory elements inside the buffer and how frequently the `valid` singal will go high.

## Block Details

The generated FFT Buffer has one input and one output port. Both of these are standard `ValidWithSync` interfaces. The input 
data type is a single `protoData` wire while the output is a vector of the same type. `in.valid` is used to shift data into
the memory (and hence the output) and every time the internal counter reaches the value of `lanes`, `out.valid` is held high.
A new data shifted in to the buffer causes `out.valid` to go low and outputs to change.
