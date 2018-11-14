# FFT
This FFT generator is based on [ucb-art/fft](https://github.com/ucb-art/fft/tree/diplomacyPort2) (diplomacyPort2 branch). This FFT block is restricted to signal lengths of powers of 2, but that should be fine for our application (at least for now).

The parameters for the FFT block are set by `FFTConfig`. The parameters are `genIn`, `genOut`, `n`, `pipelineDepth`, `lanes`, and `quadrature`. `genIn` and `genOut` are the input and output types, `n` sets the number of points for the FFT, `pipelineDepth` sets the number of pipeline stages, and `lanes` sets the number of parallel input and output lanes.
