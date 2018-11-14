# SVM

## Overview

The SVM block performs classification using the Support Vector Machine algorithm. [`svm_reference.py`](svm_reference.py) models the whole chain (from training all the way to inference/classification). This reference file already implements the final SVM algorithm to be implemented for this project (parameterizable number of classes, different kernel support, and variable number of features). Understanding what the script does requires some background on how to do inference using SVM. I have written some [`comprehensive tutorial`](svm_tutorial.md) regarding that. Please read that first.

## Parameters

The SVM generator has the following configurable parameters:

```
trait SVMParams[T <: Data] {
  val protoData: T
  val nSupports: Int
  val nFeatures: Int 
  val nClasses:  Int   
  val classifierType: String 
  val codeBook: Seq[Seq[Int]] 
  val kernelType: String        
  val nDegree: Int            
}
```

* `nSupports` corresponds to the number of support vectors that the generator can take in. 
    * The actual number of support vectors actually depend on training. For flexibility, you can set `nSupports` to be some large number (the highest expected number of support vectors) and then just zero out the extra vectors if not needed. Of course, you trade-off flexibility with hardware cost.

* `nFeatures` corresponds to the dimension of the input to the SVM. 
    * Since the SVM is connected to a PCA block, which performs dimensionality reduction, this parameter doesn't actually correspond to the number of computed features in the system. Instead, this corresponds to the number of reduced dimensions coming from the PCA.
    
* `nClasses` corresponds to the number of classes that the SVM will distinguish. 
    * The bare-bones SVM performs binary classification (i.e. only identifies two classes). However, you can extend this functionality by creating additional classifiers which can then perform multi-class classification through voting. The next parameter allows you to choose the configuration.
    
* `classifierType` corresponds to either one of the three approaches to do multi-class classification. 
    * This parameter takes in a string input. 'ovr' corresponds to one-vs-rest approach. 'ovo' corresponds to one-vs-one approach. 'ecoc' corresponds to error-correcting-output-codes. This parameter dictates how many classifiers will be generated to perform classification and voting. Details regarding these three approaches are included in the [`SVM tutorial`](svm_tutorial.md) document.
    
* `codeBook` corresponds to the 2D-matrix that maps the classes to a binary string.
    * This parameter is only used for the error-correcting-output-code classifier. This should strictly be a 2D matrix consisting of 1 and -1, and the number of rows should correspond to the `nClasses`. 

* `kernelType` corresponds to the type of kernel to be used for classification: either 'poly' (polynomial kernel) or 'rbf' (radial basis function kernel)
    * More details regarding kernels are discussed in the [`tutorial`](svm_tutorial.md).

* `nDegree` corresponds to the degree of the polynomial kernel that the SVM uses. 
    *  The bare-bones SVM has a linear separator between two classes, which corresponds to degree 1. This parameter is ignored when the kernel type is 'rbf'. 
    

## Input and Output Ports

The SVM generator has four inputs and two outputs. These ports are vectors or 2D matrices where the number of rows/columns are defined by the parameters discussed earlier. Moreover, the number of classifiers (which is dictated by the `classifierType` and `nClasses` parameters) is also calculated to define the size of some of these ports.

First, here's the calculation for the number of classifiers, defined in the `SVMIO` class:

```
class SVMIO[T <: Data](params: SVMParams[T]) extends Bundle {
  ...

  // define the number of classifiers
  var nClassifiers = params.nClasses  // one vs rest default
  if (params.classifierType == "ovr") {
    if (params.nClasses == 2) nClassifiers = params.nClasses - 1
  } else if (params.classifierType == "ovo") {   // one vs one
    nClassifiers = (params.nClasses*(params.nClasses - 1))/2
  } else if (params.classifierType == "ecoc") {  // error correcting output code
    nClassifiers = params.codeBook.head.length // # columns = # classifiers
  }

  ...
}
```

Each of the classifier types will have different number of classifiers. Again, read the [`tutorial`](svm_tutorial.md) if you don't know what I am talking about.
* If the classifier is 'ovr' (one-vs-rest), then the number of classifiers is equal to the number of classes.

* If the classifier is 'ovo' (one-vs-one), then the number of classifiers is equal to the pairwise combinations of all the classes. In formula form: `n(n-1)/2`, where n is the number of classes.

* If the classifier is 'ecoc' (error-correcting-output-code), then the number of classifiers will depend on the number of columns of the code book. This code book should have been defined during offline training as should be passed as a parameter `codeBook`.

The generator has four input ports:

