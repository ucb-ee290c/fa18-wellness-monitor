import csv
import math
import numpy as np

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

def load_dataset(pair_num,channel_num,balance):
    # load the training dataset
    for j in range(len(pair_num)):
        for i in range(len(channel_num)):
            temp = []
            with open('../data/channel%d_pairs/channel%d_pair%d.csv' 
                      %  (channel_num[i], channel_num[i], pair_num[j])) as csvfile:
                readCsv = csv.reader(csvfile, delimiter=',')
                for row in readCsv:
                    temp.append(row)
            if i == 0:
                pairset = np.array(temp)
            else:
                pairset = np.concatenate((pairset,np.array(temp)),axis=1)
        pairset = pairset.astype(float)
        
        # load the labels
        pairlabel = []
        with open('../data/labels/label%d.csv' % pair_num[j]) as csvfile:
            readCsv = csv.reader(csvfile, delimiter=',')
            for row in readCsv:
                pairlabel.append(row)
        
        pairlabel = np.array(pairlabel).T.astype(float)
        
        # equalize the number of classes, assuming 000....0011111.... format
        if balance == 1:
            pairset = pairset[-2*round(np.asscalar(sum(pairlabel))):,:]
            pairlabel = pairlabel[-2*round(np.asscalar(sum(pairlabel))):,:]
    
        if j == 0:
            X = pairset
            y = pairlabel
        else:
            X = np.concatenate((X,pairset),axis=0)
            y = np.concatenate((y,pairlabel),axis=0)
                
    return X, y
   
def data_filtering (X, y, lpf):
    # now perform filtering on the data
    for i in range(X.shape[1]):
        if i == 0:
            temp = np.convolve(X[:,i],lpf,mode='valid')
            filtered = temp.reshape((len(temp),1))
        else:
            temp = np.convolve(X[:,i],lpf,mode='valid').reshape((len(temp),1))
            filtered = np.concatenate((filtered,temp),axis=1)    
    
    lendiff = len(y) - filtered.shape[0] + 1
    # valid labels to match the 'valid' convolution
    valid_labels = y[math.floor(lendiff/2):-math.floor(lendiff/2)+1,0]
    
    return filtered, valid_labels