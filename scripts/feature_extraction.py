import csv
import math
import pylab as pl
import numpy as np
from scipy.signal import remez
from scipy.signal import freqz
from scipy.signal import stft

fs = 500
# toy data to check filter
# t = pl.arange(0, 1, 1.0/fs)
# s = 4*np.sin(2*np.pi*20*t)+np.sin(2*np.pi*100*t)

pair_num = 1
channel_num = (1,2,3)

# mode = valid, if the end points are not included (for better plots)
# mode = full, if the end points are included (for testing)
convolve_mode = 'full'

# number of filter taps, use even numbers for now
numtaps = 32

# window size for linelength and fft calculation
window = 500 # 1 second

# freqeuncy bands in Hz
delta_band = (0, 4)
theta_band = (4, 7)
alpha_band = (8, 12)
beta_band = (12, 30)
gamma_band = (30, 100)

load_data = 1

#########################################
# Loading the dataset from the CSV files
#########################################

if load_data == 1:
    # load the training dataset
    for i in range(len(channel_num)):
        temp = []
        with open('/Users/adelson.chua/fa18-wellness-monitor/data/channel%d_pairs/channel%d_pair%d.csv' 
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
    with open('/Users/adelson.chua/fa18-wellness-monitor/data/labels/label%d.csv' % pair_num) as csvfile:
        readCsv = csv.reader(csvfile, delimiter=',')
        for row in readCsv:
            labels.append(row)
    
    labels = np.array(labels).T.astype(float)

#########################################
# Balancing of dataset
#########################################

# Trim the data such that sum(labels == 1) ~= sum(labels == 0)
# It makes training fast and more efficient
train = train[-2*round(np.asscalar(sum(labels))):,:]
labels = labels[-2*round(np.asscalar(sum(labels))):,:]

#########################################
# Printing the input data to a file
# OMG THIS IS SO LARGE
#########################################

f = open("generated_files/input_matrix.txt","w")
for i in range(len(channel_num)):
    f.write("double input%d[] = {" % i)
    for j in range(math.floor(len(train[:,i]) / 1000)):
        array_container = repr(train[j*1000:((j+1)*1000)-1,i])
        array_container = array_container.replace('array','').replace('(','').replace(')','')
        array_container = array_container.replace('[','').replace(']',',')
        array_container = array_container.replace('. ','')
        f.write(array_container)
        f.write("\n        ")
    array_container = repr(train[(j+1)*1000:,i])
    array_container = array_container.replace('array','').replace('(','').replace(')','')
    array_container = array_container.replace('[','').replace(']','}')
    array_container = array_container.replace('. ','')
    f.write(array_container)
    f.write(";\n\n")
f.close()

f = open("generated_files/labels.txt","w")
f.write("int labels[] = {")
for j in range(math.floor(len(labels[:,0]) / 1000)):
    array_container = repr(labels[j*1000:((j+1)*1000)-1,0])
    array_container = array_container.replace('array','').replace('(','').replace(')','')
    array_container = array_container.replace('[','').replace(']',',')
    array_container = array_container.replace('.,',',')
    f.write(array_container)
    f.write("\n        ")
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
f = open("generated_files/filter_taps.txt","w")
f.write("taps = ")
array_container = repr(lpf)
array_container = array_container.replace('array','').replace('(','').replace(')','')
array_container = array_container.replace('[','Seq(').replace(']',')')
array_container = array_container.replace('.,',',').replace('.)',')')
f.write(array_container)
f.close()

# Plot filter frequency response
w, h = freqz(lpf)
pl.plot(w/(2*np.pi)*fs, 20*np.log10(abs(h)))
pl.show()

#########################################
# Raw data filtering (signal conditioning)
#########################################

# now perform filtering on the data
for i in range(len(channel_num)):
    if i == 0:
        temp = np.convolve(train[:,i],lpf,mode=convolve_mode)
        filtered = temp.reshape((len(temp),1))
    else:
        temp = np.convolve(train[:,i],lpf,mode=convolve_mode).reshape((len(temp),1))
        filtered = np.concatenate((filtered,temp),axis=1)

# this is the valid filtered signal, use this for training
valid_filtered = filtered[numtaps-1:-numtaps+1,:]

# valid labels to match
valid_labels = labels[math.floor(numtaps/2):-math.floor(numtaps/2)+1,0]

# this is the extended labels (0 padded), you will use this for label comparison after full convolve
# you use this for characterization
extended_labels = np.concatenate((np.zeros((math.floor(numtaps/2),1)),
                                  labels,
                                  np.zeros((math.floor(numtaps/2)-1,1))))
extended_filtered = filtered # just renaming for consistency

#########################################
# Feature calculations
#########################################

# Line length
def linelength(data,window):
    datalength = abs(np.diff(data,axis=0))
    
    for i in range(data.shape[1]):
        if i == 0:
            temp = np.convolve(datalength[:,i],np.ones(window,dtype=int),'full')
            cumsum = temp.reshape((len(temp),1))
        else:
            temp = np.convolve(datalength[:,i],np.ones(window,dtype=int),'full').reshape((len(temp),1))
            cumsum = np.concatenate((cumsum,temp),axis=1)
    
    # maintain the same size of data, throw away all the trailing answers
    return cumsum[:data.shape[0],:]/window 

# Bandpower, TODO: need a sliding window type thing
def bandpower(data,freq_band):
    fft_res = np.fft.rfft(data,axis=0)
    temp = np.abs(fft_res[freq_band[0]:freq_band[1]])
    # f,t,test = stft(filtered, fs=500, nperseg=500, noverlap=499, axis=0)
    return np.sum(temp**2,axis=0)

#########################################
# Form the X and y set for PCA and SVM processing
#########################################

# all feature calculations must end up the same size
X = np.concatenate((linelength(filtered,window),
                    bandpower(filtered,delta_band),
                    bandpower(filtered,theta_band),
                    bandpower(filtered,alpha_band),
                    bandpower(filtered,beta_band),
                    bandpower(filtered,gamma_band)),axis=1)

# size of labels should be consistent with X
y = labels
