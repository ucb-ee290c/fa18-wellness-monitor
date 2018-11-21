# PCA

The PCA block performs dimensionality reduction using Principal Component Analysis. This algorithm enables the transformation of the current feature space into a reduced dimension space that captures most of the variance in the original data. This is done through the process called eigendecomposition. For this project, this procedure will be done offline (through some software such as MATLAB, Python), and only the translation from the original feature space to the reduced dimension space will be performed.You can refer to the [`pca_reference.py`](../scripts/pca_svm/pca_reference.py) file for the implementation of the whole PCA chain in Python.

## Parameters

The PCA generator has the following configurable parameters:
```
trait PCAParams[T <: Data] {
  val protoData: T
  val nDimensions: Int 
  val nFeatures: Int 
}
```

* `nDimensions` corresponds to the number of original features extracted from the input data. 
    * Most likely, this will be a hardcoded parameter since the number of features would have been already determined when constructing the whole system datapath.
    
* `nFeatures` corresponds to the number of reduced dimensions after doing the PCA.
    * This is the same number of features that will be mapped to the SVM generator, which this block connects to. This is the main reason why this parameter is named as such, to make it consistent with the SVM generator parameter.

## Input and Output Ports

The SVM generator has two inputs and one output. These ports are vectors or 2D matrices where the number of rows/columns are defined by the parameters discussed earlier.

```
class PCAIO[T <: Data](params: PCAParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nDimensions, params.protoData)))
  val out = ValidWithSync(Vec(params.nFeatures, params.protoData))

  val PCAVector = Input(Vec(params.nFeatures, Vec(params.nDimensions, params.protoData)))
}
```

* The `in` vector has a size of `nDimensions x 1`. This is the vector of the datapoint with each element is a feature that was calculated by the feature extraction units preceding this stage. This is the vector before the dimensionality reduction.

* The `PCAVector` is a 2D matrix with a size of `nFeatures x nDimensions`. This is the principal component array that allows translation from `nDimensions` down to `nFeatures`. This is something acquired from training, as shown in this [`script`](../scripts/pca_svm/pca_reference.py)

* The `out` vector has a size of `nFeatures x 1`. This is the vector corresponding to the reduced dimensions after doing the PCA translation. This will then feed to the SVM block.

 The PCA translation is achieved through a simple dot product between the two input matrices: the transformation matrix is a `nFeatures x nDimensions` matrix, and the input space is a `nDimensions x 1` matrix. The dot product gives out a `nFeatures x 1` vector which is the output going to the SVM classifier.

## Considerations for all-Online PCA
Based on our research, efficient algorithms to perform PCA and singular value decomposition (SVD) for an arbitrary floating-point m x n matrix are still under active research within the community. In [1], the authors developed an iterative algorithm for a 4x4 matrix based on Hemkumar's two-sided Jacobi algorithm. In [2], the authors improved iterative executions for a fixed-point design with a Hestenes preprocessor, Jacobi rotation, and cyclic ordering. Prior work such as the Brent-Luk-Van Loan systolic array for general n x n matrices is also promising for computing the SVD in real time.

It might also be possible to design a rocketchip-based "soft-core" capable of performing SVD decomposition. However, as the PCA eigendecomposition should be performed before training data with SVM and does not necessarily need to be computed in real-time, the tradeoff limitations in area and speed likely negate the benefit of having an on-chip PCA soft-core.

[1] Design and Prototype of Singular Value Decomposition Hardware in IEEE 802.11n MIMO Standards for Software Defined Radio [pdf link](https://pdfs.semanticscholar.org/a196/cd08786acd8c3d7da40ca87081f3807a4be9.pdf)

[2] An FPGA Implementation of the Hestenes-Jacobi Algorithm for Singular Value Decomposition (http://www.ece.lsu.edu/vaidy/raw14/link-files/Day2/Session5/Paper2_Day2_Session4.pdf)

