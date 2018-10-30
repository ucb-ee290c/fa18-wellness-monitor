# Memory Buffer

The memory buffer block acts as a container of the arrays and vectors needed by the SVM and PCA blocks. Dynamically allocating a segment of the RISC-V memory to contain these arrays is hard in the interfacing standpoint since the number of support vectors and principal components can change during the generation process, which will then require some remapping of the addresses for other blocks if ever. This block is basically a serial to array converter. It takes in an input and shifts it through the array creating an nRows x nColumns matrix which can then be used as an input by the SVM (support vectors, alpha vector, intercept vector) and PCA blocks (principal component array).

