import csv
import math
import pylab as pl
import numpy as np
from scipy.signal import remez
from scipy.signal import freqz

fs = 500
# toy data to check filter
# t = pl.arange(0, 1, 1.0/fs)
# s = 4*np.sin(2*np.pi*20*t)+np.sin(2*np.pi*100*t)

pair_num = 1
channel_num = (1,2,3)

# number of filter taps, use even numbers for now
numtaps = 32

# window size for linelength and fft calculation
window = 500 # 1 second

# freqeuncy bands in Hz
delta_band = (0, 4)
theta_band = (4, 8)
alpha_band = (8, 16)
beta_band = (16, 32)
gamma_band = (32, 96)

# are we loading the data again? might take a while
load_data = 1

# are we printing out the matrices to a file?
print_data = 1

# how many points to keep for train/labels?
keep_points = 0

#########################################
# Loading the dataset from the CSV files
#########################################

if load_data == 1:
    # load the training dataset
    for i in range(len(channel_num)):
        temp = []
        with open('../data/channel%d_pairs/channel%d_pair%d.csv' 
                  %  (channel_num[i], channel_num[i], pair_num)) as csvfile:
            readCsv = csv.reader(csvfile, delimiter=',')
            for row in readCsv:
                temp.append(row)
        if i == 0:
            train = np.array(temp)
        else:
            train = np.concatenate((train,np.array(temp)),axis=1)
    train = train.astype(float)
    
    # load the labels
    labels = []
    with open('../data/labels/label%d.csv' % pair_num) as csvfile:
        readCsv = csv.reader(csvfile, delimiter=',')
        for row in readCsv:
            labels.append(row)
    
    labels = np.array(labels).T.astype(float)

#########################################
# Trimmiing/Balancing of dataset
#########################################

# Trim the data such that sum(labels == 1) ~= sum(labels == 0)
# It makes training fast and more efficient
train = train[-2*round(np.asscalar(sum(labels))):,:]
labels = labels[-2*round(np.asscalar(sum(labels))):,:]

if keep_points != 0:
    # Trim the data again since there's just too many points, take the center point
    midpoint = np.where(abs(np.diff(labels[:,0])) == 1)[0]
    
    train = train[math.floor(midpoint-keep_points/2):math.floor(midpoint+keep_points/2),:]
    labels = labels[math.floor(midpoint-keep_points/2):math.floor(midpoint+keep_points/2),:]
    
#########################################
# Printing the input data to a file
# OMG THIS IS SO LARGE
#########################################

if print_data == 1:
    f = open("generated_files/input_matrix.txt","w")
    for i in range(len(channel_num)):
        f.write("double input%d[] = {" % i)
        if len(train[:,i]) >= 1000:
            for j in range(math.floor(len(train[:,i]) / 1000)):
                array_container = repr(train[j*1000:((j+1)*1000)-1,i])
                array_container = array_container.replace('array','').replace('(','').replace(')','')
                array_container = array_container.replace('[','').replace(']',',')
                array_container = array_container.replace('. ','')
                f.write(array_container)
                f.write("\n        ")
        else: j = -1
        array_container = repr(train[(j+1)*1000:,i])
        array_container = array_container.replace('array','').replace('(','').replace(')','')
        array_container = array_container.replace('[','').replace(']','}')
        array_container = array_container.replace('. ','')
        f.write(array_container)
        f.write(";\n\n")
    f.close()
    
    f = open("generated_files/labels.txt","w")
    f.write("int labels[] = {")
    if len(labels[:,0]) >= 1000:
        for j in range(math.floor(len(labels[:,0]) / 1000)):
            array_container = repr(labels[j*1000:((j+1)*1000)-1,0])
            array_container = array_container.replace('array','').replace('(','').replace(')','')
            array_container = array_container.replace('[','').replace(']',',')
            array_container = array_container.replace('.,',',')
            f.write(array_container)
            f.write("\n        ")
    else: j = -1
    array_container = repr(labels[(j+1)*1000:,0])
    array_container = array_container.replace('array','').replace('(','').replace(')','')
    array_container = array_container.replace('[','').replace('.]','}')
    array_container = array_container.replace('.,',',')
    f.write(array_container)
    f.write(";\n\n")
    f.close()

#########################################
# Signal conditioning filter design
#########################################
    
# Set filter specs
lpf = remez(numtaps=numtaps, bands=[0, 150, 200, 250], desired=[1.0, 0.0], Hz=fs)
#lpf = remez(numtaps=numtaps, bands=[0, 50, 100, 150, 200, 250], desired=[0.0, 1.0, 0.0], Hz=fs) 

