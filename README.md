# EE 290C Wellness Monitor: ExG

[![Build Status](https://travis-ci.org/ucberkeley-ee290c/fa18-wellness-monitor.svg?branch=master)](https://travis-ci.org/ucberkeley-ee290c/fa18-wellness-monitor)

## Team Members
Adelson Chua, Justin Doong, Ryan Kaveh, Cem Yalcin, and Rachel Zoll

## Generators
1) Filters: 
[FIR](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/firFilter.md), 
[IIR](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/iir.md)
2) [FFT](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/fft.md)
3) Feature Extractors: 
[Bandpower](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/bandpower.md),
[Line Length](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/linelength.md)
4) [PCA](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/pca.md)
5) [SVM](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/svm.md)

## System Chain (Instance) 1
1) Bandpass filter (FIR)
2) FFT
3) Bandpower: alpha, beta
4) PCA
5) Classifier (SVM)

## Tape-in 1
For tape-in 1, generators and unit tests were written for FIR and IIR filters, FFT, bandpower, and SVM. For integration, because testing functionality would have been very difficult with some incomplete blocks, RocketChip integration was confirmed using just the FIR filter block.
