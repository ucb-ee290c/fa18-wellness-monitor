# SVM Classification Crash Course

## Foreword
This is a comprehensive tutorial on using Support Vector Machines for classification. This only includes the detailed computations required to perform inference. Details on training the SVM will not be covered (it is hard, it is very mathy, and it would have been better if an expert in machine learning discusses it). I have written this document as a future reference to someone else who is trying to understand how SVMs perform classification, down in the calculation level. Hope this helps!

## Overview
I will first cover the high-level concept of SVMs, what it does and how it classifies. Afterwards, we'll go into detail on how the classification is performed. I will also reference my [`SVM Python Code`](../scripts/svm_reference.py) which was written to perform classification by manually calculating stuff. This script utilizes the matrices acquired from the SVM training. The manipulation of these matrices to perform classification, instead of relying on the predefined Python libraries, is the main feature of this document. 

## High-level SVM Description

This section covers three things: a high-level description of what SVM does, the kernel trick which enables classification on non-linearly-separable data, and the extension of this binary algorithm for multi-class classification.

### SVM algorithm
The Support Vector Machine algorithm tries to create a dividing line (or in general, a hyperplane) between two classes. This separation allows classification by checking what part of the line the new point belongs to. The line that separates the two classes would be a function of a subset of points from the two classes. In 2-dimensional case, the linear combination of these points would define the slope and intercept of the separating line. Since the separating line depends on these points, the latter are called support vectors, which the namesake of this algorithm. 

