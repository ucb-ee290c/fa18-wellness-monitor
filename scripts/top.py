import numpy as np

from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score
from sklearn.svm import SVC
from sklearn.multiclass import OneVsRestClassifier
from sklearn.multiclass import OutputCodeClassifier
from scipy.signal import remez

import features as fe
import utils as utils
import printers as pr
import svm as svm

import warnings

#########################################
# Setting of the parameters
#########################################

fs = 500

# number of filter taps, use even numbers for now
numtaps = 6

features = ['linelength','theta','alpha']
# are we loading the data again? might take a while
load_data = 1 # you can turn this off if the script has run once
balance = 1 # to equalize number of seizure and nonseizure events
# are we printing out the matrices to a file?
print_data = 1
# just print the accuracy, for test purposes
silence = 0

# should I do PCA or not?
do_pca = 1
# number of final features after dimensionality reduction
dimensions = 1 # 5 for degree 2, 6 for degree 1

# do we normalize the input?
normalize = 1

# set the kernel here: poly, rbf, linear is basically poly at degree 1
kernel = 'poly'
# these are for the polynomial kernel only
degree = 1
coef = 0
# how many classes?
classes = 2
# set the classifier type: ovr, ovo, ecoc
class_type = 'ovr'
# maximum number of iterations for SVM training
max_iter = 1e4

# what dataset to use? 'actual' or 'toy' data?
dataset = 'actual'
# actual dataset parameters, what pair in 151? how many channels?
train_pair_num = [2,3,4]
test_pair_num = [5]
channel_num = [1]

# good settings:
# train = [2,3,4], test = [5], degree = 1, dimensions = 6, features = 12
# train = [2,3,4], test = [5], degree = 2, dimensions = 5, features = 12
# train = [2,3,4], test = [5], degree = 1, dimensions = 1, features = 3, wow!

# test using the train data?
cheat_test = 0

#########################################
# Loading the dataset from the CSV files
#########################################
if silence == 0: print("Using actual dataset with %d classes" % classes)

if silence == 0: print("Loading training dataset")
if silence == 0: print("Dataset has %d pairs of seizure/nonseizure points, with %d channels" % (len(train_pair_num),len(channel_num)))
if load_data == 1: X_train_raw, y_train_raw = utils.load_dataset(train_pair_num,channel_num,balance)

if silence == 0: print("Loading test dataset")
if silence == 0: print("Dataset has %d pairs of seizure/nonseizure points, with %d channels" % (len(test_pair_num),len(channel_num)))
if load_data == 1: X_test_raw, y_test_raw = utils.load_dataset(test_pair_num,channel_num,balance)

#########################################
# Signal conditioning filter design
#########################################
if silence == 0: print("Designing filter with %d taps" % numtaps)
# Set filter specs
lpf = remez(numtaps=numtaps, bands=[0, 150, 200, 250], desired=[1.0, 0.0], Hz=fs)
#lpf = remez(numtaps=numtaps, bands=[0, 50, 100, 150, 200, 250], desired=[0.0, 1.0, 0.0], Hz=fs) 

#########################################
# Data filtering and Feature extraction
#########################################
if silence == 0: print("Passing the dataset through the filter")
filtered_train, valid_labels_train = utils.data_filtering(X_train_raw, y_train_raw, lpf)

if silence == 0: print("Calculating features...")
X_train, y_train = fe.feature_extraction(features,filtered_train,valid_labels_train,fs)

if cheat_test == 1:
    print("Setting test set = train set, you're cheating")
    X_test = X_train
    y_test = y_train
else: 
    filtered_test, valid_labels_test = utils.data_filtering(X_test_raw, y_test_raw, lpf)
    X_test, y_test = fe.feature_extraction(features,filtered_test,valid_labels_test,fs)

#########################################
# Normalization of the dataset
#########################################
if normalize == 1:
    if silence == 0: print("Normalizing training set")
    # we must transform the data to 0 mean and 1 std
    # for conventional machine learning algorithms to work
    params = StandardScaler().fit(X_train)
    X_train_mean = params.mean_
    X_train_var = params.var_
    
    # normalization is basically (x - mean) / std
    X_train = (X_train - X_train_mean)/np.sqrt(X_train_var)
    
    if silence == 0: print("Normalizing test set")
    # Before projecting the test set, it must also be normalized
    # However, it should be normalized using the training set data
    # This avoids future data leaking into the algorithm
    X_test = np.array(X_test)   # we're using numpy here
    X_test = (X_test - X_train_mean)/np.sqrt(X_train_var)

#########################################
# Perform PCA on the training set
#########################################
# pick the number of components to retain, top 3 in this case
pca = PCA(n_components=dimensions)
# perform the transformation to the new dimension
pca.fit(X_train)

if do_pca == 1:
    if silence == 0: print("Reducing dimensions from %d to %d through PCA" % (X_train.shape[1], dimensions))
    # mapping the new sample to the new set of dimensions is simply a dot product
    X_train = np.matmul(X_train,pca.components_.T)
    X_test = np.matmul(X_test,pca.components_.T)

#########################################
# Create a SVM Classifier
#########################################
# for more information, check out this link: http://scikit-learn.org/stable/modules/multiclass.html
if class_type == 'ovr':
    clf = OneVsRestClassifier(SVC(kernel=kernel, gamma=1, coef0=coef, degree=degree, max_iter=max_iter))
elif class_type == 'ovo':
    clf = SVC(kernel=kernel, gamma=1, coef0=coef, degree=degree, max_iter=max_iter) # SVC is ovo by default, contrary to documentation
elif class_type == 'ecoc':
    clf = OutputCodeClassifier(SVC(kernel=kernel, gamma=1, coef0=coef, degree=degree, max_iter=max_iter), random_state=109)

# remove convergence warning printouts from SVM training
if silence == 1: warnings.filterwarnings("ignore")

# Train the model using the training sets
if silence == 0: print("Training SVM using %s classification" % class_type)
clf.fit(X_train, y_train)

#########################################
# Generate the configuration matrix for the SVM
#########################################
# this will be used for manual classification
if silence == 0: print("Setting up the configuration matrices for SVM")
alpha_vector, supports, intercept, num_classifiers = svm.config_matrix(clf,class_type,classes)

########################################################################################
# Do classification to check the accuracy using the test set
########################################################################################

if silence == 0: print("Calculating SVM %s kernel and decision matrix" % kernel)
decision, vote = svm.get_decision(X_test, kernel, coef, degree, alpha_vector, supports, intercept, num_classifiers)

if silence == 0: print("Classifying test set...")
y_manual = svm.predict(X_test, clf, class_type, classes, num_classifiers, decision, vote)
    
#########################################
# Compare model accuracies (computed vs Python library output)
#########################################
# Using the sklearn library, we get obtain the actual prediction
y_pred = clf.predict(X_test)

print("Accuracy from predict function: %f" % accuracy_score(y_test, y_pred))
print("Accuracy from manual calculation: %f" % accuracy_score(y_test, y_manual))

#########################################
# Printing the input data to a file
#########################################
if print_data == 1:
    pr.generate_files(X_test_raw, y_test_raw, fs, 
                   normalize, X_train_mean, np.sqrt(X_train_var),
                   lpf,
                   do_pca, pca,
                   alpha_vector, supports, intercept,
                   class_type, clf)

