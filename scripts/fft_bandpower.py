import numpy as np

input_time_series = [0, 1, 2, 3, 4, 5, 6, 7]
n = len(input_time_series)

fft_res = np.fft.fft(input_time_series)
print(fft_res)

p2 = np.abs(fft_res) ** 2
m = int(n/2)
p1 = p2[0:m+1]
p1[1:m] = 2*p2[1:m]
bandpower = sum(i/n**2 for i in p1)
print(bandpower)