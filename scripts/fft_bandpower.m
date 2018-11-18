% close all
% clear all
% clc

input_time_series = [1, 2, 3, 4, 5, 6, 7, 8];
% input_time_series = [17, 32, 23, 34, 45, 16, 17, 8];
% input_time_series = [17, 32, 23, 34, 45, 16, 17, 8, 1, 2, 3, 4, 5, 6, 7, 8];
n = length(input_time_series);

fft_res = fft(input_time_series);

% p2 = abs(fft_res/n);
p2 = abs(fft_res);

p1 = p2(1:n/2+1);
p1(2:end-1) = 2 * p1(2:end-1);

bp_math1 = sum(p1.^2);
bp_ref = bandpower(input_time_series);