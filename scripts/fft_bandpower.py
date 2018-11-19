import numpy as np

input_time_series = [17, 32, 23, 34, 45, 16, 17, 8, 1, 2, 3, 4, 5, 6, 7, 8]
n = len(input_time_series)

fft_res = np.fft.fft(input_time_series)

p2 = np.abs(fft_res)
m = int(n/2)
p1 = p2[0:m+1]
p1[1:m] = 2*p2[1:m]
bandpower = sum(i*i for i in p1)
print(bandpower)