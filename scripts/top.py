import numpy as np
import matplotlib.pyplot as plt

from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score
from sklearn.svm import SVC
from sklearn.multiclass import OneVsRestClassifier
from sklearn.multiclass import OutputCodeClassifier
from scipy.signal import remez

import features as fe
import utils as utils
import svm as svm

import warnings

#########################################
# Setting of the parameters
#########################################

# what is the sampling rate of the dataset?
fs = 500

# window size for linelength and fft calculation
window = 512 # 1 second

# number of filter taps, use even numbers for now
numtaps = 6
# low pass filter, allow 0-150 Hz, roll-off starting 150, minimum at 200-250 Hz
cutoff = [0, 150, 200, 250]

# what features to calculate? check features.py for all possible list
features = ['theta','alpha','linelength']

# are we loading the data again? might take a while
load_data = 1 # you can turn this off if the script has run once
balance = 1 # to equalize number of seizure and nonseizure events
# are we printing out the matrices to a file?
print_data = 1
# are we plotting the results?
plot_data = 1

# you want the script to be verbose or not?
silence = 0

# should I do PCA or not?
do_pca = 1
# number of final features after dimensionality reduction
dimensions = 1

# do we normalize the training and test data set?
normalize = 1 # almost always that we have to normalize for proper training

# set the kernel here: poly, rbf, linear is basically poly at degree 1
kernel = 'poly'
# these are for the polynomial kernel only
degree = 1
coef = 0
# how many classes?
classes = 2
# set the classifier type: ovr, ovo, ecoc
class_type = 'ovo'
# maximum number of iterations for SVM training
max_iter = 1e4
# penalty term, higher = lesser number of support vectors = lesser accuracy
penalty = 1

# what dataset to use? 'actual' or 'toy' data?
dataset = 'actual'
# actual dataset parameters, what pair in 151? how many channels?
train_pair_num = [3]
test_pair_num = [4,5,6]
channel_num = [1]

# handcrafted test set?
cheat_test = 1
# number of handcrafted test set
n_handcraft = 50
# number of support vectors to retain
size_limit = 10

np.random.seed(1) # for reproducibility of results

#########################################
# Loading the dataset from the CSV files
#########################################
if silence == 0: print("Using actual dataset with %d classes" % classes)

if silence == 0: print("Loading training dataset")
if silence == 0: print("Dataset has %d pair(s) of seizure/nonseizure points, with %d channel(s)" % (len(train_pair_num),len(channel_num)))
if load_data == 1: X_train_raw, y_train_raw = utils.load_dataset(train_pair_num,channel_num,balance)

if silence == 0: print("Loading test dataset")
if silence == 0: print("Dataset has %d pair(s) of seizure/nonseizure points, with %d channel(s)" % (len(test_pair_num),len(channel_num)))
if load_data == 1: X_test_raw, y_test_raw = utils.load_dataset(test_pair_num,channel_num,balance)
    
#########################################
# Signal conditioning filter design
#########################################
if silence == 0: print("Designing filter with %d taps" % numtaps)
# Set filter specs
lpf = remez(numtaps=numtaps, bands=cutoff, desired=[1.0, 0.0], Hz=fs)

#########################################
# Data filtering and Feature extraction for Training data
#########################################
if silence == 0: print("Passing the dataset through the filter")
filtered_train, valid_labels_train = utils.data_filtering(X_train_raw, y_train_raw, lpf)

if silence == 0: print("Calculating features...")
if silence == 0: print(features)
X_train, y_train = fe.feature_extraction(features,filtered_train,valid_labels_train,fs,window)

#########################################
# Overrides for handcrafted test data, for demo
#########################################
if cheat_test == 1:
    print("Handcrafting test set, for demonstration. You're cheating")
    np.random.seed(1) # for reproducibility of results
    X_test_raw = np.concatenate((np.random.random(n_handcraft)*3-3,np.random.random(n_handcraft)*500-500))
    X_test_raw = X_test_raw.reshape((len(X_test_raw),1))
    y_test_raw = np.concatenate((np.zeros((n_handcraft,1)),np.ones((n_handcraft,1))))
    print("Overriding window size and sampling frequency")
    window = 32
    fs = 32

#########################################
# Data filtering and Feature extraction for Test data
#########################################
filtered_test, valid_labels_test = utils.data_filtering(X_test_raw, y_test_raw, lpf)
X_test, y_test = fe.feature_extraction(features,filtered_test,valid_labels_test,fs,window)

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
    clf = OneVsRestClassifier(SVC(kernel=kernel, gamma=1, coef0=coef, degree=degree, 
                                  max_iter=max_iter, C=penalty, random_state =109))
elif class_type == 'ovo':
    clf = SVC(kernel=kernel, gamma=1, coef0=coef, degree=degree, 
              max_iter=max_iter, C=penalty, random_state =109) # SVC is ovo by default, contrary to documentation
elif class_type == 'ecoc':
    clf = OutputCodeClassifier(SVC(kernel=kernel, gamma=1, coef0=coef, degree=degree, 
                                   max_iter=max_iter, C=penalty, random_state =109), random_state=109)

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

print("There are %d support vectors" % supports.shape[0])
#########################################
# Do classification to check the accuracy using the test set
#########################################
if silence == 0: print("Calculating SVM %s kernel and decision matrix" % kernel)

if cheat_test:
    # for handcrafted data, reduce algorithm complexity by reducing the number of support vectors
    supports = supports[0:size_limit,:]
    alpha_vector = alpha_vector[:,0:size_limit]

