# Line Length
This Line Length Calculator Generator takes a window size as an input to calculate the average line length over.

## Parameters

The Line Length Calculator generator has the following configurable parameters:

```
trait FIRFilterParams[T <: Data] {
  val protoData: T
  val windowSize: Int    
}
```

* `windowSize` corresponds to the size of the window over which line length is calculated. 
Currently, to reduce the hardware requirements, this can only be a power of two.

## Input and Output Ports

The generated Line Length calculator has one input and one output port. Both of these are standard `ValidWithSync` interfaces. Internally, `valid` is used to enable the shift register chain, and is also propagated through the block to preserve data validity information. `sync` pin is not internally used but is propagated to provide syncronization information for later blocks.

