% close all
% clear all
% clc

input_time_series = [0, 1, 2, 3, 4, 5, 6, 7];
n = length(input_time_series);

fft_res = fft(input_time_series);

p2 = abs(fft_res).^2;
p1 = p2(1:n/2+1);
p1(2:end-1) = 2 * p1(2:end-1);

bp_math = sum(p1 / n^2);
bp_ref = bandpower(input_time_series);