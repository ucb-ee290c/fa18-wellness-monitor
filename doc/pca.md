# PCA

The PCA block performs dimensionality reduction using Principal Component Analysis. This algorithm enables the transformation of the current feature space into a reduced dimension space that captures most of the variance in the original data. This is done through the process called eigendecomposition where the eigenvalues and their corresponding eigenvectors are extracted from an n x f matrix (where n is the number of samples, f is the number of original features) into three matrices. You can refer to the [`pca_reference.py`](pca_reference.py) file for the implementation of the whole PCA chain in Python.

For this project, the eigendecomposition procedure will be done offline (through some software such as MATLAB, Python), and only the translation from the original feature space to the reduced dimension space will be performed. This translation is achieved through a simple dot product: the input space is a 1 x f matrix and the transformation matrix is a f x p matrix, where p is the number of reduced dimensions (corresponding to the number of principal components selected). After performing the dot product, we end up with a 1 x p matrix, the input vector in the reduced dimension space, which will then be fed to the SVM classifier.

## Considerations for all-Online PCA
Based on our research, efficient algorithms to perform PCA and singular value decomposition (SVD) for an arbitrary floating-point m x n matrix are still under active research within the community. In [1], the authors developed an iterative algorithm for a 4x4 matrix based on Hemkumar's two-sided Jacobi algorithm. In [2], the authors improved iterative executions for a fixed-point design with a Hestenes preprocessor, Jacobi rotation, and cyclic ordering. Prior work such as the Brent-Luk-Van Loan systolic array for general n x n matrices is also promising for computing the SVD in real time.

It might also be possible to design a rocketchip-based "soft-core" capable of performing SVD decomposition. However, as the PCA eigendecomposition should be performed before training data with SVM and does not necessarily need to be computed in real-time, the tradeoff limitations in area and speed likely negate the benefit of having an on-chip PCA soft-core.

[1] Design and Prototype of Singular Value Decomposition Hardware in IEEE 802.11n MIMO Standards for Software Defined Radio [pdf link](https://pdfs.semanticscholar.org/a196/cd08786acd8c3d7da40ca87081f3807a4be9.pdf)

[2] An FPGA Implementation of the Hestenes-Jacobi Algorithm for Singular Value Decomposition (http://www.ece.lsu.edu/vaidy/raw14/link-files/Day2/Session5/Paper2_Day2_Session4.pdf)