![SVM highlevel](https://cdn-images-1.medium.com/max/1600/1*TudH6YvvH7-h5ZyF2dJV2w.jpeg)

### Kernel trick
The barebones SVM algorithm presented before would only create a separating line between two classes. However, for datasets that are not linearly separable, the algorithm will not arrive to a solution. To solve this problem, a kernel trick is used. A kernel is a transformation of the data projection into another dimension which enables the separating hyperplane to curve in the lower dimensional space. There is an [`excellent discussion in Quora`](https://www.quora.com/What-is-the-kernel-trick) regarding this. Instead of transforming the data into a higher dimensional domain, the transformation will be done on the dot products instead (more information regarding the dot product is presented later in this document).

![Kernel trick](https://blog-c7ff.kxcdn.com/blog/wp-content/uploads/2017/02/kernel.png)

 
There are a lot of possible kernels that can be used for SVMs. The most common ones are the polynomial and the radial basis function (RBF). The math for these two kernel functions will be shown later in this document.

### Multi-class classification

SVM is a binary classifier. Although there is a way to convert the original SVM algorithm from a binary classifier to a multi-class classifier, the math is pretty hard to understand (at least for me). However, there are other tricks to enable multi-class classification, specifically by instantiating multiple binary classifiers and then performing some kind of voting.

There are three general approaches for multi-class classification using multiple classifiers. This [`Youtube video`](https://www.youtube.com/watch?v=6kzvrq-MIO0) introduced me to those which allowed me to explore their implementations in Python, which is detailed in this [`link`](http://scikit-learn.org/stable/modules/multiclass.html). The three approaches are:

* **One vs Rest:** This fits one classifier per class (except for the two-class situation where only one classifier is created, the default SVM algorithm). For each classifier, one class is fitted against the other classes. The final class will be coming from the votes of each classifier.

* **One vs One:** This constructs one classifier per pair of classes. That is, the number of classifiers would be the pairwise combination of all classes in the system: _n(n-1)/2_, where n is the number of classes. As with One vs Rest, the final class is determined from the votes of each classifier.

* **Error-Correcting Output-Codes:** This is a rather different paradigm. Each class would be represented as a unique binary combination of classifiers. That is, each class is represented by a binary code, which is an array of 0s and 1s formed by the classifiers. This mapping of classes to classifiers are contained in a code book which should be indicated at training time. The number of classifiers, therefore, is dependent on the user. Since voting for the final class involves calculating how near the resulting binary code for the new data is to one of the class mappings, the more classifiers there is, the more robust the classification will be.

## SVM Training

### Training using the Python library

This section references the first half of my [`Python code`](../scripts/svm_reference.py). After dividing the dataset into training and test, the SVM algorithm is trained depending on the type of classification to use (refer to the previous section). This uses Python's SVC function defined in `sklearn` library.

```
if class_type == 'ovr': # One vs Rest classification
    clf = OneVsRestClassifier(SVC(kernel=kernel, gamma=1, coef0=coef, degree=degree))
    
elif class_type == 'ovo': # One vs One classification
    clf = SVC(kernel=kernel, gamma=1, coef0=coef, degree=degree)
    
elif class_type == 'ecoc': # Error-Correcting Output-Codes classification
    clf = OutputCodeClassifier(SVC(kernel=kernel, gamma=1, coef0=coef, degree=degree))
    
# Train the model using the training sets
clf.fit(X_train, y_train)
```

### Extraction of matrices

After training, we will need to extract the vectors and matrices that was generated. The important matrices that will be needed for manual computation for classification are the following:

* The support vector 2D matrix: The number of support vectors are determined through training. Since each support vector is an actual training datapoint, it is mapped to the feature space. This forms the 2D matrix of size `nSupports x nFeatures`. 

* The alpha vector: Each support vector has a corresponding weight on how they dictate the resulting equation of the separating hyperplane. These weights can be positive or negative depending on what class the corresponding support vector is mapped to originally (+ for class 1, - for class 0). If this is a multi-class classification, there will be a separate set of weights for the other classifiers. This forms the 2D matrix of size `nClassifiers x nSupports`. 

* The intercept vector: After multiplying the support vectors with its weights, there will be a bias term that needs to be added so shift the separating hyperplane away from the origin. This is the intercept term. For multiple classifiers, there will be a separate intercept term for each. This forms a 1D matrix of size `nClassifiers x 1`. 

The extraction of these matrices are different depending on what type of classification is being performed. The actual challenge is to form these matrices in a consistent fashion so that the calculation of the decision function will be consistent no matter the type of classifier (calculation of the decision function will be discussed in the next section). The specific steps in extracting these matrices are presented below (only relevant code segments are indicated, check the full code [`here`](../scripts/svm_reference.py)):

#### One vs Rest matrix extraction

The `OneVsRestClassifier()` wrapper in Python creates different classifiers (called estimators) corresponding to the number of classes. More information can be seen [`here'](https://scikit-learn.org/stable/modules/generated/sklearn.multiclass.OneVsRestClassifier.html#sklearn.multiclass.OneVsRestClassifier). The intercept for each of these classifiers is easy to extract. However, the support vectors and the corresponding weights are contained in each of the estimators, which can be indexed. Therefore, creating a collection of support vectors and alphas would require iterating through all these estimators.

```
...
# get the intercept vector
intercept = clf.intercept_

# get initial values of support vectors and alpha, at index 0
alpha_vector[0,support_index[0]:support_index[1]] = clf.estimators_[0].dual_coef_
supports = clf.estimators_[0].support_vectors_

# create the alpha vector and support vector list by iterating through the estimators
for i in range(1,classes):
    alpha_vector[i,support_index[i]:support_index[i+1]] = clf.estimators_[i].dual_coef_
    supports = np.concatenate((supports,clf.estimators_[i].support_vectors_))
    
num_classifiers = classes
...

```

#### One vs One matrix extraction

The `SVC` function in Python performs One vs One classification by default. More information can be seen [`here`](https://scikit-learn.org/stable/modules/generated/sklearn.svm.SVC.html). Extracting the intercept, the support vectors, and its weights are trivial since those become part of the attributes...

```
...
alphas = clf.dual_coef_
supports = clf.support_vectors_
intercept = clf.intercept_
...
```

No, actually not, specifically the alpha (weight) vector. According to this [`documentation`](https://scikit-learn.org/stable/modules/svm.html), the `dual_coef_` attribute arranges the weights in some specified format that saves space (shown below), but complicates computation due to additional processing involved. Rearranging these is rather tedious. 

![alpha_vectors](images/alphavectors.png)

The first step is to identify the support vector indices, through the `n_support_` attribute, to serve as a guide on how to trim the `dual_coef_` array to correspond with their support vectors. 

```
...
# create the indices for the alpha vector expansion
support_index = np.concatenate(([0],np.cumsum(clf.n_support_)))
...
```

Next is the cool part, we generate an array of the pairwise combinations of classes. You can see this relevance by looking at the pattern shown in the table earlier. These pairwise combinations will be used to mask the `dual_coef_` attribute and extract the alpha vector for each support vector per classifier. **I have never found something like this in the internet**, since all of them just wants to use the built-in `predict` function for classification. But since we want to do the classification manually, this is something that has to be done to make the matrix interpretable and easy to use. 

```
...
# generate the combination maps for the alphas
combo_map = np.zeros((classes,classes-1,2))
for i in range(classes):
    for j in range(i+1,classes):
        # i and j contains the combination
        combo_map[i,j-1] = [i,j]
        combo_map[j,i] = [i,j]

# generate the mask to extract the corresponding alpha array, per combination
# read the sklearn SVC documentation for more details on how the alphas are arranged
# http://scikit-learn.org/stable/modules/svm.html#svm-classification
class_pairs = np.array(list(it.combinations(list(range(classes)),2)))
alpha_vector = np.zeros((len(class_pairs),len(alphas[0])))
...

```

I won't specifically go into details regarding this nested loop, it might require some drawing to describe the algorithm of remapping stuff. If you're interested, understand the original mapping of `dual_coef_` then try walking through this code. Write it out on a piece of paper, look for the pattern!

```
...
for x in range(len(class_pairs)):
    mask_map = np.zeros((classes,classes-1))
    for i in range(classes):
        for j in range(classes-1):
            mask_map[i,j] = (combo_map[i,j] == class_pairs[x]).all()
            if(mask_map[i,j]):
                alpha_vector[x,support_index[i]:support_index[i+1]] = alphas[j, support_index[i]:support_index[i+1]]

num_classifiers = len(class_pairs) # also classes * (classes - 1) /2
...

```

#### Error-Correcting Output-Codes matrix extraction

The `OutputCodeClassifier()` wrapper in Python creates different classifiers based on a code book which maps the classes as a binary combination of classifiers. More information can be seen [`here`](https://scikit-learn.org/stable/modules/generated/sklearn.multiclass.OutputCodeClassifier.html). Since this is a wrapper to the SVC function, extraction of the matrices would be similar to the One vs Rest Classifier. The only difference is that the vector of intercepts for every classifier is not easily accessible as an attribute. Therefore, we must iterate through all the estimators and create the matrices (all three of them).

```
...
# get initial values of support vectors, alpha and intercept, at index 0
alpha_vector[0,support_index[0]:support_index[1]] = clf.estimators_[0].dual_coef_
supports = clf.estimators_[0].support_vectors_
intercept = clf.estimators_[0].intercept_

# create the alpha vector, support vector and intercept list by iterating through the estimators
for i in range(1,num_classifiers): 
    alpha_vector[i,support_index[i]:support_index[i+1]] = clf.estimators_[i].dual_coef_
    supports = np.concatenate((supports,clf.estimators_[i].support_vectors_))
    intercept = np.concatenate((intercept,clf.estimators_[i].intercept_))
...
```

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