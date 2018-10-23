# EE 290C Individual Repository

This repo will house work for your individual assignments.

# Dependencies updated

**This new version does not work with public releases.**

Some changes were needed for some dependencies.
Rather than make you build all of the dependencies, I've made a single jar you can download.
Download it from [here](https://goo.gl/qAAMTt) and put it in `fa18-XX/lib/`.

## CORDIC

Design and implement a flexible CORDIC generator in Chisel.

1) Support vectoring and rotation modes
2) Make widths for `X`, `Y`, and `Z` parameterized
3) Gain correction will be optionally supported (controlled by a parameter).
If gain correction is enabled, the output will be multiplied by the appropriate scaling factor.
Otherwise, the unscaled result will be passed directly to the output.
4) `Z` is modulo $2\pi$ with full range supported
5) The degree of unrolling should be set by a parameter.

### Parameters and IO
`Cordic.scala` defines some parameters objects, a `Bundle` to use as your IO, and an empty implementation of a FixedIterativeCordic (which you will need to implement).

### CordicApp
The template also includes an `App` (similar to a main function in Java) that can be used to run your generator.
It accepts commandline arguments.
To see the options, run
```
sbt "run --help"
```

### Tests
The template includes a simple test using `DspTester` and an associated ScalaTest specification.
You can run tests with
```
sbt test
```

## Synthesis for FPGA using Vivado

1. in config/use_vivado.json, change the last two entry to point to the correct files.  The
   setup_script is a shell script that sets up the vivado program (setup license server,
   source the vivado script, etc.), and the default file should work on BWRC server.  The
   constraint file maps FPGA IO to verilog net names, and set up voltage values.

2. after you generate the FixedIterativecordic.v verilog file, place it in this directory,
   then run the runhammer.sh script.  This will take that verilog file through the hammer
   flow and produce FPGA synthesis output (along with a post-synthesis verilog file for
   debugging).

## Rocket-chip Integration

The setup is similar to [project-template](https://github.com/ucb-bar/project-template).
Follow the instructions there for setup.
Run `make` in the `verisim` directory to build your simulator.
You don't need to set `CONFIG=...`; the default target should build with your CORDIC.
Run `make` in the `tests` directory to build your C code.

