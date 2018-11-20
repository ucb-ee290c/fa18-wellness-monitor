# SVM Classification Crash Course

## Foreword
This is a comprehensive tutorial on using Support Vector Machines for classification. This only includes the detailed computations required to perform inference. Details on training the SVM will not be covered (it is hard, it is very mathy, and it would have been better if an expert in machine learning discusses it). I have written this document as a future reference to someone else who is trying to understand how SVMs perform classification, down in the calculation level. Hope this helps!

## Overview
I will first cover the high-level concept of SVMs, what it does and how it classifies. Afterwards, we'll go into detail on how the classification is performed. I will also reference my [`SVM Python Code`](../scripts/svm_reference.py) which was written to perform classification by manually calculating stuff. This script utilizes the matrices acquired from the SVM training. The manipulation of these matrices to perform classification, instead of relying on the predefined Python libraries, is the main feature of this document. 

## High-level SVM Description

### SVM algorithm
The Support Vector Machine algorithm tries to create a dividing line (or in general, a hyperplane) between two classes. This separation allows classification by checking what part of the line the new point belongs to. The line that separates the two classes would be a function of a subset of points from the two classes. In 2-dimensional case, the linear combination of these points would define the slope and intercept of the separating line. Since the separating line depends on these points, the latter are called support vectors, which the namesake of this algorithm. 

![SVM highlevel](https://cdn-images-1.medium.com/max/1600/1*TudH6YvvH7-h5ZyF2dJV2w.jpeg)

### Kernel trick
The barebones SVM algorithm presented before would only create a separating line between two classes. However, for datasets that are not linearly separable, the algorithm will not arrive to a solution. To solve this problem, a kernel trick is used. A kernel is a transformation of the data projection into another dimension which enables the separating hyperplane to curve in 2D space. There is an [`excellent discussion in Quora`](https://www.quora.com/What-is-the-kernel-trick) regarding this.

![Kernel trick](https://blog-c7ff.kxcdn.com/blog/wp-content/uploads/2017/02/kernel.png)

There are a lot of possible kernels that can be used for SVMs. 

### Multi-class classification

## SVM Training

## SVM Classification

### Kernel calculation

### Decision function

### Voting


The SVM implementation for this project will be limited to classification only, since the algorithm for training the SVM is pretty complex to be implemented in custom hardware. Performing classification is done by calculating the following sum:

![SVM equation](http://chrisjmccormick.files.wordpress.com/2013/04/scoringfunction.png)




. Depending on the sign of the decision function, the answer can determine what class the new data point belongs to (say negative answers corresponding to class 0 and positive answers corresponding to class 1). The decision function is calculated 


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