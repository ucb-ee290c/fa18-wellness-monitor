import math
import utils as utils
import features as fe
import os

def print_indices(f,freq_band,window,fs):
    idxStartBin, idxEndBin = utils.get_idx(freq_band,window,fs)
    f.write("val idxStartBin = %d\n" % idxStartBin)
    f.write("val idxEndBin = %d\n" % idxEndBin)
    f.write("\n\n")

def print_array_to_file(f,array_name,part,configs):
    array_container = repr(array_name)
    array_container = array_container.replace('array','').replace('(','').replace(')','')
    array_container = array_container.replace('. ','').replace('.,',',').replace('.]',']')
    if part == 'mid':
        array_container = array_container.replace('[','').replace(']',',')
    elif part == 'all':
        array_container = array_container.replace('[','{').replace(']','}')
    elif part == 'end':
        array_container = array_container.replace('[','').replace(']','}')
    elif part == 'scala':
        array_container = array_container.replace('[','Seq(').replace(']',')')
    elif part == 'intercept':
        array_container = array_container.replace('[[','{').replace(']]','}')
        
    f.write(array_container)
    if part == 'mid':   f.write("\n        ")
    else:
        if configs == 1: f.write("};\n\n")
        else:            f.write(";\n\n")

def print_matrices (f, name, matrix, configs):
    for i in range(matrix.shape[1]):
        if configs == 1:
            f.write("double %s[][] = {{" % name)
        else:
            f.write("double %s%d[] = {" % (name,i))
        if len(matrix[:,i]) >= 1000:
            for j in range(math.floor(len(matrix[:,i]) / 1000)):
                print_array_to_file(f,matrix[j*1000:((j+1)*1000)-1,i],'mid',configs)
        else: j = -1
        print_array_to_file(f,matrix[(j+1)*1000:,i],'end',configs)

def generate_files(X_test_raw, y_test_raw, fs, 
                   normalize, X_train_mean, X_train_var,
                   lpf,
                   do_pca, pca,
                   alpha_vector, supports, intercept,
                   class_type, clf):
    # print the input channel
    f = open("generated_files/input_matrix.txt","w")
    print_matrices(f,'input',X_test_raw, 0)
    f.close()
    
    # print the corresponding label for checking purposes, if you want
    f = open("generated_files/labels.txt","w")
    print_matrices(f,'labels',y_test_raw.reshape((len(y_test_raw),1)),0)
    f.close()
    
    # print bandpower indices to file
    f = open("generated_files/bandpower_indices.txt","w")
    f.write("// Delta band\n")
    print_indices(f,fe.delta_band,fe.window,fs)
    f.write("// Theta band\n")
    print_indices(f,fe.theta_band,fe.window,fs)
    f.write("// Alpha band\n")
    print_indices(f,fe.alpha_band,fe.window,fs)
    f.write("// Beta band\n")
    print_indices(f,fe.beta_band,fe.window,fs)
    f.write("// Gamma band\n")
    print_indices(f,fe.gamma_band,fe.window,fs)
    f.close()
    
    if normalize == 1:
        f = open("generated_files/normalization_factor.txt","w")
        f.write("mean = ")
        print_array_to_file(f,X_train_mean,'all',0)
        
        f.write("recip_var = ")
        print_array_to_file(f,1/X_train_var,'all',0)
        f.close()
    else:
        if os.path.exists("generated_files/normalization_factor.txt"):
            os.remove("generated_files/normalization_factor.txt")

    # Write out the filter tap coefficients to a file
    f = open("generated_files/filter_taps.txt","w")
    f.write("taps = ")
    print_array_to_file(f,lpf,'scala',0)
    f.close()

    f = open("generated_files/C_arrays.txt","w")
    
    if do_pca == 1:
        # the PCA transformation matrix
        f.write("double PCAComponents[][] = ")
        print_array_to_file(f,pca.components_,'all',0)
    
    # the support vector weights, the alpha vector
    print_matrices(f,'SVMAlphaVector',alpha_vector.T,1)
    
    # the actual support vectors
    print_matrices(f,'SVMSupportVector',supports,1)
    
    # the SVM intercept
    f.write("double SVMIntercept[] = ")
    print_array_to_file(f,intercept,'intercept',0)
    
    f.close()
    
    # the codebook for ECOC, to be passed as a Scala parameter
    if (class_type == "ecoc"):
        f = open("generated_files/Scala_codebook.txt","w")
        f.write("val codeBook = ")
        print_array_to_file(f,clf.code_book_,'scala',0)
        f.close()
    else:
        if os.path.exists("generated_files/Scala_codebook.txt"):
            os.remove("generated_files/Scala_codebook.txt")