```
class SVMIO[T <: Data](params: SVMParams[T]) extends Bundle {
  val in = Flipped(ValidWithSync(Vec(params.nFeatures, params.protoData)))
  ...

  val supportVector = Input(Vec(params.nSupports, Vec(params.nFeatures, params.protoData)))
  val alphaVector = Input(Vec(nClassifiers, Vec(params.nSupports, params.protoData)))
  val intercept = Input(Vec(nClassifiers, params.protoData))

  ...
}
```

These four vectors/matrices allows us to perform the dot product for SVM classification. 

* The actual input vector `in` of size `nFeatures x 1`. This is the vector coming from the PCA block. Again, `nFeatures` doesn't necessarily correspond to the actual number of features in the system due to dimensionality reduction.

* The 2D array of `supportVector` of size `nSupports x nFeatures`. This is the namesake of the SVM algorithm. This should be gathered from offline training, generated by the [`Python file`](svm_reference.py)

* The 2D array of `alphaVector` of size `nClassifiers x nSupports`. This is essentially the weights of the support vectors.This is also acquired from offline training. 

* The `intercept` of size `nClassifiers x 1`. This is a vector that needs to be added after the dot products have been performed and the kernel (if ever) is applied. This is also determined from offline training.

Finally, the two (well, technically three) output ports of the generator:

```
class SVMIO[T <: Data](params: SVMParams[T]) extends Bundle {
  val out = ValidWithSync(UInt(1.W)) // TODO: update this with the actual data type!
  ...

  val rawVotes = Output(Vec(params.nClasses, params.protoData))
  val classVotes = Output(Vec(params.nClasses,UInt((log2Ceil(nClassifiers)+1).W)))
}
```

* The `out` port is a reserved port mainly used for synchronization (if ever the SVM generator would support pipelining/sequential support). Currently, the actual port is set permanently to 0. One thing that this port can map to is the final vote of the SVM on which class a new data point belongs to. However, determining the final class is a little tricky to do in hardware, so it is not yet implemented.

* The `rawVotes` is a `nClasses x 1` vector that maps to the summed computed values of the decision function after all the dot products. This is the raw value which can actually be used by the processor to determine the final class of the data point (whichever class has the highest positive vote)

* The `classVotes` is also a `nClasses x 1` vector but contains the binarized votes per class. For example, in a 2-class classification, if a decision function has a raw value of +23, then it will vote for class 1 since it is positive. `classVotes` will contain (0,1) (class 1 resides in index 1), while `rawVotes` will contain (0,23).


## Version 1

For the first version, the SVM classifier only performs binary classification (2-class system) and uses a linear kernel. This is the simplest one since the computation ends up to be a simple dot product of the alpha vector (1 x s), the support vectors (s x p), and the input vector (p x 1), plus the intercept. This gives a 1x1 numerical answer that can be positive or negative, which then determines the class where the datapoint corresponding to the input vector belongs to.

## Version 2

For the second version, the classifier will be improved with configurable kernel support. There are two variants of kernels that will be implemented for this project: a polynomial kernel and the radial basis function (RBF) kernel). The linear kernel that was implemented in version 1 is the simplest case of the polynomial kernel. The polynomial kernel raises the dot product of the support vector 2D array and the input vector to some degree (that is also parameterizable). On the other hand, the RBF kernel models the dot product as a Gaussian distribution instead (performing e^-((support - input)^2)). The RBF is actually tricky to implement due to the exponential. So in this implementation, only the exponent is being computed.

## Version 3

The final upgrade for this classifier is to support multi-class classification. SVM on its own is a binary classifier, but by implementing several parallel classifiers, multiple classes can be determined. There are three 'common' approaches to support multi-class classification, as discussed in this link: http://scikit-learn.org/stable/modules/multiclass.html. Here's a brief summary of the classification methods that will be implemented for this project.

One vs all: Say we have 3 classes: a, b, c: We create 3 classifiers. The first classifier classifies a vs (b,c). The second classifies b vs (a,c), and so on. Each of the classifier then votes for the correct classification.

One vs one: Using the same 3 classes, we create a classifier for every pairwise combination of the classes, n(n-1)/2, where n is the number of classes. Then we have voting happening here as well. They say that this is better than one vs all.

Error-correcting output codes: In this approach, each class will be assigned its own unique binary assignment (the number of bits will vary depending on the user). Each bit in this binary assignment will correspond to a classifier. If the number of bits exceed the number of classes, we can be more robust to errors. For more information, check this out: http://scikit-learn.org/stable/modules/generated/sklearn.multiclass.OutputCodeClassifier.html

There’s also a Youtube video that discusses these approaches:
https://www.youtube.com/watch?v=6kzvrq-MIO0
