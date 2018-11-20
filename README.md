# EE 290C Wellness Monitor: ExG

[![Build Status](https://travis-ci.org/ucberkeley-ee290c/fa18-wellness-monitor.svg?branch=master)](https://travis-ci.org/ucberkeley-ee290c/fa18-wellness-monitor)

## Project Description
The ExG generators describe a tool box of important digital blocks for any arbitrary wellness monitor. The goal of this project is to develop a flow such that any designer could describe a wellness monitor by high level features (e.g. arythmia detection, EEG alpha wave monitoring, siezure detection, etc.) and the generator would build and connect the neccessary filters, FFT blocks, feature extractors, and learning mechanisms required to achieve the high level specification.

In the future we will add a tutorial on building an example wellness monitor.

## Team Members
Adelson Chua, Justin Doong, Ryan Kaveh, Cem Yalcin, and Rachel Zoll

## Generators
1) Filters: 
[FIR](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/firFilter.md), 
[IIR](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/iir.md)
2) FFT:
[FFT](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/fft.md)
[FFT Buffer](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/fftbuffer.md)
3) Feature Extractors: 
[Bandpower](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/bandpower.md),
[Line Length](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/linelength.md)
4) [PCA](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/pca.md)
5) [SVM](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/doc/svm.md)
6) [Memory Buffer](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/tree/master/doc)

## Tape-in 1
For tape-in 1, generators and unit tests were written for FIR and IIR filters, FFT, bandpower, and SVM. For integration, because testing functionality would have been very difficult with some incomplete blocks, RocketChip integration was confirmed using just the FIR filter block.

## Tape-in 2
Tape-in 2's primary goal was a more complete integration. Throughout the integration process, several supporting generators were written (Memory Buffer and FFT Buffer), additional feature generators were constructed (Line Length and a WIP Arythmia Detection), and the original blocks were updated to support various new tests and functions (FIR, IIR, FFT).

## How To Set Up and Test The Current Generators
Setting up the generators is straight forward because everything is self-contained. Simply clone the repo and explore the different generators in the [src](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/tree/master/src/main/scala) folder. Refer to the doc directory [doc](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/tree/master/doc) for documentation for each generator.

There are multiple ways to test each block and whole designs: unit-tests, SBT based integration tests, and C code tests that integrate the blocks with a RISC-V Rocket core. 

### Unit Tests
Each type-generic generator comes equipped with unit tests to randomnly excersize the blocks and compare their outputs against golden scala models (all of which are in the [test](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/tree/master/src/test/scala) directory). 

To run a specific unit test, open SBT and use the 'testOnly' function:

```
testOnly packageName.specName
```
for example:
```
testOnly firFilter.FIRFilterSpec
```

### Wellness Integration Tests
In order to test the entire flow, each block has been connected in an WIP [tester](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/blob/master/src/test/scala/WellnessIntegrationTester.scala). The current datapath involves: 

filters->LineLength->
                      | -> PCA -> SVM
FFT buffer->    FFT->

You can run it as part of the all encompassing SBT 'tests' or a similar testOnly as the unit tests:
```
testOnly wellness.WellnessIntegrationSpec
```

### Rocket Core Integration Tests
Currently there are two C code tests in the [c_sources](https://github.com/ucberkeley-ee290c/fa18-wellness-monitor/tree/master/c_sources) directory that both integrate FIR filters with rocket core. The first tests a single writer and reader to/from the 'wellness' block while the second tests multiple writers and single reader from the 'wellness' block. 