# Write out the filter tap coefficients to a file
if print_data == 1:
    f = open("generated_files/filter_taps.txt","w")
    f.write("taps = ")
    array_container = repr(lpf)
    array_container = array_container.replace('array','').replace('(','').replace(')','')
    array_container = array_container.replace('[','Seq(').replace(']',')')
    array_container = array_container.replace('.,',',').replace('.)',')')
    f.write(array_container)
    f.close()

# Plot filter frequency response if you want
# w, h = freqz(lpf)
# pl.plot(w/(2*np.pi)*fs, 20*np.log10(abs(h)))
# pl.show()

#########################################
# Raw data filtering (signal conditioning)
#########################################

# now perform filtering on the data
for i in range(len(channel_num)):
    if i == 0:
        temp = np.convolve(train[:,i],lpf,mode='valid')
        filtered = temp.reshape((len(temp),1))
    else:
        temp = np.convolve(train[:,i],lpf,mode='valid').reshape((len(temp),1))
        filtered = np.concatenate((filtered,temp),axis=1)


# this is the valid filtered signal taken from full convolution, use this for training
# valid_filtered = filtered[numtaps-1:-numtaps+1,:]

# this is the extended labels (0 padded), you will use this for label comparison after full convolve
# you use this for characterization
# extended_labels = np.concatenate((np.zeros((math.floor(numtaps/2),1)),
#                                  labels,
#                                  np.zeros((math.floor(numtaps/2)-1,1))))


# valid labels to match the 'valid' convolution
valid_labels = labels[math.floor(numtaps/2):-math.floor(numtaps/2)+1,0]

#########################################
# Feature calculations
#########################################

# Line length
def linelength(data,window):
    datalength = abs(np.diff(data,axis=0))
    
    for i in range(data.shape[1]):
        if i == 0:
            temp = np.convolve(datalength[:,i],np.ones(window,dtype=int),'valid')
            cumsum = temp.reshape((len(temp),1))
        else:
            temp = np.convolve(datalength[:,i],np.ones(window,dtype=int),'valid').reshape((len(temp),1))
            cumsum = np.concatenate((cumsum,temp),axis=1)
    
    return cumsum/window 

# Auxillary function to identify the index of the frequency bands (for bandpower)
def get_idx(freq,n_fft,fs):
    idxStartBin = round(freq[0] * n_fft / fs)
    idxEndBin = round(freq[1] * n_fft / fs)
    # check if power of 2
    if ((idxEndBin - idxStartBin) & ((idxEndBin - idxStartBin - 1)) == 0):
        return [idxStartBin, idxEndBin]
    else:
        print("Warning! difference between indices is not a power of 2")
        return [idxStartBin, idxEndBin]

def print_indices(f,freq_band,window,fs):
    idxStartBin, idxEndBin = get_idx(freq_band,window,fs)
    f.write("val idxStartBin = %d\n" % idxStartBin)
    f.write("val idxEndBin = %d\n" % idxEndBin)
    f.write("\n\n")
    
# Bandpower
def bandpower(data,window,freq_band,fs):

    bandpower = []
    # This is like an STFT, a sliding window of FFTs with overlap being window-1
    for i in range(data.shape[0]-window):
        fft_res = np.fft.fft(data[i:i+window,:],axis=0)

        p2 = np.abs(fft_res) ** 2
        m = int(window/2)
        p1 = p2[0:m+1,:]
        p1[1:m,:] = 2*p2[1:m,:]
        
        index = get_idx(freq_band,window,fs)        
        bandpower.append(np.sum(p1[index[0]:index[1],:],axis=0)/
                         ((index[1]-index[0])**2))
    
    return np.array(bandpower)

#########################################
# Form the X and y set for PCA and SVM processing
#########################################

# print bandpower indices to file
if print_data == 1:
    f = open("generated_files/bandpower_indices.txt","w")
    f.write("// Delta band\n")
    print_indices(f,delta_band,window,fs)
    f.write("// Theta band\n")
    print_indices(f,theta_band,window,fs)
    f.write("// Alpha band\n")
    print_indices(f,alpha_band,window,fs)
    f.write("// Beta band\n")
    print_indices(f,beta_band,window,fs)
    f.write("// Gamma band\n")
    print_indices(f,gamma_band,window,fs)
    f.close()

# all feature calculations must end up the same size
X = np.concatenate((linelength(filtered,window),
                    bandpower(filtered,window,delta_band,fs),
                    bandpower(filtered,window,theta_band,fs),
                    bandpower(filtered,window,alpha_band,fs),
                    bandpower(filtered,window,beta_band,fs),
                    bandpower(filtered,window,gamma_band,fs)),axis=1)

# size of labels should be consistent with X.shape[0]
y = valid_labels[window:]
