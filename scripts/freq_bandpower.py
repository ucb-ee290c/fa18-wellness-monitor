# Sampling freq of data
fs = 100 # Hz
# Num of FFT pts (bins)
n_fft = 64

# Note: freq resolution limited by fs / n_fft
# and max freq limited by fs / 2 (Nyquist)
# (technically not inclusive)

# Delta, Theta, Alpha, Beta bands
# [lower freq, upper freq]
bands = [[0, 3], [4, 7], [8, 15], [16, 31], [fs/n_fft, fs/2]]

def get_idx(freq):
  return round(freq * n_fft / fs)

idxs = [[get_idx(i) for i in j] for j in bands]

print(idxs)