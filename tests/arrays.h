#ifndef __ARRAY_H__
#define __ARRAY_H__

#define DIMENSIONS 3         // number of channels going into the PCA
#define FEATURES 2           // number of reduced dimensions going into the SVM
#define SUPPORTS 2           // number of support vectors for SVM
#define CLASSES 2            // number of classes

#define CLASSIFIERS 1        // number of classifiers created

static int pcaVector[FEATURES][DIMENSIONS] = {{5,0,-2},{1,2,3}};
static int SVMSupportVector[SUPPORTS][FEATURES] = {{1,2},{3,4}};
static int SVMAlphaVector[CLASSIFIERS][SUPPORTS] = {{7,3}};
static int SVMIntercept[CLASSIFIERS] = {4};

#endif
