import sklearn as sk
from sklearn import datasets
from sklearn.model_selection import train_test_split
from sklearn import svm
import numpy as np
import pandas as pd  
import itertools as it

# pick a dataset to represent the classes: 2 or 3
classes = 3

# set the kernel here: poly, rbf
kernel = 'poly'

# these are for the polynomial kernel only
degree = 1
coef = 0

#########################################
# Perform training
#########################################

if classes == 2:
    #Load dataset
    cancer = datasets.load_breast_cancer()
    # Split dataset into training set and test set
    X_train, X_test, y_train, y_test = train_test_split(cancer.data, cancer.target, test_size=0.3,random_state=109) # 70% training and 30% test

elif classes == 3 or classes == 4:
    url = "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
    # Assign colum names to the dataset
    colnames = ['sepal-length', 'sepal-width', 'petal-length', 'petal-width', 'Class']
    # Read dataset to pandas dataframe
    irisdata = pd.read_csv(url, names=colnames)
    X = irisdata.drop('Class', axis=1)  
    y = irisdata['Class']
    y = np.array(pd.Categorical(pd.factorize(y)[0]))
    if classes == 4:
        y[120:129] = [3,3,3,3,3,3,3,3,3] # just messing around to check my algo
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.3, random_state=109) 
    
# Create a SVM Classifier
# This is a generic function, depending on the kernel, some params will be ignored
clf = svm.SVC(kernel=kernel, gamma=1, coef0=coef, degree=degree, decision_function_shape = 'ovo')

# Train the model using the training sets
clf.fit(X_train, y_train)

#########################################
# Now do the classification. 
# This is the preprocessing step so that you just feed data to the generator
#########################################

# Using the sklearn library, for double check
y_pred = clf.predict(X_test)

# you want to generate this before making the decision
decision1 = clf.decision_function(X_test)

#########################################
# Alternatively, do it manually
# Extract the parameters from the offline training 
alphas = np.array(clf.dual_coef_)
supports = np.array(clf.support_vectors_)
intercept = clf.intercept_
X_test = np.array(X_test).T
n_supports = clf.n_support_
support_index = np.concatenate(([0],np.cumsum(n_supports)))

# generate the combination maps for the alphas
combo_map = np.zeros((classes,classes-1,2))
for i in range(classes):
    for j in range(i+1,classes):
        # i and j contains the combination
        combo_map[i,j-1] = [i,j]
        combo_map[j,i] = [i,j]

# generate the mask to extract the corresponding alpha array, per combination
class_pairs = np.array(list(it.combinations(list(range(classes)),2)))
alpha_vector = np.zeros((len(class_pairs),len(alphas[0])))

for x in range(len(class_pairs)):
    mask_map = np.zeros((classes,classes-1))
    for i in range(classes):
        for j in range(classes-1):
            mask_map[i,j] = (combo_map[i,j] == class_pairs[x]).all()
            if(mask_map[i,j]):
                alpha_vector[x,support_index[i]:support_index[i+1]] = alphas[j,support_index[i]:support_index[i+1]]

# Here's what will be passed to the generator
# supports = the support vectors s x f, s=number of vectors, f=features
# intercept = the training intercept 1 x c, c=number of classifiers to create
# alpha_vector = the support vector weights c x f






############################################
# This is the part that will be implemented in Chisel
                
# This is where the kernel goes
# Select the corresponding kernel calculation
if kernel == 'poly':
    # polynomial kernel, varying degrees
    # if you want linear, set coef = 0, degree = 1
    kernel_dotproduct = np.power((coef + np.matmul(supports,X_test)),degree) 

elif kernel == 'rbf': # this is so tricky!
    # rbf kernel
    kernel_dotproduct = np.zeros((len(supports),len(X_test.T)))
    for i in range(len(supports)): # loop for all support vectors
        for j in range(len(X_test.T)): # loop for all test data samples
            kernel_dotproduct[i,j] = np.exp(-sum((supports[i] - X_test.T[j]) ** 2))

# kernel_dotproduct will be computed given the test set and support vectors
decision2 = np.matmul(alpha_vector,kernel_dotproduct) 
decision2 = decision2 + np.matmul(intercept.reshape((len(class_pairs),1)),np.ones((1,len(X_test[0]))))
decision2 = decision2.T

# set votes to 0 or 1
vote = decision2 > 0
# change boolean to int, then convert as list
vote = np.ndarray.tolist(vote.astype(int))
# initialize container of final predicted classes
y_manual = np.zeros((len(vote),1))
# write the different combinations of classes (taken 2 at a time)

# create the votes from the values of the decision function (vote)
for i in range(len(vote)):
    for j in range(len(vote[0])):
        if classes > 2:     # this is weird, kindly check
            vote[i][j] = class_pairs[j][1-vote[i][j]]
        else:
            vote[i][j] = class_pairs[j][vote[i][j]]
        # I did 1-x since 1 must correspond to the first of the pair
        # this is just index manipulation, 0 -> 1, 1 -> 0
        
    # find the max votes, that will be the final class
    y_manual[i] = max(set(vote[i]), key=vote[i].count)
    
'''
# Do the dot product with alphas, get the sign, that's your prediction
# This works for 2 class systems
decision2 = (np.matmul(alphas,kernel_dotproduct) + intercept)[0]
y_manual = decision2 > 0
'''

#########################################
# Model Accuracy: how often is the classifier correct?
#########################################

print("Accuracy fun:",sk.metrics.accuracy_score(y_test, y_pred))
print("Accuracy man:",sk.metrics.accuracy_score(y_test, y_manual))