decision, vote = svm.get_decision(X_test, kernel, coef, degree, alpha_vector, supports, intercept, num_classifiers)

if silence == 0: print("Classifying test set...")
y_manual = svm.predict(X_test, clf, class_type, classes, num_classifiers, decision, vote)
    
#########################################
# Compare model accuracies (computed vs Python library output)
#########################################
y_pred = clf.predict(X_test)

print("Accuracy from predict function: %f" % accuracy_score(y_test, y_pred))
print("Accuracy from manual calculation: %f" % accuracy_score(y_test, y_manual))

sensitivity = sum(sum((y_manual.T == y_test)&(y_test == 1)))/sum(y_test)
specificity = sum(sum((y_manual.T == y_test)&(y_test == 0)))/(len(y_test)-sum(y_test))
print("Sensitivity: %f" % sensitivity)
print("Specificity: %f" % specificity)

#########################################
# Plot the data, for presentation
#########################################
if (plot_data == 1) and (cheat_test) == 0:
    offset = window+numtaps-1
    start_offset = round(offset/2)+1
    end_offset = -round(offset/2)
    y_test_plot = y_test_raw[start_offset:end_offset]
    X_test_plot = X_test_raw[start_offset:end_offset,:]
    time = np.divide(np.array(range(len(y_test_plot))),fs)
    
    if silence == 0: print("Plotting data...")
    fig, ax1 = plt.subplots()
    ax1.plot(time,np.divide(X_test_plot,abs(y_test_plot-1)), 'b-', label='No Seizure')
    ax1.plot(time,np.divide(X_test_plot,y_test_plot), 'r-', label='Seizure')
    ax1.set_xlabel('Time (seconds)')
    ax1.set_ylabel('EEG raw value (uV)')
    ax1.tick_params('y')
    
    ax2 = ax1.twinx()
    ax2.plot(time,y_manual, 'g-')
    ax2.set_ylabel('Predicted label', color='g')
    ax2.tick_params('y', colors='g')
    plt.savefig("results/seizure_detection.png")
    plt.show()
    
    if silence == 0: print("Printing accuracy statistics to a file under results folder")
    text_file = open("results/accuracy_stats.txt","w")
    text_file.write("Sensitivity: %f\n" % sensitivity)
    text_file.write("Specificity: %f\n" % specificity)
    text_file.close()

#########################################
# Printing data to CSV files, to be read by Scala Tester
#########################################
if print_data == 1:
    
    if silence == 0: print("Printing all configuration parameters to files under generated_files folder")
    fmt = '%.10f' # 10 decimal places as float
    np.savetxt("generated_files/input.csv",X_test_raw.T,fmt=fmt,delimiter=',')
    np.savetxt("generated_files/labels.csv",y_test_raw.T,fmt='%d',delimiter=',')
    np.savetxt("generated_files/expected.csv",decision.T,fmt=fmt,delimiter=',')
    
    np.savetxt("generated_files/filter_taps.csv",lpf,fmt=fmt,delimiter=',')
    
    np.savetxt("generated_files/normalization_mean.csv",X_train_mean,fmt=fmt,delimiter=',')
    np.savetxt("generated_files/normalization_recipvar.csv",1/np.sqrt(X_train_var),fmt=fmt,delimiter=',')
    
    np.savetxt("generated_files/pca_vectors.csv",pca.components_,fmt=fmt,delimiter=',')
    np.savetxt("generated_files/support_vectors.csv",supports,fmt=fmt,delimiter=',')
    np.savetxt("generated_files/alpha_vectors.csv",alpha_vector,fmt=fmt,delimiter=',')
    np.savetxt("generated_files/intercepts.csv",intercept,fmt=fmt,delimiter=',')
    
    for i in features:
        if i == 'delta': np.savetxt("generated_files/delta_index.csv",utils.get_idx(fe.delta_band,window,fs),fmt='%d',delimiter=',')
        if i == 'theta': np.savetxt("generated_files/theta_index.csv",utils.get_idx(fe.theta_band,window,fs),fmt='%d',delimiter=',')
        if i == 'alpha': np.savetxt("generated_files/alpha_index.csv",utils.get_idx(fe.alpha_band,window,fs),fmt='%d',delimiter=',')
        if i == 'beta': np.savetxt("generated_files/beta_index.csv",utils.get_idx(fe.beta_band,window,fs),fmt='%d',delimiter=',')
        if i == 'gamma': np.savetxt("generated_files/gamma_index.csv",utils.get_idx(fe.gamma_band,window,fs),fmt='%d',delimiter=',')
    
    np.savetxt("generated_files/normalize_band.csv",[fe.band_normalize],fmt=fmt,delimiter=',')
    np.savetxt("generated_files/normalize_line.csv",[fe.line_normalize],fmt=fmt,delimiter=',')
    
    # list of all parameters used in this model, take note of the order, needs to be consistent for the Scala implementation
    np.savetxt("generated_files/parameters.csv",[window, # windowSize, lanes, nPts, nBins
                                                 pca.components_.shape[0],  # nFeatures
                                                 pca.components_.shape[1],  # nDimensions
                                                 supports.shape[0],    # nSupports
                                                 classes,   #nClasses
                                                 degree    #nDegree
                                                 ],fmt='%d',delimiter=',')
    
    np.savetxt("generated_files/feature_list.csv",features,fmt='%s',delimiter=',')
    
    if class_type == 'ecoc':
        np.savetxt("generated_files/codebook.csv",clf.code_book_,fmt=fmt,delimiter=',')