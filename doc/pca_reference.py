import pandas as pd
import numpy as np
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

url = "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
# load dataset into Pandas DataFrame
df = pd.read_csv(url, names=['sepal length','sepal width','petal length','petal width','target'])
features = ['sepal length', 'sepal width', 'petal length', 'petal width']

# Separating out the features
x = df.loc[:, features].values

# Separating out the target
y = df.loc[:,['target']].values

# Standardizing the features, 0 mean, 1 std?
x = StandardScaler().fit_transform(x)

# pick the number of components to retain, top 3 in this case
pca = PCA(n_components=3)

# perform the transformation to the new dimension
# use this to verify that you got the correct dot product
principalComponents = pca.fit_transform(x)

# this gives you the weights per feature for the new transformed space
# principal components x number of features
# this is what will be provided for the system
# this is a p x f matrix:
# p = number of principal components you select (reduced dimension target)
# f = number of original features (the original dimension)
pca.components_

##############################################################
# mapping the new sample to the new set of dimensions is simply a dot product
# the only thing that you have to do in chisel?
# x is the data that needs to be projected, s x f matrix:
# s = number of samples to be projected
# f = number of original features
# s x f dot product with f x p, gives us s x p, the samples in the reduced dimension space
transformed = np.matmul(x,pca.components_.T)

# you can compare principalComponents and transformed,
# they should be approximately equal

