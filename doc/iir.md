# Infinite Impulse Response Filter Generator
This iir block takes in two sequences of coefficients and will generate a direct form II IIR block (a generic block diagram is shown below). The generator will extrapolate the number of taps from the length of the coefficient sequences. Lastly, the generator implements a valid signal to only allow new inputs when valid is high. This prevents the output from being unstable while applying new signals to the input (in between clock edges). 

![blockDiagram](iirFilterForm2.png)

Requirements and use notes are noted below:
1) Coefficients_B must be one element larger than Coefficients_A
2) Generate coefficient values in matlab (will eventually scala wrapper to calculate coefficients for you)
3) Plug coefficient values as sequences into params
4) To test this block, there is a golden scala implementation of an IIR block in the tests folder. Running SBT test will automatically run the proper tests. Keep in mind, with random coefficients, the IIR block will probable overflow and break.
