import numpy as np
import utils as utils

# frequency bands in Hz
delta_band = [0, 4]
theta_band = [4, 8]
alpha_band = [8, 16]
beta_band = [16, 32]
gamma_band = [32, 96]

# post computation normalization values
line_normalize = 2**3
band_normalize = 2**23

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

    return cumsum/(window*line_normalize) 

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
        
        bandpower.append(np.sum(p1[freq_band[0]:freq_band[1],:],axis=0)/
                         ((freq_band[1]-freq_band[0])**2))

    return np.array(bandpower)/(band_normalize)

def feature_extraction (features, filtered, valid_labels, fs, window):    
    # all feature calculations must end up the same size
    X = np.empty((len(valid_labels[window:]),0))
    for i in features:
        if i == 'linelength': X = np.concatenate((X,linelength(filtered,window)),axis=1)
        if i == 'delta': X = np.concatenate((X,bandpower(filtered,window,utils.get_idx(delta_band,window,fs),fs)),axis=1)
        if i == 'theta': X = np.concatenate((X,bandpower(filtered,window,utils.get_idx(theta_band,window,fs),fs)),axis=1)
        if i == 'alpha': X = np.concatenate((X,bandpower(filtered,window,utils.get_idx(alpha_band,window,fs),fs)),axis=1)
        if i == 'beta': X = np.concatenate((X,bandpower(filtered,window,utils.get_idx(beta_band,window,fs),fs)),axis=1)
        if i == 'gamma': X = np.concatenate((X,bandpower(filtered,window,utils.get_idx(gamma_band,window,fs),fs)),axis=1)
    
    # size of labels should be consistent with X.shape[0]
    y = valid_labels[window:]
    
    return X, y