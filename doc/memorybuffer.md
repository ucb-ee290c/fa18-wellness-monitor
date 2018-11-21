# Memory Buffer

The memory buffer block acts as a container of the arrays and vectors needed by the SVM and PCA blocks. Dynamically allocating a segment of the RISC-V memory to contain these arrays is hard in the interfacing standpoint since the number of support vectors and principal components can change during the generation process, which will then require some remapping of the addresses for other blocks if ever. This block is basically a serial to array converter, similar to a scan chain. It takes in an input and shifts it through the array creating an nRows x nColumns matrix which can then be used as an input by the SVM (support vectors, alpha vector, intercept vector) and PCA blocks (principal component array).

## Parameters 

The memory buffer has the following configurable parameters:

```
trait MemoryBufferParams[T <: Data] {
  val protoData: T
  val nRows: Int   
  val nColumns: Int 
}

```

* `nRows` corresponds to the number of rows of the output 2D matrix. This should match the parameters of the following matrices:
    * **PCAVector**: `nDimensions`
    * **SVMSupportVector**: `nFeatures`
    * **SVMAlphaVector**: `nSupports`
    * **SVMIntercept**: `nClassifiers`

    
* `nColumns` corresponds to the number of columns of the output 2D matrix. This should match the parameters of the following matrices:
    * **PCAVector**: `nFeatures`
    * **SVMSupportVector**: `nSupports`
    * **SVMAlphaVector**: `nClassifiers`
    * **SVMIntercept**: `1`
    
## Input and Output Ports

Since this is similar to a scan chain, it has 1 (serial) input and 1 (two-dimensional matrix) output port:

```
class MemoryBufferIO[T <: Data](params: MemoryBufferParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(params.protoData))
  val out = ValidWithSync(Vec(params.nColumns,Vec(params.nRows,params.protoData)))
}
```

* The `in` port is the data that gets shifted in to the buffer.

* The `out` port is the resulting `nRows x nColumns` matrix from the shifted `in` data.

## Extension

This generator is being used for the `ConfigurationMemory` block, which is a bundle of 4 memory buffers, as described here. You might want to check it out.