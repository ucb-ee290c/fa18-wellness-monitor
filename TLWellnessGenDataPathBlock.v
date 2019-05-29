module AXI4StreamToBundleBridge(
  output        auto_in_ready,
  input         auto_in_valid,
  input  [63:0] auto_in_bits_data,
  input         auto_in_bits_last,
  input         auto_out_ready,
  output        auto_out_valid,
  output [63:0] auto_out_bits_data,
  output        auto_out_bits_last
);
  assign auto_in_ready = auto_out_ready; // @[LazyModule.scala 173:31]
  assign auto_out_valid = auto_in_valid; // @[LazyModule.scala 173:49]
  assign auto_out_bits_data = auto_in_bits_data; // @[LazyModule.scala 173:49]
  assign auto_out_bits_last = auto_in_bits_last; // @[LazyModule.scala 173:49]
endmodule
module ConstantCoefficientFIRFilter(
  input         clock,
  input         reset,
  input         io_in_valid,
  input  [31:0] io_in_bits,
  output        io_out_valid,
  output [31:0] io_out_bits
);
  reg [31:0] regs_0; // @[FIRFilter.scala 39:21]
  reg [31:0] _RAND_0;
  reg [31:0] regs_1; // @[FIRFilter.scala 39:21]
  reg [31:0] _RAND_1;
  reg [31:0] regs_2; // @[FIRFilter.scala 39:21]
  reg [31:0] _RAND_2;
  reg [31:0] regs_3; // @[FIRFilter.scala 39:21]
  reg [31:0] _RAND_3;
  reg [31:0] regs_4; // @[FIRFilter.scala 39:21]
  reg [31:0] _RAND_4;
  reg [31:0] regs_5; // @[FIRFilter.scala 39:21]
  reg [31:0] _RAND_5;
  wire [43:0] accumulator_0; // @[FixedPointTypeClass.scala 43:59]
  wire [42:0] muls_1; // @[FixedPointTypeClass.scala 43:59]
  wire [46:0] muls_2; // @[FixedPointTypeClass.scala 43:59]
  wire [46:0] muls_3; // @[FixedPointTypeClass.scala 43:59]
  wire [42:0] muls_4; // @[FixedPointTypeClass.scala 43:59]
  wire [43:0] muls_5; // @[FixedPointTypeClass.scala 43:59]
  wire [43:0] _GEN_19; // @[FixedPointTypeClass.scala 21:58]
  wire [43:0] _T_8; // @[FixedPointTypeClass.scala 21:58]
  wire [43:0] accumulator_1; // @[FixedPointTypeClass.scala 21:58]
  wire [46:0] _GEN_20; // @[FixedPointTypeClass.scala 21:58]
  wire [46:0] _T_10; // @[FixedPointTypeClass.scala 21:58]
  wire [46:0] accumulator_2; // @[FixedPointTypeClass.scala 21:58]
  wire [46:0] _T_12; // @[FixedPointTypeClass.scala 21:58]
  wire [46:0] accumulator_3; // @[FixedPointTypeClass.scala 21:58]
  wire [46:0] _GEN_21; // @[FixedPointTypeClass.scala 21:58]
  wire [46:0] _T_14; // @[FixedPointTypeClass.scala 21:58]
  wire [46:0] accumulator_4; // @[FixedPointTypeClass.scala 21:58]
  wire [46:0] _GEN_22; // @[FixedPointTypeClass.scala 21:58]
  wire [46:0] _T_16; // @[FixedPointTypeClass.scala 21:58]
  wire [46:0] accumulator_5; // @[FixedPointTypeClass.scala 21:58]
  reg  _T_18; // @[Reg.scala 19:20]
  reg [31:0] _RAND_6;
  reg  _T_19; // @[Reg.scala 19:20]
  reg [31:0] _RAND_7;
  reg  _T_20; // @[Reg.scala 19:20]
  reg [31:0] _RAND_8;
  reg  _T_21; // @[Reg.scala 19:20]
  reg [31:0] _RAND_9;
  reg  _T_22; // @[Reg.scala 19:20]
  reg [31:0] _RAND_10;
  reg  _T_23; // @[Reg.scala 19:20]
  reg [31:0] _RAND_11;
  wire [32:0] _GEN_23; // @[FIRFilter.scala 67:15]
  wire [31:0] _GEN_24; // @[FIRFilter.scala 67:15]
  assign accumulator_0 = $signed(regs_0) * $signed(-32'sh7a9); // @[FixedPointTypeClass.scala 43:59]
  assign muls_1 = $signed(regs_1) * $signed(-32'sh3d4); // @[FixedPointTypeClass.scala 43:59]
  assign muls_2 = $signed(regs_2) * $signed(32'sh24b5); // @[FixedPointTypeClass.scala 43:59]
  assign muls_3 = $signed(regs_3) * $signed(32'sh24b5); // @[FixedPointTypeClass.scala 43:59]
  assign muls_4 = $signed(regs_4) * $signed(-32'sh3d4); // @[FixedPointTypeClass.scala 43:59]
  assign muls_5 = $signed(regs_5) * $signed(-32'sh7a9); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_19 = {{1{muls_1[42]}},muls_1}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_8 = $signed(_GEN_19) + $signed(accumulator_0); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_1 = $signed(_T_8); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_20 = {{3{accumulator_1[43]}},accumulator_1}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_10 = $signed(muls_2) + $signed(_GEN_20); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_2 = $signed(_T_10); // @[FixedPointTypeClass.scala 21:58]
  assign _T_12 = $signed(muls_3) + $signed(accumulator_2); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_3 = $signed(_T_12); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_21 = {{4{muls_4[42]}},muls_4}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_14 = $signed(_GEN_21) + $signed(accumulator_3); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_4 = $signed(_T_14); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_22 = {{3{muls_5[43]}},muls_5}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_16 = $signed(_GEN_22) + $signed(accumulator_4); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_5 = $signed(_T_16); // @[FixedPointTypeClass.scala 21:58]
  assign io_out_valid = _T_23 & io_in_valid; // @[FIRFilter.scala 68:16]
  assign _GEN_23 = accumulator_5[46:14]; // @[FIRFilter.scala 67:15]
  assign _GEN_24 = _GEN_23[31:0]; // @[FIRFilter.scala 67:15]
  assign io_out_bits = $signed(_GEN_24); // @[FIRFilter.scala 67:15]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  regs_0 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  regs_1 = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  regs_2 = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  regs_3 = _RAND_3[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  regs_4 = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  regs_5 = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  _T_18 = _RAND_6[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  _T_19 = _RAND_7[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  _T_20 = _RAND_8[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  _T_21 = _RAND_9[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  _T_22 = _RAND_10[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{`RANDOM}};
  _T_23 = _RAND_11[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      regs_0 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_0 <= io_in_bits;
      end
    end
    if (reset) begin
      regs_1 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_1 <= regs_0;
      end
    end
    if (reset) begin
      regs_2 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_2 <= regs_1;
      end
    end
    if (reset) begin
      regs_3 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_3 <= regs_2;
      end
    end
    if (reset) begin
      regs_4 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_4 <= regs_3;
      end
    end
    if (reset) begin
      regs_5 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_5 <= regs_4;
      end
    end
    if (reset) begin
      _T_18 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_18 <= io_in_valid;
      end
    end
    if (reset) begin
      _T_19 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_19 <= _T_18;
      end
    end
    if (reset) begin
      _T_20 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_20 <= _T_19;
      end
    end
    if (reset) begin
      _T_21 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_21 <= _T_20;
      end
    end
    if (reset) begin
      _T_22 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_22 <= _T_21;
      end
    end
    if (reset) begin
      _T_23 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_23 <= _T_22;
      end
    end
  end
endmodule
module FFTBuffer(
  input         clock,
  input         reset,
  input         io_in_valid,
  input  [31:0] io_in_bits,
  output        io_out_valid,
  output [31:0] io_out_bits_0,
  output [31:0] io_out_bits_1,
  output [31:0] io_out_bits_2,
  output [31:0] io_out_bits_3,
  output [31:0] io_out_bits_4,
  output [31:0] io_out_bits_5,
  output [31:0] io_out_bits_6,
  output [31:0] io_out_bits_7,
  output [31:0] io_out_bits_8,
  output [31:0] io_out_bits_9,
  output [31:0] io_out_bits_10,
  output [31:0] io_out_bits_11,
  output [31:0] io_out_bits_12,
  output [31:0] io_out_bits_13,
  output [31:0] io_out_bits_14,
  output [31:0] io_out_bits_15,
  output [31:0] io_out_bits_16,
  output [31:0] io_out_bits_17,
  output [31:0] io_out_bits_18,
  output [31:0] io_out_bits_19,
  output [31:0] io_out_bits_20,
  output [31:0] io_out_bits_21,
  output [31:0] io_out_bits_22,
  output [31:0] io_out_bits_23,
  output [31:0] io_out_bits_24,
  output [31:0] io_out_bits_25,
  output [31:0] io_out_bits_26,
  output [31:0] io_out_bits_27,
  output [31:0] io_out_bits_28,
  output [31:0] io_out_bits_29,
  output [31:0] io_out_bits_30,
  output [31:0] io_out_bits_31
);
  reg [31:0] regs_0; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_0;
  reg [31:0] regs_1; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_1;
  reg [31:0] regs_2; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_2;
  reg [31:0] regs_3; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_3;
  reg [31:0] regs_4; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_4;
  reg [31:0] regs_5; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_5;
  reg [31:0] regs_6; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_6;
  reg [31:0] regs_7; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_7;
  reg [31:0] regs_8; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_8;
  reg [31:0] regs_9; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_9;
  reg [31:0] regs_10; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_10;
  reg [31:0] regs_11; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_11;
  reg [31:0] regs_12; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_12;
  reg [31:0] regs_13; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_13;
  reg [31:0] regs_14; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_14;
  reg [31:0] regs_15; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_15;
  reg [31:0] regs_16; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_16;
  reg [31:0] regs_17; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_17;
  reg [31:0] regs_18; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_18;
  reg [31:0] regs_19; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_19;
  reg [31:0] regs_20; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_20;
  reg [31:0] regs_21; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_21;
  reg [31:0] regs_22; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_22;
  reg [31:0] regs_23; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_23;
  reg [31:0] regs_24; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_24;
  reg [31:0] regs_25; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_25;
  reg [31:0] regs_26; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_26;
  reg [31:0] regs_27; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_27;
  reg [31:0] regs_28; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_28;
  reg [31:0] regs_29; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_29;
  reg [31:0] regs_30; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_30;
  reg [31:0] regs_31; // @[FFTBuffer.scala 48:21]
  reg [31:0] _RAND_31;
  reg  _T_37; // @[Reg.scala 19:20]
  reg [31:0] _RAND_32;
  reg  _T_38; // @[Reg.scala 19:20]
  reg [31:0] _RAND_33;
  reg  _T_39; // @[Reg.scala 19:20]
  reg [31:0] _RAND_34;
  reg  _T_40; // @[Reg.scala 19:20]
  reg [31:0] _RAND_35;
  reg  _T_41; // @[Reg.scala 19:20]
  reg [31:0] _RAND_36;
  reg  _T_42; // @[Reg.scala 19:20]
  reg [31:0] _RAND_37;
  reg  _T_43; // @[Reg.scala 19:20]
  reg [31:0] _RAND_38;
  reg  _T_44; // @[Reg.scala 19:20]
  reg [31:0] _RAND_39;
  reg  _T_45; // @[Reg.scala 19:20]
  reg [31:0] _RAND_40;
  reg  _T_46; // @[Reg.scala 19:20]
  reg [31:0] _RAND_41;
  reg  _T_47; // @[Reg.scala 19:20]
  reg [31:0] _RAND_42;
  reg  _T_48; // @[Reg.scala 19:20]
  reg [31:0] _RAND_43;
  reg  _T_49; // @[Reg.scala 19:20]
  reg [31:0] _RAND_44;
  reg  _T_50; // @[Reg.scala 19:20]
  reg [31:0] _RAND_45;
  reg  _T_51; // @[Reg.scala 19:20]
  reg [31:0] _RAND_46;
  reg  _T_52; // @[Reg.scala 19:20]
  reg [31:0] _RAND_47;
  reg  _T_53; // @[Reg.scala 19:20]
  reg [31:0] _RAND_48;
  reg  _T_54; // @[Reg.scala 19:20]
  reg [31:0] _RAND_49;
  reg  _T_55; // @[Reg.scala 19:20]
  reg [31:0] _RAND_50;
  reg  _T_56; // @[Reg.scala 19:20]
  reg [31:0] _RAND_51;
  reg  _T_57; // @[Reg.scala 19:20]
  reg [31:0] _RAND_52;
  reg  _T_58; // @[Reg.scala 19:20]
  reg [31:0] _RAND_53;
  reg  _T_59; // @[Reg.scala 19:20]
  reg [31:0] _RAND_54;
  reg  _T_60; // @[Reg.scala 19:20]
  reg [31:0] _RAND_55;
  reg  _T_61; // @[Reg.scala 19:20]
  reg [31:0] _RAND_56;
  reg  _T_62; // @[Reg.scala 19:20]
  reg [31:0] _RAND_57;
  reg  _T_63; // @[Reg.scala 19:20]
  reg [31:0] _RAND_58;
  reg  _T_64; // @[Reg.scala 19:20]
  reg [31:0] _RAND_59;
  reg  _T_65; // @[Reg.scala 19:20]
  reg [31:0] _RAND_60;
  reg  _T_66; // @[Reg.scala 19:20]
  reg [31:0] _RAND_61;
  reg  _T_67; // @[Reg.scala 19:20]
  reg [31:0] _RAND_62;
  reg  _T_68; // @[Reg.scala 19:20]
  reg [31:0] _RAND_63;
  assign io_out_valid = _T_68 & io_in_valid; // @[FFTBuffer.scala 76:16]
  assign io_out_bits_0 = regs_0; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_1 = regs_1; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_2 = regs_2; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_3 = regs_3; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_4 = regs_4; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_5 = regs_5; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_6 = regs_6; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_7 = regs_7; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_8 = regs_8; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_9 = regs_9; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_10 = regs_10; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_11 = regs_11; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_12 = regs_12; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_13 = regs_13; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_14 = regs_14; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_15 = regs_15; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_16 = regs_16; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_17 = regs_17; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_18 = regs_18; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_19 = regs_19; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_20 = regs_20; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_21 = regs_21; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_22 = regs_22; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_23 = regs_23; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_24 = regs_24; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_25 = regs_25; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_26 = regs_26; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_27 = regs_27; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_28 = regs_28; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_29 = regs_29; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_30 = regs_30; // @[FFTBuffer.scala 73:20]
  assign io_out_bits_31 = regs_31; // @[FFTBuffer.scala 73:20]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  regs_0 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  regs_1 = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  regs_2 = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  regs_3 = _RAND_3[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  regs_4 = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  regs_5 = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  regs_6 = _RAND_6[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  regs_7 = _RAND_7[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  regs_8 = _RAND_8[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  regs_9 = _RAND_9[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  regs_10 = _RAND_10[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{`RANDOM}};
  regs_11 = _RAND_11[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{`RANDOM}};
  regs_12 = _RAND_12[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{`RANDOM}};
  regs_13 = _RAND_13[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{`RANDOM}};
  regs_14 = _RAND_14[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {1{`RANDOM}};
  regs_15 = _RAND_15[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {1{`RANDOM}};
  regs_16 = _RAND_16[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {1{`RANDOM}};
  regs_17 = _RAND_17[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{`RANDOM}};
  regs_18 = _RAND_18[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{`RANDOM}};
  regs_19 = _RAND_19[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{`RANDOM}};
  regs_20 = _RAND_20[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_21 = {1{`RANDOM}};
  regs_21 = _RAND_21[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_22 = {1{`RANDOM}};
  regs_22 = _RAND_22[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_23 = {1{`RANDOM}};
  regs_23 = _RAND_23[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {1{`RANDOM}};
  regs_24 = _RAND_24[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_25 = {1{`RANDOM}};
  regs_25 = _RAND_25[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_26 = {1{`RANDOM}};
  regs_26 = _RAND_26[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_27 = {1{`RANDOM}};
  regs_27 = _RAND_27[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_28 = {1{`RANDOM}};
  regs_28 = _RAND_28[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_29 = {1{`RANDOM}};
  regs_29 = _RAND_29[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_30 = {1{`RANDOM}};
  regs_30 = _RAND_30[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_31 = {1{`RANDOM}};
  regs_31 = _RAND_31[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_32 = {1{`RANDOM}};
  _T_37 = _RAND_32[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_33 = {1{`RANDOM}};
  _T_38 = _RAND_33[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_34 = {1{`RANDOM}};
  _T_39 = _RAND_34[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_35 = {1{`RANDOM}};
  _T_40 = _RAND_35[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_36 = {1{`RANDOM}};
  _T_41 = _RAND_36[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_37 = {1{`RANDOM}};
  _T_42 = _RAND_37[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_38 = {1{`RANDOM}};
  _T_43 = _RAND_38[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_39 = {1{`RANDOM}};
  _T_44 = _RAND_39[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_40 = {1{`RANDOM}};
  _T_45 = _RAND_40[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_41 = {1{`RANDOM}};
  _T_46 = _RAND_41[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_42 = {1{`RANDOM}};
  _T_47 = _RAND_42[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_43 = {1{`RANDOM}};
  _T_48 = _RAND_43[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_44 = {1{`RANDOM}};
  _T_49 = _RAND_44[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_45 = {1{`RANDOM}};
  _T_50 = _RAND_45[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_46 = {1{`RANDOM}};
  _T_51 = _RAND_46[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_47 = {1{`RANDOM}};
  _T_52 = _RAND_47[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_48 = {1{`RANDOM}};
  _T_53 = _RAND_48[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_49 = {1{`RANDOM}};
  _T_54 = _RAND_49[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_50 = {1{`RANDOM}};
  _T_55 = _RAND_50[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_51 = {1{`RANDOM}};
  _T_56 = _RAND_51[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_52 = {1{`RANDOM}};
  _T_57 = _RAND_52[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_53 = {1{`RANDOM}};
  _T_58 = _RAND_53[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_54 = {1{`RANDOM}};
  _T_59 = _RAND_54[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_55 = {1{`RANDOM}};
  _T_60 = _RAND_55[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_56 = {1{`RANDOM}};
  _T_61 = _RAND_56[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_57 = {1{`RANDOM}};
  _T_62 = _RAND_57[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_58 = {1{`RANDOM}};
  _T_63 = _RAND_58[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_59 = {1{`RANDOM}};
  _T_64 = _RAND_59[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_60 = {1{`RANDOM}};
  _T_65 = _RAND_60[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_61 = {1{`RANDOM}};
  _T_66 = _RAND_61[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_62 = {1{`RANDOM}};
  _T_67 = _RAND_62[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_63 = {1{`RANDOM}};
  _T_68 = _RAND_63[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      regs_0 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_0 <= io_in_bits;
      end
    end
    if (reset) begin
      regs_1 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_1 <= regs_0;
      end
    end
    if (reset) begin
      regs_2 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_2 <= regs_1;
      end
    end
    if (reset) begin
      regs_3 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_3 <= regs_2;
      end
    end
    if (reset) begin
      regs_4 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_4 <= regs_3;
      end
    end
    if (reset) begin
      regs_5 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_5 <= regs_4;
      end
    end
    if (reset) begin
      regs_6 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_6 <= regs_5;
      end
    end
    if (reset) begin
      regs_7 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_7 <= regs_6;
      end
    end
    if (reset) begin
      regs_8 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_8 <= regs_7;
      end
    end
    if (reset) begin
      regs_9 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_9 <= regs_8;
      end
    end
    if (reset) begin
      regs_10 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_10 <= regs_9;
      end
    end
    if (reset) begin
      regs_11 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_11 <= regs_10;
      end
    end
    if (reset) begin
      regs_12 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_12 <= regs_11;
      end
    end
    if (reset) begin
      regs_13 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_13 <= regs_12;
      end
    end
    if (reset) begin
      regs_14 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_14 <= regs_13;
      end
    end
    if (reset) begin
      regs_15 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_15 <= regs_14;
      end
    end
    if (reset) begin
      regs_16 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_16 <= regs_15;
      end
    end
    if (reset) begin
      regs_17 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_17 <= regs_16;
      end
    end
    if (reset) begin
      regs_18 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_18 <= regs_17;
      end
    end
    if (reset) begin
      regs_19 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_19 <= regs_18;
      end
    end
    if (reset) begin
      regs_20 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_20 <= regs_19;
      end
    end
    if (reset) begin
      regs_21 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_21 <= regs_20;
      end
    end
    if (reset) begin
      regs_22 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_22 <= regs_21;
      end
    end
    if (reset) begin
      regs_23 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_23 <= regs_22;
      end
    end
    if (reset) begin
      regs_24 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_24 <= regs_23;
      end
    end
    if (reset) begin
      regs_25 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_25 <= regs_24;
      end
    end
    if (reset) begin
      regs_26 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_26 <= regs_25;
      end
    end
    if (reset) begin
      regs_27 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_27 <= regs_26;
      end
    end
    if (reset) begin
      regs_28 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_28 <= regs_27;
      end
    end
    if (reset) begin
      regs_29 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_29 <= regs_28;
      end
    end
    if (reset) begin
      regs_30 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_30 <= regs_29;
      end
    end
    if (reset) begin
      regs_31 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_31 <= regs_30;
      end
    end
    if (reset) begin
      _T_37 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_37 <= io_in_valid;
      end
    end
    if (reset) begin
      _T_38 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_38 <= _T_37;
      end
    end
    if (reset) begin
      _T_39 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_39 <= _T_38;
      end
    end
    if (reset) begin
      _T_40 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_40 <= _T_39;
      end
    end
    if (reset) begin
      _T_41 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_41 <= _T_40;
      end
    end
    if (reset) begin
      _T_42 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_42 <= _T_41;
      end
    end
    if (reset) begin
      _T_43 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_43 <= _T_42;
      end
    end
    if (reset) begin
      _T_44 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_44 <= _T_43;
      end
    end
    if (reset) begin
      _T_45 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_45 <= _T_44;
      end
    end
    if (reset) begin
      _T_46 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_46 <= _T_45;
      end
    end
    if (reset) begin
      _T_47 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_47 <= _T_46;
      end
    end
    if (reset) begin
      _T_48 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_48 <= _T_47;
      end
    end
    if (reset) begin
      _T_49 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_49 <= _T_48;
      end
    end
    if (reset) begin
      _T_50 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_50 <= _T_49;
      end
    end
    if (reset) begin
      _T_51 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_51 <= _T_50;
      end
    end
    if (reset) begin
      _T_52 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_52 <= _T_51;
      end
    end
    if (reset) begin
      _T_53 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_53 <= _T_52;
      end
    end
    if (reset) begin
      _T_54 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_54 <= _T_53;
      end
    end
    if (reset) begin
      _T_55 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_55 <= _T_54;
      end
    end
    if (reset) begin
      _T_56 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_56 <= _T_55;
      end
    end
    if (reset) begin
      _T_57 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_57 <= _T_56;
      end
    end
    if (reset) begin
      _T_58 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_58 <= _T_57;
      end
    end
    if (reset) begin
      _T_59 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_59 <= _T_58;
      end
    end
    if (reset) begin
      _T_60 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_60 <= _T_59;
      end
    end
    if (reset) begin
      _T_61 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_61 <= _T_60;
      end
    end
    if (reset) begin
      _T_62 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_62 <= _T_61;
      end
    end
    if (reset) begin
      _T_63 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_63 <= _T_62;
      end
    end
    if (reset) begin
      _T_64 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_64 <= _T_63;
      end
    end
    if (reset) begin
      _T_65 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_65 <= _T_64;
      end
    end
    if (reset) begin
      _T_66 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_66 <= _T_65;
      end
    end
    if (reset) begin
      _T_67 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_67 <= _T_66;
      end
    end
    if (reset) begin
      _T_68 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_68 <= _T_67;
      end
    end
  end
endmodule
module DirectFFT(
  input  [31:0] io_in_bits_0_real,
  input  [31:0] io_in_bits_0_imag,
  input  [31:0] io_in_bits_1_real,
  input  [31:0] io_in_bits_1_imag,
  input  [31:0] io_in_bits_2_real,
  input  [31:0] io_in_bits_2_imag,
  input  [31:0] io_in_bits_3_real,
  input  [31:0] io_in_bits_3_imag,
  input  [31:0] io_in_bits_4_real,
  input  [31:0] io_in_bits_4_imag,
  input  [31:0] io_in_bits_5_real,
  input  [31:0] io_in_bits_5_imag,
  input  [31:0] io_in_bits_6_real,
  input  [31:0] io_in_bits_6_imag,
  input  [31:0] io_in_bits_7_real,
  input  [31:0] io_in_bits_7_imag,
  input  [31:0] io_in_bits_8_real,
  input  [31:0] io_in_bits_8_imag,
  input  [31:0] io_in_bits_9_real,
  input  [31:0] io_in_bits_9_imag,
  input  [31:0] io_in_bits_10_real,
  input  [31:0] io_in_bits_10_imag,
  input  [31:0] io_in_bits_11_real,
  input  [31:0] io_in_bits_11_imag,
  input  [31:0] io_in_bits_12_real,
  input  [31:0] io_in_bits_12_imag,
  input  [31:0] io_in_bits_13_real,
  input  [31:0] io_in_bits_13_imag,
  input  [31:0] io_in_bits_14_real,
  input  [31:0] io_in_bits_14_imag,
  input  [31:0] io_in_bits_15_real,
  input  [31:0] io_in_bits_15_imag,
  input  [31:0] io_in_bits_16_real,
  input  [31:0] io_in_bits_16_imag,
  input  [31:0] io_in_bits_17_real,
  input  [31:0] io_in_bits_17_imag,
  input  [31:0] io_in_bits_18_real,
  input  [31:0] io_in_bits_18_imag,
  input  [31:0] io_in_bits_19_real,
  input  [31:0] io_in_bits_19_imag,
  input  [31:0] io_in_bits_20_real,
  input  [31:0] io_in_bits_20_imag,
  input  [31:0] io_in_bits_21_real,
  input  [31:0] io_in_bits_21_imag,
  input  [31:0] io_in_bits_22_real,
  input  [31:0] io_in_bits_22_imag,
  input  [31:0] io_in_bits_23_real,
  input  [31:0] io_in_bits_23_imag,
  input  [31:0] io_in_bits_24_real,
  input  [31:0] io_in_bits_24_imag,
  input  [31:0] io_in_bits_25_real,
  input  [31:0] io_in_bits_25_imag,
  input  [31:0] io_in_bits_26_real,
  input  [31:0] io_in_bits_26_imag,
  input  [31:0] io_in_bits_27_real,
  input  [31:0] io_in_bits_27_imag,
  input  [31:0] io_in_bits_28_real,
  input  [31:0] io_in_bits_28_imag,
  input  [31:0] io_in_bits_29_real,
  input  [31:0] io_in_bits_29_imag,
  input  [31:0] io_in_bits_30_real,
  input  [31:0] io_in_bits_30_imag,
  input  [31:0] io_in_bits_31_real,
  input  [31:0] io_in_bits_31_imag,
  output [31:0] io_out_bits_4_real,
  output [31:0] io_out_bits_4_imag,
  output [31:0] io_out_bits_5_real,
  output [31:0] io_out_bits_5_imag,
  output [31:0] io_out_bits_6_real,
  output [31:0] io_out_bits_6_imag,
  output [31:0] io_out_bits_7_real,
  output [31:0] io_out_bits_7_imag,
  output [31:0] io_out_bits_8_real,
  output [31:0] io_out_bits_8_imag,
  output [31:0] io_out_bits_9_real,
  output [31:0] io_out_bits_9_imag,
  output [31:0] io_out_bits_10_real,
  output [31:0] io_out_bits_10_imag,
  output [31:0] io_out_bits_11_real,
  output [31:0] io_out_bits_11_imag,
  output [31:0] io_out_bits_12_real,
  output [31:0] io_out_bits_12_imag,
  output [31:0] io_out_bits_13_real,
  output [31:0] io_out_bits_13_imag,
  output [31:0] io_out_bits_14_real,
  output [31:0] io_out_bits_14_imag,
  output [31:0] io_out_bits_15_real,
  output [31:0] io_out_bits_15_imag
);
  wire [31:0] _T_932; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_933; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_935; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_936; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_0; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_937; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_938; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_2; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_939; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_941; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_942; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_944; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_945; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_3; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_4; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_5; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_950; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_951; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_6; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_7; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_8; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_953; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_954; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_959; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_960; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_962; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_963; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_973; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_974; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_976; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_977; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_15; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_978; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_16; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_979; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_17; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_980; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_982; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_983; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_985; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_986; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_18; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_19; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_20; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_991; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_992; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_21; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_22; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_23; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_994; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_995; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1000; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1001; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1003; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1004; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1014; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1015; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1017; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1018; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_30; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1019; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_31; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1020; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_32; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1021; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1023; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1024; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1026; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1027; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_33; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_34; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_35; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1032; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1033; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_36; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_37; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_38; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1035; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1036; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1041; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1042; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1044; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1045; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1055; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1056; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1058; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1059; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_45; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1060; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_46; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1061; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_47; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1062; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1064; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1065; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1067; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1068; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_48; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_49; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_50; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1073; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1074; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_51; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_52; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_53; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1076; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1077; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1082; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1083; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1085; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1086; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1096; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1097; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1099; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1100; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_60; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1101; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_61; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1102; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_62; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1103; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1105; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1106; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1108; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1109; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_63; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_64; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_65; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1114; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1115; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_66; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_67; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_68; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1117; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1118; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1123; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1124; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1126; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1127; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1137; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1138; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1140; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1141; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_75; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1142; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_76; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1143; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_77; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1144; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1146; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1147; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1149; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1150; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_78; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_79; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_80; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1155; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1156; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_81; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_82; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_83; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1158; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1159; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1164; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1165; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1167; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1168; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1178; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1179; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1181; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1182; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_90; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1183; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_91; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1184; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_92; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1185; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1187; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1188; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1190; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1191; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_93; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_94; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_95; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1196; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1197; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_96; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_97; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_98; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1199; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1200; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1205; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1206; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1208; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1209; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1219; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1220; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1222; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1223; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_105; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1224; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_106; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1225; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_107; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1226; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1228; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1229; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1231; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1232; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_108; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_109; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_110; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1237; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1238; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_111; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_112; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_113; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1240; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1241; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1246; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1247; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1249; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1250; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1260; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1261; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1263; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1264; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_120; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1265; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_121; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1266; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_122; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1267; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1269; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1270; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1272; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1273; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_123; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_124; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_125; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1278; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1279; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_126; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_127; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_128; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1281; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1282; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1287; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1288; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1290; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1291; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1301; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1302; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1304; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1305; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_135; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1306; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_136; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1307; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_137; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1308; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1310; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1311; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1313; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1314; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_138; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_139; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_140; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1319; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1320; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_141; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_142; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_143; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1322; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1323; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1328; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1329; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1331; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1332; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1342; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1343; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1345; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1346; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_150; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1347; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_151; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1348; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_152; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1349; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1351; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1352; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1354; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1355; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_153; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_154; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_155; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1360; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1361; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_156; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_157; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_158; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1363; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1364; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1369; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1370; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1372; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1373; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1383; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1384; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1386; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1387; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_165; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1388; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_166; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1389; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_167; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1390; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1392; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1393; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1395; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1396; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_168; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_169; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_170; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1401; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1402; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_171; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_172; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_173; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1404; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1405; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1410; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1411; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1413; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1414; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1424; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1425; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1427; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1428; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_180; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1429; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_181; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1430; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_182; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1431; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1433; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1434; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1436; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1437; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_183; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_184; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_185; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1442; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1443; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_186; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_187; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_188; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1445; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1446; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1451; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1452; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1454; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1455; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1465; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1466; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1468; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1469; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_195; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1470; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_196; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1471; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_197; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1472; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1474; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1475; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1477; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1478; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_198; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_199; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_200; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1483; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1484; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_201; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_202; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_203; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1486; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1487; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1492; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1493; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1495; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1496; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1506; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1507; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1509; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1510; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_210; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1511; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_211; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1512; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_212; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1513; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1515; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1516; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1518; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1519; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_213; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_214; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_215; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1524; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1525; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_216; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_217; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_218; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1527; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1528; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1533; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1534; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1536; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1537; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1547; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1548; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1550; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1551; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_225; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1552; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_226; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1553; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_227; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1554; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1556; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1557; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1559; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1560; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_228; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_229; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_230; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1565; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1566; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_231; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_232; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_233; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1568; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1569; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1574; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1575; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1577; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1578; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_240; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_241; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_472_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_242; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_243; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_472_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_1588; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1589; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1591; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1592; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_244; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1593; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_245; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1594; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_246; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1595; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1597; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1598; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1600; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1601; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_247; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_248; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_448_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_249; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_250; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_251; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1606; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1607; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_252; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_253; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_448_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_254; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_255; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_256; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1609; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1610; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1615; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1616; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1618; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1619; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_263; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_264; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_475_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_265; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_266; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_475_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_1629; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1630; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1632; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1633; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_267; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1634; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_268; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1635; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_269; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1636; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1638; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1639; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1641; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1642; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_270; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_271; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_451_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_272; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_273; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_274; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1647; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1648; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_275; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_276; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_451_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_277; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_278; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_279; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1650; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1651; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1656; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1657; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1659; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1660; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_286; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_287; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_478_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_288; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_289; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_478_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_1670; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1671; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1673; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1674; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_290; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1675; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_291; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1676; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_292; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1677; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1679; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1680; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1682; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1683; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_293; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_294; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_454_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_295; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_296; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_297; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1688; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1689; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_298; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_299; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_454_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_300; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_301; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_302; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1691; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1692; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1697; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1698; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1700; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1701; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_309; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_310; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_481_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_311; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_312; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_481_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_1711; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1712; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1714; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1715; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_313; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1716; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_314; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1717; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_315; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1718; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1720; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1721; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1723; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1724; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_316; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_317; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_457_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_318; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_319; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_320; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1729; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1730; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_321; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_322; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_457_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_323; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_324; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_325; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1732; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1733; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1738; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1739; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1741; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1742; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_332; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_333; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_484_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_334; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_335; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_484_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_1752; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1753; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1755; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1756; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_336; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1757; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_337; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1758; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_338; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1759; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1761; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1762; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1764; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1765; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_339; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_340; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_460_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_341; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_342; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_343; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1770; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1771; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_344; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_345; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_460_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_346; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_347; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_348; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1773; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1774; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1779; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1780; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1782; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1783; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_355; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_356; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_487_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_357; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_358; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_487_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_1793; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1794; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1796; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1797; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_359; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1798; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_360; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1799; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_361; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1800; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1802; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1803; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1805; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1806; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_362; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_363; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_463_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_364; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_365; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_366; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1811; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1812; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_367; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_368; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_463_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_369; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_370; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_371; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1814; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1815; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1820; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1821; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1823; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1824; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_378; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_379; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_490_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_380; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_381; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_490_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_1834; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1835; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1837; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1838; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_382; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1839; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_383; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1840; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_384; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1841; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1843; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1844; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1846; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1847; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_385; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_386; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_466_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_387; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_388; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_389; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1852; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1853; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_390; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_391; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_466_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_392; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_393; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_394; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1855; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1856; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1861; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1862; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1864; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1865; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_401; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_402; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_493_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_403; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_404; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_493_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_1875; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1876; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1878; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1879; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_405; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1880; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_406; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1881; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_407; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1882; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1884; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1885; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1887; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1888; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_408; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_409; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_469_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_410; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_411; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_412; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1893; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1894; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_413; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_414; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_469_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_415; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_416; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_417; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1896; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1897; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1902; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1903; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1905; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1906; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_424; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_425; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_520_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_426; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_427; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_520_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_1916; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1917; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1919; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1920; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_428; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1921; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_429; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1922; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_430; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1923; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1925; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1926; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1928; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1929; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_431; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_432; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_496_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_433; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_434; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_435; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1934; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1935; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_436; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_437; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_496_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_438; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_439; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_440; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1937; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1938; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1943; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1944; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1946; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1947; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_447; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_448; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_523_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_449; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_450; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_523_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_1957; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1958; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1960; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_1961; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_451; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1962; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_452; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1963; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_453; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1964; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_1966; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1967; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1969; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1970; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_454; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_455; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_499_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_456; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_457; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_458; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1975; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1976; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_459; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_460; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_499_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_461; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_462; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_463; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1978; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1979; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_1984; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1985; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1987; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_1988; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_470; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_471; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_526_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_472; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_473; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_526_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_1998; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_1999; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2001; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2002; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_474; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2003; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_475; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2004; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_476; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2005; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2007; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2008; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2010; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2011; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_477; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_478; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_502_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_479; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_480; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_481; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2016; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2017; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_482; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_483; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_502_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_484; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_485; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_486; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2019; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2020; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2025; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2026; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2028; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2029; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_493; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_494; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_529_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_495; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_496; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_529_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2039; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2040; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2042; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2043; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_497; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2044; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_498; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2045; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_499; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2046; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2048; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2049; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2051; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2052; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_500; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_501; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_505_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_502; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_503; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_504; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2057; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2058; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_505; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_506; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_505_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_507; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_508; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_509; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2060; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2061; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2066; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2067; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2069; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2070; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_516; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_517; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_532_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_518; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_519; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_532_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2080; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2081; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2083; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2084; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_520; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2085; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_521; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2086; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_522; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2087; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2089; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2090; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2092; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2093; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_523; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_524; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_508_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_525; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_526; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_527; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2098; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2099; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_528; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_529; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_508_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_530; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_531; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_532; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2101; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2102; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2107; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2108; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2110; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2111; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_539; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_540; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_535_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_541; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_542; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_535_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2121; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2122; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2124; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2125; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_543; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2126; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_544; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2127; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_545; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2128; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2130; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2131; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2133; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2134; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_546; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_547; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_511_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_548; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_549; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_550; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2139; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2140; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_551; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_552; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_511_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_553; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_554; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_555; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2142; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2143; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2148; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2149; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2151; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2152; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_562; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_563; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_538_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_564; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_565; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_538_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2162; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2163; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2165; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2166; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_566; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2167; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_567; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2168; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_568; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2169; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2171; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2172; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2174; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2175; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_569; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_570; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_514_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_571; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_572; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_573; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2180; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2181; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_574; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_575; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_514_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_576; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_577; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_578; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2183; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2184; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2189; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2190; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2192; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2193; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_585; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_586; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_541_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_587; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_588; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_541_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2203; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2204; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2206; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2207; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_589; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2208; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_590; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2209; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_591; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2210; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2212; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2213; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2215; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2216; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_592; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_593; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_517_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_594; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_595; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_596; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2221; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2222; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_597; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_598; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_517_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_599; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_600; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_601; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2224; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2225; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2230; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2231; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2233; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2234; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_608; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_609; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_556_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_610; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_611; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_556_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2244; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2245; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2247; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2248; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_612; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2249; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_613; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2250; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_614; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2251; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2253; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2254; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2256; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2257; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_615; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_616; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_544_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_617; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_618; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_619; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2262; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2263; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_620; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_621; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_544_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_622; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_623; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_624; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2265; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2266; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2271; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2272; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2274; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2275; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_631; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_632; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_559_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_633; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_634; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_559_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2285; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2286; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2288; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2289; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_635; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2290; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_636; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2291; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_637; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2292; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2294; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2295; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2297; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2298; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_638; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_639; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_547_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_640; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_641; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_642; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2303; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2304; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_643; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_644; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_547_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_645; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_646; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_647; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2306; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2307; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2312; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2313; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2315; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2316; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_654; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_655; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_562_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_656; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_657; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_562_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2326; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2327; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2329; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2330; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_658; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2331; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_659; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2332; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_660; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2333; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2335; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2336; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2338; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2339; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_661; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_662; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_550_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_663; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_664; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_665; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2344; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2345; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_666; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_667; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_550_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_668; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_669; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_670; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2347; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2348; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2353; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2354; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2356; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2357; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_677; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_678; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_565_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_679; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_680; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_565_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2367; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2368; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2370; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2371; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_681; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2372; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_682; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2373; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_683; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2374; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2376; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2377; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2379; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2380; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_684; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_685; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_553_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_686; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_687; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_688; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2385; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2386; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_689; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_690; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_553_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_691; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_692; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_693; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2388; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2389; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2394; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2395; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2397; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2398; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_700; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_701; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_580_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_702; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_703; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_580_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2408; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2409; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2411; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2412; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_704; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2413; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_705; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2414; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_706; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2415; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2417; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2418; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2420; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2421; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_707; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_708; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_568_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_709; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_710; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_711; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2426; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2427; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_712; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_713; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_568_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_714; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_715; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_716; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2429; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2430; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2435; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2436; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2438; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2439; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_723; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_724; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_583_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_725; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_726; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_583_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2449; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2450; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2452; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2453; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_727; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2454; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_728; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2455; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_729; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2456; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2458; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2459; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2461; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2462; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_730; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_731; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_571_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_732; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_733; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_734; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2467; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2468; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_735; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_736; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_571_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_737; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_738; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_739; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2470; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2471; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2476; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2477; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2479; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2480; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_746; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_747; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_586_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_748; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_749; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_586_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2490; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2491; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2493; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2494; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_750; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2495; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_751; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2496; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_752; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2497; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2499; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2500; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2502; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2503; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_753; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_754; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_574_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_755; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_756; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_757; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2508; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2509; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_758; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_759; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_574_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_760; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_761; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_762; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2511; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2512; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2517; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2518; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2520; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2521; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_769; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_770; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_589_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_771; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_772; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_589_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2531; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2532; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2534; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2535; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_773; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2536; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_774; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2537; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_775; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2538; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2540; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2541; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2543; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2544; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_776; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_777; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_577_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_778; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_779; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_780; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2549; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2550; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_781; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_782; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_577_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_783; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_784; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_785; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2552; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2553; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2558; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2559; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2561; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2562; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_792; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_793; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_604_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_794; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_795; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_604_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2572; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2573; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2575; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2576; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_796; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2577; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_797; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2578; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_798; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2579; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2581; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2582; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2584; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2585; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_799; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_800; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_592_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_801; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_802; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_803; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2590; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2591; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_804; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_805; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_592_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_806; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_807; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_808; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2593; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2594; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2599; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2600; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2602; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2603; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_815; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_816; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_607_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_817; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_818; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_607_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2613; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2614; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2616; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2617; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_819; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2618; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_820; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2619; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_821; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2620; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2622; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2623; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2625; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2626; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_822; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_823; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_595_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_824; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_825; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_826; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2631; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2632; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_827; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_828; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_595_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_829; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_830; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_831; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2634; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2635; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2640; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2641; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2643; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2644; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_838; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_839; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_610_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_840; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_841; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_610_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2654; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2655; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2657; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2658; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_842; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2659; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_843; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2660; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_844; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2661; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2663; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2664; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2666; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2667; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_845; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_846; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_598_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_847; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_848; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_849; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2672; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2673; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_850; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_851; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_598_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_852; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_853; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_854; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2675; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2676; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2681; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2682; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2684; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2685; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_861; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_862; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_613_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_863; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_864; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_613_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2695; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2696; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2698; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2699; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_865; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2700; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_866; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2701; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_867; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2702; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2704; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2705; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2707; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2708; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_868; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_869; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_601_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_870; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_871; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_872; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2713; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2714; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_873; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_874; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_601_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_875; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_876; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_877; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2716; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2717; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2722; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2723; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2725; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2726; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_884; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_885; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_628_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_886; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_887; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_628_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2736; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2737; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2739; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2740; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_888; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2741; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_889; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2742; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_890; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2743; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2745; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2746; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2748; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2749; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_891; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_892; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_616_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_893; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_894; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_895; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2754; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2755; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_896; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_897; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_616_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_898; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_899; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_900; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2757; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2758; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2763; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2764; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2766; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2767; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_907; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_908; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_631_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_909; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_910; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_631_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2777; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2778; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2780; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2781; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_911; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2782; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_912; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2783; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_913; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2784; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2786; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2787; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2789; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2790; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_914; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_915; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_619_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_916; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_917; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_918; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2795; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2796; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_919; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_920; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_619_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_921; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_922; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_923; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2798; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2799; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2804; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2805; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2807; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2808; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_930; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_931; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_634_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_932; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_933; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_634_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2818; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2819; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2821; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2822; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_934; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2823; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_935; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2824; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_936; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2825; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2827; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2828; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2830; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2831; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_937; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_938; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_622_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_939; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_940; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_941; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2836; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2837; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_942; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_943; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_622_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_944; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_945; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_946; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2839; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2840; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2845; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2846; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2848; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2849; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_953; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_954; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_637_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_955; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_956; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_637_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2859; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2860; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2862; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2863; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_957; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2864; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_958; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2865; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_959; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2866; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2868; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2869; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2871; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2872; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_960; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_961; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_625_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_962; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_963; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_964; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2877; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2878; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_965; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_966; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_625_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_967; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_968; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_969; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2880; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2881; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2886; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2887; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2889; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2890; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_976; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_977; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_646_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_978; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_979; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_646_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2900; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2901; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2903; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2904; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_980; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2905; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_981; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2906; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_982; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2907; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2909; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2910; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2912; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2913; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_983; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_984; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_640_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_985; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_986; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_987; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_988; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_989; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_640_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_990; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_991; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_992; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2927; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2928; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2930; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2931; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_999; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1000; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_649_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1001; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1002; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_649_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2941; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2942; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2944; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2945; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1003; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2946; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1004; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2947; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1005; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2948; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2950; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2951; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2953; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2954; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1006; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1007; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_643_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1008; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1009; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1010; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1011; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1012; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_643_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1013; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1014; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1015; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2968; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2969; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2971; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2972; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1022; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1023; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_658_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1024; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1025; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_658_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_2982; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2983; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_2985; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2986; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1026; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2987; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1027; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2988; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1028; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2989; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_2991; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2992; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_2994; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_2995; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1029; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1030; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_652_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1031; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1032; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1033; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3000; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3001; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1034; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1035; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_652_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1036; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1037; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1038; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3003; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3004; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3009; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3010; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3012; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3013; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1045; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1046; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_661_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1047; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1048; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_661_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3023; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3024; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3026; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3027; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1049; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3028; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1050; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3029; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1051; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3030; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3032; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3033; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3035; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3036; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1052; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1053; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_655_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1054; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1055; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1056; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3041; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3042; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1057; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1058; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_655_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1059; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1060; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1061; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3044; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3045; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3050; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3051; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3053; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3054; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1068; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1069; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_670_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1070; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1071; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_670_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3064; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3065; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3067; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3068; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1072; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3069; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1073; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3070; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1074; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3071; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3073; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3074; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3076; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3077; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1075; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1076; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_664_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1077; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1078; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1079; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1080; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1081; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_664_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1082; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1083; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1084; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3091; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3092; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3094; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3095; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1091; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1092; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_673_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1093; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1094; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_673_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3105; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3106; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3108; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3109; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1095; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3110; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1096; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3111; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1097; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3112; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3114; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3115; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3117; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3118; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1098; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1099; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_667_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1100; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1101; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1102; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1103; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1104; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_667_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1105; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1106; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1107; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3132; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3133; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3135; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3136; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1114; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1115; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_682_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1116; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1117; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_682_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3146; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3147; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3149; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3150; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1118; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3151; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1119; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3152; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1120; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3153; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3155; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3156; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3158; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3159; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1121; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1122; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_676_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1123; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1124; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1125; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3164; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3165; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1126; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1127; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_676_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1128; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1129; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1130; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3167; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3168; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3173; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3174; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3176; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3177; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1137; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1138; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_685_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1139; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1140; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_685_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3187; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3188; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3190; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3191; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1141; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3192; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1142; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3193; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1143; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3194; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3196; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3197; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3199; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3200; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1144; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1145; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_679_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1146; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1147; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1148; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3205; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3206; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1149; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1150; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_679_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1151; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1152; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1153; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3208; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3209; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3214; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3215; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3217; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3218; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1160; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1161; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_694_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1162; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1163; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_694_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3228; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3229; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3231; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3232; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1164; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3233; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1165; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3234; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1166; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3235; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3237; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3238; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3240; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3241; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1167; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1168; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_688_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1169; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1170; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1171; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1172; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1173; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_688_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1174; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1175; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1176; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3255; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3256; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3258; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3259; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1183; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1184; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_697_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1185; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1186; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_697_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3269; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3270; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3272; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3273; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1187; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3274; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1188; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3275; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1189; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3276; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3278; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3279; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3281; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3282; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1190; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1191; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_691_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1192; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1193; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1194; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1195; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1196; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_691_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1197; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1198; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1199; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3296; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3297; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3299; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3300; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1206; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1207; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_706_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1208; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1209; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_706_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3310; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3311; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3313; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3314; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1210; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3315; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1211; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3316; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1212; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3317; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3319; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3320; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3322; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3323; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1213; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1214; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_700_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1215; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1216; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1217; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3328; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3329; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1218; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1219; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_700_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1220; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1221; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1222; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3331; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3332; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3337; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3338; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3340; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3341; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1229; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1230; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_709_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1231; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1232; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_709_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3351; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3352; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3354; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3355; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1233; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3356; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1234; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3357; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1235; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3358; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3360; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3361; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3363; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3364; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1236; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1237; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_703_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1238; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1239; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1240; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3369; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3370; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1241; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1242; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_703_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1243; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1244; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1245; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3372; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3373; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3378; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3379; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3381; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3382; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1252; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1253; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_718_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1254; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1255; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_718_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3392; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3393; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3395; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3396; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1256; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3397; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1257; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3398; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1258; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3399; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3401; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3402; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3404; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3405; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1259; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1260; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_712_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1261; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1262; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1263; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1264; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1265; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_712_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1266; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1267; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1268; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3419; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3420; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3422; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3423; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1275; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1276; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_721_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1277; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1278; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_721_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3433; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3434; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3436; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3437; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1279; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3438; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1280; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3439; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1281; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3440; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3442; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3443; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3445; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3446; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1282; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1283; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_715_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1284; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1285; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1286; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1287; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1288; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_715_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1289; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1290; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1291; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3460; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3461; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3463; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3464; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1298; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1299; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_730_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1300; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1301; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_730_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3474; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3475; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3477; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3478; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1302; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3479; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1303; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3480; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1304; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3481; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3483; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3484; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3486; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3487; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1305; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1306; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_724_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1307; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1308; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1309; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3492; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3493; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1310; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1311; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_724_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1312; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1313; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1314; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3495; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3496; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3501; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3502; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3504; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3505; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1321; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1322; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_733_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1323; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1324; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_733_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3515; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3516; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3518; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3519; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1325; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3520; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1326; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3521; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1327; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3522; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3524; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3525; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3527; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3528; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1328; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1329; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_727_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1330; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1331; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1332; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3533; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3534; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1333; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1334; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_727_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1335; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1336; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1337; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3536; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3537; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3542; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3543; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3545; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3546; // @[FixedPointTypeClass.scala 31:68]
  wire [33:0] _GEN_1367; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1368; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_745_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1369; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1370; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_745_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3597; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3598; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3600; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3601; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1371; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3602; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1372; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3603; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1373; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3604; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3606; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3607; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3609; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3610; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1374; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1375; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_742_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1376; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1377; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1378; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3615; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3616; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1379; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1380; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_742_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1381; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1382; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1383; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3618; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3619; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1390; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1391; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_751_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1392; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1393; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_751_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3638; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3639; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3641; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3642; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1394; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3643; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1395; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3644; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1396; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3645; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3647; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3648; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3650; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3651; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1397; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1398; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_748_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1399; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1400; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1401; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3656; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3657; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1402; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1403; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_748_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1404; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1405; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1406; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3659; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3660; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1413; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1414; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_757_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1415; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1416; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_757_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3679; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3680; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3682; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3683; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1417; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3684; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1418; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3685; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1419; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3686; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3688; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3689; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3691; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3692; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1420; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1421; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_754_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1422; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1423; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1424; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3697; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3698; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1425; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1426; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_754_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1427; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1428; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1429; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3700; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3701; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1459; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1460; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_769_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1461; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1462; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_769_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3761; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3762; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3764; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3765; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1463; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3766; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1464; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3767; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1465; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3768; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3770; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3771; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3773; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3774; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1466; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1467; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_766_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1468; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1469; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1470; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3779; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3780; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1471; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1472; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_766_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1473; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1474; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1475; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3782; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3783; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1482; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1483; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_775_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1484; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1485; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_775_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3802; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3803; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3805; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3806; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1486; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3807; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1487; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3808; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1488; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3809; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3811; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3812; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3814; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3815; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1489; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1490; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_772_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1491; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1492; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1493; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3820; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3821; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1494; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1495; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_772_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1496; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1497; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1498; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3823; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3824; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1505; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1506; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_781_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1507; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1508; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_781_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3843; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3844; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3846; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3847; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1509; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3848; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1510; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3849; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1511; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3850; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3852; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3853; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3855; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3856; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1512; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1513; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_778_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1514; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1515; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1516; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3861; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3862; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1517; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1518; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_778_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1519; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1520; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1521; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3864; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3865; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1551; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1552; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_793_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1553; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1554; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_793_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3925; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3926; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3928; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3929; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1555; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3930; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1556; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3931; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1557; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3932; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3934; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3935; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3937; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3938; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1558; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1559; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_790_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1560; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1561; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1562; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3943; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3944; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1563; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1564; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_790_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1565; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1566; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1567; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3946; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3947; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1574; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1575; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_799_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1576; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1577; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_799_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_3966; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3967; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_3969; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_3970; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1578; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3971; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1579; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3972; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1580; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3973; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_3975; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3976; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_3978; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3979; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1581; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1582; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_796_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1583; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1584; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1585; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3984; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3985; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1586; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1587; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_796_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1588; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1589; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1590; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3987; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_3988; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1597; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1598; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_805_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1599; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1600; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_805_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_4007; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_4008; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_4010; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_4011; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1601; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4012; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1602; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4013; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1603; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4014; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4016; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_4017; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_4019; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4020; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1604; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1605; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_802_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1606; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1607; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1608; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4025; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4026; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1609; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1610; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_802_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1611; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1612; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1613; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4028; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4029; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1643; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1644; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_817_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1645; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1646; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_817_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_4089; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_4090; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_4092; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_4093; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1647; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4094; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1648; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4095; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1649; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4096; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4098; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_4099; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_4101; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4102; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1650; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1651; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_814_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1652; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1653; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1654; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4107; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4108; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1655; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1656; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_814_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1657; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1658; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1659; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4110; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4111; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1666; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1667; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_823_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1668; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1669; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_823_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_4130; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_4131; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_4133; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_4134; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1670; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4135; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1671; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4136; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1672; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4137; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4139; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_4140; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_4142; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4143; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1673; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1674; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_820_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1675; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1676; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1677; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4148; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4149; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1678; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1679; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_820_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1680; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1681; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1682; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4151; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4152; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1689; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1690; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_829_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1691; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1692; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_829_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_4171; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_4172; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_4174; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_4175; // @[FixedPointTypeClass.scala 31:68]
  wire [34:0] _GEN_1693; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4176; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1694; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4177; // @[FixedPointTypeClass.scala 43:59]
  wire [34:0] _GEN_1695; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4178; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_4180; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_4181; // @[FixedPointTypeClass.scala 31:68]
  wire [66:0] _T_4183; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4184; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1696; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1697; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_826_real; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1698; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1699; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1700; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4189; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4190; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1701; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1702; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _T_826_imag; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [64:0] _GEN_1703; // @[FixedPointTypeClass.scala 21:58]
  wire [64:0] _GEN_1704; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _GEN_1705; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4192; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_4193; // @[FixedPointTypeClass.scala 21:58]
  wire [33:0] _GEN_1720; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1721; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1722; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1723; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1728; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1729; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1730; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1731; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1736; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1737; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1738; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1739; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1752; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1753; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1754; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1755; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1760; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1761; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1762; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1763; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1768; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1769; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1770; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1771; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1784; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1785; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1786; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1787; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1792; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1793; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1794; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1795; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1800; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1801; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1802; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1803; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1816; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1817; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1818; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1819; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1824; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1825; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1826; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1827; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1832; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1833; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [33:0] _GEN_1834; // @[FFT.scala 96:89 FFT.scala 110:16]
  wire [31:0] _GEN_1835; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_932 = $signed(io_in_bits_16_real) + $signed(io_in_bits_16_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_933 = $signed(_T_932); // @[FixedPointTypeClass.scala 21:58]
  assign _T_935 = $signed(io_in_bits_16_imag) - $signed(io_in_bits_16_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_936 = $signed(_T_935); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_0 = {{3{io_in_bits_16_real[31]}},io_in_bits_16_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_937 = $signed(_GEN_0) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1 = {{3{_T_933[31]}},_T_933}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_938 = $signed(_GEN_1) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_2 = {{3{_T_936[31]}},_T_936}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_939 = $signed(_GEN_2) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_941 = $signed(_T_937) - $signed(_T_938); // @[FixedPointTypeClass.scala 31:68]
  assign _T_942 = $signed(_T_941); // @[FixedPointTypeClass.scala 31:68]
  assign _T_944 = $signed(_T_937) + $signed(_T_939); // @[FixedPointTypeClass.scala 21:58]
  assign _T_945 = $signed(_T_944); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_3 = {{33{io_in_bits_0_real[31]}},io_in_bits_0_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_4 = $signed(_GEN_3) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_5 = {{2{_GEN_4[64]}},_GEN_4}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_950 = $signed(_GEN_5) + $signed(_T_942); // @[FixedPointTypeClass.scala 21:58]
  assign _T_951 = $signed(_T_950); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_6 = {{33{io_in_bits_0_imag[31]}},io_in_bits_0_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_7 = $signed(_GEN_6) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_8 = {{2{_GEN_7[64]}},_GEN_7}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_953 = $signed(_GEN_8) + $signed(_T_945); // @[FixedPointTypeClass.scala 21:58]
  assign _T_954 = $signed(_T_953); // @[FixedPointTypeClass.scala 21:58]
  assign _T_959 = $signed(_GEN_5) - $signed(_T_942); // @[FixedPointTypeClass.scala 31:68]
  assign _T_960 = $signed(_T_959); // @[FixedPointTypeClass.scala 31:68]
  assign _T_962 = $signed(_GEN_8) - $signed(_T_945); // @[FixedPointTypeClass.scala 31:68]
  assign _T_963 = $signed(_T_962); // @[FixedPointTypeClass.scala 31:68]
  assign _T_973 = $signed(io_in_bits_17_real) + $signed(io_in_bits_17_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_974 = $signed(_T_973); // @[FixedPointTypeClass.scala 21:58]
  assign _T_976 = $signed(io_in_bits_17_imag) - $signed(io_in_bits_17_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_977 = $signed(_T_976); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_15 = {{3{io_in_bits_17_real[31]}},io_in_bits_17_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_978 = $signed(_GEN_15) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_16 = {{3{_T_974[31]}},_T_974}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_979 = $signed(_GEN_16) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_17 = {{3{_T_977[31]}},_T_977}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_980 = $signed(_GEN_17) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_982 = $signed(_T_978) - $signed(_T_979); // @[FixedPointTypeClass.scala 31:68]
  assign _T_983 = $signed(_T_982); // @[FixedPointTypeClass.scala 31:68]
  assign _T_985 = $signed(_T_978) + $signed(_T_980); // @[FixedPointTypeClass.scala 21:58]
  assign _T_986 = $signed(_T_985); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_18 = {{33{io_in_bits_1_real[31]}},io_in_bits_1_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_19 = $signed(_GEN_18) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_20 = {{2{_GEN_19[64]}},_GEN_19}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_991 = $signed(_GEN_20) + $signed(_T_983); // @[FixedPointTypeClass.scala 21:58]
  assign _T_992 = $signed(_T_991); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_21 = {{33{io_in_bits_1_imag[31]}},io_in_bits_1_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_22 = $signed(_GEN_21) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_23 = {{2{_GEN_22[64]}},_GEN_22}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_994 = $signed(_GEN_23) + $signed(_T_986); // @[FixedPointTypeClass.scala 21:58]
  assign _T_995 = $signed(_T_994); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1000 = $signed(_GEN_20) - $signed(_T_983); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1001 = $signed(_T_1000); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1003 = $signed(_GEN_23) - $signed(_T_986); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1004 = $signed(_T_1003); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1014 = $signed(io_in_bits_18_real) + $signed(io_in_bits_18_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1015 = $signed(_T_1014); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1017 = $signed(io_in_bits_18_imag) - $signed(io_in_bits_18_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1018 = $signed(_T_1017); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_30 = {{3{io_in_bits_18_real[31]}},io_in_bits_18_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1019 = $signed(_GEN_30) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_31 = {{3{_T_1015[31]}},_T_1015}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1020 = $signed(_GEN_31) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_32 = {{3{_T_1018[31]}},_T_1018}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1021 = $signed(_GEN_32) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1023 = $signed(_T_1019) - $signed(_T_1020); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1024 = $signed(_T_1023); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1026 = $signed(_T_1019) + $signed(_T_1021); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1027 = $signed(_T_1026); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_33 = {{33{io_in_bits_2_real[31]}},io_in_bits_2_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_34 = $signed(_GEN_33) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_35 = {{2{_GEN_34[64]}},_GEN_34}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1032 = $signed(_GEN_35) + $signed(_T_1024); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1033 = $signed(_T_1032); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_36 = {{33{io_in_bits_2_imag[31]}},io_in_bits_2_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_37 = $signed(_GEN_36) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_38 = {{2{_GEN_37[64]}},_GEN_37}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1035 = $signed(_GEN_38) + $signed(_T_1027); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1036 = $signed(_T_1035); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1041 = $signed(_GEN_35) - $signed(_T_1024); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1042 = $signed(_T_1041); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1044 = $signed(_GEN_38) - $signed(_T_1027); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1045 = $signed(_T_1044); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1055 = $signed(io_in_bits_19_real) + $signed(io_in_bits_19_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1056 = $signed(_T_1055); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1058 = $signed(io_in_bits_19_imag) - $signed(io_in_bits_19_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1059 = $signed(_T_1058); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_45 = {{3{io_in_bits_19_real[31]}},io_in_bits_19_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1060 = $signed(_GEN_45) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_46 = {{3{_T_1056[31]}},_T_1056}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1061 = $signed(_GEN_46) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_47 = {{3{_T_1059[31]}},_T_1059}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1062 = $signed(_GEN_47) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1064 = $signed(_T_1060) - $signed(_T_1061); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1065 = $signed(_T_1064); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1067 = $signed(_T_1060) + $signed(_T_1062); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1068 = $signed(_T_1067); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_48 = {{33{io_in_bits_3_real[31]}},io_in_bits_3_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_49 = $signed(_GEN_48) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_50 = {{2{_GEN_49[64]}},_GEN_49}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1073 = $signed(_GEN_50) + $signed(_T_1065); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1074 = $signed(_T_1073); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_51 = {{33{io_in_bits_3_imag[31]}},io_in_bits_3_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_52 = $signed(_GEN_51) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_53 = {{2{_GEN_52[64]}},_GEN_52}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1076 = $signed(_GEN_53) + $signed(_T_1068); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1077 = $signed(_T_1076); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1082 = $signed(_GEN_50) - $signed(_T_1065); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1083 = $signed(_T_1082); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1085 = $signed(_GEN_53) - $signed(_T_1068); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1086 = $signed(_T_1085); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1096 = $signed(io_in_bits_20_real) + $signed(io_in_bits_20_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1097 = $signed(_T_1096); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1099 = $signed(io_in_bits_20_imag) - $signed(io_in_bits_20_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1100 = $signed(_T_1099); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_60 = {{3{io_in_bits_20_real[31]}},io_in_bits_20_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1101 = $signed(_GEN_60) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_61 = {{3{_T_1097[31]}},_T_1097}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1102 = $signed(_GEN_61) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_62 = {{3{_T_1100[31]}},_T_1100}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1103 = $signed(_GEN_62) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1105 = $signed(_T_1101) - $signed(_T_1102); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1106 = $signed(_T_1105); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1108 = $signed(_T_1101) + $signed(_T_1103); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1109 = $signed(_T_1108); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_63 = {{33{io_in_bits_4_real[31]}},io_in_bits_4_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_64 = $signed(_GEN_63) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_65 = {{2{_GEN_64[64]}},_GEN_64}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1114 = $signed(_GEN_65) + $signed(_T_1106); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1115 = $signed(_T_1114); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_66 = {{33{io_in_bits_4_imag[31]}},io_in_bits_4_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_67 = $signed(_GEN_66) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_68 = {{2{_GEN_67[64]}},_GEN_67}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1117 = $signed(_GEN_68) + $signed(_T_1109); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1118 = $signed(_T_1117); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1123 = $signed(_GEN_65) - $signed(_T_1106); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1124 = $signed(_T_1123); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1126 = $signed(_GEN_68) - $signed(_T_1109); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1127 = $signed(_T_1126); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1137 = $signed(io_in_bits_21_real) + $signed(io_in_bits_21_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1138 = $signed(_T_1137); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1140 = $signed(io_in_bits_21_imag) - $signed(io_in_bits_21_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1141 = $signed(_T_1140); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_75 = {{3{io_in_bits_21_real[31]}},io_in_bits_21_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1142 = $signed(_GEN_75) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_76 = {{3{_T_1138[31]}},_T_1138}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1143 = $signed(_GEN_76) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_77 = {{3{_T_1141[31]}},_T_1141}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1144 = $signed(_GEN_77) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1146 = $signed(_T_1142) - $signed(_T_1143); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1147 = $signed(_T_1146); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1149 = $signed(_T_1142) + $signed(_T_1144); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1150 = $signed(_T_1149); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_78 = {{33{io_in_bits_5_real[31]}},io_in_bits_5_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_79 = $signed(_GEN_78) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_80 = {{2{_GEN_79[64]}},_GEN_79}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1155 = $signed(_GEN_80) + $signed(_T_1147); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1156 = $signed(_T_1155); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_81 = {{33{io_in_bits_5_imag[31]}},io_in_bits_5_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_82 = $signed(_GEN_81) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_83 = {{2{_GEN_82[64]}},_GEN_82}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1158 = $signed(_GEN_83) + $signed(_T_1150); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1159 = $signed(_T_1158); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1164 = $signed(_GEN_80) - $signed(_T_1147); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1165 = $signed(_T_1164); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1167 = $signed(_GEN_83) - $signed(_T_1150); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1168 = $signed(_T_1167); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1178 = $signed(io_in_bits_22_real) + $signed(io_in_bits_22_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1179 = $signed(_T_1178); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1181 = $signed(io_in_bits_22_imag) - $signed(io_in_bits_22_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1182 = $signed(_T_1181); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_90 = {{3{io_in_bits_22_real[31]}},io_in_bits_22_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1183 = $signed(_GEN_90) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_91 = {{3{_T_1179[31]}},_T_1179}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1184 = $signed(_GEN_91) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_92 = {{3{_T_1182[31]}},_T_1182}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1185 = $signed(_GEN_92) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1187 = $signed(_T_1183) - $signed(_T_1184); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1188 = $signed(_T_1187); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1190 = $signed(_T_1183) + $signed(_T_1185); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1191 = $signed(_T_1190); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_93 = {{33{io_in_bits_6_real[31]}},io_in_bits_6_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_94 = $signed(_GEN_93) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_95 = {{2{_GEN_94[64]}},_GEN_94}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1196 = $signed(_GEN_95) + $signed(_T_1188); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1197 = $signed(_T_1196); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_96 = {{33{io_in_bits_6_imag[31]}},io_in_bits_6_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_97 = $signed(_GEN_96) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_98 = {{2{_GEN_97[64]}},_GEN_97}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1199 = $signed(_GEN_98) + $signed(_T_1191); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1200 = $signed(_T_1199); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1205 = $signed(_GEN_95) - $signed(_T_1188); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1206 = $signed(_T_1205); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1208 = $signed(_GEN_98) - $signed(_T_1191); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1209 = $signed(_T_1208); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1219 = $signed(io_in_bits_23_real) + $signed(io_in_bits_23_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1220 = $signed(_T_1219); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1222 = $signed(io_in_bits_23_imag) - $signed(io_in_bits_23_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1223 = $signed(_T_1222); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_105 = {{3{io_in_bits_23_real[31]}},io_in_bits_23_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1224 = $signed(_GEN_105) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_106 = {{3{_T_1220[31]}},_T_1220}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1225 = $signed(_GEN_106) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_107 = {{3{_T_1223[31]}},_T_1223}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1226 = $signed(_GEN_107) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1228 = $signed(_T_1224) - $signed(_T_1225); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1229 = $signed(_T_1228); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1231 = $signed(_T_1224) + $signed(_T_1226); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1232 = $signed(_T_1231); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_108 = {{33{io_in_bits_7_real[31]}},io_in_bits_7_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_109 = $signed(_GEN_108) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_110 = {{2{_GEN_109[64]}},_GEN_109}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1237 = $signed(_GEN_110) + $signed(_T_1229); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1238 = $signed(_T_1237); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_111 = {{33{io_in_bits_7_imag[31]}},io_in_bits_7_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_112 = $signed(_GEN_111) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_113 = {{2{_GEN_112[64]}},_GEN_112}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1240 = $signed(_GEN_113) + $signed(_T_1232); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1241 = $signed(_T_1240); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1246 = $signed(_GEN_110) - $signed(_T_1229); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1247 = $signed(_T_1246); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1249 = $signed(_GEN_113) - $signed(_T_1232); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1250 = $signed(_T_1249); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1260 = $signed(io_in_bits_24_real) + $signed(io_in_bits_24_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1261 = $signed(_T_1260); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1263 = $signed(io_in_bits_24_imag) - $signed(io_in_bits_24_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1264 = $signed(_T_1263); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_120 = {{3{io_in_bits_24_real[31]}},io_in_bits_24_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1265 = $signed(_GEN_120) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_121 = {{3{_T_1261[31]}},_T_1261}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1266 = $signed(_GEN_121) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_122 = {{3{_T_1264[31]}},_T_1264}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1267 = $signed(_GEN_122) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1269 = $signed(_T_1265) - $signed(_T_1266); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1270 = $signed(_T_1269); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1272 = $signed(_T_1265) + $signed(_T_1267); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1273 = $signed(_T_1272); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_123 = {{33{io_in_bits_8_real[31]}},io_in_bits_8_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_124 = $signed(_GEN_123) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_125 = {{2{_GEN_124[64]}},_GEN_124}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1278 = $signed(_GEN_125) + $signed(_T_1270); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1279 = $signed(_T_1278); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_126 = {{33{io_in_bits_8_imag[31]}},io_in_bits_8_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_127 = $signed(_GEN_126) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_128 = {{2{_GEN_127[64]}},_GEN_127}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1281 = $signed(_GEN_128) + $signed(_T_1273); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1282 = $signed(_T_1281); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1287 = $signed(_GEN_125) - $signed(_T_1270); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1288 = $signed(_T_1287); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1290 = $signed(_GEN_128) - $signed(_T_1273); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1291 = $signed(_T_1290); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1301 = $signed(io_in_bits_25_real) + $signed(io_in_bits_25_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1302 = $signed(_T_1301); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1304 = $signed(io_in_bits_25_imag) - $signed(io_in_bits_25_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1305 = $signed(_T_1304); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_135 = {{3{io_in_bits_25_real[31]}},io_in_bits_25_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1306 = $signed(_GEN_135) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_136 = {{3{_T_1302[31]}},_T_1302}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1307 = $signed(_GEN_136) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_137 = {{3{_T_1305[31]}},_T_1305}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1308 = $signed(_GEN_137) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1310 = $signed(_T_1306) - $signed(_T_1307); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1311 = $signed(_T_1310); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1313 = $signed(_T_1306) + $signed(_T_1308); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1314 = $signed(_T_1313); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_138 = {{33{io_in_bits_9_real[31]}},io_in_bits_9_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_139 = $signed(_GEN_138) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_140 = {{2{_GEN_139[64]}},_GEN_139}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1319 = $signed(_GEN_140) + $signed(_T_1311); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1320 = $signed(_T_1319); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_141 = {{33{io_in_bits_9_imag[31]}},io_in_bits_9_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_142 = $signed(_GEN_141) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_143 = {{2{_GEN_142[64]}},_GEN_142}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1322 = $signed(_GEN_143) + $signed(_T_1314); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1323 = $signed(_T_1322); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1328 = $signed(_GEN_140) - $signed(_T_1311); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1329 = $signed(_T_1328); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1331 = $signed(_GEN_143) - $signed(_T_1314); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1332 = $signed(_T_1331); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1342 = $signed(io_in_bits_26_real) + $signed(io_in_bits_26_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1343 = $signed(_T_1342); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1345 = $signed(io_in_bits_26_imag) - $signed(io_in_bits_26_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1346 = $signed(_T_1345); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_150 = {{3{io_in_bits_26_real[31]}},io_in_bits_26_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1347 = $signed(_GEN_150) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_151 = {{3{_T_1343[31]}},_T_1343}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1348 = $signed(_GEN_151) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_152 = {{3{_T_1346[31]}},_T_1346}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1349 = $signed(_GEN_152) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1351 = $signed(_T_1347) - $signed(_T_1348); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1352 = $signed(_T_1351); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1354 = $signed(_T_1347) + $signed(_T_1349); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1355 = $signed(_T_1354); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_153 = {{33{io_in_bits_10_real[31]}},io_in_bits_10_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_154 = $signed(_GEN_153) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_155 = {{2{_GEN_154[64]}},_GEN_154}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1360 = $signed(_GEN_155) + $signed(_T_1352); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1361 = $signed(_T_1360); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_156 = {{33{io_in_bits_10_imag[31]}},io_in_bits_10_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_157 = $signed(_GEN_156) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_158 = {{2{_GEN_157[64]}},_GEN_157}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1363 = $signed(_GEN_158) + $signed(_T_1355); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1364 = $signed(_T_1363); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1369 = $signed(_GEN_155) - $signed(_T_1352); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1370 = $signed(_T_1369); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1372 = $signed(_GEN_158) - $signed(_T_1355); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1373 = $signed(_T_1372); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1383 = $signed(io_in_bits_27_real) + $signed(io_in_bits_27_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1384 = $signed(_T_1383); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1386 = $signed(io_in_bits_27_imag) - $signed(io_in_bits_27_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1387 = $signed(_T_1386); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_165 = {{3{io_in_bits_27_real[31]}},io_in_bits_27_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1388 = $signed(_GEN_165) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_166 = {{3{_T_1384[31]}},_T_1384}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1389 = $signed(_GEN_166) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_167 = {{3{_T_1387[31]}},_T_1387}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1390 = $signed(_GEN_167) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1392 = $signed(_T_1388) - $signed(_T_1389); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1393 = $signed(_T_1392); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1395 = $signed(_T_1388) + $signed(_T_1390); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1396 = $signed(_T_1395); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_168 = {{33{io_in_bits_11_real[31]}},io_in_bits_11_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_169 = $signed(_GEN_168) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_170 = {{2{_GEN_169[64]}},_GEN_169}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1401 = $signed(_GEN_170) + $signed(_T_1393); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1402 = $signed(_T_1401); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_171 = {{33{io_in_bits_11_imag[31]}},io_in_bits_11_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_172 = $signed(_GEN_171) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_173 = {{2{_GEN_172[64]}},_GEN_172}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1404 = $signed(_GEN_173) + $signed(_T_1396); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1405 = $signed(_T_1404); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1410 = $signed(_GEN_170) - $signed(_T_1393); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1411 = $signed(_T_1410); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1413 = $signed(_GEN_173) - $signed(_T_1396); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1414 = $signed(_T_1413); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1424 = $signed(io_in_bits_28_real) + $signed(io_in_bits_28_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1425 = $signed(_T_1424); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1427 = $signed(io_in_bits_28_imag) - $signed(io_in_bits_28_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1428 = $signed(_T_1427); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_180 = {{3{io_in_bits_28_real[31]}},io_in_bits_28_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1429 = $signed(_GEN_180) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_181 = {{3{_T_1425[31]}},_T_1425}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1430 = $signed(_GEN_181) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_182 = {{3{_T_1428[31]}},_T_1428}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1431 = $signed(_GEN_182) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1433 = $signed(_T_1429) - $signed(_T_1430); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1434 = $signed(_T_1433); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1436 = $signed(_T_1429) + $signed(_T_1431); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1437 = $signed(_T_1436); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_183 = {{33{io_in_bits_12_real[31]}},io_in_bits_12_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_184 = $signed(_GEN_183) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_185 = {{2{_GEN_184[64]}},_GEN_184}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1442 = $signed(_GEN_185) + $signed(_T_1434); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1443 = $signed(_T_1442); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_186 = {{33{io_in_bits_12_imag[31]}},io_in_bits_12_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_187 = $signed(_GEN_186) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_188 = {{2{_GEN_187[64]}},_GEN_187}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1445 = $signed(_GEN_188) + $signed(_T_1437); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1446 = $signed(_T_1445); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1451 = $signed(_GEN_185) - $signed(_T_1434); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1452 = $signed(_T_1451); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1454 = $signed(_GEN_188) - $signed(_T_1437); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1455 = $signed(_T_1454); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1465 = $signed(io_in_bits_29_real) + $signed(io_in_bits_29_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1466 = $signed(_T_1465); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1468 = $signed(io_in_bits_29_imag) - $signed(io_in_bits_29_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1469 = $signed(_T_1468); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_195 = {{3{io_in_bits_29_real[31]}},io_in_bits_29_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1470 = $signed(_GEN_195) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_196 = {{3{_T_1466[31]}},_T_1466}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1471 = $signed(_GEN_196) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_197 = {{3{_T_1469[31]}},_T_1469}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1472 = $signed(_GEN_197) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1474 = $signed(_T_1470) - $signed(_T_1471); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1475 = $signed(_T_1474); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1477 = $signed(_T_1470) + $signed(_T_1472); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1478 = $signed(_T_1477); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_198 = {{33{io_in_bits_13_real[31]}},io_in_bits_13_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_199 = $signed(_GEN_198) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_200 = {{2{_GEN_199[64]}},_GEN_199}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1483 = $signed(_GEN_200) + $signed(_T_1475); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1484 = $signed(_T_1483); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_201 = {{33{io_in_bits_13_imag[31]}},io_in_bits_13_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_202 = $signed(_GEN_201) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_203 = {{2{_GEN_202[64]}},_GEN_202}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1486 = $signed(_GEN_203) + $signed(_T_1478); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1487 = $signed(_T_1486); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1492 = $signed(_GEN_200) - $signed(_T_1475); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1493 = $signed(_T_1492); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1495 = $signed(_GEN_203) - $signed(_T_1478); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1496 = $signed(_T_1495); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1506 = $signed(io_in_bits_30_real) + $signed(io_in_bits_30_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1507 = $signed(_T_1506); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1509 = $signed(io_in_bits_30_imag) - $signed(io_in_bits_30_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1510 = $signed(_T_1509); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_210 = {{3{io_in_bits_30_real[31]}},io_in_bits_30_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1511 = $signed(_GEN_210) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_211 = {{3{_T_1507[31]}},_T_1507}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1512 = $signed(_GEN_211) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_212 = {{3{_T_1510[31]}},_T_1510}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1513 = $signed(_GEN_212) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1515 = $signed(_T_1511) - $signed(_T_1512); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1516 = $signed(_T_1515); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1518 = $signed(_T_1511) + $signed(_T_1513); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1519 = $signed(_T_1518); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_213 = {{33{io_in_bits_14_real[31]}},io_in_bits_14_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_214 = $signed(_GEN_213) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_215 = {{2{_GEN_214[64]}},_GEN_214}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1524 = $signed(_GEN_215) + $signed(_T_1516); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1525 = $signed(_T_1524); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_216 = {{33{io_in_bits_14_imag[31]}},io_in_bits_14_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_217 = $signed(_GEN_216) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_218 = {{2{_GEN_217[64]}},_GEN_217}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1527 = $signed(_GEN_218) + $signed(_T_1519); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1528 = $signed(_T_1527); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1533 = $signed(_GEN_215) - $signed(_T_1516); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1534 = $signed(_T_1533); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1536 = $signed(_GEN_218) - $signed(_T_1519); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1537 = $signed(_T_1536); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1547 = $signed(io_in_bits_31_real) + $signed(io_in_bits_31_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1548 = $signed(_T_1547); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1550 = $signed(io_in_bits_31_imag) - $signed(io_in_bits_31_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1551 = $signed(_T_1550); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_225 = {{3{io_in_bits_31_real[31]}},io_in_bits_31_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1552 = $signed(_GEN_225) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_226 = {{3{_T_1548[31]}},_T_1548}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1553 = $signed(_GEN_226) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_227 = {{3{_T_1551[31]}},_T_1551}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1554 = $signed(_GEN_227) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1556 = $signed(_T_1552) - $signed(_T_1553); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1557 = $signed(_T_1556); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1559 = $signed(_T_1552) + $signed(_T_1554); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1560 = $signed(_T_1559); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_228 = {{33{io_in_bits_15_real[31]}},io_in_bits_15_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_229 = $signed(_GEN_228) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_230 = {{2{_GEN_229[64]}},_GEN_229}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1565 = $signed(_GEN_230) + $signed(_T_1557); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1566 = $signed(_T_1565); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_231 = {{33{io_in_bits_15_imag[31]}},io_in_bits_15_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_232 = $signed(_GEN_231) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_233 = {{2{_GEN_232[64]}},_GEN_232}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1568 = $signed(_GEN_233) + $signed(_T_1560); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1569 = $signed(_T_1568); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1574 = $signed(_GEN_230) - $signed(_T_1557); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1575 = $signed(_T_1574); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1577 = $signed(_GEN_233) - $signed(_T_1560); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1578 = $signed(_T_1577); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_240 = _T_1279[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_241 = _GEN_240[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_472_real = $signed(_GEN_241); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_242 = _T_1282[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_243 = _GEN_242[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_472_imag = $signed(_GEN_243); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_1588 = $signed(_T_472_real) + $signed(_T_472_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1589 = $signed(_T_1588); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1591 = $signed(_T_472_imag) - $signed(_T_472_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1592 = $signed(_T_1591); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_244 = {{3{_T_472_real[31]}},_T_472_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1593 = $signed(_GEN_244) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_245 = {{3{_T_1589[31]}},_T_1589}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1594 = $signed(_GEN_245) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_246 = {{3{_T_1592[31]}},_T_1592}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1595 = $signed(_GEN_246) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1597 = $signed(_T_1593) - $signed(_T_1594); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1598 = $signed(_T_1597); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1600 = $signed(_T_1593) + $signed(_T_1595); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1601 = $signed(_T_1600); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_247 = _T_951[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_248 = _GEN_247[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_448_real = $signed(_GEN_248); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_249 = {{33{_T_448_real[31]}},_T_448_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_250 = $signed(_GEN_249) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_251 = {{2{_GEN_250[64]}},_GEN_250}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1606 = $signed(_GEN_251) + $signed(_T_1598); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1607 = $signed(_T_1606); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_252 = _T_954[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_253 = _GEN_252[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_448_imag = $signed(_GEN_253); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_254 = {{33{_T_448_imag[31]}},_T_448_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_255 = $signed(_GEN_254) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_256 = {{2{_GEN_255[64]}},_GEN_255}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1609 = $signed(_GEN_256) + $signed(_T_1601); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1610 = $signed(_T_1609); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1615 = $signed(_GEN_251) - $signed(_T_1598); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1616 = $signed(_T_1615); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1618 = $signed(_GEN_256) - $signed(_T_1601); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1619 = $signed(_T_1618); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_263 = _T_1320[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_264 = _GEN_263[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_475_real = $signed(_GEN_264); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_265 = _T_1323[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_266 = _GEN_265[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_475_imag = $signed(_GEN_266); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_1629 = $signed(_T_475_real) + $signed(_T_475_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1630 = $signed(_T_1629); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1632 = $signed(_T_475_imag) - $signed(_T_475_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1633 = $signed(_T_1632); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_267 = {{3{_T_475_real[31]}},_T_475_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1634 = $signed(_GEN_267) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_268 = {{3{_T_1630[31]}},_T_1630}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1635 = $signed(_GEN_268) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_269 = {{3{_T_1633[31]}},_T_1633}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1636 = $signed(_GEN_269) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1638 = $signed(_T_1634) - $signed(_T_1635); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1639 = $signed(_T_1638); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1641 = $signed(_T_1634) + $signed(_T_1636); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1642 = $signed(_T_1641); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_270 = _T_992[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_271 = _GEN_270[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_451_real = $signed(_GEN_271); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_272 = {{33{_T_451_real[31]}},_T_451_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_273 = $signed(_GEN_272) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_274 = {{2{_GEN_273[64]}},_GEN_273}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1647 = $signed(_GEN_274) + $signed(_T_1639); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1648 = $signed(_T_1647); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_275 = _T_995[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_276 = _GEN_275[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_451_imag = $signed(_GEN_276); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_277 = {{33{_T_451_imag[31]}},_T_451_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_278 = $signed(_GEN_277) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_279 = {{2{_GEN_278[64]}},_GEN_278}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1650 = $signed(_GEN_279) + $signed(_T_1642); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1651 = $signed(_T_1650); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1656 = $signed(_GEN_274) - $signed(_T_1639); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1657 = $signed(_T_1656); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1659 = $signed(_GEN_279) - $signed(_T_1642); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1660 = $signed(_T_1659); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_286 = _T_1361[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_287 = _GEN_286[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_478_real = $signed(_GEN_287); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_288 = _T_1364[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_289 = _GEN_288[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_478_imag = $signed(_GEN_289); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_1670 = $signed(_T_478_real) + $signed(_T_478_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1671 = $signed(_T_1670); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1673 = $signed(_T_478_imag) - $signed(_T_478_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1674 = $signed(_T_1673); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_290 = {{3{_T_478_real[31]}},_T_478_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1675 = $signed(_GEN_290) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_291 = {{3{_T_1671[31]}},_T_1671}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1676 = $signed(_GEN_291) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_292 = {{3{_T_1674[31]}},_T_1674}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1677 = $signed(_GEN_292) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1679 = $signed(_T_1675) - $signed(_T_1676); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1680 = $signed(_T_1679); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1682 = $signed(_T_1675) + $signed(_T_1677); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1683 = $signed(_T_1682); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_293 = _T_1033[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_294 = _GEN_293[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_454_real = $signed(_GEN_294); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_295 = {{33{_T_454_real[31]}},_T_454_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_296 = $signed(_GEN_295) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_297 = {{2{_GEN_296[64]}},_GEN_296}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1688 = $signed(_GEN_297) + $signed(_T_1680); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1689 = $signed(_T_1688); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_298 = _T_1036[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_299 = _GEN_298[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_454_imag = $signed(_GEN_299); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_300 = {{33{_T_454_imag[31]}},_T_454_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_301 = $signed(_GEN_300) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_302 = {{2{_GEN_301[64]}},_GEN_301}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1691 = $signed(_GEN_302) + $signed(_T_1683); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1692 = $signed(_T_1691); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1697 = $signed(_GEN_297) - $signed(_T_1680); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1698 = $signed(_T_1697); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1700 = $signed(_GEN_302) - $signed(_T_1683); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1701 = $signed(_T_1700); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_309 = _T_1402[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_310 = _GEN_309[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_481_real = $signed(_GEN_310); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_311 = _T_1405[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_312 = _GEN_311[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_481_imag = $signed(_GEN_312); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_1711 = $signed(_T_481_real) + $signed(_T_481_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1712 = $signed(_T_1711); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1714 = $signed(_T_481_imag) - $signed(_T_481_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1715 = $signed(_T_1714); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_313 = {{3{_T_481_real[31]}},_T_481_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1716 = $signed(_GEN_313) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_314 = {{3{_T_1712[31]}},_T_1712}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1717 = $signed(_GEN_314) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_315 = {{3{_T_1715[31]}},_T_1715}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1718 = $signed(_GEN_315) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1720 = $signed(_T_1716) - $signed(_T_1717); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1721 = $signed(_T_1720); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1723 = $signed(_T_1716) + $signed(_T_1718); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1724 = $signed(_T_1723); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_316 = _T_1074[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_317 = _GEN_316[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_457_real = $signed(_GEN_317); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_318 = {{33{_T_457_real[31]}},_T_457_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_319 = $signed(_GEN_318) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_320 = {{2{_GEN_319[64]}},_GEN_319}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1729 = $signed(_GEN_320) + $signed(_T_1721); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1730 = $signed(_T_1729); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_321 = _T_1077[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_322 = _GEN_321[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_457_imag = $signed(_GEN_322); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_323 = {{33{_T_457_imag[31]}},_T_457_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_324 = $signed(_GEN_323) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_325 = {{2{_GEN_324[64]}},_GEN_324}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1732 = $signed(_GEN_325) + $signed(_T_1724); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1733 = $signed(_T_1732); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1738 = $signed(_GEN_320) - $signed(_T_1721); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1739 = $signed(_T_1738); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1741 = $signed(_GEN_325) - $signed(_T_1724); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1742 = $signed(_T_1741); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_332 = _T_1443[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_333 = _GEN_332[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_484_real = $signed(_GEN_333); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_334 = _T_1446[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_335 = _GEN_334[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_484_imag = $signed(_GEN_335); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_1752 = $signed(_T_484_real) + $signed(_T_484_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1753 = $signed(_T_1752); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1755 = $signed(_T_484_imag) - $signed(_T_484_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1756 = $signed(_T_1755); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_336 = {{3{_T_484_real[31]}},_T_484_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1757 = $signed(_GEN_336) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_337 = {{3{_T_1753[31]}},_T_1753}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1758 = $signed(_GEN_337) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_338 = {{3{_T_1756[31]}},_T_1756}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1759 = $signed(_GEN_338) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1761 = $signed(_T_1757) - $signed(_T_1758); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1762 = $signed(_T_1761); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1764 = $signed(_T_1757) + $signed(_T_1759); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1765 = $signed(_T_1764); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_339 = _T_1115[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_340 = _GEN_339[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_460_real = $signed(_GEN_340); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_341 = {{33{_T_460_real[31]}},_T_460_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_342 = $signed(_GEN_341) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_343 = {{2{_GEN_342[64]}},_GEN_342}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1770 = $signed(_GEN_343) + $signed(_T_1762); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1771 = $signed(_T_1770); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_344 = _T_1118[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_345 = _GEN_344[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_460_imag = $signed(_GEN_345); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_346 = {{33{_T_460_imag[31]}},_T_460_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_347 = $signed(_GEN_346) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_348 = {{2{_GEN_347[64]}},_GEN_347}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1773 = $signed(_GEN_348) + $signed(_T_1765); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1774 = $signed(_T_1773); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1779 = $signed(_GEN_343) - $signed(_T_1762); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1780 = $signed(_T_1779); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1782 = $signed(_GEN_348) - $signed(_T_1765); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1783 = $signed(_T_1782); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_355 = _T_1484[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_356 = _GEN_355[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_487_real = $signed(_GEN_356); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_357 = _T_1487[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_358 = _GEN_357[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_487_imag = $signed(_GEN_358); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_1793 = $signed(_T_487_real) + $signed(_T_487_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1794 = $signed(_T_1793); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1796 = $signed(_T_487_imag) - $signed(_T_487_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1797 = $signed(_T_1796); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_359 = {{3{_T_487_real[31]}},_T_487_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1798 = $signed(_GEN_359) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_360 = {{3{_T_1794[31]}},_T_1794}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1799 = $signed(_GEN_360) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_361 = {{3{_T_1797[31]}},_T_1797}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1800 = $signed(_GEN_361) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1802 = $signed(_T_1798) - $signed(_T_1799); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1803 = $signed(_T_1802); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1805 = $signed(_T_1798) + $signed(_T_1800); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1806 = $signed(_T_1805); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_362 = _T_1156[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_363 = _GEN_362[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_463_real = $signed(_GEN_363); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_364 = {{33{_T_463_real[31]}},_T_463_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_365 = $signed(_GEN_364) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_366 = {{2{_GEN_365[64]}},_GEN_365}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1811 = $signed(_GEN_366) + $signed(_T_1803); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1812 = $signed(_T_1811); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_367 = _T_1159[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_368 = _GEN_367[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_463_imag = $signed(_GEN_368); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_369 = {{33{_T_463_imag[31]}},_T_463_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_370 = $signed(_GEN_369) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_371 = {{2{_GEN_370[64]}},_GEN_370}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1814 = $signed(_GEN_371) + $signed(_T_1806); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1815 = $signed(_T_1814); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1820 = $signed(_GEN_366) - $signed(_T_1803); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1821 = $signed(_T_1820); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1823 = $signed(_GEN_371) - $signed(_T_1806); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1824 = $signed(_T_1823); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_378 = _T_1525[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_379 = _GEN_378[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_490_real = $signed(_GEN_379); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_380 = _T_1528[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_381 = _GEN_380[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_490_imag = $signed(_GEN_381); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_1834 = $signed(_T_490_real) + $signed(_T_490_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1835 = $signed(_T_1834); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1837 = $signed(_T_490_imag) - $signed(_T_490_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1838 = $signed(_T_1837); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_382 = {{3{_T_490_real[31]}},_T_490_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1839 = $signed(_GEN_382) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_383 = {{3{_T_1835[31]}},_T_1835}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1840 = $signed(_GEN_383) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_384 = {{3{_T_1838[31]}},_T_1838}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1841 = $signed(_GEN_384) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1843 = $signed(_T_1839) - $signed(_T_1840); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1844 = $signed(_T_1843); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1846 = $signed(_T_1839) + $signed(_T_1841); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1847 = $signed(_T_1846); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_385 = _T_1197[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_386 = _GEN_385[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_466_real = $signed(_GEN_386); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_387 = {{33{_T_466_real[31]}},_T_466_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_388 = $signed(_GEN_387) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_389 = {{2{_GEN_388[64]}},_GEN_388}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1852 = $signed(_GEN_389) + $signed(_T_1844); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1853 = $signed(_T_1852); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_390 = _T_1200[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_391 = _GEN_390[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_466_imag = $signed(_GEN_391); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_392 = {{33{_T_466_imag[31]}},_T_466_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_393 = $signed(_GEN_392) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_394 = {{2{_GEN_393[64]}},_GEN_393}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1855 = $signed(_GEN_394) + $signed(_T_1847); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1856 = $signed(_T_1855); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1861 = $signed(_GEN_389) - $signed(_T_1844); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1862 = $signed(_T_1861); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1864 = $signed(_GEN_394) - $signed(_T_1847); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1865 = $signed(_T_1864); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_401 = _T_1566[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_402 = _GEN_401[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_493_real = $signed(_GEN_402); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_403 = _T_1569[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_404 = _GEN_403[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_493_imag = $signed(_GEN_404); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_1875 = $signed(_T_493_real) + $signed(_T_493_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1876 = $signed(_T_1875); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1878 = $signed(_T_493_imag) - $signed(_T_493_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1879 = $signed(_T_1878); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_405 = {{3{_T_493_real[31]}},_T_493_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1880 = $signed(_GEN_405) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_406 = {{3{_T_1876[31]}},_T_1876}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1881 = $signed(_GEN_406) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_407 = {{3{_T_1879[31]}},_T_1879}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1882 = $signed(_GEN_407) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1884 = $signed(_T_1880) - $signed(_T_1881); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1885 = $signed(_T_1884); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1887 = $signed(_T_1880) + $signed(_T_1882); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1888 = $signed(_T_1887); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_408 = _T_1238[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_409 = _GEN_408[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_469_real = $signed(_GEN_409); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_410 = {{33{_T_469_real[31]}},_T_469_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_411 = $signed(_GEN_410) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_412 = {{2{_GEN_411[64]}},_GEN_411}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1893 = $signed(_GEN_412) + $signed(_T_1885); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1894 = $signed(_T_1893); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_413 = _T_1241[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_414 = _GEN_413[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_469_imag = $signed(_GEN_414); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_415 = {{33{_T_469_imag[31]}},_T_469_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_416 = $signed(_GEN_415) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_417 = {{2{_GEN_416[64]}},_GEN_416}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1896 = $signed(_GEN_417) + $signed(_T_1888); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1897 = $signed(_T_1896); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1902 = $signed(_GEN_412) - $signed(_T_1885); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1903 = $signed(_T_1902); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1905 = $signed(_GEN_417) - $signed(_T_1888); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1906 = $signed(_T_1905); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_424 = _T_1288[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_425 = _GEN_424[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_520_real = $signed(_GEN_425); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_426 = _T_1291[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_427 = _GEN_426[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_520_imag = $signed(_GEN_427); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_1916 = $signed(_T_520_real) + $signed(_T_520_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1917 = $signed(_T_1916); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1919 = $signed(_T_520_imag) - $signed(_T_520_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1920 = $signed(_T_1919); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_428 = {{3{_T_520_real[31]}},_T_520_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1921 = $signed(_GEN_428) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_429 = {{3{_T_1917[31]}},_T_1917}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1922 = $signed(_GEN_429) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_430 = {{3{_T_1920[31]}},_T_1920}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1923 = $signed(_GEN_430) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1925 = $signed(_T_1921) - $signed(_T_1922); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1926 = $signed(_T_1925); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1928 = $signed(_T_1921) + $signed(_T_1923); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1929 = $signed(_T_1928); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_431 = _T_960[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_432 = _GEN_431[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_496_real = $signed(_GEN_432); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_433 = {{33{_T_496_real[31]}},_T_496_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_434 = $signed(_GEN_433) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_435 = {{2{_GEN_434[64]}},_GEN_434}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1934 = $signed(_GEN_435) + $signed(_T_1926); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1935 = $signed(_T_1934); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_436 = _T_963[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_437 = _GEN_436[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_496_imag = $signed(_GEN_437); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_438 = {{33{_T_496_imag[31]}},_T_496_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_439 = $signed(_GEN_438) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_440 = {{2{_GEN_439[64]}},_GEN_439}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1937 = $signed(_GEN_440) + $signed(_T_1929); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1938 = $signed(_T_1937); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1943 = $signed(_GEN_435) - $signed(_T_1926); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1944 = $signed(_T_1943); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1946 = $signed(_GEN_440) - $signed(_T_1929); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1947 = $signed(_T_1946); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_447 = _T_1329[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_448 = _GEN_447[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_523_real = $signed(_GEN_448); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_449 = _T_1332[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_450 = _GEN_449[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_523_imag = $signed(_GEN_450); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_1957 = $signed(_T_523_real) + $signed(_T_523_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1958 = $signed(_T_1957); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1960 = $signed(_T_523_imag) - $signed(_T_523_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1961 = $signed(_T_1960); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_451 = {{3{_T_523_real[31]}},_T_523_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1962 = $signed(_GEN_451) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_452 = {{3{_T_1958[31]}},_T_1958}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1963 = $signed(_GEN_452) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_453 = {{3{_T_1961[31]}},_T_1961}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_1964 = $signed(_GEN_453) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1966 = $signed(_T_1962) - $signed(_T_1963); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1967 = $signed(_T_1966); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1969 = $signed(_T_1962) + $signed(_T_1964); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1970 = $signed(_T_1969); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_454 = _T_1001[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_455 = _GEN_454[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_499_real = $signed(_GEN_455); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_456 = {{33{_T_499_real[31]}},_T_499_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_457 = $signed(_GEN_456) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_458 = {{2{_GEN_457[64]}},_GEN_457}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1975 = $signed(_GEN_458) + $signed(_T_1967); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1976 = $signed(_T_1975); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_459 = _T_1004[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_460 = _GEN_459[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_499_imag = $signed(_GEN_460); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_461 = {{33{_T_499_imag[31]}},_T_499_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_462 = $signed(_GEN_461) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_463 = {{2{_GEN_462[64]}},_GEN_462}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_1978 = $signed(_GEN_463) + $signed(_T_1970); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1979 = $signed(_T_1978); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1984 = $signed(_GEN_458) - $signed(_T_1967); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1985 = $signed(_T_1984); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1987 = $signed(_GEN_463) - $signed(_T_1970); // @[FixedPointTypeClass.scala 31:68]
  assign _T_1988 = $signed(_T_1987); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_470 = _T_1370[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_471 = _GEN_470[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_526_real = $signed(_GEN_471); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_472 = _T_1373[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_473 = _GEN_472[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_526_imag = $signed(_GEN_473); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_1998 = $signed(_T_526_real) + $signed(_T_526_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_1999 = $signed(_T_1998); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2001 = $signed(_T_526_imag) - $signed(_T_526_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2002 = $signed(_T_2001); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_474 = {{3{_T_526_real[31]}},_T_526_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2003 = $signed(_GEN_474) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_475 = {{3{_T_1999[31]}},_T_1999}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2004 = $signed(_GEN_475) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_476 = {{3{_T_2002[31]}},_T_2002}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2005 = $signed(_GEN_476) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2007 = $signed(_T_2003) - $signed(_T_2004); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2008 = $signed(_T_2007); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2010 = $signed(_T_2003) + $signed(_T_2005); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2011 = $signed(_T_2010); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_477 = _T_1042[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_478 = _GEN_477[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_502_real = $signed(_GEN_478); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_479 = {{33{_T_502_real[31]}},_T_502_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_480 = $signed(_GEN_479) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_481 = {{2{_GEN_480[64]}},_GEN_480}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2016 = $signed(_GEN_481) + $signed(_T_2008); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2017 = $signed(_T_2016); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_482 = _T_1045[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_483 = _GEN_482[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_502_imag = $signed(_GEN_483); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_484 = {{33{_T_502_imag[31]}},_T_502_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_485 = $signed(_GEN_484) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_486 = {{2{_GEN_485[64]}},_GEN_485}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2019 = $signed(_GEN_486) + $signed(_T_2011); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2020 = $signed(_T_2019); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2025 = $signed(_GEN_481) - $signed(_T_2008); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2026 = $signed(_T_2025); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2028 = $signed(_GEN_486) - $signed(_T_2011); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2029 = $signed(_T_2028); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_493 = _T_1411[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_494 = _GEN_493[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_529_real = $signed(_GEN_494); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_495 = _T_1414[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_496 = _GEN_495[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_529_imag = $signed(_GEN_496); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2039 = $signed(_T_529_real) + $signed(_T_529_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2040 = $signed(_T_2039); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2042 = $signed(_T_529_imag) - $signed(_T_529_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2043 = $signed(_T_2042); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_497 = {{3{_T_529_real[31]}},_T_529_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2044 = $signed(_GEN_497) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_498 = {{3{_T_2040[31]}},_T_2040}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2045 = $signed(_GEN_498) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_499 = {{3{_T_2043[31]}},_T_2043}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2046 = $signed(_GEN_499) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2048 = $signed(_T_2044) - $signed(_T_2045); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2049 = $signed(_T_2048); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2051 = $signed(_T_2044) + $signed(_T_2046); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2052 = $signed(_T_2051); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_500 = _T_1083[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_501 = _GEN_500[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_505_real = $signed(_GEN_501); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_502 = {{33{_T_505_real[31]}},_T_505_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_503 = $signed(_GEN_502) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_504 = {{2{_GEN_503[64]}},_GEN_503}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2057 = $signed(_GEN_504) + $signed(_T_2049); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2058 = $signed(_T_2057); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_505 = _T_1086[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_506 = _GEN_505[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_505_imag = $signed(_GEN_506); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_507 = {{33{_T_505_imag[31]}},_T_505_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_508 = $signed(_GEN_507) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_509 = {{2{_GEN_508[64]}},_GEN_508}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2060 = $signed(_GEN_509) + $signed(_T_2052); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2061 = $signed(_T_2060); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2066 = $signed(_GEN_504) - $signed(_T_2049); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2067 = $signed(_T_2066); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2069 = $signed(_GEN_509) - $signed(_T_2052); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2070 = $signed(_T_2069); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_516 = _T_1452[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_517 = _GEN_516[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_532_real = $signed(_GEN_517); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_518 = _T_1455[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_519 = _GEN_518[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_532_imag = $signed(_GEN_519); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2080 = $signed(_T_532_real) + $signed(_T_532_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2081 = $signed(_T_2080); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2083 = $signed(_T_532_imag) - $signed(_T_532_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2084 = $signed(_T_2083); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_520 = {{3{_T_532_real[31]}},_T_532_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2085 = $signed(_GEN_520) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_521 = {{3{_T_2081[31]}},_T_2081}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2086 = $signed(_GEN_521) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_522 = {{3{_T_2084[31]}},_T_2084}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2087 = $signed(_GEN_522) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2089 = $signed(_T_2085) - $signed(_T_2086); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2090 = $signed(_T_2089); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2092 = $signed(_T_2085) + $signed(_T_2087); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2093 = $signed(_T_2092); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_523 = _T_1124[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_524 = _GEN_523[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_508_real = $signed(_GEN_524); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_525 = {{33{_T_508_real[31]}},_T_508_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_526 = $signed(_GEN_525) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_527 = {{2{_GEN_526[64]}},_GEN_526}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2098 = $signed(_GEN_527) + $signed(_T_2090); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2099 = $signed(_T_2098); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_528 = _T_1127[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_529 = _GEN_528[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_508_imag = $signed(_GEN_529); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_530 = {{33{_T_508_imag[31]}},_T_508_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_531 = $signed(_GEN_530) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_532 = {{2{_GEN_531[64]}},_GEN_531}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2101 = $signed(_GEN_532) + $signed(_T_2093); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2102 = $signed(_T_2101); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2107 = $signed(_GEN_527) - $signed(_T_2090); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2108 = $signed(_T_2107); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2110 = $signed(_GEN_532) - $signed(_T_2093); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2111 = $signed(_T_2110); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_539 = _T_1493[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_540 = _GEN_539[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_535_real = $signed(_GEN_540); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_541 = _T_1496[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_542 = _GEN_541[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_535_imag = $signed(_GEN_542); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2121 = $signed(_T_535_real) + $signed(_T_535_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2122 = $signed(_T_2121); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2124 = $signed(_T_535_imag) - $signed(_T_535_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2125 = $signed(_T_2124); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_543 = {{3{_T_535_real[31]}},_T_535_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2126 = $signed(_GEN_543) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_544 = {{3{_T_2122[31]}},_T_2122}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2127 = $signed(_GEN_544) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_545 = {{3{_T_2125[31]}},_T_2125}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2128 = $signed(_GEN_545) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2130 = $signed(_T_2126) - $signed(_T_2127); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2131 = $signed(_T_2130); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2133 = $signed(_T_2126) + $signed(_T_2128); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2134 = $signed(_T_2133); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_546 = _T_1165[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_547 = _GEN_546[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_511_real = $signed(_GEN_547); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_548 = {{33{_T_511_real[31]}},_T_511_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_549 = $signed(_GEN_548) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_550 = {{2{_GEN_549[64]}},_GEN_549}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2139 = $signed(_GEN_550) + $signed(_T_2131); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2140 = $signed(_T_2139); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_551 = _T_1168[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_552 = _GEN_551[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_511_imag = $signed(_GEN_552); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_553 = {{33{_T_511_imag[31]}},_T_511_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_554 = $signed(_GEN_553) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_555 = {{2{_GEN_554[64]}},_GEN_554}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2142 = $signed(_GEN_555) + $signed(_T_2134); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2143 = $signed(_T_2142); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2148 = $signed(_GEN_550) - $signed(_T_2131); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2149 = $signed(_T_2148); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2151 = $signed(_GEN_555) - $signed(_T_2134); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2152 = $signed(_T_2151); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_562 = _T_1534[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_563 = _GEN_562[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_538_real = $signed(_GEN_563); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_564 = _T_1537[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_565 = _GEN_564[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_538_imag = $signed(_GEN_565); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2162 = $signed(_T_538_real) + $signed(_T_538_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2163 = $signed(_T_2162); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2165 = $signed(_T_538_imag) - $signed(_T_538_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2166 = $signed(_T_2165); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_566 = {{3{_T_538_real[31]}},_T_538_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2167 = $signed(_GEN_566) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_567 = {{3{_T_2163[31]}},_T_2163}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2168 = $signed(_GEN_567) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_568 = {{3{_T_2166[31]}},_T_2166}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2169 = $signed(_GEN_568) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2171 = $signed(_T_2167) - $signed(_T_2168); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2172 = $signed(_T_2171); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2174 = $signed(_T_2167) + $signed(_T_2169); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2175 = $signed(_T_2174); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_569 = _T_1206[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_570 = _GEN_569[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_514_real = $signed(_GEN_570); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_571 = {{33{_T_514_real[31]}},_T_514_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_572 = $signed(_GEN_571) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_573 = {{2{_GEN_572[64]}},_GEN_572}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2180 = $signed(_GEN_573) + $signed(_T_2172); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2181 = $signed(_T_2180); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_574 = _T_1209[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_575 = _GEN_574[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_514_imag = $signed(_GEN_575); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_576 = {{33{_T_514_imag[31]}},_T_514_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_577 = $signed(_GEN_576) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_578 = {{2{_GEN_577[64]}},_GEN_577}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2183 = $signed(_GEN_578) + $signed(_T_2175); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2184 = $signed(_T_2183); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2189 = $signed(_GEN_573) - $signed(_T_2172); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2190 = $signed(_T_2189); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2192 = $signed(_GEN_578) - $signed(_T_2175); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2193 = $signed(_T_2192); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_585 = _T_1575[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_586 = _GEN_585[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_541_real = $signed(_GEN_586); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_587 = _T_1578[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_588 = _GEN_587[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_541_imag = $signed(_GEN_588); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2203 = $signed(_T_541_real) + $signed(_T_541_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2204 = $signed(_T_2203); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2206 = $signed(_T_541_imag) - $signed(_T_541_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2207 = $signed(_T_2206); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_589 = {{3{_T_541_real[31]}},_T_541_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2208 = $signed(_GEN_589) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_590 = {{3{_T_2204[31]}},_T_2204}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2209 = $signed(_GEN_590) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_591 = {{3{_T_2207[31]}},_T_2207}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2210 = $signed(_GEN_591) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2212 = $signed(_T_2208) - $signed(_T_2209); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2213 = $signed(_T_2212); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2215 = $signed(_T_2208) + $signed(_T_2210); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2216 = $signed(_T_2215); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_592 = _T_1247[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_593 = _GEN_592[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_517_real = $signed(_GEN_593); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_594 = {{33{_T_517_real[31]}},_T_517_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_595 = $signed(_GEN_594) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_596 = {{2{_GEN_595[64]}},_GEN_595}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2221 = $signed(_GEN_596) + $signed(_T_2213); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2222 = $signed(_T_2221); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_597 = _T_1250[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_598 = _GEN_597[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_517_imag = $signed(_GEN_598); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_599 = {{33{_T_517_imag[31]}},_T_517_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_600 = $signed(_GEN_599) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_601 = {{2{_GEN_600[64]}},_GEN_600}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2224 = $signed(_GEN_601) + $signed(_T_2216); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2225 = $signed(_T_2224); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2230 = $signed(_GEN_596) - $signed(_T_2213); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2231 = $signed(_T_2230); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2233 = $signed(_GEN_601) - $signed(_T_2216); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2234 = $signed(_T_2233); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_608 = _T_1771[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_609 = _GEN_608[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_556_real = $signed(_GEN_609); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_610 = _T_1774[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_611 = _GEN_610[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_556_imag = $signed(_GEN_611); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2244 = $signed(_T_556_real) + $signed(_T_556_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2245 = $signed(_T_2244); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2247 = $signed(_T_556_imag) - $signed(_T_556_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2248 = $signed(_T_2247); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_612 = {{3{_T_556_real[31]}},_T_556_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2249 = $signed(_GEN_612) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_613 = {{3{_T_2245[31]}},_T_2245}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2250 = $signed(_GEN_613) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_614 = {{3{_T_2248[31]}},_T_2248}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2251 = $signed(_GEN_614) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2253 = $signed(_T_2249) - $signed(_T_2250); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2254 = $signed(_T_2253); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2256 = $signed(_T_2249) + $signed(_T_2251); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2257 = $signed(_T_2256); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_615 = _T_1607[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_616 = _GEN_615[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_544_real = $signed(_GEN_616); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_617 = {{33{_T_544_real[31]}},_T_544_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_618 = $signed(_GEN_617) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_619 = {{2{_GEN_618[64]}},_GEN_618}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2262 = $signed(_GEN_619) + $signed(_T_2254); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2263 = $signed(_T_2262); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_620 = _T_1610[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_621 = _GEN_620[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_544_imag = $signed(_GEN_621); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_622 = {{33{_T_544_imag[31]}},_T_544_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_623 = $signed(_GEN_622) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_624 = {{2{_GEN_623[64]}},_GEN_623}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2265 = $signed(_GEN_624) + $signed(_T_2257); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2266 = $signed(_T_2265); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2271 = $signed(_GEN_619) - $signed(_T_2254); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2272 = $signed(_T_2271); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2274 = $signed(_GEN_624) - $signed(_T_2257); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2275 = $signed(_T_2274); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_631 = _T_1812[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_632 = _GEN_631[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_559_real = $signed(_GEN_632); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_633 = _T_1815[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_634 = _GEN_633[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_559_imag = $signed(_GEN_634); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2285 = $signed(_T_559_real) + $signed(_T_559_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2286 = $signed(_T_2285); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2288 = $signed(_T_559_imag) - $signed(_T_559_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2289 = $signed(_T_2288); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_635 = {{3{_T_559_real[31]}},_T_559_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2290 = $signed(_GEN_635) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_636 = {{3{_T_2286[31]}},_T_2286}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2291 = $signed(_GEN_636) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_637 = {{3{_T_2289[31]}},_T_2289}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2292 = $signed(_GEN_637) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2294 = $signed(_T_2290) - $signed(_T_2291); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2295 = $signed(_T_2294); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2297 = $signed(_T_2290) + $signed(_T_2292); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2298 = $signed(_T_2297); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_638 = _T_1648[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_639 = _GEN_638[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_547_real = $signed(_GEN_639); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_640 = {{33{_T_547_real[31]}},_T_547_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_641 = $signed(_GEN_640) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_642 = {{2{_GEN_641[64]}},_GEN_641}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2303 = $signed(_GEN_642) + $signed(_T_2295); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2304 = $signed(_T_2303); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_643 = _T_1651[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_644 = _GEN_643[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_547_imag = $signed(_GEN_644); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_645 = {{33{_T_547_imag[31]}},_T_547_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_646 = $signed(_GEN_645) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_647 = {{2{_GEN_646[64]}},_GEN_646}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2306 = $signed(_GEN_647) + $signed(_T_2298); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2307 = $signed(_T_2306); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2312 = $signed(_GEN_642) - $signed(_T_2295); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2313 = $signed(_T_2312); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2315 = $signed(_GEN_647) - $signed(_T_2298); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2316 = $signed(_T_2315); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_654 = _T_1853[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_655 = _GEN_654[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_562_real = $signed(_GEN_655); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_656 = _T_1856[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_657 = _GEN_656[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_562_imag = $signed(_GEN_657); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2326 = $signed(_T_562_real) + $signed(_T_562_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2327 = $signed(_T_2326); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2329 = $signed(_T_562_imag) - $signed(_T_562_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2330 = $signed(_T_2329); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_658 = {{3{_T_562_real[31]}},_T_562_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2331 = $signed(_GEN_658) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_659 = {{3{_T_2327[31]}},_T_2327}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2332 = $signed(_GEN_659) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_660 = {{3{_T_2330[31]}},_T_2330}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2333 = $signed(_GEN_660) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2335 = $signed(_T_2331) - $signed(_T_2332); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2336 = $signed(_T_2335); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2338 = $signed(_T_2331) + $signed(_T_2333); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2339 = $signed(_T_2338); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_661 = _T_1689[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_662 = _GEN_661[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_550_real = $signed(_GEN_662); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_663 = {{33{_T_550_real[31]}},_T_550_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_664 = $signed(_GEN_663) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_665 = {{2{_GEN_664[64]}},_GEN_664}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2344 = $signed(_GEN_665) + $signed(_T_2336); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2345 = $signed(_T_2344); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_666 = _T_1692[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_667 = _GEN_666[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_550_imag = $signed(_GEN_667); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_668 = {{33{_T_550_imag[31]}},_T_550_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_669 = $signed(_GEN_668) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_670 = {{2{_GEN_669[64]}},_GEN_669}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2347 = $signed(_GEN_670) + $signed(_T_2339); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2348 = $signed(_T_2347); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2353 = $signed(_GEN_665) - $signed(_T_2336); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2354 = $signed(_T_2353); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2356 = $signed(_GEN_670) - $signed(_T_2339); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2357 = $signed(_T_2356); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_677 = _T_1894[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_678 = _GEN_677[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_565_real = $signed(_GEN_678); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_679 = _T_1897[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_680 = _GEN_679[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_565_imag = $signed(_GEN_680); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2367 = $signed(_T_565_real) + $signed(_T_565_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2368 = $signed(_T_2367); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2370 = $signed(_T_565_imag) - $signed(_T_565_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2371 = $signed(_T_2370); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_681 = {{3{_T_565_real[31]}},_T_565_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2372 = $signed(_GEN_681) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_682 = {{3{_T_2368[31]}},_T_2368}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2373 = $signed(_GEN_682) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_683 = {{3{_T_2371[31]}},_T_2371}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2374 = $signed(_GEN_683) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2376 = $signed(_T_2372) - $signed(_T_2373); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2377 = $signed(_T_2376); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2379 = $signed(_T_2372) + $signed(_T_2374); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2380 = $signed(_T_2379); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_684 = _T_1730[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_685 = _GEN_684[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_553_real = $signed(_GEN_685); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_686 = {{33{_T_553_real[31]}},_T_553_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_687 = $signed(_GEN_686) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_688 = {{2{_GEN_687[64]}},_GEN_687}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2385 = $signed(_GEN_688) + $signed(_T_2377); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2386 = $signed(_T_2385); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_689 = _T_1733[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_690 = _GEN_689[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_553_imag = $signed(_GEN_690); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_691 = {{33{_T_553_imag[31]}},_T_553_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_692 = $signed(_GEN_691) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_693 = {{2{_GEN_692[64]}},_GEN_692}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2388 = $signed(_GEN_693) + $signed(_T_2380); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2389 = $signed(_T_2388); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2394 = $signed(_GEN_688) - $signed(_T_2377); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2395 = $signed(_T_2394); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2397 = $signed(_GEN_693) - $signed(_T_2380); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2398 = $signed(_T_2397); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_700 = _T_1780[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_701 = _GEN_700[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_580_real = $signed(_GEN_701); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_702 = _T_1783[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_703 = _GEN_702[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_580_imag = $signed(_GEN_703); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2408 = $signed(_T_580_real) + $signed(_T_580_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2409 = $signed(_T_2408); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2411 = $signed(_T_580_imag) - $signed(_T_580_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2412 = $signed(_T_2411); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_704 = {{3{_T_580_real[31]}},_T_580_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2413 = $signed(_GEN_704) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_705 = {{3{_T_2409[31]}},_T_2409}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2414 = $signed(_GEN_705) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_706 = {{3{_T_2412[31]}},_T_2412}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2415 = $signed(_GEN_706) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2417 = $signed(_T_2413) - $signed(_T_2414); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2418 = $signed(_T_2417); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2420 = $signed(_T_2413) + $signed(_T_2415); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2421 = $signed(_T_2420); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_707 = _T_1616[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_708 = _GEN_707[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_568_real = $signed(_GEN_708); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_709 = {{33{_T_568_real[31]}},_T_568_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_710 = $signed(_GEN_709) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_711 = {{2{_GEN_710[64]}},_GEN_710}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2426 = $signed(_GEN_711) + $signed(_T_2418); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2427 = $signed(_T_2426); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_712 = _T_1619[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_713 = _GEN_712[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_568_imag = $signed(_GEN_713); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_714 = {{33{_T_568_imag[31]}},_T_568_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_715 = $signed(_GEN_714) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_716 = {{2{_GEN_715[64]}},_GEN_715}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2429 = $signed(_GEN_716) + $signed(_T_2421); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2430 = $signed(_T_2429); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2435 = $signed(_GEN_711) - $signed(_T_2418); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2436 = $signed(_T_2435); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2438 = $signed(_GEN_716) - $signed(_T_2421); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2439 = $signed(_T_2438); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_723 = _T_1821[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_724 = _GEN_723[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_583_real = $signed(_GEN_724); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_725 = _T_1824[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_726 = _GEN_725[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_583_imag = $signed(_GEN_726); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2449 = $signed(_T_583_real) + $signed(_T_583_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2450 = $signed(_T_2449); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2452 = $signed(_T_583_imag) - $signed(_T_583_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2453 = $signed(_T_2452); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_727 = {{3{_T_583_real[31]}},_T_583_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2454 = $signed(_GEN_727) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_728 = {{3{_T_2450[31]}},_T_2450}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2455 = $signed(_GEN_728) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_729 = {{3{_T_2453[31]}},_T_2453}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2456 = $signed(_GEN_729) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2458 = $signed(_T_2454) - $signed(_T_2455); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2459 = $signed(_T_2458); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2461 = $signed(_T_2454) + $signed(_T_2456); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2462 = $signed(_T_2461); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_730 = _T_1657[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_731 = _GEN_730[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_571_real = $signed(_GEN_731); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_732 = {{33{_T_571_real[31]}},_T_571_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_733 = $signed(_GEN_732) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_734 = {{2{_GEN_733[64]}},_GEN_733}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2467 = $signed(_GEN_734) + $signed(_T_2459); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2468 = $signed(_T_2467); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_735 = _T_1660[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_736 = _GEN_735[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_571_imag = $signed(_GEN_736); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_737 = {{33{_T_571_imag[31]}},_T_571_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_738 = $signed(_GEN_737) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_739 = {{2{_GEN_738[64]}},_GEN_738}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2470 = $signed(_GEN_739) + $signed(_T_2462); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2471 = $signed(_T_2470); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2476 = $signed(_GEN_734) - $signed(_T_2459); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2477 = $signed(_T_2476); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2479 = $signed(_GEN_739) - $signed(_T_2462); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2480 = $signed(_T_2479); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_746 = _T_1862[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_747 = _GEN_746[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_586_real = $signed(_GEN_747); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_748 = _T_1865[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_749 = _GEN_748[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_586_imag = $signed(_GEN_749); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2490 = $signed(_T_586_real) + $signed(_T_586_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2491 = $signed(_T_2490); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2493 = $signed(_T_586_imag) - $signed(_T_586_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2494 = $signed(_T_2493); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_750 = {{3{_T_586_real[31]}},_T_586_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2495 = $signed(_GEN_750) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_751 = {{3{_T_2491[31]}},_T_2491}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2496 = $signed(_GEN_751) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_752 = {{3{_T_2494[31]}},_T_2494}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2497 = $signed(_GEN_752) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2499 = $signed(_T_2495) - $signed(_T_2496); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2500 = $signed(_T_2499); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2502 = $signed(_T_2495) + $signed(_T_2497); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2503 = $signed(_T_2502); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_753 = _T_1698[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_754 = _GEN_753[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_574_real = $signed(_GEN_754); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_755 = {{33{_T_574_real[31]}},_T_574_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_756 = $signed(_GEN_755) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_757 = {{2{_GEN_756[64]}},_GEN_756}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2508 = $signed(_GEN_757) + $signed(_T_2500); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2509 = $signed(_T_2508); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_758 = _T_1701[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_759 = _GEN_758[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_574_imag = $signed(_GEN_759); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_760 = {{33{_T_574_imag[31]}},_T_574_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_761 = $signed(_GEN_760) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_762 = {{2{_GEN_761[64]}},_GEN_761}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2511 = $signed(_GEN_762) + $signed(_T_2503); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2512 = $signed(_T_2511); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2517 = $signed(_GEN_757) - $signed(_T_2500); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2518 = $signed(_T_2517); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2520 = $signed(_GEN_762) - $signed(_T_2503); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2521 = $signed(_T_2520); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_769 = _T_1903[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_770 = _GEN_769[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_589_real = $signed(_GEN_770); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_771 = _T_1906[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_772 = _GEN_771[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_589_imag = $signed(_GEN_772); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2531 = $signed(_T_589_real) + $signed(_T_589_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2532 = $signed(_T_2531); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2534 = $signed(_T_589_imag) - $signed(_T_589_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2535 = $signed(_T_2534); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_773 = {{3{_T_589_real[31]}},_T_589_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2536 = $signed(_GEN_773) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_774 = {{3{_T_2532[31]}},_T_2532}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2537 = $signed(_GEN_774) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_775 = {{3{_T_2535[31]}},_T_2535}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2538 = $signed(_GEN_775) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2540 = $signed(_T_2536) - $signed(_T_2537); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2541 = $signed(_T_2540); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2543 = $signed(_T_2536) + $signed(_T_2538); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2544 = $signed(_T_2543); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_776 = _T_1739[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_777 = _GEN_776[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_577_real = $signed(_GEN_777); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_778 = {{33{_T_577_real[31]}},_T_577_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_779 = $signed(_GEN_778) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_780 = {{2{_GEN_779[64]}},_GEN_779}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2549 = $signed(_GEN_780) + $signed(_T_2541); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2550 = $signed(_T_2549); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_781 = _T_1742[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_782 = _GEN_781[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_577_imag = $signed(_GEN_782); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_783 = {{33{_T_577_imag[31]}},_T_577_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_784 = $signed(_GEN_783) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_785 = {{2{_GEN_784[64]}},_GEN_784}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2552 = $signed(_GEN_785) + $signed(_T_2544); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2553 = $signed(_T_2552); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2558 = $signed(_GEN_780) - $signed(_T_2541); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2559 = $signed(_T_2558); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2561 = $signed(_GEN_785) - $signed(_T_2544); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2562 = $signed(_T_2561); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_792 = _T_2099[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_793 = _GEN_792[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_604_real = $signed(_GEN_793); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_794 = _T_2102[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_795 = _GEN_794[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_604_imag = $signed(_GEN_795); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2572 = $signed(_T_604_real) + $signed(_T_604_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2573 = $signed(_T_2572); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2575 = $signed(_T_604_imag) - $signed(_T_604_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2576 = $signed(_T_2575); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_796 = {{3{_T_604_real[31]}},_T_604_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2577 = $signed(_GEN_796) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_797 = {{3{_T_2573[31]}},_T_2573}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2578 = $signed(_GEN_797) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_798 = {{3{_T_2576[31]}},_T_2576}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2579 = $signed(_GEN_798) * $signed(35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2581 = $signed(_T_2577) - $signed(_T_2578); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2582 = $signed(_T_2581); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2584 = $signed(_T_2577) + $signed(_T_2579); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2585 = $signed(_T_2584); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_799 = _T_1935[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_800 = _GEN_799[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_592_real = $signed(_GEN_800); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_801 = {{33{_T_592_real[31]}},_T_592_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_802 = $signed(_GEN_801) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_803 = {{2{_GEN_802[64]}},_GEN_802}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2590 = $signed(_GEN_803) + $signed(_T_2582); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2591 = $signed(_T_2590); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_804 = _T_1938[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_805 = _GEN_804[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_592_imag = $signed(_GEN_805); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_806 = {{33{_T_592_imag[31]}},_T_592_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_807 = $signed(_GEN_806) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_808 = {{2{_GEN_807[64]}},_GEN_807}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2593 = $signed(_GEN_808) + $signed(_T_2585); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2594 = $signed(_T_2593); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2599 = $signed(_GEN_803) - $signed(_T_2582); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2600 = $signed(_T_2599); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2602 = $signed(_GEN_808) - $signed(_T_2585); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2603 = $signed(_T_2602); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_815 = _T_2140[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_816 = _GEN_815[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_607_real = $signed(_GEN_816); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_817 = _T_2143[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_818 = _GEN_817[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_607_imag = $signed(_GEN_818); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2613 = $signed(_T_607_real) + $signed(_T_607_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2614 = $signed(_T_2613); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2616 = $signed(_T_607_imag) - $signed(_T_607_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2617 = $signed(_T_2616); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_819 = {{3{_T_607_real[31]}},_T_607_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2618 = $signed(_GEN_819) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_820 = {{3{_T_2614[31]}},_T_2614}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2619 = $signed(_GEN_820) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_821 = {{3{_T_2617[31]}},_T_2617}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2620 = $signed(_GEN_821) * $signed(35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2622 = $signed(_T_2618) - $signed(_T_2619); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2623 = $signed(_T_2622); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2625 = $signed(_T_2618) + $signed(_T_2620); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2626 = $signed(_T_2625); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_822 = _T_1976[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_823 = _GEN_822[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_595_real = $signed(_GEN_823); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_824 = {{33{_T_595_real[31]}},_T_595_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_825 = $signed(_GEN_824) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_826 = {{2{_GEN_825[64]}},_GEN_825}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2631 = $signed(_GEN_826) + $signed(_T_2623); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2632 = $signed(_T_2631); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_827 = _T_1979[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_828 = _GEN_827[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_595_imag = $signed(_GEN_828); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_829 = {{33{_T_595_imag[31]}},_T_595_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_830 = $signed(_GEN_829) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_831 = {{2{_GEN_830[64]}},_GEN_830}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2634 = $signed(_GEN_831) + $signed(_T_2626); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2635 = $signed(_T_2634); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2640 = $signed(_GEN_826) - $signed(_T_2623); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2641 = $signed(_T_2640); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2643 = $signed(_GEN_831) - $signed(_T_2626); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2644 = $signed(_T_2643); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_838 = _T_2181[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_839 = _GEN_838[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_610_real = $signed(_GEN_839); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_840 = _T_2184[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_841 = _GEN_840[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_610_imag = $signed(_GEN_841); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2654 = $signed(_T_610_real) + $signed(_T_610_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2655 = $signed(_T_2654); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2657 = $signed(_T_610_imag) - $signed(_T_610_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2658 = $signed(_T_2657); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_842 = {{3{_T_610_real[31]}},_T_610_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2659 = $signed(_GEN_842) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_843 = {{3{_T_2655[31]}},_T_2655}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2660 = $signed(_GEN_843) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_844 = {{3{_T_2658[31]}},_T_2658}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2661 = $signed(_GEN_844) * $signed(35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2663 = $signed(_T_2659) - $signed(_T_2660); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2664 = $signed(_T_2663); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2666 = $signed(_T_2659) + $signed(_T_2661); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2667 = $signed(_T_2666); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_845 = _T_2017[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_846 = _GEN_845[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_598_real = $signed(_GEN_846); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_847 = {{33{_T_598_real[31]}},_T_598_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_848 = $signed(_GEN_847) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_849 = {{2{_GEN_848[64]}},_GEN_848}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2672 = $signed(_GEN_849) + $signed(_T_2664); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2673 = $signed(_T_2672); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_850 = _T_2020[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_851 = _GEN_850[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_598_imag = $signed(_GEN_851); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_852 = {{33{_T_598_imag[31]}},_T_598_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_853 = $signed(_GEN_852) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_854 = {{2{_GEN_853[64]}},_GEN_853}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2675 = $signed(_GEN_854) + $signed(_T_2667); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2676 = $signed(_T_2675); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2681 = $signed(_GEN_849) - $signed(_T_2664); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2682 = $signed(_T_2681); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2684 = $signed(_GEN_854) - $signed(_T_2667); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2685 = $signed(_T_2684); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_861 = _T_2222[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_862 = _GEN_861[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_613_real = $signed(_GEN_862); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_863 = _T_2225[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_864 = _GEN_863[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_613_imag = $signed(_GEN_864); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2695 = $signed(_T_613_real) + $signed(_T_613_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2696 = $signed(_T_2695); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2698 = $signed(_T_613_imag) - $signed(_T_613_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2699 = $signed(_T_2698); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_865 = {{3{_T_613_real[31]}},_T_613_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2700 = $signed(_GEN_865) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_866 = {{3{_T_2696[31]}},_T_2696}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2701 = $signed(_GEN_866) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_867 = {{3{_T_2699[31]}},_T_2699}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2702 = $signed(_GEN_867) * $signed(35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2704 = $signed(_T_2700) - $signed(_T_2701); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2705 = $signed(_T_2704); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2707 = $signed(_T_2700) + $signed(_T_2702); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2708 = $signed(_T_2707); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_868 = _T_2058[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_869 = _GEN_868[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_601_real = $signed(_GEN_869); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_870 = {{33{_T_601_real[31]}},_T_601_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_871 = $signed(_GEN_870) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_872 = {{2{_GEN_871[64]}},_GEN_871}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2713 = $signed(_GEN_872) + $signed(_T_2705); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2714 = $signed(_T_2713); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_873 = _T_2061[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_874 = _GEN_873[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_601_imag = $signed(_GEN_874); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_875 = {{33{_T_601_imag[31]}},_T_601_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_876 = $signed(_GEN_875) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_877 = {{2{_GEN_876[64]}},_GEN_876}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2716 = $signed(_GEN_877) + $signed(_T_2708); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2717 = $signed(_T_2716); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2722 = $signed(_GEN_872) - $signed(_T_2705); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2723 = $signed(_T_2722); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2725 = $signed(_GEN_877) - $signed(_T_2708); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2726 = $signed(_T_2725); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_884 = _T_2108[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_885 = _GEN_884[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_628_real = $signed(_GEN_885); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_886 = _T_2111[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_887 = _GEN_886[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_628_imag = $signed(_GEN_887); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2736 = $signed(_T_628_real) + $signed(_T_628_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2737 = $signed(_T_2736); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2739 = $signed(_T_628_imag) - $signed(_T_628_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2740 = $signed(_T_2739); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_888 = {{3{_T_628_real[31]}},_T_628_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2741 = $signed(_GEN_888) * $signed(-35'sh2d413ccd0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_889 = {{3{_T_2737[31]}},_T_2737}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2742 = $signed(_GEN_889) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_890 = {{3{_T_2740[31]}},_T_2740}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2743 = $signed(_GEN_890) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2745 = $signed(_T_2741) - $signed(_T_2742); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2746 = $signed(_T_2745); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2748 = $signed(_T_2741) + $signed(_T_2743); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2749 = $signed(_T_2748); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_891 = _T_1944[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_892 = _GEN_891[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_616_real = $signed(_GEN_892); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_893 = {{33{_T_616_real[31]}},_T_616_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_894 = $signed(_GEN_893) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_895 = {{2{_GEN_894[64]}},_GEN_894}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2754 = $signed(_GEN_895) + $signed(_T_2746); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2755 = $signed(_T_2754); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_896 = _T_1947[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_897 = _GEN_896[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_616_imag = $signed(_GEN_897); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_898 = {{33{_T_616_imag[31]}},_T_616_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_899 = $signed(_GEN_898) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_900 = {{2{_GEN_899[64]}},_GEN_899}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2757 = $signed(_GEN_900) + $signed(_T_2749); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2758 = $signed(_T_2757); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2763 = $signed(_GEN_895) - $signed(_T_2746); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2764 = $signed(_T_2763); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2766 = $signed(_GEN_900) - $signed(_T_2749); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2767 = $signed(_T_2766); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_907 = _T_2149[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_908 = _GEN_907[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_631_real = $signed(_GEN_908); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_909 = _T_2152[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_910 = _GEN_909[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_631_imag = $signed(_GEN_910); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2777 = $signed(_T_631_real) + $signed(_T_631_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2778 = $signed(_T_2777); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2780 = $signed(_T_631_imag) - $signed(_T_631_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2781 = $signed(_T_2780); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_911 = {{3{_T_631_real[31]}},_T_631_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2782 = $signed(_GEN_911) * $signed(-35'sh2d413ccd0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_912 = {{3{_T_2778[31]}},_T_2778}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2783 = $signed(_GEN_912) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_913 = {{3{_T_2781[31]}},_T_2781}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2784 = $signed(_GEN_913) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2786 = $signed(_T_2782) - $signed(_T_2783); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2787 = $signed(_T_2786); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2789 = $signed(_T_2782) + $signed(_T_2784); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2790 = $signed(_T_2789); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_914 = _T_1985[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_915 = _GEN_914[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_619_real = $signed(_GEN_915); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_916 = {{33{_T_619_real[31]}},_T_619_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_917 = $signed(_GEN_916) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_918 = {{2{_GEN_917[64]}},_GEN_917}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2795 = $signed(_GEN_918) + $signed(_T_2787); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2796 = $signed(_T_2795); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_919 = _T_1988[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_920 = _GEN_919[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_619_imag = $signed(_GEN_920); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_921 = {{33{_T_619_imag[31]}},_T_619_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_922 = $signed(_GEN_921) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_923 = {{2{_GEN_922[64]}},_GEN_922}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2798 = $signed(_GEN_923) + $signed(_T_2790); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2799 = $signed(_T_2798); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2804 = $signed(_GEN_918) - $signed(_T_2787); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2805 = $signed(_T_2804); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2807 = $signed(_GEN_923) - $signed(_T_2790); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2808 = $signed(_T_2807); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_930 = _T_2190[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_931 = _GEN_930[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_634_real = $signed(_GEN_931); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_932 = _T_2193[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_933 = _GEN_932[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_634_imag = $signed(_GEN_933); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2818 = $signed(_T_634_real) + $signed(_T_634_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2819 = $signed(_T_2818); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2821 = $signed(_T_634_imag) - $signed(_T_634_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2822 = $signed(_T_2821); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_934 = {{3{_T_634_real[31]}},_T_634_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2823 = $signed(_GEN_934) * $signed(-35'sh2d413ccd0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_935 = {{3{_T_2819[31]}},_T_2819}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2824 = $signed(_GEN_935) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_936 = {{3{_T_2822[31]}},_T_2822}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2825 = $signed(_GEN_936) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2827 = $signed(_T_2823) - $signed(_T_2824); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2828 = $signed(_T_2827); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2830 = $signed(_T_2823) + $signed(_T_2825); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2831 = $signed(_T_2830); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_937 = _T_2026[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_938 = _GEN_937[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_622_real = $signed(_GEN_938); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_939 = {{33{_T_622_real[31]}},_T_622_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_940 = $signed(_GEN_939) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_941 = {{2{_GEN_940[64]}},_GEN_940}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2836 = $signed(_GEN_941) + $signed(_T_2828); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2837 = $signed(_T_2836); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_942 = _T_2029[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_943 = _GEN_942[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_622_imag = $signed(_GEN_943); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_944 = {{33{_T_622_imag[31]}},_T_622_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_945 = $signed(_GEN_944) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_946 = {{2{_GEN_945[64]}},_GEN_945}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2839 = $signed(_GEN_946) + $signed(_T_2831); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2840 = $signed(_T_2839); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2845 = $signed(_GEN_941) - $signed(_T_2828); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2846 = $signed(_T_2845); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2848 = $signed(_GEN_946) - $signed(_T_2831); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2849 = $signed(_T_2848); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_953 = _T_2231[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_954 = _GEN_953[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_637_real = $signed(_GEN_954); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_955 = _T_2234[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_956 = _GEN_955[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_637_imag = $signed(_GEN_956); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2859 = $signed(_T_637_real) + $signed(_T_637_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2860 = $signed(_T_2859); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2862 = $signed(_T_637_imag) - $signed(_T_637_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2863 = $signed(_T_2862); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_957 = {{3{_T_637_real[31]}},_T_637_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2864 = $signed(_GEN_957) * $signed(-35'sh2d413ccd0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_958 = {{3{_T_2860[31]}},_T_2860}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2865 = $signed(_GEN_958) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_959 = {{3{_T_2863[31]}},_T_2863}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2866 = $signed(_GEN_959) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2868 = $signed(_T_2864) - $signed(_T_2865); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2869 = $signed(_T_2868); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2871 = $signed(_T_2864) + $signed(_T_2866); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2872 = $signed(_T_2871); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_960 = _T_2067[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_961 = _GEN_960[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_625_real = $signed(_GEN_961); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_962 = {{33{_T_625_real[31]}},_T_625_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_963 = $signed(_GEN_962) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_964 = {{2{_GEN_963[64]}},_GEN_963}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2877 = $signed(_GEN_964) + $signed(_T_2869); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2878 = $signed(_T_2877); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_965 = _T_2070[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_966 = _GEN_965[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_625_imag = $signed(_GEN_966); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_967 = {{33{_T_625_imag[31]}},_T_625_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_968 = $signed(_GEN_967) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_969 = {{2{_GEN_968[64]}},_GEN_968}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2880 = $signed(_GEN_969) + $signed(_T_2872); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2881 = $signed(_T_2880); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2886 = $signed(_GEN_964) - $signed(_T_2869); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2887 = $signed(_T_2886); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2889 = $signed(_GEN_969) - $signed(_T_2872); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2890 = $signed(_T_2889); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_976 = _T_2345[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_977 = _GEN_976[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_646_real = $signed(_GEN_977); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_978 = _T_2348[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_979 = _GEN_978[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_646_imag = $signed(_GEN_979); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2900 = $signed(_T_646_real) + $signed(_T_646_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2901 = $signed(_T_2900); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2903 = $signed(_T_646_imag) - $signed(_T_646_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2904 = $signed(_T_2903); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_980 = {{3{_T_646_real[31]}},_T_646_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2905 = $signed(_GEN_980) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_981 = {{3{_T_2901[31]}},_T_2901}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2906 = $signed(_GEN_981) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_982 = {{3{_T_2904[31]}},_T_2904}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2907 = $signed(_GEN_982) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2909 = $signed(_T_2905) - $signed(_T_2906); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2910 = $signed(_T_2909); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2912 = $signed(_T_2905) + $signed(_T_2907); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2913 = $signed(_T_2912); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_983 = _T_2263[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_984 = _GEN_983[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_640_real = $signed(_GEN_984); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_985 = {{33{_T_640_real[31]}},_T_640_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_986 = $signed(_GEN_985) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_987 = {{2{_GEN_986[64]}},_GEN_986}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_988 = _T_2266[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_989 = _GEN_988[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_640_imag = $signed(_GEN_989); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_990 = {{33{_T_640_imag[31]}},_T_640_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_991 = $signed(_GEN_990) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_992 = {{2{_GEN_991[64]}},_GEN_991}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2927 = $signed(_GEN_987) - $signed(_T_2910); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2928 = $signed(_T_2927); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2930 = $signed(_GEN_992) - $signed(_T_2913); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2931 = $signed(_T_2930); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_999 = _T_2386[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1000 = _GEN_999[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_649_real = $signed(_GEN_1000); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1001 = _T_2389[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1002 = _GEN_1001[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_649_imag = $signed(_GEN_1002); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2941 = $signed(_T_649_real) + $signed(_T_649_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2942 = $signed(_T_2941); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2944 = $signed(_T_649_imag) - $signed(_T_649_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2945 = $signed(_T_2944); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1003 = {{3{_T_649_real[31]}},_T_649_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2946 = $signed(_GEN_1003) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1004 = {{3{_T_2942[31]}},_T_2942}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2947 = $signed(_GEN_1004) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1005 = {{3{_T_2945[31]}},_T_2945}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2948 = $signed(_GEN_1005) * $signed(35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2950 = $signed(_T_2946) - $signed(_T_2947); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2951 = $signed(_T_2950); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2953 = $signed(_T_2946) + $signed(_T_2948); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2954 = $signed(_T_2953); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1006 = _T_2304[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1007 = _GEN_1006[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_643_real = $signed(_GEN_1007); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1008 = {{33{_T_643_real[31]}},_T_643_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1009 = $signed(_GEN_1008) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1010 = {{2{_GEN_1009[64]}},_GEN_1009}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1011 = _T_2307[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1012 = _GEN_1011[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_643_imag = $signed(_GEN_1012); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1013 = {{33{_T_643_imag[31]}},_T_643_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1014 = $signed(_GEN_1013) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1015 = {{2{_GEN_1014[64]}},_GEN_1014}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_2968 = $signed(_GEN_1010) - $signed(_T_2951); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2969 = $signed(_T_2968); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2971 = $signed(_GEN_1015) - $signed(_T_2954); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2972 = $signed(_T_2971); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1022 = _T_2354[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1023 = _GEN_1022[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_658_real = $signed(_GEN_1023); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1024 = _T_2357[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1025 = _GEN_1024[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_658_imag = $signed(_GEN_1025); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_2982 = $signed(_T_658_real) + $signed(_T_658_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2983 = $signed(_T_2982); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2985 = $signed(_T_658_imag) - $signed(_T_658_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2986 = $signed(_T_2985); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1026 = {{3{_T_658_real[31]}},_T_658_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2987 = $signed(_GEN_1026) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1027 = {{3{_T_2983[31]}},_T_2983}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2988 = $signed(_GEN_1027) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1028 = {{3{_T_2986[31]}},_T_2986}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_2989 = $signed(_GEN_1028) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2991 = $signed(_T_2987) - $signed(_T_2988); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2992 = $signed(_T_2991); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2994 = $signed(_T_2987) + $signed(_T_2989); // @[FixedPointTypeClass.scala 21:58]
  assign _T_2995 = $signed(_T_2994); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1029 = _T_2272[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1030 = _GEN_1029[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_652_real = $signed(_GEN_1030); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1031 = {{33{_T_652_real[31]}},_T_652_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1032 = $signed(_GEN_1031) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1033 = {{2{_GEN_1032[64]}},_GEN_1032}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3000 = $signed(_GEN_1033) + $signed(_T_2992); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3001 = $signed(_T_3000); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1034 = _T_2275[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1035 = _GEN_1034[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_652_imag = $signed(_GEN_1035); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1036 = {{33{_T_652_imag[31]}},_T_652_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1037 = $signed(_GEN_1036) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1038 = {{2{_GEN_1037[64]}},_GEN_1037}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3003 = $signed(_GEN_1038) + $signed(_T_2995); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3004 = $signed(_T_3003); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3009 = $signed(_GEN_1033) - $signed(_T_2992); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3010 = $signed(_T_3009); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3012 = $signed(_GEN_1038) - $signed(_T_2995); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3013 = $signed(_T_3012); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1045 = _T_2395[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1046 = _GEN_1045[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_661_real = $signed(_GEN_1046); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1047 = _T_2398[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1048 = _GEN_1047[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_661_imag = $signed(_GEN_1048); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3023 = $signed(_T_661_real) + $signed(_T_661_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3024 = $signed(_T_3023); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3026 = $signed(_T_661_imag) - $signed(_T_661_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3027 = $signed(_T_3026); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1049 = {{3{_T_661_real[31]}},_T_661_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3028 = $signed(_GEN_1049) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1050 = {{3{_T_3024[31]}},_T_3024}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3029 = $signed(_GEN_1050) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1051 = {{3{_T_3027[31]}},_T_3027}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3030 = $signed(_GEN_1051) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3032 = $signed(_T_3028) - $signed(_T_3029); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3033 = $signed(_T_3032); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3035 = $signed(_T_3028) + $signed(_T_3030); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3036 = $signed(_T_3035); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1052 = _T_2313[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1053 = _GEN_1052[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_655_real = $signed(_GEN_1053); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1054 = {{33{_T_655_real[31]}},_T_655_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1055 = $signed(_GEN_1054) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1056 = {{2{_GEN_1055[64]}},_GEN_1055}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3041 = $signed(_GEN_1056) + $signed(_T_3033); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3042 = $signed(_T_3041); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1057 = _T_2316[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1058 = _GEN_1057[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_655_imag = $signed(_GEN_1058); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1059 = {{33{_T_655_imag[31]}},_T_655_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1060 = $signed(_GEN_1059) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1061 = {{2{_GEN_1060[64]}},_GEN_1060}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3044 = $signed(_GEN_1061) + $signed(_T_3036); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3045 = $signed(_T_3044); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3050 = $signed(_GEN_1056) - $signed(_T_3033); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3051 = $signed(_T_3050); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3053 = $signed(_GEN_1061) - $signed(_T_3036); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3054 = $signed(_T_3053); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1068 = _T_2509[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1069 = _GEN_1068[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_670_real = $signed(_GEN_1069); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1070 = _T_2512[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1071 = _GEN_1070[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_670_imag = $signed(_GEN_1071); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3064 = $signed(_T_670_real) + $signed(_T_670_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3065 = $signed(_T_3064); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3067 = $signed(_T_670_imag) - $signed(_T_670_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3068 = $signed(_T_3067); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1072 = {{3{_T_670_real[31]}},_T_670_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3069 = $signed(_GEN_1072) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1073 = {{3{_T_3065[31]}},_T_3065}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3070 = $signed(_GEN_1073) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1074 = {{3{_T_3068[31]}},_T_3068}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3071 = $signed(_GEN_1074) * $signed(35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3073 = $signed(_T_3069) - $signed(_T_3070); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3074 = $signed(_T_3073); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3076 = $signed(_T_3069) + $signed(_T_3071); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3077 = $signed(_T_3076); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1075 = _T_2427[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1076 = _GEN_1075[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_664_real = $signed(_GEN_1076); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1077 = {{33{_T_664_real[31]}},_T_664_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1078 = $signed(_GEN_1077) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1079 = {{2{_GEN_1078[64]}},_GEN_1078}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1080 = _T_2430[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1081 = _GEN_1080[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_664_imag = $signed(_GEN_1081); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1082 = {{33{_T_664_imag[31]}},_T_664_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1083 = $signed(_GEN_1082) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1084 = {{2{_GEN_1083[64]}},_GEN_1083}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3091 = $signed(_GEN_1079) - $signed(_T_3074); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3092 = $signed(_T_3091); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3094 = $signed(_GEN_1084) - $signed(_T_3077); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3095 = $signed(_T_3094); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1091 = _T_2550[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1092 = _GEN_1091[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_673_real = $signed(_GEN_1092); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1093 = _T_2553[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1094 = _GEN_1093[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_673_imag = $signed(_GEN_1094); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3105 = $signed(_T_673_real) + $signed(_T_673_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3106 = $signed(_T_3105); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3108 = $signed(_T_673_imag) - $signed(_T_673_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3109 = $signed(_T_3108); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1095 = {{3{_T_673_real[31]}},_T_673_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3110 = $signed(_GEN_1095) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1096 = {{3{_T_3106[31]}},_T_3106}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3111 = $signed(_GEN_1096) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1097 = {{3{_T_3109[31]}},_T_3109}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3112 = $signed(_GEN_1097) * $signed(35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3114 = $signed(_T_3110) - $signed(_T_3111); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3115 = $signed(_T_3114); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3117 = $signed(_T_3110) + $signed(_T_3112); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3118 = $signed(_T_3117); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1098 = _T_2468[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1099 = _GEN_1098[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_667_real = $signed(_GEN_1099); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1100 = {{33{_T_667_real[31]}},_T_667_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1101 = $signed(_GEN_1100) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1102 = {{2{_GEN_1101[64]}},_GEN_1101}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1103 = _T_2471[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1104 = _GEN_1103[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_667_imag = $signed(_GEN_1104); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1105 = {{33{_T_667_imag[31]}},_T_667_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1106 = $signed(_GEN_1105) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1107 = {{2{_GEN_1106[64]}},_GEN_1106}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3132 = $signed(_GEN_1102) - $signed(_T_3115); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3133 = $signed(_T_3132); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3135 = $signed(_GEN_1107) - $signed(_T_3118); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3136 = $signed(_T_3135); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1114 = _T_2518[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1115 = _GEN_1114[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_682_real = $signed(_GEN_1115); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1116 = _T_2521[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1117 = _GEN_1116[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_682_imag = $signed(_GEN_1117); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3146 = $signed(_T_682_real) + $signed(_T_682_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3147 = $signed(_T_3146); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3149 = $signed(_T_682_imag) - $signed(_T_682_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3150 = $signed(_T_3149); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1118 = {{3{_T_682_real[31]}},_T_682_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3151 = $signed(_GEN_1118) * $signed(-35'sh2d413ccd0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1119 = {{3{_T_3147[31]}},_T_3147}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3152 = $signed(_GEN_1119) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1120 = {{3{_T_3150[31]}},_T_3150}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3153 = $signed(_GEN_1120) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3155 = $signed(_T_3151) - $signed(_T_3152); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3156 = $signed(_T_3155); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3158 = $signed(_T_3151) + $signed(_T_3153); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3159 = $signed(_T_3158); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1121 = _T_2436[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1122 = _GEN_1121[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_676_real = $signed(_GEN_1122); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1123 = {{33{_T_676_real[31]}},_T_676_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1124 = $signed(_GEN_1123) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1125 = {{2{_GEN_1124[64]}},_GEN_1124}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3164 = $signed(_GEN_1125) + $signed(_T_3156); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3165 = $signed(_T_3164); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1126 = _T_2439[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1127 = _GEN_1126[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_676_imag = $signed(_GEN_1127); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1128 = {{33{_T_676_imag[31]}},_T_676_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1129 = $signed(_GEN_1128) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1130 = {{2{_GEN_1129[64]}},_GEN_1129}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3167 = $signed(_GEN_1130) + $signed(_T_3159); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3168 = $signed(_T_3167); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3173 = $signed(_GEN_1125) - $signed(_T_3156); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3174 = $signed(_T_3173); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3176 = $signed(_GEN_1130) - $signed(_T_3159); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3177 = $signed(_T_3176); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1137 = _T_2559[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1138 = _GEN_1137[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_685_real = $signed(_GEN_1138); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1139 = _T_2562[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1140 = _GEN_1139[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_685_imag = $signed(_GEN_1140); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3187 = $signed(_T_685_real) + $signed(_T_685_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3188 = $signed(_T_3187); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3190 = $signed(_T_685_imag) - $signed(_T_685_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3191 = $signed(_T_3190); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1141 = {{3{_T_685_real[31]}},_T_685_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3192 = $signed(_GEN_1141) * $signed(-35'sh2d413ccd0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1142 = {{3{_T_3188[31]}},_T_3188}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3193 = $signed(_GEN_1142) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1143 = {{3{_T_3191[31]}},_T_3191}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3194 = $signed(_GEN_1143) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3196 = $signed(_T_3192) - $signed(_T_3193); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3197 = $signed(_T_3196); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3199 = $signed(_T_3192) + $signed(_T_3194); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3200 = $signed(_T_3199); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1144 = _T_2477[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1145 = _GEN_1144[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_679_real = $signed(_GEN_1145); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1146 = {{33{_T_679_real[31]}},_T_679_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1147 = $signed(_GEN_1146) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1148 = {{2{_GEN_1147[64]}},_GEN_1147}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3205 = $signed(_GEN_1148) + $signed(_T_3197); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3206 = $signed(_T_3205); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1149 = _T_2480[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1150 = _GEN_1149[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_679_imag = $signed(_GEN_1150); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1151 = {{33{_T_679_imag[31]}},_T_679_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1152 = $signed(_GEN_1151) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1153 = {{2{_GEN_1152[64]}},_GEN_1152}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3208 = $signed(_GEN_1153) + $signed(_T_3200); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3209 = $signed(_T_3208); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3214 = $signed(_GEN_1148) - $signed(_T_3197); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3215 = $signed(_T_3214); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3217 = $signed(_GEN_1153) - $signed(_T_3200); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3218 = $signed(_T_3217); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1160 = _T_2673[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1161 = _GEN_1160[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_694_real = $signed(_GEN_1161); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1162 = _T_2676[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1163 = _GEN_1162[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_694_imag = $signed(_GEN_1163); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3228 = $signed(_T_694_real) + $signed(_T_694_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3229 = $signed(_T_3228); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3231 = $signed(_T_694_imag) - $signed(_T_694_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3232 = $signed(_T_3231); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1164 = {{3{_T_694_real[31]}},_T_694_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3233 = $signed(_GEN_1164) * $signed(35'sh11517a7be); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1165 = {{3{_T_3229[31]}},_T_3229}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3234 = $signed(_GEN_1165) * $signed(-35'shc3ef1535); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1166 = {{3{_T_3232[31]}},_T_3232}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3235 = $signed(_GEN_1166) * $signed(35'sh1d906bcf3); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3237 = $signed(_T_3233) - $signed(_T_3234); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3238 = $signed(_T_3237); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3240 = $signed(_T_3233) + $signed(_T_3235); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3241 = $signed(_T_3240); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1167 = _T_2591[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1168 = _GEN_1167[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_688_real = $signed(_GEN_1168); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1169 = {{33{_T_688_real[31]}},_T_688_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1170 = $signed(_GEN_1169) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1171 = {{2{_GEN_1170[64]}},_GEN_1170}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1172 = _T_2594[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1173 = _GEN_1172[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_688_imag = $signed(_GEN_1173); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1174 = {{33{_T_688_imag[31]}},_T_688_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1175 = $signed(_GEN_1174) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1176 = {{2{_GEN_1175[64]}},_GEN_1175}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3255 = $signed(_GEN_1171) - $signed(_T_3238); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3256 = $signed(_T_3255); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3258 = $signed(_GEN_1176) - $signed(_T_3241); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3259 = $signed(_T_3258); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1183 = _T_2714[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1184 = _GEN_1183[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_697_real = $signed(_GEN_1184); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1185 = _T_2717[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1186 = _GEN_1185[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_697_imag = $signed(_GEN_1186); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3269 = $signed(_T_697_real) + $signed(_T_697_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3270 = $signed(_T_3269); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3272 = $signed(_T_697_imag) - $signed(_T_697_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3273 = $signed(_T_3272); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1187 = {{3{_T_697_real[31]}},_T_697_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3274 = $signed(_GEN_1187) * $signed(35'sh11517a7be); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1188 = {{3{_T_3270[31]}},_T_3270}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3275 = $signed(_GEN_1188) * $signed(-35'shc3ef1535); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1189 = {{3{_T_3273[31]}},_T_3273}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3276 = $signed(_GEN_1189) * $signed(35'sh1d906bcf3); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3278 = $signed(_T_3274) - $signed(_T_3275); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3279 = $signed(_T_3278); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3281 = $signed(_T_3274) + $signed(_T_3276); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3282 = $signed(_T_3281); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1190 = _T_2632[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1191 = _GEN_1190[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_691_real = $signed(_GEN_1191); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1192 = {{33{_T_691_real[31]}},_T_691_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1193 = $signed(_GEN_1192) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1194 = {{2{_GEN_1193[64]}},_GEN_1193}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1195 = _T_2635[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1196 = _GEN_1195[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_691_imag = $signed(_GEN_1196); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1197 = {{33{_T_691_imag[31]}},_T_691_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1198 = $signed(_GEN_1197) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1199 = {{2{_GEN_1198[64]}},_GEN_1198}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3296 = $signed(_GEN_1194) - $signed(_T_3279); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3297 = $signed(_T_3296); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3299 = $signed(_GEN_1199) - $signed(_T_3282); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3300 = $signed(_T_3299); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1206 = _T_2682[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1207 = _GEN_1206[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_706_real = $signed(_GEN_1207); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1208 = _T_2685[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1209 = _GEN_1208[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_706_imag = $signed(_GEN_1209); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3310 = $signed(_T_706_real) + $signed(_T_706_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3311 = $signed(_T_3310); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3313 = $signed(_T_706_imag) - $signed(_T_706_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3314 = $signed(_T_3313); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1210 = {{3{_T_706_real[31]}},_T_706_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3315 = $signed(_GEN_1210) * $signed(-35'sh29cf5d228); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1211 = {{3{_T_3311[31]}},_T_3311}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3316 = $signed(_GEN_1211) * $signed(-35'sh1d906bcf3); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1212 = {{3{_T_3314[31]}},_T_3314}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3317 = $signed(_GEN_1212) * $signed(-35'shc3ef1535); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3319 = $signed(_T_3315) - $signed(_T_3316); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3320 = $signed(_T_3319); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3322 = $signed(_T_3315) + $signed(_T_3317); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3323 = $signed(_T_3322); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1213 = _T_2600[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1214 = _GEN_1213[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_700_real = $signed(_GEN_1214); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1215 = {{33{_T_700_real[31]}},_T_700_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1216 = $signed(_GEN_1215) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1217 = {{2{_GEN_1216[64]}},_GEN_1216}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3328 = $signed(_GEN_1217) + $signed(_T_3320); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3329 = $signed(_T_3328); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1218 = _T_2603[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1219 = _GEN_1218[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_700_imag = $signed(_GEN_1219); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1220 = {{33{_T_700_imag[31]}},_T_700_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1221 = $signed(_GEN_1220) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1222 = {{2{_GEN_1221[64]}},_GEN_1221}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3331 = $signed(_GEN_1222) + $signed(_T_3323); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3332 = $signed(_T_3331); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3337 = $signed(_GEN_1217) - $signed(_T_3320); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3338 = $signed(_T_3337); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3340 = $signed(_GEN_1222) - $signed(_T_3323); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3341 = $signed(_T_3340); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1229 = _T_2723[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1230 = _GEN_1229[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_709_real = $signed(_GEN_1230); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1231 = _T_2726[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1232 = _GEN_1231[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_709_imag = $signed(_GEN_1232); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3351 = $signed(_T_709_real) + $signed(_T_709_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3352 = $signed(_T_3351); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3354 = $signed(_T_709_imag) - $signed(_T_709_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3355 = $signed(_T_3354); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1233 = {{3{_T_709_real[31]}},_T_709_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3356 = $signed(_GEN_1233) * $signed(-35'sh29cf5d228); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1234 = {{3{_T_3352[31]}},_T_3352}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3357 = $signed(_GEN_1234) * $signed(-35'sh1d906bcf3); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1235 = {{3{_T_3355[31]}},_T_3355}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3358 = $signed(_GEN_1235) * $signed(-35'shc3ef1535); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3360 = $signed(_T_3356) - $signed(_T_3357); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3361 = $signed(_T_3360); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3363 = $signed(_T_3356) + $signed(_T_3358); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3364 = $signed(_T_3363); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1236 = _T_2641[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1237 = _GEN_1236[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_703_real = $signed(_GEN_1237); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1238 = {{33{_T_703_real[31]}},_T_703_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1239 = $signed(_GEN_1238) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1240 = {{2{_GEN_1239[64]}},_GEN_1239}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3369 = $signed(_GEN_1240) + $signed(_T_3361); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3370 = $signed(_T_3369); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1241 = _T_2644[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1242 = _GEN_1241[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_703_imag = $signed(_GEN_1242); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1243 = {{33{_T_703_imag[31]}},_T_703_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1244 = $signed(_GEN_1243) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1245 = {{2{_GEN_1244[64]}},_GEN_1244}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3372 = $signed(_GEN_1245) + $signed(_T_3364); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3373 = $signed(_T_3372); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3378 = $signed(_GEN_1240) - $signed(_T_3361); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3379 = $signed(_T_3378); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3381 = $signed(_GEN_1245) - $signed(_T_3364); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3382 = $signed(_T_3381); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1252 = _T_2837[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1253 = _GEN_1252[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_718_real = $signed(_GEN_1253); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1254 = _T_2840[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1255 = _GEN_1254[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_718_imag = $signed(_GEN_1255); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3392 = $signed(_T_718_real) + $signed(_T_718_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3393 = $signed(_T_3392); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3395 = $signed(_T_718_imag) - $signed(_T_718_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3396 = $signed(_T_3395); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1256 = {{3{_T_718_real[31]}},_T_718_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3397 = $signed(_GEN_1256) * $signed(-35'sh11517a7be); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1257 = {{3{_T_3393[31]}},_T_3393}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3398 = $signed(_GEN_1257) * $signed(-35'sh1d906bcf3); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1258 = {{3{_T_3396[31]}},_T_3396}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3399 = $signed(_GEN_1258) * $signed(35'shc3ef1535); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3401 = $signed(_T_3397) - $signed(_T_3398); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3402 = $signed(_T_3401); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3404 = $signed(_T_3397) + $signed(_T_3399); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3405 = $signed(_T_3404); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1259 = _T_2755[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1260 = _GEN_1259[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_712_real = $signed(_GEN_1260); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1261 = {{33{_T_712_real[31]}},_T_712_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1262 = $signed(_GEN_1261) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1263 = {{2{_GEN_1262[64]}},_GEN_1262}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1264 = _T_2758[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1265 = _GEN_1264[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_712_imag = $signed(_GEN_1265); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1266 = {{33{_T_712_imag[31]}},_T_712_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1267 = $signed(_GEN_1266) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1268 = {{2{_GEN_1267[64]}},_GEN_1267}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3419 = $signed(_GEN_1263) - $signed(_T_3402); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3420 = $signed(_T_3419); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3422 = $signed(_GEN_1268) - $signed(_T_3405); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3423 = $signed(_T_3422); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1275 = _T_2878[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1276 = _GEN_1275[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_721_real = $signed(_GEN_1276); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1277 = _T_2881[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1278 = _GEN_1277[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_721_imag = $signed(_GEN_1278); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3433 = $signed(_T_721_real) + $signed(_T_721_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3434 = $signed(_T_3433); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3436 = $signed(_T_721_imag) - $signed(_T_721_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3437 = $signed(_T_3436); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1279 = {{3{_T_721_real[31]}},_T_721_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3438 = $signed(_GEN_1279) * $signed(-35'sh11517a7be); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1280 = {{3{_T_3434[31]}},_T_3434}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3439 = $signed(_GEN_1280) * $signed(-35'sh1d906bcf3); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1281 = {{3{_T_3437[31]}},_T_3437}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3440 = $signed(_GEN_1281) * $signed(35'shc3ef1535); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3442 = $signed(_T_3438) - $signed(_T_3439); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3443 = $signed(_T_3442); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3445 = $signed(_T_3438) + $signed(_T_3440); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3446 = $signed(_T_3445); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1282 = _T_2796[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1283 = _GEN_1282[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_715_real = $signed(_GEN_1283); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1284 = {{33{_T_715_real[31]}},_T_715_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1285 = $signed(_GEN_1284) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1286 = {{2{_GEN_1285[64]}},_GEN_1285}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1287 = _T_2799[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1288 = _GEN_1287[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_715_imag = $signed(_GEN_1288); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1289 = {{33{_T_715_imag[31]}},_T_715_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1290 = $signed(_GEN_1289) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1291 = {{2{_GEN_1290[64]}},_GEN_1290}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3460 = $signed(_GEN_1286) - $signed(_T_3443); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3461 = $signed(_T_3460); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3463 = $signed(_GEN_1291) - $signed(_T_3446); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3464 = $signed(_T_3463); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1298 = _T_2846[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1299 = _GEN_1298[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_730_real = $signed(_GEN_1299); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1300 = _T_2849[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1301 = _GEN_1300[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_730_imag = $signed(_GEN_1301); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3474 = $signed(_T_730_real) + $signed(_T_730_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3475 = $signed(_T_3474); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3477 = $signed(_T_730_imag) - $signed(_T_730_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3478 = $signed(_T_3477); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1302 = {{3{_T_730_real[31]}},_T_730_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3479 = $signed(_GEN_1302) * $signed(-35'sh29cf5d228); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1303 = {{3{_T_3475[31]}},_T_3475}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3480 = $signed(_GEN_1303) * $signed(-35'shc3ef1535); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1304 = {{3{_T_3478[31]}},_T_3478}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3481 = $signed(_GEN_1304) * $signed(-35'sh1d906bcf3); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3483 = $signed(_T_3479) - $signed(_T_3480); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3484 = $signed(_T_3483); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3486 = $signed(_T_3479) + $signed(_T_3481); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3487 = $signed(_T_3486); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1305 = _T_2764[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1306 = _GEN_1305[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_724_real = $signed(_GEN_1306); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1307 = {{33{_T_724_real[31]}},_T_724_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1308 = $signed(_GEN_1307) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1309 = {{2{_GEN_1308[64]}},_GEN_1308}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3492 = $signed(_GEN_1309) + $signed(_T_3484); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3493 = $signed(_T_3492); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1310 = _T_2767[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1311 = _GEN_1310[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_724_imag = $signed(_GEN_1311); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1312 = {{33{_T_724_imag[31]}},_T_724_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1313 = $signed(_GEN_1312) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1314 = {{2{_GEN_1313[64]}},_GEN_1313}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3495 = $signed(_GEN_1314) + $signed(_T_3487); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3496 = $signed(_T_3495); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3501 = $signed(_GEN_1309) - $signed(_T_3484); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3502 = $signed(_T_3501); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3504 = $signed(_GEN_1314) - $signed(_T_3487); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3505 = $signed(_T_3504); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1321 = _T_2887[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1322 = _GEN_1321[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_733_real = $signed(_GEN_1322); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1323 = _T_2890[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1324 = _GEN_1323[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_733_imag = $signed(_GEN_1324); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3515 = $signed(_T_733_real) + $signed(_T_733_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3516 = $signed(_T_3515); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3518 = $signed(_T_733_imag) - $signed(_T_733_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3519 = $signed(_T_3518); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1325 = {{3{_T_733_real[31]}},_T_733_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3520 = $signed(_GEN_1325) * $signed(-35'sh29cf5d228); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1326 = {{3{_T_3516[31]}},_T_3516}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3521 = $signed(_GEN_1326) * $signed(-35'shc3ef1535); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1327 = {{3{_T_3519[31]}},_T_3519}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3522 = $signed(_GEN_1327) * $signed(-35'sh1d906bcf3); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3524 = $signed(_T_3520) - $signed(_T_3521); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3525 = $signed(_T_3524); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3527 = $signed(_T_3520) + $signed(_T_3522); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3528 = $signed(_T_3527); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1328 = _T_2805[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1329 = _GEN_1328[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_727_real = $signed(_GEN_1329); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1330 = {{33{_T_727_real[31]}},_T_727_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1331 = $signed(_GEN_1330) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1332 = {{2{_GEN_1331[64]}},_GEN_1331}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3533 = $signed(_GEN_1332) + $signed(_T_3525); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3534 = $signed(_T_3533); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1333 = _T_2808[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1334 = _GEN_1333[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_727_imag = $signed(_GEN_1334); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1335 = {{33{_T_727_imag[31]}},_T_727_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1336 = $signed(_GEN_1335) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1337 = {{2{_GEN_1336[64]}},_GEN_1336}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3536 = $signed(_GEN_1337) + $signed(_T_3528); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3537 = $signed(_T_3536); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3542 = $signed(_GEN_1332) - $signed(_T_3525); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3543 = $signed(_T_3542); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3545 = $signed(_GEN_1337) - $signed(_T_3528); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3546 = $signed(_T_3545); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1367 = _T_2969[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1368 = _GEN_1367[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_745_real = $signed(_GEN_1368); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1369 = _T_2972[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1370 = _GEN_1369[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_745_imag = $signed(_GEN_1370); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3597 = $signed(_T_745_real) + $signed(_T_745_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3598 = $signed(_T_3597); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3600 = $signed(_T_745_imag) - $signed(_T_745_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3601 = $signed(_T_3600); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1371 = {{3{_T_745_real[31]}},_T_745_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3602 = $signed(_GEN_1371) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1372 = {{3{_T_3598[31]}},_T_3598}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3603 = $signed(_GEN_1372) * $signed(-35'sh200000000); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1373 = {{3{_T_3601[31]}},_T_3601}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3604 = $signed(_GEN_1373) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3606 = $signed(_T_3602) - $signed(_T_3603); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3607 = $signed(_T_3606); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3609 = $signed(_T_3602) + $signed(_T_3604); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3610 = $signed(_T_3609); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1374 = _T_2928[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1375 = _GEN_1374[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_742_real = $signed(_GEN_1375); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1376 = {{33{_T_742_real[31]}},_T_742_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1377 = $signed(_GEN_1376) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1378 = {{2{_GEN_1377[64]}},_GEN_1377}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3615 = $signed(_GEN_1378) + $signed(_T_3607); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3616 = $signed(_T_3615); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1379 = _T_2931[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1380 = _GEN_1379[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_742_imag = $signed(_GEN_1380); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1381 = {{33{_T_742_imag[31]}},_T_742_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1382 = $signed(_GEN_1381) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1383 = {{2{_GEN_1382[64]}},_GEN_1382}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3618 = $signed(_GEN_1383) + $signed(_T_3610); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3619 = $signed(_T_3618); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1390 = _T_3042[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1391 = _GEN_1390[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_751_real = $signed(_GEN_1391); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1392 = _T_3045[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1393 = _GEN_1392[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_751_imag = $signed(_GEN_1393); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3638 = $signed(_T_751_real) + $signed(_T_751_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3639 = $signed(_T_3638); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3641 = $signed(_T_751_imag) - $signed(_T_751_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3642 = $signed(_T_3641); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1394 = {{3{_T_751_real[31]}},_T_751_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3643 = $signed(_GEN_1394) * $signed(35'sh0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1395 = {{3{_T_3639[31]}},_T_3639}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3644 = $signed(_GEN_1395) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1396 = {{3{_T_3642[31]}},_T_3642}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3645 = $signed(_GEN_1396) * $signed(35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3647 = $signed(_T_3643) - $signed(_T_3644); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3648 = $signed(_T_3647); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3650 = $signed(_T_3643) + $signed(_T_3645); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3651 = $signed(_T_3650); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1397 = _T_3001[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1398 = _GEN_1397[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_748_real = $signed(_GEN_1398); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1399 = {{33{_T_748_real[31]}},_T_748_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1400 = $signed(_GEN_1399) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1401 = {{2{_GEN_1400[64]}},_GEN_1400}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3656 = $signed(_GEN_1401) + $signed(_T_3648); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3657 = $signed(_T_3656); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1402 = _T_3004[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1403 = _GEN_1402[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_748_imag = $signed(_GEN_1403); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1404 = {{33{_T_748_imag[31]}},_T_748_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1405 = $signed(_GEN_1404) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1406 = {{2{_GEN_1405[64]}},_GEN_1405}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3659 = $signed(_GEN_1406) + $signed(_T_3651); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3660 = $signed(_T_3659); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1413 = _T_3051[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1414 = _GEN_1413[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_757_real = $signed(_GEN_1414); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1415 = _T_3054[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1416 = _GEN_1415[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_757_imag = $signed(_GEN_1416); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3679 = $signed(_T_757_real) + $signed(_T_757_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3680 = $signed(_T_3679); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3682 = $signed(_T_757_imag) - $signed(_T_757_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3683 = $signed(_T_3682); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1417 = {{3{_T_757_real[31]}},_T_757_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3684 = $signed(_GEN_1417) * $signed(-35'sh2d413ccd0); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1418 = {{3{_T_3680[31]}},_T_3680}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3685 = $signed(_GEN_1418) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1419 = {{3{_T_3683[31]}},_T_3683}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3686 = $signed(_GEN_1419) * $signed(-35'sh16a09e668); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3688 = $signed(_T_3684) - $signed(_T_3685); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3689 = $signed(_T_3688); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3691 = $signed(_T_3684) + $signed(_T_3686); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3692 = $signed(_T_3691); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1420 = _T_3010[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1421 = _GEN_1420[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_754_real = $signed(_GEN_1421); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1422 = {{33{_T_754_real[31]}},_T_754_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1423 = $signed(_GEN_1422) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1424 = {{2{_GEN_1423[64]}},_GEN_1423}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3697 = $signed(_GEN_1424) + $signed(_T_3689); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3698 = $signed(_T_3697); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1425 = _T_3013[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1426 = _GEN_1425[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_754_imag = $signed(_GEN_1426); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1427 = {{33{_T_754_imag[31]}},_T_754_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1428 = $signed(_GEN_1427) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1429 = {{2{_GEN_1428[64]}},_GEN_1428}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3700 = $signed(_GEN_1429) + $signed(_T_3692); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3701 = $signed(_T_3700); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1459 = _T_3133[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1460 = _GEN_1459[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_769_real = $signed(_GEN_1460); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1461 = _T_3136[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1462 = _GEN_1461[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_769_imag = $signed(_GEN_1462); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3761 = $signed(_T_769_real) + $signed(_T_769_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3762 = $signed(_T_3761); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3764 = $signed(_T_769_imag) - $signed(_T_769_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3765 = $signed(_T_3764); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1463 = {{3{_T_769_real[31]}},_T_769_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3766 = $signed(_GEN_1463) * $signed(-35'sh29cf5d228); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1464 = {{3{_T_3762[31]}},_T_3762}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3767 = $signed(_GEN_1464) * $signed(-35'sh1d906bcf3); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1465 = {{3{_T_3765[31]}},_T_3765}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3768 = $signed(_GEN_1465) * $signed(-35'shc3ef1535); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3770 = $signed(_T_3766) - $signed(_T_3767); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3771 = $signed(_T_3770); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3773 = $signed(_T_3766) + $signed(_T_3768); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3774 = $signed(_T_3773); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1466 = _T_3092[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1467 = _GEN_1466[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_766_real = $signed(_GEN_1467); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1468 = {{33{_T_766_real[31]}},_T_766_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1469 = $signed(_GEN_1468) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1470 = {{2{_GEN_1469[64]}},_GEN_1469}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3779 = $signed(_GEN_1470) + $signed(_T_3771); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3780 = $signed(_T_3779); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1471 = _T_3095[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1472 = _GEN_1471[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_766_imag = $signed(_GEN_1472); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1473 = {{33{_T_766_imag[31]}},_T_766_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1474 = $signed(_GEN_1473) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1475 = {{2{_GEN_1474[64]}},_GEN_1474}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3782 = $signed(_GEN_1475) + $signed(_T_3774); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3783 = $signed(_T_3782); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1482 = _T_3206[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1483 = _GEN_1482[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_775_real = $signed(_GEN_1483); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1484 = _T_3209[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1485 = _GEN_1484[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_775_imag = $signed(_GEN_1485); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3802 = $signed(_T_775_real) + $signed(_T_775_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3803 = $signed(_T_3802); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3805 = $signed(_T_775_imag) - $signed(_T_775_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3806 = $signed(_T_3805); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1486 = {{3{_T_775_real[31]}},_T_775_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3807 = $signed(_GEN_1486) * $signed(-35'sh11517a7be); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1487 = {{3{_T_3803[31]}},_T_3803}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3808 = $signed(_GEN_1487) * $signed(-35'sh1d906bcf3); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1488 = {{3{_T_3806[31]}},_T_3806}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3809 = $signed(_GEN_1488) * $signed(35'shc3ef1535); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3811 = $signed(_T_3807) - $signed(_T_3808); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3812 = $signed(_T_3811); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3814 = $signed(_T_3807) + $signed(_T_3809); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3815 = $signed(_T_3814); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1489 = _T_3165[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1490 = _GEN_1489[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_772_real = $signed(_GEN_1490); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1491 = {{33{_T_772_real[31]}},_T_772_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1492 = $signed(_GEN_1491) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1493 = {{2{_GEN_1492[64]}},_GEN_1492}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3820 = $signed(_GEN_1493) + $signed(_T_3812); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3821 = $signed(_T_3820); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1494 = _T_3168[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1495 = _GEN_1494[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_772_imag = $signed(_GEN_1495); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1496 = {{33{_T_772_imag[31]}},_T_772_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1497 = $signed(_GEN_1496) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1498 = {{2{_GEN_1497[64]}},_GEN_1497}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3823 = $signed(_GEN_1498) + $signed(_T_3815); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3824 = $signed(_T_3823); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1505 = _T_3215[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1506 = _GEN_1505[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_781_real = $signed(_GEN_1506); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1507 = _T_3218[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1508 = _GEN_1507[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_781_imag = $signed(_GEN_1508); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3843 = $signed(_T_781_real) + $signed(_T_781_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3844 = $signed(_T_3843); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3846 = $signed(_T_781_imag) - $signed(_T_781_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3847 = $signed(_T_3846); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1509 = {{3{_T_781_real[31]}},_T_781_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3848 = $signed(_GEN_1509) * $signed(-35'sh29cf5d228); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1510 = {{3{_T_3844[31]}},_T_3844}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3849 = $signed(_GEN_1510) * $signed(-35'shc3ef1535); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1511 = {{3{_T_3847[31]}},_T_3847}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3850 = $signed(_GEN_1511) * $signed(-35'sh1d906bcf3); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3852 = $signed(_T_3848) - $signed(_T_3849); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3853 = $signed(_T_3852); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3855 = $signed(_T_3848) + $signed(_T_3850); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3856 = $signed(_T_3855); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1512 = _T_3174[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1513 = _GEN_1512[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_778_real = $signed(_GEN_1513); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1514 = {{33{_T_778_real[31]}},_T_778_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1515 = $signed(_GEN_1514) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1516 = {{2{_GEN_1515[64]}},_GEN_1515}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3861 = $signed(_GEN_1516) + $signed(_T_3853); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3862 = $signed(_T_3861); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1517 = _T_3177[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1518 = _GEN_1517[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_778_imag = $signed(_GEN_1518); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1519 = {{33{_T_778_imag[31]}},_T_778_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1520 = $signed(_GEN_1519) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1521 = {{2{_GEN_1520[64]}},_GEN_1520}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3864 = $signed(_GEN_1521) + $signed(_T_3856); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3865 = $signed(_T_3864); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1551 = _T_3297[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1552 = _GEN_1551[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_793_real = $signed(_GEN_1552); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1553 = _T_3300[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1554 = _GEN_1553[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_793_imag = $signed(_GEN_1554); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3925 = $signed(_T_793_real) + $signed(_T_793_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3926 = $signed(_T_3925); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3928 = $signed(_T_793_imag) - $signed(_T_793_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3929 = $signed(_T_3928); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1555 = {{3{_T_793_real[31]}},_T_793_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3930 = $signed(_GEN_1555) * $signed(-35'sh25a0c5df1); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1556 = {{3{_T_3926[31]}},_T_3926}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3931 = $signed(_GEN_1556) * $signed(-35'sh1f6297cff); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1557 = {{3{_T_3929[31]}},_T_3929}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3932 = $signed(_GEN_1557) * $signed(-35'sh63e2e0f2); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3934 = $signed(_T_3930) - $signed(_T_3931); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3935 = $signed(_T_3934); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3937 = $signed(_T_3930) + $signed(_T_3932); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3938 = $signed(_T_3937); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1558 = _T_3256[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1559 = _GEN_1558[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_790_real = $signed(_GEN_1559); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1560 = {{33{_T_790_real[31]}},_T_790_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1561 = $signed(_GEN_1560) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1562 = {{2{_GEN_1561[64]}},_GEN_1561}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3943 = $signed(_GEN_1562) + $signed(_T_3935); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3944 = $signed(_T_3943); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1563 = _T_3259[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1564 = _GEN_1563[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_790_imag = $signed(_GEN_1564); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1565 = {{33{_T_790_imag[31]}},_T_790_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1566 = $signed(_GEN_1565) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1567 = {{2{_GEN_1566[64]}},_GEN_1566}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3946 = $signed(_GEN_1567) + $signed(_T_3938); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3947 = $signed(_T_3946); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1574 = _T_3370[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1575 = _GEN_1574[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_799_real = $signed(_GEN_1575); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1576 = _T_3373[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1577 = _GEN_1576[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_799_imag = $signed(_GEN_1577); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_3966 = $signed(_T_799_real) + $signed(_T_799_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3967 = $signed(_T_3966); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3969 = $signed(_T_799_imag) - $signed(_T_799_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3970 = $signed(_T_3969); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1578 = {{3{_T_799_real[31]}},_T_799_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3971 = $signed(_GEN_1578) * $signed(-35'sh8d42aef6); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1579 = {{3{_T_3967[31]}},_T_3967}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3972 = $signed(_GEN_1579) * $signed(-35'sh1a9b66291); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1580 = {{3{_T_3970[31]}},_T_3970}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_3973 = $signed(_GEN_1580) * $signed(35'sh11c73b39b); // @[FixedPointTypeClass.scala 43:59]
  assign _T_3975 = $signed(_T_3971) - $signed(_T_3972); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3976 = $signed(_T_3975); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3978 = $signed(_T_3971) + $signed(_T_3973); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3979 = $signed(_T_3978); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1581 = _T_3329[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1582 = _GEN_1581[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_796_real = $signed(_GEN_1582); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1583 = {{33{_T_796_real[31]}},_T_796_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1584 = $signed(_GEN_1583) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1585 = {{2{_GEN_1584[64]}},_GEN_1584}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3984 = $signed(_GEN_1585) + $signed(_T_3976); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3985 = $signed(_T_3984); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1586 = _T_3332[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1587 = _GEN_1586[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_796_imag = $signed(_GEN_1587); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1588 = {{33{_T_796_imag[31]}},_T_796_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1589 = $signed(_GEN_1588) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1590 = {{2{_GEN_1589[64]}},_GEN_1589}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_3987 = $signed(_GEN_1590) + $signed(_T_3979); // @[FixedPointTypeClass.scala 21:58]
  assign _T_3988 = $signed(_T_3987); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1597 = _T_3379[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1598 = _GEN_1597[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_805_real = $signed(_GEN_1598); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1599 = _T_3382[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1600 = _GEN_1599[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_805_imag = $signed(_GEN_1600); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_4007 = $signed(_T_805_real) + $signed(_T_805_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4008 = $signed(_T_4007); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4010 = $signed(_T_805_imag) - $signed(_T_805_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4011 = $signed(_T_4010); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1601 = {{3{_T_805_real[31]}},_T_805_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4012 = $signed(_GEN_1601) * $signed(-35'sh2c62a162c); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1602 = {{3{_T_4008[31]}},_T_4008}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4013 = $signed(_GEN_1602) * $signed(-35'sh11c73b39b); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1603 = {{3{_T_4011[31]}},_T_4011}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4014 = $signed(_GEN_1603) * $signed(-35'sh1a9b66291); // @[FixedPointTypeClass.scala 43:59]
  assign _T_4016 = $signed(_T_4012) - $signed(_T_4013); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4017 = $signed(_T_4016); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4019 = $signed(_T_4012) + $signed(_T_4014); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4020 = $signed(_T_4019); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1604 = _T_3338[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1605 = _GEN_1604[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_802_real = $signed(_GEN_1605); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1606 = {{33{_T_802_real[31]}},_T_802_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1607 = $signed(_GEN_1606) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1608 = {{2{_GEN_1607[64]}},_GEN_1607}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_4025 = $signed(_GEN_1608) + $signed(_T_4017); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4026 = $signed(_T_4025); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1609 = _T_3341[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1610 = _GEN_1609[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_802_imag = $signed(_GEN_1610); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1611 = {{33{_T_802_imag[31]}},_T_802_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1612 = $signed(_GEN_1611) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1613 = {{2{_GEN_1612[64]}},_GEN_1612}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_4028 = $signed(_GEN_1613) + $signed(_T_4020); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4029 = $signed(_T_4028); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1643 = _T_3461[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1644 = _GEN_1643[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_817_real = $signed(_GEN_1644); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1645 = _T_3464[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1646 = _GEN_1645[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_817_imag = $signed(_GEN_1646); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_4089 = $signed(_T_817_real) + $signed(_T_817_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4090 = $signed(_T_4089); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4092 = $signed(_T_817_imag) - $signed(_T_817_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4093 = $signed(_T_4092); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1647 = {{3{_T_817_real[31]}},_T_817_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4094 = $signed(_GEN_1647) * $signed(-35'sh2c62a162c); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1648 = {{3{_T_4090[31]}},_T_4090}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4095 = $signed(_GEN_1648) * $signed(-35'sh1a9b66291); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1649 = {{3{_T_4093[31]}},_T_4093}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4096 = $signed(_GEN_1649) * $signed(-35'sh11c73b39b); // @[FixedPointTypeClass.scala 43:59]
  assign _T_4098 = $signed(_T_4094) - $signed(_T_4095); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4099 = $signed(_T_4098); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4101 = $signed(_T_4094) + $signed(_T_4096); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4102 = $signed(_T_4101); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1650 = _T_3420[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1651 = _GEN_1650[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_814_real = $signed(_GEN_1651); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1652 = {{33{_T_814_real[31]}},_T_814_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1653 = $signed(_GEN_1652) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1654 = {{2{_GEN_1653[64]}},_GEN_1653}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_4107 = $signed(_GEN_1654) + $signed(_T_4099); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4108 = $signed(_T_4107); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1655 = _T_3423[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1656 = _GEN_1655[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_814_imag = $signed(_GEN_1656); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1657 = {{33{_T_814_imag[31]}},_T_814_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1658 = $signed(_GEN_1657) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1659 = {{2{_GEN_1658[64]}},_GEN_1658}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_4110 = $signed(_GEN_1659) + $signed(_T_4102); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4111 = $signed(_T_4110); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1666 = _T_3534[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1667 = _GEN_1666[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_823_real = $signed(_GEN_1667); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1668 = _T_3537[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1669 = _GEN_1668[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_823_imag = $signed(_GEN_1669); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_4130 = $signed(_T_823_real) + $signed(_T_823_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4131 = $signed(_T_4130); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4133 = $signed(_T_823_imag) - $signed(_T_823_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4134 = $signed(_T_4133); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1670 = {{3{_T_823_real[31]}},_T_823_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4135 = $signed(_GEN_1670) * $signed(-35'sh192469c0d); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1671 = {{3{_T_4131[31]}},_T_4131}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4136 = $signed(_GEN_1671) * $signed(-35'sh1f6297cff); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1672 = {{3{_T_4134[31]}},_T_4134}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4137 = $signed(_GEN_1672) * $signed(35'sh63e2e0f2); // @[FixedPointTypeClass.scala 43:59]
  assign _T_4139 = $signed(_T_4135) - $signed(_T_4136); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4140 = $signed(_T_4139); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4142 = $signed(_T_4135) + $signed(_T_4137); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4143 = $signed(_T_4142); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1673 = _T_3493[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1674 = _GEN_1673[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_820_real = $signed(_GEN_1674); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1675 = {{33{_T_820_real[31]}},_T_820_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1676 = $signed(_GEN_1675) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1677 = {{2{_GEN_1676[64]}},_GEN_1676}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_4148 = $signed(_GEN_1677) + $signed(_T_4140); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4149 = $signed(_T_4148); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1678 = _T_3496[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1679 = _GEN_1678[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_820_imag = $signed(_GEN_1679); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1680 = {{33{_T_820_imag[31]}},_T_820_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1681 = $signed(_GEN_1680) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1682 = {{2{_GEN_1681[64]}},_GEN_1681}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_4151 = $signed(_GEN_1682) + $signed(_T_4143); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4152 = $signed(_T_4151); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1689 = _T_3543[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1690 = _GEN_1689[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_829_real = $signed(_GEN_1690); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1691 = _T_3546[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1692 = _GEN_1691[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_829_imag = $signed(_GEN_1692); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_4171 = $signed(_T_829_real) + $signed(_T_829_imag); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4172 = $signed(_T_4171); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4174 = $signed(_T_829_imag) - $signed(_T_829_real); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4175 = $signed(_T_4174); // @[FixedPointTypeClass.scala 31:68]
  assign _GEN_1693 = {{3{_T_829_real[31]}},_T_829_real}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4176 = $signed(_GEN_1693) * $signed(-35'sh25a0c5df1); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1694 = {{3{_T_4172[31]}},_T_4172}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4177 = $signed(_GEN_1694) * $signed(-35'sh63e2e0f2); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_1695 = {{3{_T_4175[31]}},_T_4175}; // @[FixedPointTypeClass.scala 43:59]
  assign _T_4178 = $signed(_GEN_1695) * $signed(-35'sh1f6297cff); // @[FixedPointTypeClass.scala 43:59]
  assign _T_4180 = $signed(_T_4176) - $signed(_T_4177); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4181 = $signed(_T_4180); // @[FixedPointTypeClass.scala 31:68]
  assign _T_4183 = $signed(_T_4176) + $signed(_T_4178); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4184 = $signed(_T_4183); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1696 = _T_3502[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1697 = _GEN_1696[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_826_real = $signed(_GEN_1697); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1698 = {{33{_T_826_real[31]}},_T_826_real}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1699 = $signed(_GEN_1698) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1700 = {{2{_GEN_1699[64]}},_GEN_1699}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_4189 = $signed(_GEN_1700) + $signed(_T_4181); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4190 = $signed(_T_4189); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1701 = _T_3505[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1702 = _GEN_1701[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _T_826_imag = $signed(_GEN_1702); // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1703 = {{33{_T_826_imag[31]}},_T_826_imag}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1704 = $signed(_GEN_1703) << 33; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1705 = {{2{_GEN_1704[64]}},_GEN_1704}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_4192 = $signed(_GEN_1705) + $signed(_T_4184); // @[FixedPointTypeClass.scala 21:58]
  assign _T_4193 = $signed(_T_4192); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_1720 = _T_3616[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1721 = _GEN_1720[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1722 = _T_3619[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1723 = _GEN_1722[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1728 = _T_3657[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1729 = _GEN_1728[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1730 = _T_3660[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1731 = _GEN_1730[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1736 = _T_3698[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1737 = _GEN_1736[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1738 = _T_3701[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1739 = _GEN_1738[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1752 = _T_3780[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1753 = _GEN_1752[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1754 = _T_3783[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1755 = _GEN_1754[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1760 = _T_3821[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1761 = _GEN_1760[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1762 = _T_3824[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1763 = _GEN_1762[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1768 = _T_3862[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1769 = _GEN_1768[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1770 = _T_3865[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1771 = _GEN_1770[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1784 = _T_3944[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1785 = _GEN_1784[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1786 = _T_3947[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1787 = _GEN_1786[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1792 = _T_3985[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1793 = _GEN_1792[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1794 = _T_3988[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1795 = _GEN_1794[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1800 = _T_4026[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1801 = _GEN_1800[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1802 = _T_4029[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1803 = _GEN_1802[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1816 = _T_4108[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1817 = _GEN_1816[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1818 = _T_4111[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1819 = _GEN_1818[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1824 = _T_4149[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1825 = _GEN_1824[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1826 = _T_4152[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1827 = _GEN_1826[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1832 = _T_4190[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1833 = _GEN_1832[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1834 = _T_4193[66:33]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign _GEN_1835 = _GEN_1834[31:0]; // @[FFT.scala 96:89 FFT.scala 110:16]
  assign io_out_bits_4_real = $signed(_GEN_1729); // @[FFT.scala 148:17]
  assign io_out_bits_4_imag = $signed(_GEN_1731); // @[FFT.scala 148:17]
  assign io_out_bits_5_real = $signed(_GEN_1793); // @[FFT.scala 148:17]
  assign io_out_bits_5_imag = $signed(_GEN_1795); // @[FFT.scala 148:17]
  assign io_out_bits_6_real = $signed(_GEN_1761); // @[FFT.scala 148:17]
  assign io_out_bits_6_imag = $signed(_GEN_1763); // @[FFT.scala 148:17]
  assign io_out_bits_7_real = $signed(_GEN_1825); // @[FFT.scala 148:17]
  assign io_out_bits_7_imag = $signed(_GEN_1827); // @[FFT.scala 148:17]
  assign io_out_bits_8_real = $signed(_GEN_1721); // @[FFT.scala 148:17]
  assign io_out_bits_8_imag = $signed(_GEN_1723); // @[FFT.scala 148:17]
  assign io_out_bits_9_real = $signed(_GEN_1785); // @[FFT.scala 148:17]
  assign io_out_bits_9_imag = $signed(_GEN_1787); // @[FFT.scala 148:17]
  assign io_out_bits_10_real = $signed(_GEN_1753); // @[FFT.scala 148:17]
  assign io_out_bits_10_imag = $signed(_GEN_1755); // @[FFT.scala 148:17]
  assign io_out_bits_11_real = $signed(_GEN_1817); // @[FFT.scala 148:17]
  assign io_out_bits_11_imag = $signed(_GEN_1819); // @[FFT.scala 148:17]
  assign io_out_bits_12_real = $signed(_GEN_1737); // @[FFT.scala 148:17]
  assign io_out_bits_12_imag = $signed(_GEN_1739); // @[FFT.scala 148:17]
  assign io_out_bits_13_real = $signed(_GEN_1801); // @[FFT.scala 148:17]
  assign io_out_bits_13_imag = $signed(_GEN_1803); // @[FFT.scala 148:17]
  assign io_out_bits_14_real = $signed(_GEN_1769); // @[FFT.scala 148:17]
  assign io_out_bits_14_imag = $signed(_GEN_1771); // @[FFT.scala 148:17]
  assign io_out_bits_15_real = $signed(_GEN_1833); // @[FFT.scala 148:17]
  assign io_out_bits_15_imag = $signed(_GEN_1835); // @[FFT.scala 148:17]
endmodule
module FFT(
  input         clock,
  input         io_in_valid,
  input  [31:0] io_in_bits_0_real,
  input  [31:0] io_in_bits_1_real,
  input  [31:0] io_in_bits_2_real,
  input  [31:0] io_in_bits_3_real,
  input  [31:0] io_in_bits_4_real,
  input  [31:0] io_in_bits_5_real,
  input  [31:0] io_in_bits_6_real,
  input  [31:0] io_in_bits_7_real,
  input  [31:0] io_in_bits_8_real,
  input  [31:0] io_in_bits_9_real,
  input  [31:0] io_in_bits_10_real,
  input  [31:0] io_in_bits_11_real,
  input  [31:0] io_in_bits_12_real,
  input  [31:0] io_in_bits_13_real,
  input  [31:0] io_in_bits_14_real,
  input  [31:0] io_in_bits_15_real,
  input  [31:0] io_in_bits_16_real,
  input  [31:0] io_in_bits_17_real,
  input  [31:0] io_in_bits_18_real,
  input  [31:0] io_in_bits_19_real,
  input  [31:0] io_in_bits_20_real,
  input  [31:0] io_in_bits_21_real,
  input  [31:0] io_in_bits_22_real,
  input  [31:0] io_in_bits_23_real,
  input  [31:0] io_in_bits_24_real,
  input  [31:0] io_in_bits_25_real,
  input  [31:0] io_in_bits_26_real,
  input  [31:0] io_in_bits_27_real,
  input  [31:0] io_in_bits_28_real,
  input  [31:0] io_in_bits_29_real,
  input  [31:0] io_in_bits_30_real,
  input  [31:0] io_in_bits_31_real,
  output        io_out_valid,
  output [31:0] io_out_bits_4_real,
  output [31:0] io_out_bits_4_imag,
  output [31:0] io_out_bits_5_real,
  output [31:0] io_out_bits_5_imag,
  output [31:0] io_out_bits_6_real,
  output [31:0] io_out_bits_6_imag,
  output [31:0] io_out_bits_7_real,
  output [31:0] io_out_bits_7_imag,
  output [31:0] io_out_bits_8_real,
  output [31:0] io_out_bits_8_imag,
  output [31:0] io_out_bits_9_real,
  output [31:0] io_out_bits_9_imag,
  output [31:0] io_out_bits_10_real,
  output [31:0] io_out_bits_10_imag,
  output [31:0] io_out_bits_11_real,
  output [31:0] io_out_bits_11_imag,
  output [31:0] io_out_bits_12_real,
  output [31:0] io_out_bits_12_imag,
  output [31:0] io_out_bits_13_real,
  output [31:0] io_out_bits_13_imag,
  output [31:0] io_out_bits_14_real,
  output [31:0] io_out_bits_14_imag,
  output [31:0] io_out_bits_15_real,
  output [31:0] io_out_bits_15_imag
);
  wire [31:0] direct_io_in_bits_0_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_0_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_1_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_1_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_2_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_2_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_3_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_3_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_4_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_4_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_5_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_5_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_6_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_6_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_7_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_7_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_8_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_8_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_9_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_9_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_10_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_10_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_11_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_11_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_12_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_12_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_13_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_13_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_14_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_14_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_15_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_15_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_16_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_16_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_17_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_17_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_18_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_18_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_19_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_19_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_20_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_20_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_21_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_21_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_22_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_22_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_23_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_23_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_24_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_24_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_25_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_25_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_26_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_26_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_27_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_27_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_28_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_28_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_29_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_29_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_30_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_30_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_31_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_in_bits_31_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_4_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_4_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_5_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_5_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_6_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_6_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_7_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_7_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_8_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_8_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_9_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_9_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_10_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_10_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_11_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_11_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_12_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_12_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_13_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_13_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_14_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_14_imag; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_15_real; // @[FFT.scala 427:22]
  wire [31:0] direct_io_out_bits_15_imag; // @[FFT.scala 427:22]
  reg [31:0] outReg_4_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_0;
  reg [31:0] outReg_4_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_1;
  reg [31:0] outReg_5_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_2;
  reg [31:0] outReg_5_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_3;
  reg [31:0] outReg_6_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_4;
  reg [31:0] outReg_6_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_5;
  reg [31:0] outReg_7_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_6;
  reg [31:0] outReg_7_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_7;
  reg [31:0] outReg_8_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_8;
  reg [31:0] outReg_8_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_9;
  reg [31:0] outReg_9_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_10;
  reg [31:0] outReg_9_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_11;
  reg [31:0] outReg_10_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_12;
  reg [31:0] outReg_10_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_13;
  reg [31:0] outReg_11_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_14;
  reg [31:0] outReg_11_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_15;
  reg [31:0] outReg_12_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_16;
  reg [31:0] outReg_12_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_17;
  reg [31:0] outReg_13_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_18;
  reg [31:0] outReg_13_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_19;
  reg [31:0] outReg_14_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_20;
  reg [31:0] outReg_14_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_21;
  reg [31:0] outReg_15_real; // @[Reg.scala 11:16]
  reg [31:0] _RAND_22;
  reg [31:0] outReg_15_imag; // @[Reg.scala 11:16]
  reg [31:0] _RAND_23;
  reg  valReg; // @[FFT.scala 444:23]
  reg [31:0] _RAND_24;
  DirectFFT direct ( // @[FFT.scala 427:22]
    .io_in_bits_0_real(direct_io_in_bits_0_real),
    .io_in_bits_0_imag(direct_io_in_bits_0_imag),
    .io_in_bits_1_real(direct_io_in_bits_1_real),
    .io_in_bits_1_imag(direct_io_in_bits_1_imag),
    .io_in_bits_2_real(direct_io_in_bits_2_real),
    .io_in_bits_2_imag(direct_io_in_bits_2_imag),
    .io_in_bits_3_real(direct_io_in_bits_3_real),
    .io_in_bits_3_imag(direct_io_in_bits_3_imag),
    .io_in_bits_4_real(direct_io_in_bits_4_real),
    .io_in_bits_4_imag(direct_io_in_bits_4_imag),
    .io_in_bits_5_real(direct_io_in_bits_5_real),
    .io_in_bits_5_imag(direct_io_in_bits_5_imag),
    .io_in_bits_6_real(direct_io_in_bits_6_real),
    .io_in_bits_6_imag(direct_io_in_bits_6_imag),
    .io_in_bits_7_real(direct_io_in_bits_7_real),
    .io_in_bits_7_imag(direct_io_in_bits_7_imag),
    .io_in_bits_8_real(direct_io_in_bits_8_real),
    .io_in_bits_8_imag(direct_io_in_bits_8_imag),
    .io_in_bits_9_real(direct_io_in_bits_9_real),
    .io_in_bits_9_imag(direct_io_in_bits_9_imag),
    .io_in_bits_10_real(direct_io_in_bits_10_real),
    .io_in_bits_10_imag(direct_io_in_bits_10_imag),
    .io_in_bits_11_real(direct_io_in_bits_11_real),
    .io_in_bits_11_imag(direct_io_in_bits_11_imag),
    .io_in_bits_12_real(direct_io_in_bits_12_real),
    .io_in_bits_12_imag(direct_io_in_bits_12_imag),
    .io_in_bits_13_real(direct_io_in_bits_13_real),
    .io_in_bits_13_imag(direct_io_in_bits_13_imag),
    .io_in_bits_14_real(direct_io_in_bits_14_real),
    .io_in_bits_14_imag(direct_io_in_bits_14_imag),
    .io_in_bits_15_real(direct_io_in_bits_15_real),
    .io_in_bits_15_imag(direct_io_in_bits_15_imag),
    .io_in_bits_16_real(direct_io_in_bits_16_real),
    .io_in_bits_16_imag(direct_io_in_bits_16_imag),
    .io_in_bits_17_real(direct_io_in_bits_17_real),
    .io_in_bits_17_imag(direct_io_in_bits_17_imag),
    .io_in_bits_18_real(direct_io_in_bits_18_real),
    .io_in_bits_18_imag(direct_io_in_bits_18_imag),
    .io_in_bits_19_real(direct_io_in_bits_19_real),
    .io_in_bits_19_imag(direct_io_in_bits_19_imag),
    .io_in_bits_20_real(direct_io_in_bits_20_real),
    .io_in_bits_20_imag(direct_io_in_bits_20_imag),
    .io_in_bits_21_real(direct_io_in_bits_21_real),
    .io_in_bits_21_imag(direct_io_in_bits_21_imag),
    .io_in_bits_22_real(direct_io_in_bits_22_real),
    .io_in_bits_22_imag(direct_io_in_bits_22_imag),
    .io_in_bits_23_real(direct_io_in_bits_23_real),
    .io_in_bits_23_imag(direct_io_in_bits_23_imag),
    .io_in_bits_24_real(direct_io_in_bits_24_real),
    .io_in_bits_24_imag(direct_io_in_bits_24_imag),
    .io_in_bits_25_real(direct_io_in_bits_25_real),
    .io_in_bits_25_imag(direct_io_in_bits_25_imag),
    .io_in_bits_26_real(direct_io_in_bits_26_real),
    .io_in_bits_26_imag(direct_io_in_bits_26_imag),
    .io_in_bits_27_real(direct_io_in_bits_27_real),
    .io_in_bits_27_imag(direct_io_in_bits_27_imag),
    .io_in_bits_28_real(direct_io_in_bits_28_real),
    .io_in_bits_28_imag(direct_io_in_bits_28_imag),
    .io_in_bits_29_real(direct_io_in_bits_29_real),
    .io_in_bits_29_imag(direct_io_in_bits_29_imag),
    .io_in_bits_30_real(direct_io_in_bits_30_real),
    .io_in_bits_30_imag(direct_io_in_bits_30_imag),
    .io_in_bits_31_real(direct_io_in_bits_31_real),
    .io_in_bits_31_imag(direct_io_in_bits_31_imag),
    .io_out_bits_4_real(direct_io_out_bits_4_real),
    .io_out_bits_4_imag(direct_io_out_bits_4_imag),
    .io_out_bits_5_real(direct_io_out_bits_5_real),
    .io_out_bits_5_imag(direct_io_out_bits_5_imag),
    .io_out_bits_6_real(direct_io_out_bits_6_real),
    .io_out_bits_6_imag(direct_io_out_bits_6_imag),
    .io_out_bits_7_real(direct_io_out_bits_7_real),
    .io_out_bits_7_imag(direct_io_out_bits_7_imag),
    .io_out_bits_8_real(direct_io_out_bits_8_real),
    .io_out_bits_8_imag(direct_io_out_bits_8_imag),
    .io_out_bits_9_real(direct_io_out_bits_9_real),
    .io_out_bits_9_imag(direct_io_out_bits_9_imag),
    .io_out_bits_10_real(direct_io_out_bits_10_real),
    .io_out_bits_10_imag(direct_io_out_bits_10_imag),
    .io_out_bits_11_real(direct_io_out_bits_11_real),
    .io_out_bits_11_imag(direct_io_out_bits_11_imag),
    .io_out_bits_12_real(direct_io_out_bits_12_real),
    .io_out_bits_12_imag(direct_io_out_bits_12_imag),
    .io_out_bits_13_real(direct_io_out_bits_13_real),
    .io_out_bits_13_imag(direct_io_out_bits_13_imag),
    .io_out_bits_14_real(direct_io_out_bits_14_real),
    .io_out_bits_14_imag(direct_io_out_bits_14_imag),
    .io_out_bits_15_real(direct_io_out_bits_15_real),
    .io_out_bits_15_imag(direct_io_out_bits_15_imag)
  );
  assign io_out_valid = valReg; // @[FFT.scala 448:16]
  assign io_out_bits_4_real = outReg_4_real; // @[FFT.scala 447:15]
  assign io_out_bits_4_imag = outReg_4_imag; // @[FFT.scala 447:15]
  assign io_out_bits_5_real = outReg_5_real; // @[FFT.scala 447:15]
  assign io_out_bits_5_imag = outReg_5_imag; // @[FFT.scala 447:15]
  assign io_out_bits_6_real = outReg_6_real; // @[FFT.scala 447:15]
  assign io_out_bits_6_imag = outReg_6_imag; // @[FFT.scala 447:15]
  assign io_out_bits_7_real = outReg_7_real; // @[FFT.scala 447:15]
  assign io_out_bits_7_imag = outReg_7_imag; // @[FFT.scala 447:15]
  assign io_out_bits_8_real = outReg_8_real; // @[FFT.scala 447:15]
  assign io_out_bits_8_imag = outReg_8_imag; // @[FFT.scala 447:15]
  assign io_out_bits_9_real = outReg_9_real; // @[FFT.scala 447:15]
  assign io_out_bits_9_imag = outReg_9_imag; // @[FFT.scala 447:15]
  assign io_out_bits_10_real = outReg_10_real; // @[FFT.scala 447:15]
  assign io_out_bits_10_imag = outReg_10_imag; // @[FFT.scala 447:15]
  assign io_out_bits_11_real = outReg_11_real; // @[FFT.scala 447:15]
  assign io_out_bits_11_imag = outReg_11_imag; // @[FFT.scala 447:15]
  assign io_out_bits_12_real = outReg_12_real; // @[FFT.scala 447:15]
  assign io_out_bits_12_imag = outReg_12_imag; // @[FFT.scala 447:15]
  assign io_out_bits_13_real = outReg_13_real; // @[FFT.scala 447:15]
  assign io_out_bits_13_imag = outReg_13_imag; // @[FFT.scala 447:15]
  assign io_out_bits_14_real = outReg_14_real; // @[FFT.scala 447:15]
  assign io_out_bits_14_imag = outReg_14_imag; // @[FFT.scala 447:15]
  assign io_out_bits_15_real = outReg_15_real; // @[FFT.scala 447:15]
  assign io_out_bits_15_imag = outReg_15_imag; // @[FFT.scala 447:15]
  assign direct_io_in_bits_0_real = io_in_valid ? $signed(io_in_bits_0_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_0_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_1_real = io_in_valid ? $signed(io_in_bits_1_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_1_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_2_real = io_in_valid ? $signed(io_in_bits_2_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_2_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_3_real = io_in_valid ? $signed(io_in_bits_3_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_3_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_4_real = io_in_valid ? $signed(io_in_bits_4_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_4_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_5_real = io_in_valid ? $signed(io_in_bits_5_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_5_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_6_real = io_in_valid ? $signed(io_in_bits_6_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_6_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_7_real = io_in_valid ? $signed(io_in_bits_7_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_7_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_8_real = io_in_valid ? $signed(io_in_bits_8_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_8_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_9_real = io_in_valid ? $signed(io_in_bits_9_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_9_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_10_real = io_in_valid ? $signed(io_in_bits_10_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_10_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_11_real = io_in_valid ? $signed(io_in_bits_11_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_11_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_12_real = io_in_valid ? $signed(io_in_bits_12_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_12_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_13_real = io_in_valid ? $signed(io_in_bits_13_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_13_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_14_real = io_in_valid ? $signed(io_in_bits_14_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_14_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_15_real = io_in_valid ? $signed(io_in_bits_15_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_15_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_16_real = io_in_valid ? $signed(io_in_bits_16_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_16_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_17_real = io_in_valid ? $signed(io_in_bits_17_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_17_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_18_real = io_in_valid ? $signed(io_in_bits_18_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_18_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_19_real = io_in_valid ? $signed(io_in_bits_19_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_19_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_20_real = io_in_valid ? $signed(io_in_bits_20_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_20_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_21_real = io_in_valid ? $signed(io_in_bits_21_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_21_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_22_real = io_in_valid ? $signed(io_in_bits_22_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_22_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_23_real = io_in_valid ? $signed(io_in_bits_23_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_23_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_24_real = io_in_valid ? $signed(io_in_bits_24_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_24_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_25_real = io_in_valid ? $signed(io_in_bits_25_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_25_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_26_real = io_in_valid ? $signed(io_in_bits_26_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_26_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_27_real = io_in_valid ? $signed(io_in_bits_27_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_27_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_28_real = io_in_valid ? $signed(io_in_bits_28_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_28_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_29_real = io_in_valid ? $signed(io_in_bits_29_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_29_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_30_real = io_in_valid ? $signed(io_in_bits_30_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_30_imag = 32'sh0; // @[FFT.scala 440:18]
  assign direct_io_in_bits_31_real = io_in_valid ? $signed(io_in_bits_31_real) : $signed(32'sh0); // @[FFT.scala 440:18]
  assign direct_io_in_bits_31_imag = 32'sh0; // @[FFT.scala 440:18]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  outReg_4_real = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  outReg_4_imag = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  outReg_5_real = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  outReg_5_imag = _RAND_3[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  outReg_6_real = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  outReg_6_imag = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  outReg_7_real = _RAND_6[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  outReg_7_imag = _RAND_7[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  outReg_8_real = _RAND_8[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  outReg_8_imag = _RAND_9[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  outReg_9_real = _RAND_10[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{`RANDOM}};
  outReg_9_imag = _RAND_11[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{`RANDOM}};
  outReg_10_real = _RAND_12[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{`RANDOM}};
  outReg_10_imag = _RAND_13[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{`RANDOM}};
  outReg_11_real = _RAND_14[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {1{`RANDOM}};
  outReg_11_imag = _RAND_15[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {1{`RANDOM}};
  outReg_12_real = _RAND_16[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {1{`RANDOM}};
  outReg_12_imag = _RAND_17[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{`RANDOM}};
  outReg_13_real = _RAND_18[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{`RANDOM}};
  outReg_13_imag = _RAND_19[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{`RANDOM}};
  outReg_14_real = _RAND_20[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_21 = {1{`RANDOM}};
  outReg_14_imag = _RAND_21[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_22 = {1{`RANDOM}};
  outReg_15_real = _RAND_22[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_23 = {1{`RANDOM}};
  outReg_15_imag = _RAND_23[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {1{`RANDOM}};
  valReg = _RAND_24[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (io_in_valid) begin
      outReg_4_real <= direct_io_out_bits_4_real;
    end
    if (io_in_valid) begin
      outReg_4_imag <= direct_io_out_bits_4_imag;
    end
    if (io_in_valid) begin
      outReg_5_real <= direct_io_out_bits_5_real;
    end
    if (io_in_valid) begin
      outReg_5_imag <= direct_io_out_bits_5_imag;
    end
    if (io_in_valid) begin
      outReg_6_real <= direct_io_out_bits_6_real;
    end
    if (io_in_valid) begin
      outReg_6_imag <= direct_io_out_bits_6_imag;
    end
    if (io_in_valid) begin
      outReg_7_real <= direct_io_out_bits_7_real;
    end
    if (io_in_valid) begin
      outReg_7_imag <= direct_io_out_bits_7_imag;
    end
    if (io_in_valid) begin
      outReg_8_real <= direct_io_out_bits_8_real;
    end
    if (io_in_valid) begin
      outReg_8_imag <= direct_io_out_bits_8_imag;
    end
    if (io_in_valid) begin
      outReg_9_real <= direct_io_out_bits_9_real;
    end
    if (io_in_valid) begin
      outReg_9_imag <= direct_io_out_bits_9_imag;
    end
    if (io_in_valid) begin
      outReg_10_real <= direct_io_out_bits_10_real;
    end
    if (io_in_valid) begin
      outReg_10_imag <= direct_io_out_bits_10_imag;
    end
    if (io_in_valid) begin
      outReg_11_real <= direct_io_out_bits_11_real;
    end
    if (io_in_valid) begin
      outReg_11_imag <= direct_io_out_bits_11_imag;
    end
    if (io_in_valid) begin
      outReg_12_real <= direct_io_out_bits_12_real;
    end
    if (io_in_valid) begin
      outReg_12_imag <= direct_io_out_bits_12_imag;
    end
    if (io_in_valid) begin
      outReg_13_real <= direct_io_out_bits_13_real;
    end
    if (io_in_valid) begin
      outReg_13_imag <= direct_io_out_bits_13_imag;
    end
    if (io_in_valid) begin
      outReg_14_real <= direct_io_out_bits_14_real;
    end
    if (io_in_valid) begin
      outReg_14_imag <= direct_io_out_bits_14_imag;
    end
    if (io_in_valid) begin
      outReg_15_real <= direct_io_out_bits_15_real;
    end
    if (io_in_valid) begin
      outReg_15_imag <= direct_io_out_bits_15_imag;
    end
    valReg <= io_in_valid;
  end
endmodule
module Bandpower(
  input         clock,
  input         io_in_valid,
  input  [31:0] io_in_bits_4_real,
  input  [31:0] io_in_bits_4_imag,
  input  [31:0] io_in_bits_5_real,
  input  [31:0] io_in_bits_5_imag,
  input  [31:0] io_in_bits_6_real,
  input  [31:0] io_in_bits_6_imag,
  input  [31:0] io_in_bits_7_real,
  input  [31:0] io_in_bits_7_imag,
  output        io_out_valid,
  output [31:0] io_out_bits
);
  wire [63:0] _T_80; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_81; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_83; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_4; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_84; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_85; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_87; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_5; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_88; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_89; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_91; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_6; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_92; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_93; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_95; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_7; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] p1_4; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] p1_5; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] p1_6; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] p1_7; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_195; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_196; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_198; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_199; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_201; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_202; // @[FixedPointTypeClass.scala 21:58]
  wire [62:0] _T_203; // @[FixedPointTypeClass.scala 118:50]
  wire [39:0] outNext; // @[FixedPointTypeClass.scala 118:50]
  reg [39:0] outReg; // @[Reg.scala 11:16]
  reg [63:0] _RAND_0;
  reg  valReg; // @[Bandpower.scala 89:23]
  reg [31:0] _RAND_1;
  assign _T_80 = $signed(io_in_bits_4_real) * $signed(io_in_bits_4_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_81 = $signed(io_in_bits_4_imag) * $signed(io_in_bits_4_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_83 = $signed(_T_80) + $signed(_T_81); // @[FixedPointTypeClass.scala 21:58]
  assign p2_4 = $signed(_T_83); // @[FixedPointTypeClass.scala 21:58]
  assign _T_84 = $signed(io_in_bits_5_real) * $signed(io_in_bits_5_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_85 = $signed(io_in_bits_5_imag) * $signed(io_in_bits_5_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_87 = $signed(_T_84) + $signed(_T_85); // @[FixedPointTypeClass.scala 21:58]
  assign p2_5 = $signed(_T_87); // @[FixedPointTypeClass.scala 21:58]
  assign _T_88 = $signed(io_in_bits_6_real) * $signed(io_in_bits_6_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_89 = $signed(io_in_bits_6_imag) * $signed(io_in_bits_6_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_91 = $signed(_T_88) + $signed(_T_89); // @[FixedPointTypeClass.scala 21:58]
  assign p2_6 = $signed(_T_91); // @[FixedPointTypeClass.scala 21:58]
  assign _T_92 = $signed(io_in_bits_7_real) * $signed(io_in_bits_7_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_93 = $signed(io_in_bits_7_imag) * $signed(io_in_bits_7_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_95 = $signed(_T_92) + $signed(_T_93); // @[FixedPointTypeClass.scala 21:58]
  assign p2_7 = $signed(_T_95); // @[FixedPointTypeClass.scala 21:58]
  assign p1_4 = $signed(p2_4) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign p1_5 = $signed(p2_5) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign p1_6 = $signed(p2_6) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign p1_7 = $signed(p2_7) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign _T_195 = $signed(p1_4) + $signed(p1_5); // @[FixedPointTypeClass.scala 21:58]
  assign _T_196 = $signed(_T_195); // @[FixedPointTypeClass.scala 21:58]
  assign _T_198 = $signed(_T_196) + $signed(p1_6); // @[FixedPointTypeClass.scala 21:58]
  assign _T_199 = $signed(_T_198); // @[FixedPointTypeClass.scala 21:58]
  assign _T_201 = $signed(_T_199) + $signed(p1_7); // @[FixedPointTypeClass.scala 21:58]
  assign _T_202 = $signed(_T_201); // @[FixedPointTypeClass.scala 21:58]
  assign _T_203 = _T_202[66:4]; // @[FixedPointTypeClass.scala 118:50]
  assign outNext = _T_203[62:23]; // @[FixedPointTypeClass.scala 118:50]
  assign io_out_valid = valReg; // @[Bandpower.scala 93:16]
  assign io_out_bits = outReg[39:8]; // @[Bandpower.scala 92:15]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  outReg = _RAND_0[39:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  valReg = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (io_in_valid) begin
      outReg <= outNext;
    end
    valReg <= io_in_valid;
  end
endmodule
module Bandpower_1(
  input         clock,
  input         io_in_valid,
  input  [31:0] io_in_bits_8_real,
  input  [31:0] io_in_bits_8_imag,
  input  [31:0] io_in_bits_9_real,
  input  [31:0] io_in_bits_9_imag,
  input  [31:0] io_in_bits_10_real,
  input  [31:0] io_in_bits_10_imag,
  input  [31:0] io_in_bits_11_real,
  input  [31:0] io_in_bits_11_imag,
  input  [31:0] io_in_bits_12_real,
  input  [31:0] io_in_bits_12_imag,
  input  [31:0] io_in_bits_13_real,
  input  [31:0] io_in_bits_13_imag,
  input  [31:0] io_in_bits_14_real,
  input  [31:0] io_in_bits_14_imag,
  input  [31:0] io_in_bits_15_real,
  input  [31:0] io_in_bits_15_imag,
  output        io_out_valid,
  output [31:0] io_out_bits
);
  wire [63:0] _T_96; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_97; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_99; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_8; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_100; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_101; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_103; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_9; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_104; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_105; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_107; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_10; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_108; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_109; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_111; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_11; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_112; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_113; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_115; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_12; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_116; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_117; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_119; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_13; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_120; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_121; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_123; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_14; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_124; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_125; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_127; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] p2_15; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] p1_8; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] p1_9; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] p1_10; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] p1_11; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] p1_12; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] p1_13; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] p1_14; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] p1_15; // @[FixedPointTypeClass.scala 43:59]
  wire [66:0] _T_195; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_196; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_198; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_199; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_201; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_202; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_204; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_205; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_207; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_208; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_210; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_211; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_213; // @[FixedPointTypeClass.scala 21:58]
  wire [66:0] _T_214; // @[FixedPointTypeClass.scala 21:58]
  wire [60:0] _T_215; // @[FixedPointTypeClass.scala 118:50]
  wire [37:0] outNext; // @[FixedPointTypeClass.scala 118:50]
  reg [37:0] outReg; // @[Reg.scala 11:16]
  reg [63:0] _RAND_0;
  reg  valReg; // @[Bandpower.scala 89:23]
  reg [31:0] _RAND_1;
  wire [29:0] _GEN_1; // @[Bandpower.scala 92:15]
  assign _T_96 = $signed(io_in_bits_8_real) * $signed(io_in_bits_8_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_97 = $signed(io_in_bits_8_imag) * $signed(io_in_bits_8_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_99 = $signed(_T_96) + $signed(_T_97); // @[FixedPointTypeClass.scala 21:58]
  assign p2_8 = $signed(_T_99); // @[FixedPointTypeClass.scala 21:58]
  assign _T_100 = $signed(io_in_bits_9_real) * $signed(io_in_bits_9_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_101 = $signed(io_in_bits_9_imag) * $signed(io_in_bits_9_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_103 = $signed(_T_100) + $signed(_T_101); // @[FixedPointTypeClass.scala 21:58]
  assign p2_9 = $signed(_T_103); // @[FixedPointTypeClass.scala 21:58]
  assign _T_104 = $signed(io_in_bits_10_real) * $signed(io_in_bits_10_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_105 = $signed(io_in_bits_10_imag) * $signed(io_in_bits_10_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_107 = $signed(_T_104) + $signed(_T_105); // @[FixedPointTypeClass.scala 21:58]
  assign p2_10 = $signed(_T_107); // @[FixedPointTypeClass.scala 21:58]
  assign _T_108 = $signed(io_in_bits_11_real) * $signed(io_in_bits_11_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_109 = $signed(io_in_bits_11_imag) * $signed(io_in_bits_11_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_111 = $signed(_T_108) + $signed(_T_109); // @[FixedPointTypeClass.scala 21:58]
  assign p2_11 = $signed(_T_111); // @[FixedPointTypeClass.scala 21:58]
  assign _T_112 = $signed(io_in_bits_12_real) * $signed(io_in_bits_12_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_113 = $signed(io_in_bits_12_imag) * $signed(io_in_bits_12_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_115 = $signed(_T_112) + $signed(_T_113); // @[FixedPointTypeClass.scala 21:58]
  assign p2_12 = $signed(_T_115); // @[FixedPointTypeClass.scala 21:58]
  assign _T_116 = $signed(io_in_bits_13_real) * $signed(io_in_bits_13_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_117 = $signed(io_in_bits_13_imag) * $signed(io_in_bits_13_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_119 = $signed(_T_116) + $signed(_T_117); // @[FixedPointTypeClass.scala 21:58]
  assign p2_13 = $signed(_T_119); // @[FixedPointTypeClass.scala 21:58]
  assign _T_120 = $signed(io_in_bits_14_real) * $signed(io_in_bits_14_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_121 = $signed(io_in_bits_14_imag) * $signed(io_in_bits_14_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_123 = $signed(_T_120) + $signed(_T_121); // @[FixedPointTypeClass.scala 21:58]
  assign p2_14 = $signed(_T_123); // @[FixedPointTypeClass.scala 21:58]
  assign _T_124 = $signed(io_in_bits_15_real) * $signed(io_in_bits_15_real); // @[FixedPointTypeClass.scala 43:59]
  assign _T_125 = $signed(io_in_bits_15_imag) * $signed(io_in_bits_15_imag); // @[FixedPointTypeClass.scala 43:59]
  assign _T_127 = $signed(_T_124) + $signed(_T_125); // @[FixedPointTypeClass.scala 21:58]
  assign p2_15 = $signed(_T_127); // @[FixedPointTypeClass.scala 21:58]
  assign p1_8 = $signed(p2_8) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign p1_9 = $signed(p2_9) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign p1_10 = $signed(p2_10) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign p1_11 = $signed(p2_11) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign p1_12 = $signed(p2_12) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign p1_13 = $signed(p2_13) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign p1_14 = $signed(p2_14) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign p1_15 = $signed(p2_15) * $signed(64'sh2); // @[FixedPointTypeClass.scala 43:59]
  assign _T_195 = $signed(p1_8) + $signed(p1_9); // @[FixedPointTypeClass.scala 21:58]
  assign _T_196 = $signed(_T_195); // @[FixedPointTypeClass.scala 21:58]
  assign _T_198 = $signed(_T_196) + $signed(p1_10); // @[FixedPointTypeClass.scala 21:58]
  assign _T_199 = $signed(_T_198); // @[FixedPointTypeClass.scala 21:58]
  assign _T_201 = $signed(_T_199) + $signed(p1_11); // @[FixedPointTypeClass.scala 21:58]
  assign _T_202 = $signed(_T_201); // @[FixedPointTypeClass.scala 21:58]
  assign _T_204 = $signed(_T_202) + $signed(p1_12); // @[FixedPointTypeClass.scala 21:58]
  assign _T_205 = $signed(_T_204); // @[FixedPointTypeClass.scala 21:58]
  assign _T_207 = $signed(_T_205) + $signed(p1_13); // @[FixedPointTypeClass.scala 21:58]
  assign _T_208 = $signed(_T_207); // @[FixedPointTypeClass.scala 21:58]
  assign _T_210 = $signed(_T_208) + $signed(p1_14); // @[FixedPointTypeClass.scala 21:58]
  assign _T_211 = $signed(_T_210); // @[FixedPointTypeClass.scala 21:58]
  assign _T_213 = $signed(_T_211) + $signed(p1_15); // @[FixedPointTypeClass.scala 21:58]
  assign _T_214 = $signed(_T_213); // @[FixedPointTypeClass.scala 21:58]
  assign _T_215 = _T_214[66:6]; // @[FixedPointTypeClass.scala 118:50]
  assign outNext = _T_215[60:23]; // @[FixedPointTypeClass.scala 118:50]
  assign io_out_valid = valReg; // @[Bandpower.scala 93:16]
  assign _GEN_1 = outReg[37:8]; // @[Bandpower.scala 92:15]
  assign io_out_bits = {{2{_GEN_1[29]}},_GEN_1}; // @[Bandpower.scala 92:15]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  outReg = _RAND_0[37:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  valReg = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (io_in_valid) begin
      outReg <= outNext;
    end
    valReg <= io_in_valid;
  end
endmodule
module lineLength(
  input         clock,
  input         reset,
  input         io_in_valid,
  input  [31:0] io_in_bits,
  output        io_out_valid,
  output [31:0] io_out_bits
);
  reg [31:0] lineLengths_0; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_0;
  reg [31:0] lineLengths_1; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_1;
  reg [31:0] lineLengths_2; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_2;
  reg [31:0] lineLengths_3; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_3;
  reg [31:0] lineLengths_4; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_4;
  reg [31:0] lineLengths_5; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_5;
  reg [31:0] lineLengths_6; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_6;
  reg [31:0] lineLengths_7; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_7;
  reg [31:0] lineLengths_8; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_8;
  reg [31:0] lineLengths_9; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_9;
  reg [31:0] lineLengths_10; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_10;
  reg [31:0] lineLengths_11; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_11;
  reg [31:0] lineLengths_12; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_12;
  reg [31:0] lineLengths_13; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_13;
  reg [31:0] lineLengths_14; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_14;
  reg [31:0] lineLengths_15; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_15;
  reg [31:0] lineLengths_16; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_16;
  reg [31:0] lineLengths_17; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_17;
  reg [31:0] lineLengths_18; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_18;
  reg [31:0] lineLengths_19; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_19;
  reg [31:0] lineLengths_20; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_20;
  reg [31:0] lineLengths_21; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_21;
  reg [31:0] lineLengths_22; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_22;
  reg [31:0] lineLengths_23; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_23;
  reg [31:0] lineLengths_24; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_24;
  reg [31:0] lineLengths_25; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_25;
  reg [31:0] lineLengths_26; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_26;
  reg [31:0] lineLengths_27; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_27;
  reg [31:0] lineLengths_28; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_28;
  reg [31:0] lineLengths_29; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_29;
  reg [31:0] lineLengths_30; // @[lineLength.scala 47:28]
  reg [31:0] _RAND_30;
  reg [31:0] pastVal; // @[lineLength.scala 49:24]
  reg [31:0] _RAND_31;
  wire  _T_3; // @[FixedPointTypeClass.scala 57:62]
  wire [31:0] _T_5; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_6; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_8; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_9; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_42; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_1; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_44; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_2; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_46; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_3; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_48; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_4; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_50; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_5; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_52; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_6; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_54; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_7; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_56; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_8; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_58; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_9; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_60; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_10; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_62; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_11; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_64; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_12; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_66; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_13; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_68; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_14; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_70; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_15; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_72; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_16; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_74; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_17; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_76; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_18; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_78; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_19; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_80; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_20; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_82; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_21; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_84; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_22; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_86; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_23; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_88; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_24; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_90; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_25; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_92; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_26; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_94; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_27; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_96; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_28; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_98; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_29; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] _T_100; // @[FixedPointTypeClass.scala 21:58]
  wire [31:0] accumulator_30; // @[FixedPointTypeClass.scala 21:58]
  wire [26:0] _T_102; // @[FixedPointTypeClass.scala 118:50]
  wire [23:0] _T_103; // @[FixedPointTypeClass.scala 118:50]
  reg  _T_104; // @[Reg.scala 19:20]
  reg [31:0] _RAND_32;
  reg  _T_105; // @[Reg.scala 19:20]
  reg [31:0] _RAND_33;
  reg  _T_106; // @[Reg.scala 19:20]
  reg [31:0] _RAND_34;
  reg  _T_107; // @[Reg.scala 19:20]
  reg [31:0] _RAND_35;
  reg  _T_108; // @[Reg.scala 19:20]
  reg [31:0] _RAND_36;
  reg  _T_109; // @[Reg.scala 19:20]
  reg [31:0] _RAND_37;
  reg  _T_110; // @[Reg.scala 19:20]
  reg [31:0] _RAND_38;
  reg  _T_111; // @[Reg.scala 19:20]
  reg [31:0] _RAND_39;
  reg  _T_112; // @[Reg.scala 19:20]
  reg [31:0] _RAND_40;
  reg  _T_113; // @[Reg.scala 19:20]
  reg [31:0] _RAND_41;
  reg  _T_114; // @[Reg.scala 19:20]
  reg [31:0] _RAND_42;
  reg  _T_115; // @[Reg.scala 19:20]
  reg [31:0] _RAND_43;
  reg  _T_116; // @[Reg.scala 19:20]
  reg [31:0] _RAND_44;
  reg  _T_117; // @[Reg.scala 19:20]
  reg [31:0] _RAND_45;
  reg  _T_118; // @[Reg.scala 19:20]
  reg [31:0] _RAND_46;
  reg  _T_119; // @[Reg.scala 19:20]
  reg [31:0] _RAND_47;
  reg  _T_120; // @[Reg.scala 19:20]
  reg [31:0] _RAND_48;
  reg  _T_121; // @[Reg.scala 19:20]
  reg [31:0] _RAND_49;
  reg  _T_122; // @[Reg.scala 19:20]
  reg [31:0] _RAND_50;
  reg  _T_123; // @[Reg.scala 19:20]
  reg [31:0] _RAND_51;
  reg  _T_124; // @[Reg.scala 19:20]
  reg [31:0] _RAND_52;
  reg  _T_125; // @[Reg.scala 19:20]
  reg [31:0] _RAND_53;
  reg  _T_126; // @[Reg.scala 19:20]
  reg [31:0] _RAND_54;
  reg  _T_127; // @[Reg.scala 19:20]
  reg [31:0] _RAND_55;
  reg  _T_128; // @[Reg.scala 19:20]
  reg [31:0] _RAND_56;
  reg  _T_129; // @[Reg.scala 19:20]
  reg [31:0] _RAND_57;
  reg  _T_130; // @[Reg.scala 19:20]
  reg [31:0] _RAND_58;
  reg  _T_131; // @[Reg.scala 19:20]
  reg [31:0] _RAND_59;
  reg  _T_132; // @[Reg.scala 19:20]
  reg [31:0] _RAND_60;
  reg  _T_133; // @[Reg.scala 19:20]
  reg [31:0] _RAND_61;
  reg  _T_134; // @[Reg.scala 19:20]
  reg [31:0] _RAND_62;
  reg  _T_135; // @[Reg.scala 19:20]
  reg [31:0] _RAND_63;
  assign _T_3 = $signed(io_in_bits) >= $signed(pastVal); // @[FixedPointTypeClass.scala 57:62]
  assign _T_5 = $signed(io_in_bits) - $signed(pastVal); // @[FixedPointTypeClass.scala 31:68]
  assign _T_6 = $signed(_T_5); // @[FixedPointTypeClass.scala 31:68]
  assign _T_8 = $signed(pastVal) - $signed(io_in_bits); // @[FixedPointTypeClass.scala 31:68]
  assign _T_9 = $signed(_T_8); // @[FixedPointTypeClass.scala 31:68]
  assign _T_42 = $signed(lineLengths_1) + $signed(lineLengths_0); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_1 = $signed(_T_42); // @[FixedPointTypeClass.scala 21:58]
  assign _T_44 = $signed(lineLengths_2) + $signed(accumulator_1); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_2 = $signed(_T_44); // @[FixedPointTypeClass.scala 21:58]
  assign _T_46 = $signed(lineLengths_3) + $signed(accumulator_2); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_3 = $signed(_T_46); // @[FixedPointTypeClass.scala 21:58]
  assign _T_48 = $signed(lineLengths_4) + $signed(accumulator_3); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_4 = $signed(_T_48); // @[FixedPointTypeClass.scala 21:58]
  assign _T_50 = $signed(lineLengths_5) + $signed(accumulator_4); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_5 = $signed(_T_50); // @[FixedPointTypeClass.scala 21:58]
  assign _T_52 = $signed(lineLengths_6) + $signed(accumulator_5); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_6 = $signed(_T_52); // @[FixedPointTypeClass.scala 21:58]
  assign _T_54 = $signed(lineLengths_7) + $signed(accumulator_6); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_7 = $signed(_T_54); // @[FixedPointTypeClass.scala 21:58]
  assign _T_56 = $signed(lineLengths_8) + $signed(accumulator_7); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_8 = $signed(_T_56); // @[FixedPointTypeClass.scala 21:58]
  assign _T_58 = $signed(lineLengths_9) + $signed(accumulator_8); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_9 = $signed(_T_58); // @[FixedPointTypeClass.scala 21:58]
  assign _T_60 = $signed(lineLengths_10) + $signed(accumulator_9); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_10 = $signed(_T_60); // @[FixedPointTypeClass.scala 21:58]
  assign _T_62 = $signed(lineLengths_11) + $signed(accumulator_10); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_11 = $signed(_T_62); // @[FixedPointTypeClass.scala 21:58]
  assign _T_64 = $signed(lineLengths_12) + $signed(accumulator_11); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_12 = $signed(_T_64); // @[FixedPointTypeClass.scala 21:58]
  assign _T_66 = $signed(lineLengths_13) + $signed(accumulator_12); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_13 = $signed(_T_66); // @[FixedPointTypeClass.scala 21:58]
  assign _T_68 = $signed(lineLengths_14) + $signed(accumulator_13); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_14 = $signed(_T_68); // @[FixedPointTypeClass.scala 21:58]
  assign _T_70 = $signed(lineLengths_15) + $signed(accumulator_14); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_15 = $signed(_T_70); // @[FixedPointTypeClass.scala 21:58]
  assign _T_72 = $signed(lineLengths_16) + $signed(accumulator_15); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_16 = $signed(_T_72); // @[FixedPointTypeClass.scala 21:58]
  assign _T_74 = $signed(lineLengths_17) + $signed(accumulator_16); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_17 = $signed(_T_74); // @[FixedPointTypeClass.scala 21:58]
  assign _T_76 = $signed(lineLengths_18) + $signed(accumulator_17); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_18 = $signed(_T_76); // @[FixedPointTypeClass.scala 21:58]
  assign _T_78 = $signed(lineLengths_19) + $signed(accumulator_18); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_19 = $signed(_T_78); // @[FixedPointTypeClass.scala 21:58]
  assign _T_80 = $signed(lineLengths_20) + $signed(accumulator_19); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_20 = $signed(_T_80); // @[FixedPointTypeClass.scala 21:58]
  assign _T_82 = $signed(lineLengths_21) + $signed(accumulator_20); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_21 = $signed(_T_82); // @[FixedPointTypeClass.scala 21:58]
  assign _T_84 = $signed(lineLengths_22) + $signed(accumulator_21); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_22 = $signed(_T_84); // @[FixedPointTypeClass.scala 21:58]
  assign _T_86 = $signed(lineLengths_23) + $signed(accumulator_22); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_23 = $signed(_T_86); // @[FixedPointTypeClass.scala 21:58]
  assign _T_88 = $signed(lineLengths_24) + $signed(accumulator_23); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_24 = $signed(_T_88); // @[FixedPointTypeClass.scala 21:58]
  assign _T_90 = $signed(lineLengths_25) + $signed(accumulator_24); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_25 = $signed(_T_90); // @[FixedPointTypeClass.scala 21:58]
  assign _T_92 = $signed(lineLengths_26) + $signed(accumulator_25); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_26 = $signed(_T_92); // @[FixedPointTypeClass.scala 21:58]
  assign _T_94 = $signed(lineLengths_27) + $signed(accumulator_26); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_27 = $signed(_T_94); // @[FixedPointTypeClass.scala 21:58]
  assign _T_96 = $signed(lineLengths_28) + $signed(accumulator_27); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_28 = $signed(_T_96); // @[FixedPointTypeClass.scala 21:58]
  assign _T_98 = $signed(lineLengths_29) + $signed(accumulator_28); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_29 = $signed(_T_98); // @[FixedPointTypeClass.scala 21:58]
  assign _T_100 = $signed(lineLengths_30) + $signed(accumulator_29); // @[FixedPointTypeClass.scala 21:58]
  assign accumulator_30 = $signed(_T_100); // @[FixedPointTypeClass.scala 21:58]
  assign _T_102 = accumulator_30[31:5]; // @[FixedPointTypeClass.scala 118:50]
  assign _T_103 = _T_102[26:3]; // @[FixedPointTypeClass.scala 118:50]
  assign io_out_valid = _T_135 & io_in_valid; // @[lineLength.scala 84:16]
  assign io_out_bits = {{8{_T_103[23]}},_T_103}; // @[lineLength.scala 83:15]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  lineLengths_0 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  lineLengths_1 = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  lineLengths_2 = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  lineLengths_3 = _RAND_3[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  lineLengths_4 = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  lineLengths_5 = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  lineLengths_6 = _RAND_6[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  lineLengths_7 = _RAND_7[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  lineLengths_8 = _RAND_8[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  lineLengths_9 = _RAND_9[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  lineLengths_10 = _RAND_10[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{`RANDOM}};
  lineLengths_11 = _RAND_11[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{`RANDOM}};
  lineLengths_12 = _RAND_12[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{`RANDOM}};
  lineLengths_13 = _RAND_13[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{`RANDOM}};
  lineLengths_14 = _RAND_14[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {1{`RANDOM}};
  lineLengths_15 = _RAND_15[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {1{`RANDOM}};
  lineLengths_16 = _RAND_16[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {1{`RANDOM}};
  lineLengths_17 = _RAND_17[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{`RANDOM}};
  lineLengths_18 = _RAND_18[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{`RANDOM}};
  lineLengths_19 = _RAND_19[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{`RANDOM}};
  lineLengths_20 = _RAND_20[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_21 = {1{`RANDOM}};
  lineLengths_21 = _RAND_21[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_22 = {1{`RANDOM}};
  lineLengths_22 = _RAND_22[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_23 = {1{`RANDOM}};
  lineLengths_23 = _RAND_23[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {1{`RANDOM}};
  lineLengths_24 = _RAND_24[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_25 = {1{`RANDOM}};
  lineLengths_25 = _RAND_25[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_26 = {1{`RANDOM}};
  lineLengths_26 = _RAND_26[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_27 = {1{`RANDOM}};
  lineLengths_27 = _RAND_27[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_28 = {1{`RANDOM}};
  lineLengths_28 = _RAND_28[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_29 = {1{`RANDOM}};
  lineLengths_29 = _RAND_29[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_30 = {1{`RANDOM}};
  lineLengths_30 = _RAND_30[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_31 = {1{`RANDOM}};
  pastVal = _RAND_31[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_32 = {1{`RANDOM}};
  _T_104 = _RAND_32[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_33 = {1{`RANDOM}};
  _T_105 = _RAND_33[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_34 = {1{`RANDOM}};
  _T_106 = _RAND_34[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_35 = {1{`RANDOM}};
  _T_107 = _RAND_35[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_36 = {1{`RANDOM}};
  _T_108 = _RAND_36[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_37 = {1{`RANDOM}};
  _T_109 = _RAND_37[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_38 = {1{`RANDOM}};
  _T_110 = _RAND_38[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_39 = {1{`RANDOM}};
  _T_111 = _RAND_39[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_40 = {1{`RANDOM}};
  _T_112 = _RAND_40[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_41 = {1{`RANDOM}};
  _T_113 = _RAND_41[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_42 = {1{`RANDOM}};
  _T_114 = _RAND_42[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_43 = {1{`RANDOM}};
  _T_115 = _RAND_43[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_44 = {1{`RANDOM}};
  _T_116 = _RAND_44[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_45 = {1{`RANDOM}};
  _T_117 = _RAND_45[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_46 = {1{`RANDOM}};
  _T_118 = _RAND_46[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_47 = {1{`RANDOM}};
  _T_119 = _RAND_47[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_48 = {1{`RANDOM}};
  _T_120 = _RAND_48[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_49 = {1{`RANDOM}};
  _T_121 = _RAND_49[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_50 = {1{`RANDOM}};
  _T_122 = _RAND_50[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_51 = {1{`RANDOM}};
  _T_123 = _RAND_51[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_52 = {1{`RANDOM}};
  _T_124 = _RAND_52[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_53 = {1{`RANDOM}};
  _T_125 = _RAND_53[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_54 = {1{`RANDOM}};
  _T_126 = _RAND_54[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_55 = {1{`RANDOM}};
  _T_127 = _RAND_55[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_56 = {1{`RANDOM}};
  _T_128 = _RAND_56[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_57 = {1{`RANDOM}};
  _T_129 = _RAND_57[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_58 = {1{`RANDOM}};
  _T_130 = _RAND_58[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_59 = {1{`RANDOM}};
  _T_131 = _RAND_59[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_60 = {1{`RANDOM}};
  _T_132 = _RAND_60[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_61 = {1{`RANDOM}};
  _T_133 = _RAND_61[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_62 = {1{`RANDOM}};
  _T_134 = _RAND_62[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_63 = {1{`RANDOM}};
  _T_135 = _RAND_63[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      lineLengths_0 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        if (_T_3) begin
          lineLengths_0 <= _T_6;
        end else begin
          lineLengths_0 <= _T_9;
        end
      end
    end
    if (reset) begin
      lineLengths_1 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_1 <= lineLengths_0;
      end
    end
    if (reset) begin
      lineLengths_2 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_2 <= lineLengths_1;
      end
    end
    if (reset) begin
      lineLengths_3 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_3 <= lineLengths_2;
      end
    end
    if (reset) begin
      lineLengths_4 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_4 <= lineLengths_3;
      end
    end
    if (reset) begin
      lineLengths_5 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_5 <= lineLengths_4;
      end
    end
    if (reset) begin
      lineLengths_6 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_6 <= lineLengths_5;
      end
    end
    if (reset) begin
      lineLengths_7 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_7 <= lineLengths_6;
      end
    end
    if (reset) begin
      lineLengths_8 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_8 <= lineLengths_7;
      end
    end
    if (reset) begin
      lineLengths_9 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_9 <= lineLengths_8;
      end
    end
    if (reset) begin
      lineLengths_10 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_10 <= lineLengths_9;
      end
    end
    if (reset) begin
      lineLengths_11 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_11 <= lineLengths_10;
      end
    end
    if (reset) begin
      lineLengths_12 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_12 <= lineLengths_11;
      end
    end
    if (reset) begin
      lineLengths_13 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_13 <= lineLengths_12;
      end
    end
    if (reset) begin
      lineLengths_14 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_14 <= lineLengths_13;
      end
    end
    if (reset) begin
      lineLengths_15 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_15 <= lineLengths_14;
      end
    end
    if (reset) begin
      lineLengths_16 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_16 <= lineLengths_15;
      end
    end
    if (reset) begin
      lineLengths_17 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_17 <= lineLengths_16;
      end
    end
    if (reset) begin
      lineLengths_18 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_18 <= lineLengths_17;
      end
    end
    if (reset) begin
      lineLengths_19 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_19 <= lineLengths_18;
      end
    end
    if (reset) begin
      lineLengths_20 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_20 <= lineLengths_19;
      end
    end
    if (reset) begin
      lineLengths_21 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_21 <= lineLengths_20;
      end
    end
    if (reset) begin
      lineLengths_22 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_22 <= lineLengths_21;
      end
    end
    if (reset) begin
      lineLengths_23 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_23 <= lineLengths_22;
      end
    end
    if (reset) begin
      lineLengths_24 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_24 <= lineLengths_23;
      end
    end
    if (reset) begin
      lineLengths_25 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_25 <= lineLengths_24;
      end
    end
    if (reset) begin
      lineLengths_26 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_26 <= lineLengths_25;
      end
    end
    if (reset) begin
      lineLengths_27 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_27 <= lineLengths_26;
      end
    end
    if (reset) begin
      lineLengths_28 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_28 <= lineLengths_27;
      end
    end
    if (reset) begin
      lineLengths_29 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_29 <= lineLengths_28;
      end
    end
    if (reset) begin
      lineLengths_30 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        lineLengths_30 <= lineLengths_29;
      end
    end
    if (reset) begin
      pastVal <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        pastVal <= io_in_bits;
      end
    end
    if (reset) begin
      _T_104 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_104 <= io_in_valid;
      end
    end
    if (reset) begin
      _T_105 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_105 <= _T_104;
      end
    end
    if (reset) begin
      _T_106 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_106 <= _T_105;
      end
    end
    if (reset) begin
      _T_107 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_107 <= _T_106;
      end
    end
    if (reset) begin
      _T_108 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_108 <= _T_107;
      end
    end
    if (reset) begin
      _T_109 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_109 <= _T_108;
      end
    end
    if (reset) begin
      _T_110 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_110 <= _T_109;
      end
    end
    if (reset) begin
      _T_111 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_111 <= _T_110;
      end
    end
    if (reset) begin
      _T_112 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_112 <= _T_111;
      end
    end
    if (reset) begin
      _T_113 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_113 <= _T_112;
      end
    end
    if (reset) begin
      _T_114 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_114 <= _T_113;
      end
    end
    if (reset) begin
      _T_115 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_115 <= _T_114;
      end
    end
    if (reset) begin
      _T_116 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_116 <= _T_115;
      end
    end
    if (reset) begin
      _T_117 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_117 <= _T_116;
      end
    end
    if (reset) begin
      _T_118 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_118 <= _T_117;
      end
    end
    if (reset) begin
      _T_119 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_119 <= _T_118;
      end
    end
    if (reset) begin
      _T_120 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_120 <= _T_119;
      end
    end
    if (reset) begin
      _T_121 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_121 <= _T_120;
      end
    end
    if (reset) begin
      _T_122 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_122 <= _T_121;
      end
    end
    if (reset) begin
      _T_123 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_123 <= _T_122;
      end
    end
    if (reset) begin
      _T_124 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_124 <= _T_123;
      end
    end
    if (reset) begin
      _T_125 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_125 <= _T_124;
      end
    end
    if (reset) begin
      _T_126 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_126 <= _T_125;
      end
    end
    if (reset) begin
      _T_127 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_127 <= _T_126;
      end
    end
    if (reset) begin
      _T_128 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_128 <= _T_127;
      end
    end
    if (reset) begin
      _T_129 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_129 <= _T_128;
      end
    end
    if (reset) begin
      _T_130 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_130 <= _T_129;
      end
    end
    if (reset) begin
      _T_131 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_131 <= _T_130;
      end
    end
    if (reset) begin
      _T_132 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_132 <= _T_131;
      end
    end
    if (reset) begin
      _T_133 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_133 <= _T_132;
      end
    end
    if (reset) begin
      _T_134 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_134 <= _T_133;
      end
    end
    if (reset) begin
      _T_135 <= 1'h0;
    end else begin
      if (io_in_valid) begin
        _T_135 <= _T_134;
      end
    end
  end
endmodule
module ShiftReg(
  input         clock,
  input         reset,
  input         io_in_valid,
  input  [31:0] io_in_bits,
  output        io_out_valid,
  output [31:0] io_out_bits
);
  reg [31:0] outRegs_0; // @[ShiftReg.scala 30:24]
  reg [31:0] _RAND_0;
  reg  valRegs_0; // @[ShiftReg.scala 31:24]
  reg [31:0] _RAND_1;
  assign io_out_valid = valRegs_0; // @[ShiftReg.scala 45:16]
  assign io_out_bits = outRegs_0; // @[ShiftReg.scala 44:15]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  outRegs_0 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  valRegs_0 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      outRegs_0 <= 32'sh0;
    end else begin
      outRegs_0 <= io_in_bits;
    end
    if (reset) begin
      valRegs_0 <= 1'h0;
    end else begin
      valRegs_0 <= io_in_valid;
    end
  end
endmodule
module PCANormalizer(
  input         clock,
  input         io_in_valid,
  input  [31:0] io_in_bits_0,
  input  [31:0] io_in_bits_1,
  input  [31:0] io_in_bits_2,
  output        io_out_valid,
  output [31:0] io_out_bits_0,
  output [31:0] io_out_bits_1,
  output [31:0] io_out_bits_2,
  input  [31:0] io_PCANormalizationData_0_0,
  input  [31:0] io_PCANormalizationData_0_1,
  input  [31:0] io_PCANormalizationData_1_0,
  input  [31:0] io_PCANormalizationData_1_1,
  input  [31:0] io_PCANormalizationData_2_0,
  input  [31:0] io_PCANormalizationData_2_1
);
  wire [31:0] _T_1; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_2; // @[FixedPointTypeClass.scala 31:68]
  wire [63:0] _T_3; // @[FixedPointTypeClass.scala 43:59]
  wire [31:0] _T_5; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_6; // @[FixedPointTypeClass.scala 31:68]
  wire [63:0] _T_7; // @[FixedPointTypeClass.scala 43:59]
  wire [31:0] _T_9; // @[FixedPointTypeClass.scala 31:68]
  wire [31:0] _T_10; // @[FixedPointTypeClass.scala 31:68]
  wire [63:0] _T_11; // @[FixedPointTypeClass.scala 43:59]
  reg [31:0] outReg_0; // @[Reg.scala 11:16]
  reg [31:0] _RAND_0;
  reg [31:0] outReg_1; // @[Reg.scala 11:16]
  reg [31:0] _RAND_1;
  reg [31:0] outReg_2; // @[Reg.scala 11:16]
  reg [31:0] _RAND_2;
  wire [55:0] _GEN_3; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  wire [31:0] _GEN_4; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  wire [31:0] normalizedDimensions_0; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  wire [55:0] _GEN_5; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  wire [31:0] _GEN_6; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  wire [31:0] normalizedDimensions_1; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  wire [55:0] _GEN_7; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  wire [31:0] _GEN_8; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  wire [31:0] normalizedDimensions_2; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  reg  valReg; // @[pcaNormalizer.scala 31:23]
  reg [31:0] _RAND_3;
  assign _T_1 = $signed(io_in_bits_0) - $signed(io_PCANormalizationData_0_0); // @[FixedPointTypeClass.scala 31:68]
  assign _T_2 = $signed(_T_1); // @[FixedPointTypeClass.scala 31:68]
  assign _T_3 = $signed(_T_2) * $signed(io_PCANormalizationData_0_1); // @[FixedPointTypeClass.scala 43:59]
  assign _T_5 = $signed(io_in_bits_1) - $signed(io_PCANormalizationData_1_0); // @[FixedPointTypeClass.scala 31:68]
  assign _T_6 = $signed(_T_5); // @[FixedPointTypeClass.scala 31:68]
  assign _T_7 = $signed(_T_6) * $signed(io_PCANormalizationData_1_1); // @[FixedPointTypeClass.scala 43:59]
  assign _T_9 = $signed(io_in_bits_2) - $signed(io_PCANormalizationData_2_0); // @[FixedPointTypeClass.scala 31:68]
  assign _T_10 = $signed(_T_9); // @[FixedPointTypeClass.scala 31:68]
  assign _T_11 = $signed(_T_10) * $signed(io_PCANormalizationData_2_1); // @[FixedPointTypeClass.scala 43:59]
  assign _GEN_3 = _T_3[63:8]; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  assign _GEN_4 = _GEN_3[31:0]; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  assign normalizedDimensions_0 = $signed(_GEN_4); // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  assign _GEN_5 = _T_7[63:8]; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  assign _GEN_6 = _GEN_5[31:0]; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  assign normalizedDimensions_1 = $signed(_GEN_6); // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  assign _GEN_7 = _T_11[63:8]; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  assign _GEN_8 = _GEN_7[31:0]; // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  assign normalizedDimensions_2 = $signed(_GEN_8); // @[pcaNormalizer.scala 26:34 pcaNormalizer.scala 28:24]
  assign io_out_valid = valReg; // @[pcaNormalizer.scala 35:16]
  assign io_out_bits_0 = outReg_0; // @[pcaNormalizer.scala 34:15]
  assign io_out_bits_1 = outReg_1; // @[pcaNormalizer.scala 34:15]
  assign io_out_bits_2 = outReg_2; // @[pcaNormalizer.scala 34:15]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  outReg_0 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  outReg_1 = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  outReg_2 = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  valReg = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (io_in_valid) begin
      outReg_0 <= normalizedDimensions_0;
    end
    if (io_in_valid) begin
      outReg_1 <= normalizedDimensions_1;
    end
    if (io_in_valid) begin
      outReg_2 <= normalizedDimensions_2;
    end
    valReg <= io_in_valid;
  end
endmodule
module PCA(
  input         clock,
  input         io_in_valid,
  input  [31:0] io_in_bits_0,
  input  [31:0] io_in_bits_1,
  input  [31:0] io_in_bits_2,
  output        io_out_valid,
  output [31:0] io_out_bits_0,
  output [31:0] io_out_bits_1,
  input  [31:0] io_PCAVector_0_0,
  input  [31:0] io_PCAVector_0_1,
  input  [31:0] io_PCAVector_0_2,
  input  [31:0] io_PCAVector_1_0,
  input  [31:0] io_PCAVector_1_1,
  input  [31:0] io_PCAVector_1_2
);
  wire [63:0] _T; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_1; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_2; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_4; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_5; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_7; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_8; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_9; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_10; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_11; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_13; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_14; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_16; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_17; // @[FixedPointTypeClass.scala 21:58]
  reg [31:0] outReg_0; // @[Reg.scala 11:16]
  reg [31:0] _RAND_0;
  reg [31:0] outReg_1; // @[Reg.scala 11:16]
  reg [31:0] _RAND_1;
  wire [55:0] _GEN_2; // @[pca.scala 33:21 pca.scala 35:16]
  wire [31:0] _GEN_3; // @[pca.scala 33:21 pca.scala 35:16]
  wire [31:0] reduced_0; // @[pca.scala 33:21 pca.scala 35:16]
  wire [55:0] _GEN_4; // @[pca.scala 33:21 pca.scala 35:16]
  wire [31:0] _GEN_5; // @[pca.scala 33:21 pca.scala 35:16]
  wire [31:0] reduced_1; // @[pca.scala 33:21 pca.scala 35:16]
  reg  valReg; // @[pca.scala 39:23]
  reg [31:0] _RAND_2;
  assign _T = $signed(io_in_bits_0) * $signed(io_PCAVector_0_0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_1 = $signed(io_in_bits_1) * $signed(io_PCAVector_0_1); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2 = $signed(io_in_bits_2) * $signed(io_PCAVector_0_2); // @[FixedPointTypeClass.scala 43:59]
  assign _T_4 = $signed(_T) + $signed(_T_1); // @[FixedPointTypeClass.scala 21:58]
  assign _T_5 = $signed(_T_4); // @[FixedPointTypeClass.scala 21:58]
  assign _T_7 = $signed(_T_5) + $signed(_T_2); // @[FixedPointTypeClass.scala 21:58]
  assign _T_8 = $signed(_T_7); // @[FixedPointTypeClass.scala 21:58]
  assign _T_9 = $signed(io_in_bits_0) * $signed(io_PCAVector_1_0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_10 = $signed(io_in_bits_1) * $signed(io_PCAVector_1_1); // @[FixedPointTypeClass.scala 43:59]
  assign _T_11 = $signed(io_in_bits_2) * $signed(io_PCAVector_1_2); // @[FixedPointTypeClass.scala 43:59]
  assign _T_13 = $signed(_T_9) + $signed(_T_10); // @[FixedPointTypeClass.scala 21:58]
  assign _T_14 = $signed(_T_13); // @[FixedPointTypeClass.scala 21:58]
  assign _T_16 = $signed(_T_14) + $signed(_T_11); // @[FixedPointTypeClass.scala 21:58]
  assign _T_17 = $signed(_T_16); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_2 = _T_8[63:8]; // @[pca.scala 33:21 pca.scala 35:16]
  assign _GEN_3 = _GEN_2[31:0]; // @[pca.scala 33:21 pca.scala 35:16]
  assign reduced_0 = $signed(_GEN_3); // @[pca.scala 33:21 pca.scala 35:16]
  assign _GEN_4 = _T_17[63:8]; // @[pca.scala 33:21 pca.scala 35:16]
  assign _GEN_5 = _GEN_4[31:0]; // @[pca.scala 33:21 pca.scala 35:16]
  assign reduced_1 = $signed(_GEN_5); // @[pca.scala 33:21 pca.scala 35:16]
  assign io_out_valid = valReg; // @[pca.scala 43:16]
  assign io_out_bits_0 = outReg_0; // @[pca.scala 42:15]
  assign io_out_bits_1 = outReg_1; // @[pca.scala 42:15]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  outReg_0 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  outReg_1 = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  valReg = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (io_in_valid) begin
      outReg_0 <= reduced_0;
    end
    if (io_in_valid) begin
      outReg_1 <= reduced_1;
    end
    valReg <= io_in_valid;
  end
endmodule
module Logistic(
  input         clock,
  input         io_in_valid,
  input  [31:0] io_in_bits_0,
  input  [31:0] io_in_bits_1,
  output        io_out_valid,
  output        io_out_bits,
  input  [31:0] io_weights_0,
  input  [31:0] io_weights_1,
  input  [31:0] io_intercept,
  output [31:0] io_rawVotes
);
  wire [63:0] _T_1; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_2; // @[FixedPointTypeClass.scala 43:59]
  wire [63:0] _T_4; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_5; // @[FixedPointTypeClass.scala 21:58]
  wire [39:0] _GEN_45; // @[FixedPointTypeClass.scala 21:58]
  wire [39:0] _GEN_46; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _GEN_47; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] _T_7; // @[FixedPointTypeClass.scala 21:58]
  wire [63:0] reduced; // @[FixedPointTypeClass.scala 21:58]
  wire  thermometerCode_0; // @[FixedPointTypeClass.scala 57:62]
  wire  thermometerCode_1; // @[FixedPointTypeClass.scala 57:62]
  wire  thermometerCode_2; // @[FixedPointTypeClass.scala 57:62]
  wire  thermometerCode_3; // @[FixedPointTypeClass.scala 57:62]
  wire  thermometerCode_4; // @[FixedPointTypeClass.scala 57:62]
  wire  thermometerCode_5; // @[FixedPointTypeClass.scala 57:62]
  wire  thermometerCode_6; // @[FixedPointTypeClass.scala 57:62]
  wire  thermometerCode_7; // @[FixedPointTypeClass.scala 57:62]
  wire  thermometerCode_8; // @[FixedPointTypeClass.scala 57:62]
  wire  thermometerCode_9; // @[FixedPointTypeClass.scala 57:62]
  wire  thermometerCode_10; // @[FixedPointTypeClass.scala 57:62]
  wire [1:0] _T_30; // @[logistic.scala 95:60]
  wire [1:0] _GEN_48; // @[logistic.scala 95:60]
  wire [2:0] _T_31; // @[logistic.scala 95:60]
  wire [2:0] _GEN_49; // @[logistic.scala 95:60]
  wire [3:0] _T_32; // @[logistic.scala 95:60]
  wire [3:0] _GEN_50; // @[logistic.scala 95:60]
  wire [4:0] _T_33; // @[logistic.scala 95:60]
  wire [4:0] _GEN_51; // @[logistic.scala 95:60]
  wire [5:0] _T_34; // @[logistic.scala 95:60]
  wire [5:0] _GEN_52; // @[logistic.scala 95:60]
  wire [6:0] _T_35; // @[logistic.scala 95:60]
  wire [6:0] _GEN_53; // @[logistic.scala 95:60]
  wire [7:0] _T_36; // @[logistic.scala 95:60]
  wire [7:0] _GEN_54; // @[logistic.scala 95:60]
  wire [8:0] _T_37; // @[logistic.scala 95:60]
  wire [8:0] _GEN_55; // @[logistic.scala 95:60]
  wire [9:0] _T_38; // @[logistic.scala 95:60]
  wire [9:0] _GEN_56; // @[logistic.scala 95:60]
  wire [10:0] _T_39; // @[logistic.scala 95:60]
  wire [3:0] _T_40;
  reg [15:0] rawVotesReg; // @[Reg.scala 11:16]
  reg [31:0] _RAND_0;
  reg  outReg; // @[Reg.scala 11:16]
  reg [31:0] _RAND_1;
  reg  valReg; // @[logistic.scala 105:23]
  reg [31:0] _RAND_2;
  wire [9:0] _GEN_77; // @[logistic.scala 109:15]
  assign _T_1 = $signed(io_in_bits_0) * $signed(io_weights_0); // @[FixedPointTypeClass.scala 43:59]
  assign _T_2 = $signed(io_in_bits_1) * $signed(io_weights_1); // @[FixedPointTypeClass.scala 43:59]
  assign _T_4 = $signed(_T_1) + $signed(_T_2); // @[FixedPointTypeClass.scala 21:58]
  assign _T_5 = $signed(_T_4); // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_45 = {{8{io_intercept[31]}},io_intercept}; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_46 = $signed(_GEN_45) << 8; // @[FixedPointTypeClass.scala 21:58]
  assign _GEN_47 = {{24{_GEN_46[39]}},_GEN_46}; // @[FixedPointTypeClass.scala 21:58]
  assign _T_7 = $signed(_T_5) + $signed(_GEN_47); // @[FixedPointTypeClass.scala 21:58]
  assign reduced = $signed(_T_7); // @[FixedPointTypeClass.scala 21:58]
  assign thermometerCode_0 = $signed(reduced) >= $signed(-64'sh30c00); // @[FixedPointTypeClass.scala 57:62]
  assign thermometerCode_1 = $signed(reduced) >= $signed(-64'sh1d900); // @[FixedPointTypeClass.scala 57:62]
  assign thermometerCode_2 = $signed(reduced) >= $signed(-64'sh13a00); // @[FixedPointTypeClass.scala 57:62]
  assign thermometerCode_3 = $signed(reduced) >= $signed(-64'shc400); // @[FixedPointTypeClass.scala 57:62]
  assign thermometerCode_4 = $signed(reduced) >= $signed(-64'sh5f00); // @[FixedPointTypeClass.scala 57:62]
  assign thermometerCode_5 = $signed(reduced) >= $signed(64'sh0); // @[FixedPointTypeClass.scala 57:62]
  assign thermometerCode_6 = $signed(reduced) >= $signed(64'sh5e00); // @[FixedPointTypeClass.scala 57:62]
  assign thermometerCode_7 = $signed(reduced) >= $signed(64'shc300); // @[FixedPointTypeClass.scala 57:62]
  assign thermometerCode_8 = $signed(reduced) >= $signed(64'sh13900); // @[FixedPointTypeClass.scala 57:62]
  assign thermometerCode_9 = $signed(reduced) >= $signed(64'sh1d800); // @[FixedPointTypeClass.scala 57:62]
  assign thermometerCode_10 = $signed(reduced) >= $signed(64'sh30b00); // @[FixedPointTypeClass.scala 57:62]
  assign _T_30 = thermometerCode_0 + thermometerCode_1; // @[logistic.scala 95:60]
  assign _GEN_48 = {{1'd0}, thermometerCode_2}; // @[logistic.scala 95:60]
  assign _T_31 = _T_30 + _GEN_48; // @[logistic.scala 95:60]
  assign _GEN_49 = {{2'd0}, thermometerCode_3}; // @[logistic.scala 95:60]
  assign _T_32 = _T_31 + _GEN_49; // @[logistic.scala 95:60]
  assign _GEN_50 = {{3'd0}, thermometerCode_4}; // @[logistic.scala 95:60]
  assign _T_33 = _T_32 + _GEN_50; // @[logistic.scala 95:60]
  assign _GEN_51 = {{4'd0}, thermometerCode_5}; // @[logistic.scala 95:60]
  assign _T_34 = _T_33 + _GEN_51; // @[logistic.scala 95:60]
  assign _GEN_52 = {{5'd0}, thermometerCode_6}; // @[logistic.scala 95:60]
  assign _T_35 = _T_34 + _GEN_52; // @[logistic.scala 95:60]
  assign _GEN_53 = {{6'd0}, thermometerCode_7}; // @[logistic.scala 95:60]
  assign _T_36 = _T_35 + _GEN_53; // @[logistic.scala 95:60]
  assign _GEN_54 = {{7'd0}, thermometerCode_8}; // @[logistic.scala 95:60]
  assign _T_37 = _T_36 + _GEN_54; // @[logistic.scala 95:60]
  assign _GEN_55 = {{8'd0}, thermometerCode_9}; // @[logistic.scala 95:60]
  assign _T_38 = _T_37 + _GEN_55; // @[logistic.scala 95:60]
  assign _GEN_56 = {{9'd0}, thermometerCode_10}; // @[logistic.scala 95:60]
  assign _T_39 = _T_38 + _GEN_56; // @[logistic.scala 95:60]
  assign _T_40 = _T_39[3:0];
  assign io_out_valid = valReg; // @[logistic.scala 113:16]
  assign io_out_bits = outReg; // @[logistic.scala 112:15]
  assign _GEN_77 = rawVotesReg[15:6]; // @[logistic.scala 109:15]
  assign io_rawVotes = {{22{_GEN_77[9]}},_GEN_77}; // @[logistic.scala 109:15]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  rawVotesReg = _RAND_0[15:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  outReg = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  valReg = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (io_in_valid) begin
      if (4'hb == _T_40) begin
        rawVotesReg <= 16'sh4000;
      end else begin
        if (4'ha == _T_40) begin
          rawVotesReg <= 16'sh3a2f;
        end else begin
          if (4'h9 == _T_40) begin
            rawVotesReg <= 16'sh345d;
          end else begin
            if (4'h8 == _T_40) begin
              rawVotesReg <= 16'sh2e8c;
            end else begin
              if (4'h7 == _T_40) begin
                rawVotesReg <= 16'sh28ba;
              end else begin
                if (4'h6 == _T_40) begin
                  rawVotesReg <= 16'sh22e9;
                end else begin
                  if (4'h5 == _T_40) begin
                    rawVotesReg <= 16'sh1d17;
                  end else begin
                    if (4'h4 == _T_40) begin
                      rawVotesReg <= 16'sh1746;
                    end else begin
                      if (4'h3 == _T_40) begin
                        rawVotesReg <= 16'sh1174;
                      end else begin
                        if (4'h2 == _T_40) begin
                          rawVotesReg <= 16'shba3;
                        end else begin
                          if (4'h1 == _T_40) begin
                            rawVotesReg <= 16'sh5d1;
                          end else begin
                            rawVotesReg <= 16'sh0;
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if (io_in_valid) begin
      outReg <= thermometerCode_5;
    end
    valReg <= io_in_valid;
  end
endmodule
module wellnessGenModule(
  input         clock,
  input         reset,
  input         io_streamIn_valid,
  input  [31:0] io_streamIn_bits,
  input         io_in_valid,
  input  [31:0] io_in_bits,
  input  [31:0] io_inConf_bits_confPCAVector_0_0,
  input  [31:0] io_inConf_bits_confPCAVector_0_1,
  input  [31:0] io_inConf_bits_confPCAVector_0_2,
  input  [31:0] io_inConf_bits_confPCAVector_1_0,
  input  [31:0] io_inConf_bits_confPCAVector_1_1,
  input  [31:0] io_inConf_bits_confPCAVector_1_2,
  input  [31:0] io_inConf_bits_confLogisticWeightsVector_0_0,
  input  [31:0] io_inConf_bits_confLogisticWeightsVector_0_1,
  input  [31:0] io_inConf_bits_confLogisticIntercept_0_0,
  input         io_inConf_bits_confInputMuxSel,
  input  [31:0] io_inConf_bits_confPCANormalizationData_0_0,
  input  [31:0] io_inConf_bits_confPCANormalizationData_0_1,
  input  [31:0] io_inConf_bits_confPCANormalizationData_1_0,
  input  [31:0] io_inConf_bits_confPCANormalizationData_1_1,
  input  [31:0] io_inConf_bits_confPCANormalizationData_2_0,
  input  [31:0] io_inConf_bits_confPCANormalizationData_2_1,
  output        io_out_valid,
  output        io_out_bits,
  output [31:0] io_rawVotes
);
  wire  ConstantCoefficientFIRFilter_clock; // @[WellnessGen.scala 331:48]
  wire  ConstantCoefficientFIRFilter_reset; // @[WellnessGen.scala 331:48]
  wire  ConstantCoefficientFIRFilter_io_in_valid; // @[WellnessGen.scala 331:48]
  wire [31:0] ConstantCoefficientFIRFilter_io_in_bits; // @[WellnessGen.scala 331:48]
  wire  ConstantCoefficientFIRFilter_io_out_valid; // @[WellnessGen.scala 331:48]
  wire [31:0] ConstantCoefficientFIRFilter_io_out_bits; // @[WellnessGen.scala 331:48]
  wire  FFTBuffer_clock; // @[WellnessGen.scala 335:54]
  wire  FFTBuffer_reset; // @[WellnessGen.scala 335:54]
  wire  FFTBuffer_io_in_valid; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_in_bits; // @[WellnessGen.scala 335:54]
  wire  FFTBuffer_io_out_valid; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_0; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_1; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_2; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_3; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_4; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_5; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_6; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_7; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_8; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_9; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_10; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_11; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_12; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_13; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_14; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_15; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_16; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_17; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_18; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_19; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_20; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_21; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_22; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_23; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_24; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_25; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_26; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_27; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_28; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_29; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_30; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_io_out_bits_31; // @[WellnessGen.scala 335:54]
  wire  FFT_clock; // @[WellnessGen.scala 337:48]
  wire  FFT_io_in_valid; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_0_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_1_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_2_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_3_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_4_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_5_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_6_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_7_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_8_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_9_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_10_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_11_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_12_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_13_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_14_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_15_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_16_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_17_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_18_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_19_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_20_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_21_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_22_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_23_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_24_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_25_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_26_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_27_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_28_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_29_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_30_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_in_bits_31_real; // @[WellnessGen.scala 337:48]
  wire  FFT_io_out_valid; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_4_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_4_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_5_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_5_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_6_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_6_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_7_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_7_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_8_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_8_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_9_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_9_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_10_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_10_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_11_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_11_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_12_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_12_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_13_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_13_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_14_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_14_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_15_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_io_out_bits_15_imag; // @[WellnessGen.scala 337:48]
  wire  Bandpower_clock; // @[WellnessGen.scala 341:54]
  wire  Bandpower_io_in_valid; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_io_in_bits_4_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_io_in_bits_4_imag; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_io_in_bits_5_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_io_in_bits_5_imag; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_io_in_bits_6_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_io_in_bits_6_imag; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_io_in_bits_7_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_io_in_bits_7_imag; // @[WellnessGen.scala 341:54]
  wire  Bandpower_io_out_valid; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_io_out_bits; // @[WellnessGen.scala 341:54]
  wire  ConstantCoefficientFIRFilter_1_clock; // @[WellnessGen.scala 331:48]
  wire  ConstantCoefficientFIRFilter_1_reset; // @[WellnessGen.scala 331:48]
  wire  ConstantCoefficientFIRFilter_1_io_in_valid; // @[WellnessGen.scala 331:48]
  wire [31:0] ConstantCoefficientFIRFilter_1_io_in_bits; // @[WellnessGen.scala 331:48]
  wire  ConstantCoefficientFIRFilter_1_io_out_valid; // @[WellnessGen.scala 331:48]
  wire [31:0] ConstantCoefficientFIRFilter_1_io_out_bits; // @[WellnessGen.scala 331:48]
  wire  FFTBuffer_1_clock; // @[WellnessGen.scala 335:54]
  wire  FFTBuffer_1_reset; // @[WellnessGen.scala 335:54]
  wire  FFTBuffer_1_io_in_valid; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_in_bits; // @[WellnessGen.scala 335:54]
  wire  FFTBuffer_1_io_out_valid; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_0; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_1; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_2; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_3; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_4; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_5; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_6; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_7; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_8; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_9; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_10; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_11; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_12; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_13; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_14; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_15; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_16; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_17; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_18; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_19; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_20; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_21; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_22; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_23; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_24; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_25; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_26; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_27; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_28; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_29; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_30; // @[WellnessGen.scala 335:54]
  wire [31:0] FFTBuffer_1_io_out_bits_31; // @[WellnessGen.scala 335:54]
  wire  FFT_1_clock; // @[WellnessGen.scala 337:48]
  wire  FFT_1_io_in_valid; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_0_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_1_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_2_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_3_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_4_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_5_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_6_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_7_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_8_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_9_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_10_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_11_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_12_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_13_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_14_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_15_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_16_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_17_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_18_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_19_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_20_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_21_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_22_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_23_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_24_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_25_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_26_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_27_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_28_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_29_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_30_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_in_bits_31_real; // @[WellnessGen.scala 337:48]
  wire  FFT_1_io_out_valid; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_4_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_4_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_5_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_5_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_6_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_6_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_7_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_7_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_8_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_8_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_9_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_9_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_10_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_10_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_11_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_11_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_12_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_12_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_13_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_13_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_14_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_14_imag; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_15_real; // @[WellnessGen.scala 337:48]
  wire [31:0] FFT_1_io_out_bits_15_imag; // @[WellnessGen.scala 337:48]
  wire  Bandpower_1_clock; // @[WellnessGen.scala 341:54]
  wire  Bandpower_1_io_in_valid; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_8_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_8_imag; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_9_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_9_imag; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_10_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_10_imag; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_11_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_11_imag; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_12_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_12_imag; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_13_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_13_imag; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_14_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_14_imag; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_15_real; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_in_bits_15_imag; // @[WellnessGen.scala 341:54]
  wire  Bandpower_1_io_out_valid; // @[WellnessGen.scala 341:54]
  wire [31:0] Bandpower_1_io_out_bits; // @[WellnessGen.scala 341:54]
  wire  ConstantCoefficientFIRFilter_2_clock; // @[WellnessGen.scala 331:48]
  wire  ConstantCoefficientFIRFilter_2_reset; // @[WellnessGen.scala 331:48]
  wire  ConstantCoefficientFIRFilter_2_io_in_valid; // @[WellnessGen.scala 331:48]
  wire [31:0] ConstantCoefficientFIRFilter_2_io_in_bits; // @[WellnessGen.scala 331:48]
  wire  ConstantCoefficientFIRFilter_2_io_out_valid; // @[WellnessGen.scala 331:48]
  wire [31:0] ConstantCoefficientFIRFilter_2_io_out_bits; // @[WellnessGen.scala 331:48]
  wire  lineLength_clock; // @[WellnessGen.scala 339:55]
  wire  lineLength_reset; // @[WellnessGen.scala 339:55]
  wire  lineLength_io_in_valid; // @[WellnessGen.scala 339:55]
  wire [31:0] lineLength_io_in_bits; // @[WellnessGen.scala 339:55]
  wire  lineLength_io_out_valid; // @[WellnessGen.scala 339:55]
  wire [31:0] lineLength_io_out_bits; // @[WellnessGen.scala 339:55]
  wire  ShiftReg_clock; // @[WellnessGen.scala 343:52]
  wire  ShiftReg_reset; // @[WellnessGen.scala 343:52]
  wire  ShiftReg_io_in_valid; // @[WellnessGen.scala 343:52]
  wire [31:0] ShiftReg_io_in_bits; // @[WellnessGen.scala 343:52]
  wire  ShiftReg_io_out_valid; // @[WellnessGen.scala 343:52]
  wire [31:0] ShiftReg_io_out_bits; // @[WellnessGen.scala 343:52]
  wire  ShiftReg_1_clock; // @[WellnessGen.scala 343:52]
  wire  ShiftReg_1_reset; // @[WellnessGen.scala 343:52]
  wire  ShiftReg_1_io_in_valid; // @[WellnessGen.scala 343:52]
  wire [31:0] ShiftReg_1_io_in_bits; // @[WellnessGen.scala 343:52]
  wire  ShiftReg_1_io_out_valid; // @[WellnessGen.scala 343:52]
  wire [31:0] ShiftReg_1_io_out_bits; // @[WellnessGen.scala 343:52]
  wire  pcaNorm_clock; // @[WellnessGen.scala 656:23]
  wire  pcaNorm_io_in_valid; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_in_bits_0; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_in_bits_1; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_in_bits_2; // @[WellnessGen.scala 656:23]
  wire  pcaNorm_io_out_valid; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_out_bits_0; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_out_bits_1; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_out_bits_2; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_PCANormalizationData_0_0; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_PCANormalizationData_0_1; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_PCANormalizationData_1_0; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_PCANormalizationData_1_1; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_PCANormalizationData_2_0; // @[WellnessGen.scala 656:23]
  wire [31:0] pcaNorm_io_PCANormalizationData_2_1; // @[WellnessGen.scala 656:23]
  wire  pca_clock; // @[WellnessGen.scala 664:19]
  wire  pca_io_in_valid; // @[WellnessGen.scala 664:19]
  wire [31:0] pca_io_in_bits_0; // @[WellnessGen.scala 664:19]
  wire [31:0] pca_io_in_bits_1; // @[WellnessGen.scala 664:19]
  wire [31:0] pca_io_in_bits_2; // @[WellnessGen.scala 664:19]
  wire  pca_io_out_valid; // @[WellnessGen.scala 664:19]
  wire [31:0] pca_io_out_bits_0; // @[WellnessGen.scala 664:19]
  wire [31:0] pca_io_out_bits_1; // @[WellnessGen.scala 664:19]
  wire [31:0] pca_io_PCAVector_0_0; // @[WellnessGen.scala 664:19]
  wire [31:0] pca_io_PCAVector_0_1; // @[WellnessGen.scala 664:19]
  wire [31:0] pca_io_PCAVector_0_2; // @[WellnessGen.scala 664:19]
  wire [31:0] pca_io_PCAVector_1_0; // @[WellnessGen.scala 664:19]
  wire [31:0] pca_io_PCAVector_1_1; // @[WellnessGen.scala 664:19]
  wire [31:0] pca_io_PCAVector_1_2; // @[WellnessGen.scala 664:19]
  wire  logistic_clock; // @[WellnessGen.scala 671:24]
  wire  logistic_io_in_valid; // @[WellnessGen.scala 671:24]
  wire [31:0] logistic_io_in_bits_0; // @[WellnessGen.scala 671:24]
  wire [31:0] logistic_io_in_bits_1; // @[WellnessGen.scala 671:24]
  wire  logistic_io_out_valid; // @[WellnessGen.scala 671:24]
  wire  logistic_io_out_bits; // @[WellnessGen.scala 671:24]
  wire [31:0] logistic_io_weights_0; // @[WellnessGen.scala 671:24]
  wire [31:0] logistic_io_weights_1; // @[WellnessGen.scala 671:24]
  wire [31:0] logistic_io_intercept; // @[WellnessGen.scala 671:24]
  wire [31:0] logistic_io_rawVotes; // @[WellnessGen.scala 671:24]
  wire [31:0] _T_1; // @[WellnessGen.scala 297:80]
  wire [31:0] _T_2; // @[WellnessGen.scala 297:80]
  wire [31:0] _T_4; // @[WellnessGen.scala 297:120]
  wire [31:0] _T_5; // @[WellnessGen.scala 297:120]
  wire [31:0] _T_10; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_13; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_16; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_19; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_22; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_25; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_28; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_31; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_34; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_37; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_40; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_43; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_46; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_49; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_52; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_55; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_58; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_61; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_64; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_67; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_70; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_73; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_76; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_79; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_82; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_85; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_88; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_91; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_94; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_97; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_100; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_103; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_106; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_109; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_112; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_115; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_118; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_121; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_124; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_127; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_130; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_133; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_136; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_139; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_142; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_145; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_148; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_151; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_154; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_157; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_160; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_163; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_166; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_169; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_172; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_175; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_178; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_181; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_184; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_187; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_190; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_193; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_196; // @[WellnessGen.scala 522:148]
  wire [31:0] _T_199; // @[WellnessGen.scala 522:148]
  wire  pcaInValVec_2; // @[WellnessGen.scala 358:25 WellnessGen.scala 646:30]
  wire  pcaInValVec_1; // @[WellnessGen.scala 358:25 WellnessGen.scala 643:30]
  wire [1:0] _T_201; // @[WellnessGen.scala 658:44]
  wire  pcaInValVec_0; // @[WellnessGen.scala 358:25 WellnessGen.scala 643:30]
  wire [2:0] _T_202; // @[WellnessGen.scala 658:44]
  wire [2:0] _T_203; // @[WellnessGen.scala 658:51]
  ConstantCoefficientFIRFilter ConstantCoefficientFIRFilter ( // @[WellnessGen.scala 331:48]
    .clock(ConstantCoefficientFIRFilter_clock),
    .reset(ConstantCoefficientFIRFilter_reset),
    .io_in_valid(ConstantCoefficientFIRFilter_io_in_valid),
    .io_in_bits(ConstantCoefficientFIRFilter_io_in_bits),
    .io_out_valid(ConstantCoefficientFIRFilter_io_out_valid),
    .io_out_bits(ConstantCoefficientFIRFilter_io_out_bits)
  );
  FFTBuffer FFTBuffer ( // @[WellnessGen.scala 335:54]
    .clock(FFTBuffer_clock),
    .reset(FFTBuffer_reset),
    .io_in_valid(FFTBuffer_io_in_valid),
    .io_in_bits(FFTBuffer_io_in_bits),
    .io_out_valid(FFTBuffer_io_out_valid),
    .io_out_bits_0(FFTBuffer_io_out_bits_0),
    .io_out_bits_1(FFTBuffer_io_out_bits_1),
    .io_out_bits_2(FFTBuffer_io_out_bits_2),
    .io_out_bits_3(FFTBuffer_io_out_bits_3),
    .io_out_bits_4(FFTBuffer_io_out_bits_4),
    .io_out_bits_5(FFTBuffer_io_out_bits_5),
    .io_out_bits_6(FFTBuffer_io_out_bits_6),
    .io_out_bits_7(FFTBuffer_io_out_bits_7),
    .io_out_bits_8(FFTBuffer_io_out_bits_8),
    .io_out_bits_9(FFTBuffer_io_out_bits_9),
    .io_out_bits_10(FFTBuffer_io_out_bits_10),
    .io_out_bits_11(FFTBuffer_io_out_bits_11),
    .io_out_bits_12(FFTBuffer_io_out_bits_12),
    .io_out_bits_13(FFTBuffer_io_out_bits_13),
    .io_out_bits_14(FFTBuffer_io_out_bits_14),
    .io_out_bits_15(FFTBuffer_io_out_bits_15),
    .io_out_bits_16(FFTBuffer_io_out_bits_16),
    .io_out_bits_17(FFTBuffer_io_out_bits_17),
    .io_out_bits_18(FFTBuffer_io_out_bits_18),
    .io_out_bits_19(FFTBuffer_io_out_bits_19),
    .io_out_bits_20(FFTBuffer_io_out_bits_20),
    .io_out_bits_21(FFTBuffer_io_out_bits_21),
    .io_out_bits_22(FFTBuffer_io_out_bits_22),
    .io_out_bits_23(FFTBuffer_io_out_bits_23),
    .io_out_bits_24(FFTBuffer_io_out_bits_24),
    .io_out_bits_25(FFTBuffer_io_out_bits_25),
    .io_out_bits_26(FFTBuffer_io_out_bits_26),
    .io_out_bits_27(FFTBuffer_io_out_bits_27),
    .io_out_bits_28(FFTBuffer_io_out_bits_28),
    .io_out_bits_29(FFTBuffer_io_out_bits_29),
    .io_out_bits_30(FFTBuffer_io_out_bits_30),
    .io_out_bits_31(FFTBuffer_io_out_bits_31)
  );
  FFT FFT ( // @[WellnessGen.scala 337:48]
    .clock(FFT_clock),
    .io_in_valid(FFT_io_in_valid),
    .io_in_bits_0_real(FFT_io_in_bits_0_real),
    .io_in_bits_1_real(FFT_io_in_bits_1_real),
    .io_in_bits_2_real(FFT_io_in_bits_2_real),
    .io_in_bits_3_real(FFT_io_in_bits_3_real),
    .io_in_bits_4_real(FFT_io_in_bits_4_real),
    .io_in_bits_5_real(FFT_io_in_bits_5_real),
    .io_in_bits_6_real(FFT_io_in_bits_6_real),
    .io_in_bits_7_real(FFT_io_in_bits_7_real),
    .io_in_bits_8_real(FFT_io_in_bits_8_real),
    .io_in_bits_9_real(FFT_io_in_bits_9_real),
    .io_in_bits_10_real(FFT_io_in_bits_10_real),
    .io_in_bits_11_real(FFT_io_in_bits_11_real),
    .io_in_bits_12_real(FFT_io_in_bits_12_real),
    .io_in_bits_13_real(FFT_io_in_bits_13_real),
    .io_in_bits_14_real(FFT_io_in_bits_14_real),
    .io_in_bits_15_real(FFT_io_in_bits_15_real),
    .io_in_bits_16_real(FFT_io_in_bits_16_real),
    .io_in_bits_17_real(FFT_io_in_bits_17_real),
    .io_in_bits_18_real(FFT_io_in_bits_18_real),
    .io_in_bits_19_real(FFT_io_in_bits_19_real),
    .io_in_bits_20_real(FFT_io_in_bits_20_real),
    .io_in_bits_21_real(FFT_io_in_bits_21_real),
    .io_in_bits_22_real(FFT_io_in_bits_22_real),
    .io_in_bits_23_real(FFT_io_in_bits_23_real),
    .io_in_bits_24_real(FFT_io_in_bits_24_real),
    .io_in_bits_25_real(FFT_io_in_bits_25_real),
    .io_in_bits_26_real(FFT_io_in_bits_26_real),
    .io_in_bits_27_real(FFT_io_in_bits_27_real),
    .io_in_bits_28_real(FFT_io_in_bits_28_real),
    .io_in_bits_29_real(FFT_io_in_bits_29_real),
    .io_in_bits_30_real(FFT_io_in_bits_30_real),
    .io_in_bits_31_real(FFT_io_in_bits_31_real),
    .io_out_valid(FFT_io_out_valid),
    .io_out_bits_4_real(FFT_io_out_bits_4_real),
    .io_out_bits_4_imag(FFT_io_out_bits_4_imag),
    .io_out_bits_5_real(FFT_io_out_bits_5_real),
    .io_out_bits_5_imag(FFT_io_out_bits_5_imag),
    .io_out_bits_6_real(FFT_io_out_bits_6_real),
    .io_out_bits_6_imag(FFT_io_out_bits_6_imag),
    .io_out_bits_7_real(FFT_io_out_bits_7_real),
    .io_out_bits_7_imag(FFT_io_out_bits_7_imag),
    .io_out_bits_8_real(FFT_io_out_bits_8_real),
    .io_out_bits_8_imag(FFT_io_out_bits_8_imag),
    .io_out_bits_9_real(FFT_io_out_bits_9_real),
    .io_out_bits_9_imag(FFT_io_out_bits_9_imag),
    .io_out_bits_10_real(FFT_io_out_bits_10_real),
    .io_out_bits_10_imag(FFT_io_out_bits_10_imag),
    .io_out_bits_11_real(FFT_io_out_bits_11_real),
    .io_out_bits_11_imag(FFT_io_out_bits_11_imag),
    .io_out_bits_12_real(FFT_io_out_bits_12_real),
    .io_out_bits_12_imag(FFT_io_out_bits_12_imag),
    .io_out_bits_13_real(FFT_io_out_bits_13_real),
    .io_out_bits_13_imag(FFT_io_out_bits_13_imag),
    .io_out_bits_14_real(FFT_io_out_bits_14_real),
    .io_out_bits_14_imag(FFT_io_out_bits_14_imag),
    .io_out_bits_15_real(FFT_io_out_bits_15_real),
    .io_out_bits_15_imag(FFT_io_out_bits_15_imag)
  );
  Bandpower Bandpower ( // @[WellnessGen.scala 341:54]
    .clock(Bandpower_clock),
    .io_in_valid(Bandpower_io_in_valid),
    .io_in_bits_4_real(Bandpower_io_in_bits_4_real),
    .io_in_bits_4_imag(Bandpower_io_in_bits_4_imag),
    .io_in_bits_5_real(Bandpower_io_in_bits_5_real),
    .io_in_bits_5_imag(Bandpower_io_in_bits_5_imag),
    .io_in_bits_6_real(Bandpower_io_in_bits_6_real),
    .io_in_bits_6_imag(Bandpower_io_in_bits_6_imag),
    .io_in_bits_7_real(Bandpower_io_in_bits_7_real),
    .io_in_bits_7_imag(Bandpower_io_in_bits_7_imag),
    .io_out_valid(Bandpower_io_out_valid),
    .io_out_bits(Bandpower_io_out_bits)
  );
  ConstantCoefficientFIRFilter ConstantCoefficientFIRFilter_1 ( // @[WellnessGen.scala 331:48]
    .clock(ConstantCoefficientFIRFilter_1_clock),
    .reset(ConstantCoefficientFIRFilter_1_reset),
    .io_in_valid(ConstantCoefficientFIRFilter_1_io_in_valid),
    .io_in_bits(ConstantCoefficientFIRFilter_1_io_in_bits),
    .io_out_valid(ConstantCoefficientFIRFilter_1_io_out_valid),
    .io_out_bits(ConstantCoefficientFIRFilter_1_io_out_bits)
  );
  FFTBuffer FFTBuffer_1 ( // @[WellnessGen.scala 335:54]
    .clock(FFTBuffer_1_clock),
    .reset(FFTBuffer_1_reset),
    .io_in_valid(FFTBuffer_1_io_in_valid),
    .io_in_bits(FFTBuffer_1_io_in_bits),
    .io_out_valid(FFTBuffer_1_io_out_valid),
    .io_out_bits_0(FFTBuffer_1_io_out_bits_0),
    .io_out_bits_1(FFTBuffer_1_io_out_bits_1),
    .io_out_bits_2(FFTBuffer_1_io_out_bits_2),
    .io_out_bits_3(FFTBuffer_1_io_out_bits_3),
    .io_out_bits_4(FFTBuffer_1_io_out_bits_4),
    .io_out_bits_5(FFTBuffer_1_io_out_bits_5),
    .io_out_bits_6(FFTBuffer_1_io_out_bits_6),
    .io_out_bits_7(FFTBuffer_1_io_out_bits_7),
    .io_out_bits_8(FFTBuffer_1_io_out_bits_8),
    .io_out_bits_9(FFTBuffer_1_io_out_bits_9),
    .io_out_bits_10(FFTBuffer_1_io_out_bits_10),
    .io_out_bits_11(FFTBuffer_1_io_out_bits_11),
    .io_out_bits_12(FFTBuffer_1_io_out_bits_12),
    .io_out_bits_13(FFTBuffer_1_io_out_bits_13),
    .io_out_bits_14(FFTBuffer_1_io_out_bits_14),
    .io_out_bits_15(FFTBuffer_1_io_out_bits_15),
    .io_out_bits_16(FFTBuffer_1_io_out_bits_16),
    .io_out_bits_17(FFTBuffer_1_io_out_bits_17),
    .io_out_bits_18(FFTBuffer_1_io_out_bits_18),
    .io_out_bits_19(FFTBuffer_1_io_out_bits_19),
    .io_out_bits_20(FFTBuffer_1_io_out_bits_20),
    .io_out_bits_21(FFTBuffer_1_io_out_bits_21),
    .io_out_bits_22(FFTBuffer_1_io_out_bits_22),
    .io_out_bits_23(FFTBuffer_1_io_out_bits_23),
    .io_out_bits_24(FFTBuffer_1_io_out_bits_24),
    .io_out_bits_25(FFTBuffer_1_io_out_bits_25),
    .io_out_bits_26(FFTBuffer_1_io_out_bits_26),
    .io_out_bits_27(FFTBuffer_1_io_out_bits_27),
    .io_out_bits_28(FFTBuffer_1_io_out_bits_28),
    .io_out_bits_29(FFTBuffer_1_io_out_bits_29),
    .io_out_bits_30(FFTBuffer_1_io_out_bits_30),
    .io_out_bits_31(FFTBuffer_1_io_out_bits_31)
  );
  FFT FFT_1 ( // @[WellnessGen.scala 337:48]
    .clock(FFT_1_clock),
    .io_in_valid(FFT_1_io_in_valid),
    .io_in_bits_0_real(FFT_1_io_in_bits_0_real),
    .io_in_bits_1_real(FFT_1_io_in_bits_1_real),
    .io_in_bits_2_real(FFT_1_io_in_bits_2_real),
    .io_in_bits_3_real(FFT_1_io_in_bits_3_real),
    .io_in_bits_4_real(FFT_1_io_in_bits_4_real),
    .io_in_bits_5_real(FFT_1_io_in_bits_5_real),
    .io_in_bits_6_real(FFT_1_io_in_bits_6_real),
    .io_in_bits_7_real(FFT_1_io_in_bits_7_real),
    .io_in_bits_8_real(FFT_1_io_in_bits_8_real),
    .io_in_bits_9_real(FFT_1_io_in_bits_9_real),
    .io_in_bits_10_real(FFT_1_io_in_bits_10_real),
    .io_in_bits_11_real(FFT_1_io_in_bits_11_real),
    .io_in_bits_12_real(FFT_1_io_in_bits_12_real),
    .io_in_bits_13_real(FFT_1_io_in_bits_13_real),
    .io_in_bits_14_real(FFT_1_io_in_bits_14_real),
    .io_in_bits_15_real(FFT_1_io_in_bits_15_real),
    .io_in_bits_16_real(FFT_1_io_in_bits_16_real),
    .io_in_bits_17_real(FFT_1_io_in_bits_17_real),
    .io_in_bits_18_real(FFT_1_io_in_bits_18_real),
    .io_in_bits_19_real(FFT_1_io_in_bits_19_real),
    .io_in_bits_20_real(FFT_1_io_in_bits_20_real),
    .io_in_bits_21_real(FFT_1_io_in_bits_21_real),
    .io_in_bits_22_real(FFT_1_io_in_bits_22_real),
    .io_in_bits_23_real(FFT_1_io_in_bits_23_real),
    .io_in_bits_24_real(FFT_1_io_in_bits_24_real),
    .io_in_bits_25_real(FFT_1_io_in_bits_25_real),
    .io_in_bits_26_real(FFT_1_io_in_bits_26_real),
    .io_in_bits_27_real(FFT_1_io_in_bits_27_real),
    .io_in_bits_28_real(FFT_1_io_in_bits_28_real),
    .io_in_bits_29_real(FFT_1_io_in_bits_29_real),
    .io_in_bits_30_real(FFT_1_io_in_bits_30_real),
    .io_in_bits_31_real(FFT_1_io_in_bits_31_real),
    .io_out_valid(FFT_1_io_out_valid),
    .io_out_bits_4_real(FFT_1_io_out_bits_4_real),
    .io_out_bits_4_imag(FFT_1_io_out_bits_4_imag),
    .io_out_bits_5_real(FFT_1_io_out_bits_5_real),
    .io_out_bits_5_imag(FFT_1_io_out_bits_5_imag),
    .io_out_bits_6_real(FFT_1_io_out_bits_6_real),
    .io_out_bits_6_imag(FFT_1_io_out_bits_6_imag),
    .io_out_bits_7_real(FFT_1_io_out_bits_7_real),
    .io_out_bits_7_imag(FFT_1_io_out_bits_7_imag),
    .io_out_bits_8_real(FFT_1_io_out_bits_8_real),
    .io_out_bits_8_imag(FFT_1_io_out_bits_8_imag),
    .io_out_bits_9_real(FFT_1_io_out_bits_9_real),
    .io_out_bits_9_imag(FFT_1_io_out_bits_9_imag),
    .io_out_bits_10_real(FFT_1_io_out_bits_10_real),
    .io_out_bits_10_imag(FFT_1_io_out_bits_10_imag),
    .io_out_bits_11_real(FFT_1_io_out_bits_11_real),
    .io_out_bits_11_imag(FFT_1_io_out_bits_11_imag),
    .io_out_bits_12_real(FFT_1_io_out_bits_12_real),
    .io_out_bits_12_imag(FFT_1_io_out_bits_12_imag),
    .io_out_bits_13_real(FFT_1_io_out_bits_13_real),
    .io_out_bits_13_imag(FFT_1_io_out_bits_13_imag),
    .io_out_bits_14_real(FFT_1_io_out_bits_14_real),
    .io_out_bits_14_imag(FFT_1_io_out_bits_14_imag),
    .io_out_bits_15_real(FFT_1_io_out_bits_15_real),
    .io_out_bits_15_imag(FFT_1_io_out_bits_15_imag)
  );
  Bandpower_1 Bandpower_1 ( // @[WellnessGen.scala 341:54]
    .clock(Bandpower_1_clock),
    .io_in_valid(Bandpower_1_io_in_valid),
    .io_in_bits_8_real(Bandpower_1_io_in_bits_8_real),
    .io_in_bits_8_imag(Bandpower_1_io_in_bits_8_imag),
    .io_in_bits_9_real(Bandpower_1_io_in_bits_9_real),
    .io_in_bits_9_imag(Bandpower_1_io_in_bits_9_imag),
    .io_in_bits_10_real(Bandpower_1_io_in_bits_10_real),
    .io_in_bits_10_imag(Bandpower_1_io_in_bits_10_imag),
    .io_in_bits_11_real(Bandpower_1_io_in_bits_11_real),
    .io_in_bits_11_imag(Bandpower_1_io_in_bits_11_imag),
    .io_in_bits_12_real(Bandpower_1_io_in_bits_12_real),
    .io_in_bits_12_imag(Bandpower_1_io_in_bits_12_imag),
    .io_in_bits_13_real(Bandpower_1_io_in_bits_13_real),
    .io_in_bits_13_imag(Bandpower_1_io_in_bits_13_imag),
    .io_in_bits_14_real(Bandpower_1_io_in_bits_14_real),
    .io_in_bits_14_imag(Bandpower_1_io_in_bits_14_imag),
    .io_in_bits_15_real(Bandpower_1_io_in_bits_15_real),
    .io_in_bits_15_imag(Bandpower_1_io_in_bits_15_imag),
    .io_out_valid(Bandpower_1_io_out_valid),
    .io_out_bits(Bandpower_1_io_out_bits)
  );
  ConstantCoefficientFIRFilter ConstantCoefficientFIRFilter_2 ( // @[WellnessGen.scala 331:48]
    .clock(ConstantCoefficientFIRFilter_2_clock),
    .reset(ConstantCoefficientFIRFilter_2_reset),
    .io_in_valid(ConstantCoefficientFIRFilter_2_io_in_valid),
    .io_in_bits(ConstantCoefficientFIRFilter_2_io_in_bits),
    .io_out_valid(ConstantCoefficientFIRFilter_2_io_out_valid),
    .io_out_bits(ConstantCoefficientFIRFilter_2_io_out_bits)
  );
  lineLength lineLength ( // @[WellnessGen.scala 339:55]
    .clock(lineLength_clock),
    .reset(lineLength_reset),
    .io_in_valid(lineLength_io_in_valid),
    .io_in_bits(lineLength_io_in_bits),
    .io_out_valid(lineLength_io_out_valid),
    .io_out_bits(lineLength_io_out_bits)
  );
  ShiftReg ShiftReg ( // @[WellnessGen.scala 343:52]
    .clock(ShiftReg_clock),
    .reset(ShiftReg_reset),
    .io_in_valid(ShiftReg_io_in_valid),
    .io_in_bits(ShiftReg_io_in_bits),
    .io_out_valid(ShiftReg_io_out_valid),
    .io_out_bits(ShiftReg_io_out_bits)
  );
  ShiftReg ShiftReg_1 ( // @[WellnessGen.scala 343:52]
    .clock(ShiftReg_1_clock),
    .reset(ShiftReg_1_reset),
    .io_in_valid(ShiftReg_1_io_in_valid),
    .io_in_bits(ShiftReg_1_io_in_bits),
    .io_out_valid(ShiftReg_1_io_out_valid),
    .io_out_bits(ShiftReg_1_io_out_bits)
  );
  PCANormalizer pcaNorm ( // @[WellnessGen.scala 656:23]
    .clock(pcaNorm_clock),
    .io_in_valid(pcaNorm_io_in_valid),
    .io_in_bits_0(pcaNorm_io_in_bits_0),
    .io_in_bits_1(pcaNorm_io_in_bits_1),
    .io_in_bits_2(pcaNorm_io_in_bits_2),
    .io_out_valid(pcaNorm_io_out_valid),
    .io_out_bits_0(pcaNorm_io_out_bits_0),
    .io_out_bits_1(pcaNorm_io_out_bits_1),
    .io_out_bits_2(pcaNorm_io_out_bits_2),
    .io_PCANormalizationData_0_0(pcaNorm_io_PCANormalizationData_0_0),
    .io_PCANormalizationData_0_1(pcaNorm_io_PCANormalizationData_0_1),
    .io_PCANormalizationData_1_0(pcaNorm_io_PCANormalizationData_1_0),
    .io_PCANormalizationData_1_1(pcaNorm_io_PCANormalizationData_1_1),
    .io_PCANormalizationData_2_0(pcaNorm_io_PCANormalizationData_2_0),
    .io_PCANormalizationData_2_1(pcaNorm_io_PCANormalizationData_2_1)
  );
  PCA pca ( // @[WellnessGen.scala 664:19]
    .clock(pca_clock),
    .io_in_valid(pca_io_in_valid),
    .io_in_bits_0(pca_io_in_bits_0),
    .io_in_bits_1(pca_io_in_bits_1),
    .io_in_bits_2(pca_io_in_bits_2),
    .io_out_valid(pca_io_out_valid),
    .io_out_bits_0(pca_io_out_bits_0),
    .io_out_bits_1(pca_io_out_bits_1),
    .io_PCAVector_0_0(pca_io_PCAVector_0_0),
    .io_PCAVector_0_1(pca_io_PCAVector_0_1),
    .io_PCAVector_0_2(pca_io_PCAVector_0_2),
    .io_PCAVector_1_0(pca_io_PCAVector_1_0),
    .io_PCAVector_1_1(pca_io_PCAVector_1_1),
    .io_PCAVector_1_2(pca_io_PCAVector_1_2)
  );
  Logistic logistic ( // @[WellnessGen.scala 671:24]
    .clock(logistic_clock),
    .io_in_valid(logistic_io_in_valid),
    .io_in_bits_0(logistic_io_in_bits_0),
    .io_in_bits_1(logistic_io_in_bits_1),
    .io_out_valid(logistic_io_out_valid),
    .io_out_bits(logistic_io_out_bits),
    .io_weights_0(logistic_io_weights_0),
    .io_weights_1(logistic_io_weights_1),
    .io_intercept(logistic_io_intercept),
    .io_rawVotes(logistic_io_rawVotes)
  );
  assign _T_1 = $unsigned(io_streamIn_bits); // @[WellnessGen.scala 297:80]
  assign _T_2 = $signed(_T_1); // @[WellnessGen.scala 297:80]
  assign _T_4 = $unsigned(io_in_bits); // @[WellnessGen.scala 297:120]
  assign _T_5 = $signed(_T_4); // @[WellnessGen.scala 297:120]
  assign _T_10 = $unsigned(FFTBuffer_io_out_bits_0); // @[WellnessGen.scala 522:148]
  assign _T_13 = $unsigned(FFTBuffer_io_out_bits_1); // @[WellnessGen.scala 522:148]
  assign _T_16 = $unsigned(FFTBuffer_io_out_bits_2); // @[WellnessGen.scala 522:148]
  assign _T_19 = $unsigned(FFTBuffer_io_out_bits_3); // @[WellnessGen.scala 522:148]
  assign _T_22 = $unsigned(FFTBuffer_io_out_bits_4); // @[WellnessGen.scala 522:148]
  assign _T_25 = $unsigned(FFTBuffer_io_out_bits_5); // @[WellnessGen.scala 522:148]
  assign _T_28 = $unsigned(FFTBuffer_io_out_bits_6); // @[WellnessGen.scala 522:148]
  assign _T_31 = $unsigned(FFTBuffer_io_out_bits_7); // @[WellnessGen.scala 522:148]
  assign _T_34 = $unsigned(FFTBuffer_io_out_bits_8); // @[WellnessGen.scala 522:148]
  assign _T_37 = $unsigned(FFTBuffer_io_out_bits_9); // @[WellnessGen.scala 522:148]
  assign _T_40 = $unsigned(FFTBuffer_io_out_bits_10); // @[WellnessGen.scala 522:148]
  assign _T_43 = $unsigned(FFTBuffer_io_out_bits_11); // @[WellnessGen.scala 522:148]
  assign _T_46 = $unsigned(FFTBuffer_io_out_bits_12); // @[WellnessGen.scala 522:148]
  assign _T_49 = $unsigned(FFTBuffer_io_out_bits_13); // @[WellnessGen.scala 522:148]
  assign _T_52 = $unsigned(FFTBuffer_io_out_bits_14); // @[WellnessGen.scala 522:148]
  assign _T_55 = $unsigned(FFTBuffer_io_out_bits_15); // @[WellnessGen.scala 522:148]
  assign _T_58 = $unsigned(FFTBuffer_io_out_bits_16); // @[WellnessGen.scala 522:148]
  assign _T_61 = $unsigned(FFTBuffer_io_out_bits_17); // @[WellnessGen.scala 522:148]
  assign _T_64 = $unsigned(FFTBuffer_io_out_bits_18); // @[WellnessGen.scala 522:148]
  assign _T_67 = $unsigned(FFTBuffer_io_out_bits_19); // @[WellnessGen.scala 522:148]
  assign _T_70 = $unsigned(FFTBuffer_io_out_bits_20); // @[WellnessGen.scala 522:148]
  assign _T_73 = $unsigned(FFTBuffer_io_out_bits_21); // @[WellnessGen.scala 522:148]
  assign _T_76 = $unsigned(FFTBuffer_io_out_bits_22); // @[WellnessGen.scala 522:148]
  assign _T_79 = $unsigned(FFTBuffer_io_out_bits_23); // @[WellnessGen.scala 522:148]
  assign _T_82 = $unsigned(FFTBuffer_io_out_bits_24); // @[WellnessGen.scala 522:148]
  assign _T_85 = $unsigned(FFTBuffer_io_out_bits_25); // @[WellnessGen.scala 522:148]
  assign _T_88 = $unsigned(FFTBuffer_io_out_bits_26); // @[WellnessGen.scala 522:148]
  assign _T_91 = $unsigned(FFTBuffer_io_out_bits_27); // @[WellnessGen.scala 522:148]
  assign _T_94 = $unsigned(FFTBuffer_io_out_bits_28); // @[WellnessGen.scala 522:148]
  assign _T_97 = $unsigned(FFTBuffer_io_out_bits_29); // @[WellnessGen.scala 522:148]
  assign _T_100 = $unsigned(FFTBuffer_io_out_bits_30); // @[WellnessGen.scala 522:148]
  assign _T_103 = $unsigned(FFTBuffer_io_out_bits_31); // @[WellnessGen.scala 522:148]
  assign _T_106 = $unsigned(FFTBuffer_1_io_out_bits_0); // @[WellnessGen.scala 522:148]
  assign _T_109 = $unsigned(FFTBuffer_1_io_out_bits_1); // @[WellnessGen.scala 522:148]
  assign _T_112 = $unsigned(FFTBuffer_1_io_out_bits_2); // @[WellnessGen.scala 522:148]
  assign _T_115 = $unsigned(FFTBuffer_1_io_out_bits_3); // @[WellnessGen.scala 522:148]
  assign _T_118 = $unsigned(FFTBuffer_1_io_out_bits_4); // @[WellnessGen.scala 522:148]
  assign _T_121 = $unsigned(FFTBuffer_1_io_out_bits_5); // @[WellnessGen.scala 522:148]
  assign _T_124 = $unsigned(FFTBuffer_1_io_out_bits_6); // @[WellnessGen.scala 522:148]
  assign _T_127 = $unsigned(FFTBuffer_1_io_out_bits_7); // @[WellnessGen.scala 522:148]
  assign _T_130 = $unsigned(FFTBuffer_1_io_out_bits_8); // @[WellnessGen.scala 522:148]
  assign _T_133 = $unsigned(FFTBuffer_1_io_out_bits_9); // @[WellnessGen.scala 522:148]
  assign _T_136 = $unsigned(FFTBuffer_1_io_out_bits_10); // @[WellnessGen.scala 522:148]
  assign _T_139 = $unsigned(FFTBuffer_1_io_out_bits_11); // @[WellnessGen.scala 522:148]
  assign _T_142 = $unsigned(FFTBuffer_1_io_out_bits_12); // @[WellnessGen.scala 522:148]
  assign _T_145 = $unsigned(FFTBuffer_1_io_out_bits_13); // @[WellnessGen.scala 522:148]
  assign _T_148 = $unsigned(FFTBuffer_1_io_out_bits_14); // @[WellnessGen.scala 522:148]
  assign _T_151 = $unsigned(FFTBuffer_1_io_out_bits_15); // @[WellnessGen.scala 522:148]
  assign _T_154 = $unsigned(FFTBuffer_1_io_out_bits_16); // @[WellnessGen.scala 522:148]
  assign _T_157 = $unsigned(FFTBuffer_1_io_out_bits_17); // @[WellnessGen.scala 522:148]
  assign _T_160 = $unsigned(FFTBuffer_1_io_out_bits_18); // @[WellnessGen.scala 522:148]
  assign _T_163 = $unsigned(FFTBuffer_1_io_out_bits_19); // @[WellnessGen.scala 522:148]
  assign _T_166 = $unsigned(FFTBuffer_1_io_out_bits_20); // @[WellnessGen.scala 522:148]
  assign _T_169 = $unsigned(FFTBuffer_1_io_out_bits_21); // @[WellnessGen.scala 522:148]
  assign _T_172 = $unsigned(FFTBuffer_1_io_out_bits_22); // @[WellnessGen.scala 522:148]
  assign _T_175 = $unsigned(FFTBuffer_1_io_out_bits_23); // @[WellnessGen.scala 522:148]
  assign _T_178 = $unsigned(FFTBuffer_1_io_out_bits_24); // @[WellnessGen.scala 522:148]
  assign _T_181 = $unsigned(FFTBuffer_1_io_out_bits_25); // @[WellnessGen.scala 522:148]
  assign _T_184 = $unsigned(FFTBuffer_1_io_out_bits_26); // @[WellnessGen.scala 522:148]
  assign _T_187 = $unsigned(FFTBuffer_1_io_out_bits_27); // @[WellnessGen.scala 522:148]
  assign _T_190 = $unsigned(FFTBuffer_1_io_out_bits_28); // @[WellnessGen.scala 522:148]
  assign _T_193 = $unsigned(FFTBuffer_1_io_out_bits_29); // @[WellnessGen.scala 522:148]
  assign _T_196 = $unsigned(FFTBuffer_1_io_out_bits_30); // @[WellnessGen.scala 522:148]
  assign _T_199 = $unsigned(FFTBuffer_1_io_out_bits_31); // @[WellnessGen.scala 522:148]
  assign pcaInValVec_2 = ShiftReg_1_io_out_valid; // @[WellnessGen.scala 358:25 WellnessGen.scala 646:30]
  assign pcaInValVec_1 = Bandpower_1_io_out_valid; // @[WellnessGen.scala 358:25 WellnessGen.scala 643:30]
  assign _T_201 = {pcaInValVec_2,pcaInValVec_1}; // @[WellnessGen.scala 658:44]
  assign pcaInValVec_0 = Bandpower_io_out_valid; // @[WellnessGen.scala 358:25 WellnessGen.scala 643:30]
  assign _T_202 = {_T_201,pcaInValVec_0}; // @[WellnessGen.scala 658:44]
  assign _T_203 = ~ _T_202; // @[WellnessGen.scala 658:51]
  assign io_out_valid = logistic_io_out_valid; // @[WellnessGen.scala 680:16]
  assign io_out_bits = logistic_io_out_bits; // @[WellnessGen.scala 682:15]
  assign io_rawVotes = logistic_io_rawVotes; // @[WellnessGen.scala 683:15]
  assign ConstantCoefficientFIRFilter_clock = clock;
  assign ConstantCoefficientFIRFilter_reset = reset;
  assign ConstantCoefficientFIRFilter_io_in_valid = io_inConf_bits_confInputMuxSel ? io_streamIn_valid : io_in_valid; // @[WellnessGen.scala 380:91]
  assign ConstantCoefficientFIRFilter_io_in_bits = io_inConf_bits_confInputMuxSel ? $signed(_T_2) : $signed(_T_5); // @[WellnessGen.scala 381:91]
  assign FFTBuffer_clock = clock;
  assign FFTBuffer_reset = reset;
  assign FFTBuffer_io_in_valid = ConstantCoefficientFIRFilter_io_out_valid; // @[WellnessGen.scala 508:76]
  assign FFTBuffer_io_in_bits = ConstantCoefficientFIRFilter_io_out_bits; // @[WellnessGen.scala 509:76]
  assign FFT_clock = clock;
  assign FFT_io_in_valid = FFTBuffer_io_out_valid; // @[WellnessGen.scala 519:66]
  assign FFT_io_in_bits_0_real = $signed(_T_10); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_1_real = $signed(_T_13); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_2_real = $signed(_T_16); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_3_real = $signed(_T_19); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_4_real = $signed(_T_22); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_5_real = $signed(_T_25); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_6_real = $signed(_T_28); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_7_real = $signed(_T_31); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_8_real = $signed(_T_34); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_9_real = $signed(_T_37); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_10_real = $signed(_T_40); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_11_real = $signed(_T_43); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_12_real = $signed(_T_46); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_13_real = $signed(_T_49); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_14_real = $signed(_T_52); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_15_real = $signed(_T_55); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_16_real = $signed(_T_58); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_17_real = $signed(_T_61); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_18_real = $signed(_T_64); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_19_real = $signed(_T_67); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_20_real = $signed(_T_70); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_21_real = $signed(_T_73); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_22_real = $signed(_T_76); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_23_real = $signed(_T_79); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_24_real = $signed(_T_82); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_25_real = $signed(_T_85); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_26_real = $signed(_T_88); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_27_real = $signed(_T_91); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_28_real = $signed(_T_94); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_29_real = $signed(_T_97); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_30_real = $signed(_T_100); // @[WellnessGen.scala 522:75]
  assign FFT_io_in_bits_31_real = $signed(_T_103); // @[WellnessGen.scala 522:75]
  assign Bandpower_clock = clock;
  assign Bandpower_io_in_valid = FFT_io_out_valid; // @[WellnessGen.scala 587:78]
  assign Bandpower_io_in_bits_4_real = FFT_io_out_bits_4_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_io_in_bits_4_imag = FFT_io_out_bits_4_imag; // @[WellnessGen.scala 588:78]
  assign Bandpower_io_in_bits_5_real = FFT_io_out_bits_5_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_io_in_bits_5_imag = FFT_io_out_bits_5_imag; // @[WellnessGen.scala 588:78]
  assign Bandpower_io_in_bits_6_real = FFT_io_out_bits_6_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_io_in_bits_6_imag = FFT_io_out_bits_6_imag; // @[WellnessGen.scala 588:78]
  assign Bandpower_io_in_bits_7_real = FFT_io_out_bits_7_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_io_in_bits_7_imag = FFT_io_out_bits_7_imag; // @[WellnessGen.scala 588:78]
  assign ConstantCoefficientFIRFilter_1_clock = clock;
  assign ConstantCoefficientFIRFilter_1_reset = reset;
  assign ConstantCoefficientFIRFilter_1_io_in_valid = io_inConf_bits_confInputMuxSel ? io_streamIn_valid : io_in_valid; // @[WellnessGen.scala 380:91]
  assign ConstantCoefficientFIRFilter_1_io_in_bits = io_inConf_bits_confInputMuxSel ? $signed(_T_2) : $signed(_T_5); // @[WellnessGen.scala 381:91]
  assign FFTBuffer_1_clock = clock;
  assign FFTBuffer_1_reset = reset;
  assign FFTBuffer_1_io_in_valid = ConstantCoefficientFIRFilter_1_io_out_valid; // @[WellnessGen.scala 508:76]
  assign FFTBuffer_1_io_in_bits = ConstantCoefficientFIRFilter_1_io_out_bits; // @[WellnessGen.scala 509:76]
  assign FFT_1_clock = clock;
  assign FFT_1_io_in_valid = FFTBuffer_1_io_out_valid; // @[WellnessGen.scala 519:66]
  assign FFT_1_io_in_bits_0_real = $signed(_T_106); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_1_real = $signed(_T_109); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_2_real = $signed(_T_112); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_3_real = $signed(_T_115); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_4_real = $signed(_T_118); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_5_real = $signed(_T_121); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_6_real = $signed(_T_124); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_7_real = $signed(_T_127); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_8_real = $signed(_T_130); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_9_real = $signed(_T_133); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_10_real = $signed(_T_136); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_11_real = $signed(_T_139); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_12_real = $signed(_T_142); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_13_real = $signed(_T_145); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_14_real = $signed(_T_148); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_15_real = $signed(_T_151); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_16_real = $signed(_T_154); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_17_real = $signed(_T_157); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_18_real = $signed(_T_160); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_19_real = $signed(_T_163); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_20_real = $signed(_T_166); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_21_real = $signed(_T_169); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_22_real = $signed(_T_172); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_23_real = $signed(_T_175); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_24_real = $signed(_T_178); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_25_real = $signed(_T_181); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_26_real = $signed(_T_184); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_27_real = $signed(_T_187); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_28_real = $signed(_T_190); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_29_real = $signed(_T_193); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_30_real = $signed(_T_196); // @[WellnessGen.scala 522:75]
  assign FFT_1_io_in_bits_31_real = $signed(_T_199); // @[WellnessGen.scala 522:75]
  assign Bandpower_1_clock = clock;
  assign Bandpower_1_io_in_valid = FFT_1_io_out_valid; // @[WellnessGen.scala 587:78]
  assign Bandpower_1_io_in_bits_8_real = FFT_1_io_out_bits_8_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_8_imag = FFT_1_io_out_bits_8_imag; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_9_real = FFT_1_io_out_bits_9_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_9_imag = FFT_1_io_out_bits_9_imag; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_10_real = FFT_1_io_out_bits_10_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_10_imag = FFT_1_io_out_bits_10_imag; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_11_real = FFT_1_io_out_bits_11_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_11_imag = FFT_1_io_out_bits_11_imag; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_12_real = FFT_1_io_out_bits_12_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_12_imag = FFT_1_io_out_bits_12_imag; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_13_real = FFT_1_io_out_bits_13_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_13_imag = FFT_1_io_out_bits_13_imag; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_14_real = FFT_1_io_out_bits_14_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_14_imag = FFT_1_io_out_bits_14_imag; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_15_real = FFT_1_io_out_bits_15_real; // @[WellnessGen.scala 588:78]
  assign Bandpower_1_io_in_bits_15_imag = FFT_1_io_out_bits_15_imag; // @[WellnessGen.scala 588:78]
  assign ConstantCoefficientFIRFilter_2_clock = clock;
  assign ConstantCoefficientFIRFilter_2_reset = reset;
  assign ConstantCoefficientFIRFilter_2_io_in_valid = io_inConf_bits_confInputMuxSel ? io_streamIn_valid : io_in_valid; // @[WellnessGen.scala 380:91]
  assign ConstantCoefficientFIRFilter_2_io_in_bits = io_inConf_bits_confInputMuxSel ? $signed(_T_2) : $signed(_T_5); // @[WellnessGen.scala 381:91]
  assign lineLength_clock = clock;
  assign lineLength_reset = reset;
  assign lineLength_io_in_valid = ConstantCoefficientFIRFilter_2_io_out_valid; // @[WellnessGen.scala 557:77]
  assign lineLength_io_in_bits = ConstantCoefficientFIRFilter_2_io_out_bits; // @[WellnessGen.scala 558:77]
  assign ShiftReg_clock = clock;
  assign ShiftReg_reset = reset;
  assign ShiftReg_io_in_valid = lineLength_io_out_valid; // @[WellnessGen.scala 620:75]
  assign ShiftReg_io_in_bits = lineLength_io_out_bits; // @[WellnessGen.scala 621:74]
  assign ShiftReg_1_clock = clock;
  assign ShiftReg_1_reset = reset;
  assign ShiftReg_1_io_in_valid = ShiftReg_io_out_valid; // @[WellnessGen.scala 615:75]
  assign ShiftReg_1_io_in_bits = ShiftReg_io_out_bits; // @[WellnessGen.scala 616:74]
  assign pcaNorm_clock = clock;
  assign pcaNorm_io_in_valid = _T_203 == 3'h0; // @[WellnessGen.scala 658:23]
  assign pcaNorm_io_in_bits_0 = Bandpower_io_out_bits; // @[WellnessGen.scala 659:22]
  assign pcaNorm_io_in_bits_1 = Bandpower_1_io_out_bits; // @[WellnessGen.scala 659:22]
  assign pcaNorm_io_in_bits_2 = ShiftReg_1_io_out_bits; // @[WellnessGen.scala 659:22]
  assign pcaNorm_io_PCANormalizationData_0_0 = io_inConf_bits_confPCANormalizationData_0_0; // @[WellnessGen.scala 657:35]
  assign pcaNorm_io_PCANormalizationData_0_1 = io_inConf_bits_confPCANormalizationData_0_1; // @[WellnessGen.scala 657:35]
  assign pcaNorm_io_PCANormalizationData_1_0 = io_inConf_bits_confPCANormalizationData_1_0; // @[WellnessGen.scala 657:35]
  assign pcaNorm_io_PCANormalizationData_1_1 = io_inConf_bits_confPCANormalizationData_1_1; // @[WellnessGen.scala 657:35]
  assign pcaNorm_io_PCANormalizationData_2_0 = io_inConf_bits_confPCANormalizationData_2_0; // @[WellnessGen.scala 657:35]
  assign pcaNorm_io_PCANormalizationData_2_1 = io_inConf_bits_confPCANormalizationData_2_1; // @[WellnessGen.scala 657:35]
  assign pca_clock = clock;
  assign pca_io_in_valid = pcaNorm_io_out_valid; // @[WellnessGen.scala 666:19]
  assign pca_io_in_bits_0 = pcaNorm_io_out_bits_0; // @[WellnessGen.scala 667:18]
  assign pca_io_in_bits_1 = pcaNorm_io_out_bits_1; // @[WellnessGen.scala 667:18]
  assign pca_io_in_bits_2 = pcaNorm_io_out_bits_2; // @[WellnessGen.scala 667:18]
  assign pca_io_PCAVector_0_0 = io_inConf_bits_confPCAVector_0_0; // @[WellnessGen.scala 665:20]
  assign pca_io_PCAVector_0_1 = io_inConf_bits_confPCAVector_0_1; // @[WellnessGen.scala 665:20]
  assign pca_io_PCAVector_0_2 = io_inConf_bits_confPCAVector_0_2; // @[WellnessGen.scala 665:20]
  assign pca_io_PCAVector_1_0 = io_inConf_bits_confPCAVector_1_0; // @[WellnessGen.scala 665:20]
  assign pca_io_PCAVector_1_1 = io_inConf_bits_confPCAVector_1_1; // @[WellnessGen.scala 665:20]
  assign pca_io_PCAVector_1_2 = io_inConf_bits_confPCAVector_1_2; // @[WellnessGen.scala 665:20]
  assign logistic_clock = clock;
  assign logistic_io_in_valid = pca_io_out_valid; // @[WellnessGen.scala 676:24]
  assign logistic_io_in_bits_0 = pca_io_out_bits_0; // @[WellnessGen.scala 677:23]
  assign logistic_io_in_bits_1 = pca_io_out_bits_1; // @[WellnessGen.scala 677:23]
  assign logistic_io_weights_0 = io_inConf_bits_confLogisticWeightsVector_0_0; // @[WellnessGen.scala 673:23]
  assign logistic_io_weights_1 = io_inConf_bits_confLogisticWeightsVector_0_1; // @[WellnessGen.scala 673:23]
  assign logistic_io_intercept = io_inConf_bits_confLogisticIntercept_0_0; // @[WellnessGen.scala 674:25]
endmodule
module MemoryBuffer(
  input         clock,
  input         reset,
  input         io_in_valid,
  input  [31:0] io_in_bits,
  output [31:0] io_out_bits_0_0,
  output [31:0] io_out_bits_0_1,
  output [31:0] io_out_bits_0_2,
  output [31:0] io_out_bits_1_0,
  output [31:0] io_out_bits_1_1,
  output [31:0] io_out_bits_1_2
);
  reg [31:0] regs_0; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_0;
  reg [31:0] regs_1; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_1;
  reg [31:0] regs_2; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_2;
  reg [31:0] regs_3; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_3;
  reg [31:0] regs_4; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_4;
  reg [31:0] regs_5; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_5;
  assign io_out_bits_0_0 = regs_0; // @[MemoryBuffer.scala 65:25]
  assign io_out_bits_0_1 = regs_1; // @[MemoryBuffer.scala 65:25]
  assign io_out_bits_0_2 = regs_2; // @[MemoryBuffer.scala 65:25]
  assign io_out_bits_1_0 = regs_3; // @[MemoryBuffer.scala 65:25]
  assign io_out_bits_1_1 = regs_4; // @[MemoryBuffer.scala 65:25]
  assign io_out_bits_1_2 = regs_5; // @[MemoryBuffer.scala 65:25]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  regs_0 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  regs_1 = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  regs_2 = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  regs_3 = _RAND_3[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  regs_4 = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  regs_5 = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      regs_0 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_0 <= io_in_bits;
      end
    end
    if (reset) begin
      regs_1 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_1 <= regs_0;
      end
    end
    if (reset) begin
      regs_2 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_2 <= regs_1;
      end
    end
    if (reset) begin
      regs_3 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_3 <= regs_2;
      end
    end
    if (reset) begin
      regs_4 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_4 <= regs_3;
      end
    end
    if (reset) begin
      regs_5 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_5 <= regs_4;
      end
    end
  end
endmodule
module MemoryBuffer_1(
  input         clock,
  input         reset,
  input         io_in_valid,
  input  [31:0] io_in_bits,
  output [31:0] io_out_bits_0_0,
  output [31:0] io_out_bits_0_1,
  output [31:0] io_out_bits_1_0,
  output [31:0] io_out_bits_1_1,
  output [31:0] io_out_bits_2_0,
  output [31:0] io_out_bits_2_1
);
  reg [31:0] regs_0; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_0;
  reg [31:0] regs_1; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_1;
  reg [31:0] regs_2; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_2;
  reg [31:0] regs_3; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_3;
  reg [31:0] regs_4; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_4;
  reg [31:0] regs_5; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_5;
  assign io_out_bits_0_0 = regs_0; // @[MemoryBuffer.scala 65:25]
  assign io_out_bits_0_1 = regs_1; // @[MemoryBuffer.scala 65:25]
  assign io_out_bits_1_0 = regs_2; // @[MemoryBuffer.scala 65:25]
  assign io_out_bits_1_1 = regs_3; // @[MemoryBuffer.scala 65:25]
  assign io_out_bits_2_0 = regs_4; // @[MemoryBuffer.scala 65:25]
  assign io_out_bits_2_1 = regs_5; // @[MemoryBuffer.scala 65:25]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  regs_0 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  regs_1 = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  regs_2 = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  regs_3 = _RAND_3[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  regs_4 = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  regs_5 = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      regs_0 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_0 <= io_in_bits;
      end
    end
    if (reset) begin
      regs_1 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_1 <= regs_0;
      end
    end
    if (reset) begin
      regs_2 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_2 <= regs_1;
      end
    end
    if (reset) begin
      regs_3 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_3 <= regs_2;
      end
    end
    if (reset) begin
      regs_4 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_4 <= regs_3;
      end
    end
    if (reset) begin
      regs_5 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_5 <= regs_4;
      end
    end
  end
endmodule
module MemoryBuffer_2(
  input         clock,
  input         reset,
  input         io_in_valid,
  input  [31:0] io_in_bits,
  output [31:0] io_out_bits_0_0,
  output [31:0] io_out_bits_0_1
);
  reg [31:0] regs_0; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_0;
  reg [31:0] regs_1; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_1;
  assign io_out_bits_0_0 = regs_0; // @[MemoryBuffer.scala 65:25]
  assign io_out_bits_0_1 = regs_1; // @[MemoryBuffer.scala 65:25]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  regs_0 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  regs_1 = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      regs_0 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_0 <= io_in_bits;
      end
    end
    if (reset) begin
      regs_1 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_1 <= regs_0;
      end
    end
  end
endmodule
module MemoryBuffer_3(
  input         clock,
  input         reset,
  input         io_in_valid,
  input  [31:0] io_in_bits,
  output [31:0] io_out_bits_0_0
);
  reg [31:0] regs_0; // @[MemoryBuffer.scala 39:21]
  reg [31:0] _RAND_0;
  assign io_out_bits_0_0 = regs_0; // @[MemoryBuffer.scala 65:25]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  regs_0 = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      regs_0 <= 32'sh0;
    end else begin
      if (io_in_valid) begin
        regs_0 <= io_in_bits;
      end
    end
  end
endmodule
module ConfigurationMemory(
  input         clock,
  input         reset,
  input         io_in_valid,
  input  [31:0] io_in_bits_wrdata,
  input  [2:0]  io_in_bits_wraddr,
  output [31:0] io_out_bits_confPCAVector_0_0,
  output [31:0] io_out_bits_confPCAVector_0_1,
  output [31:0] io_out_bits_confPCAVector_0_2,
  output [31:0] io_out_bits_confPCAVector_1_0,
  output [31:0] io_out_bits_confPCAVector_1_1,
  output [31:0] io_out_bits_confPCAVector_1_2,
  output [31:0] io_out_bits_confLogisticWeightsVector_0_0,
  output [31:0] io_out_bits_confLogisticWeightsVector_0_1,
  output [31:0] io_out_bits_confLogisticIntercept_0_0,
  output        io_out_bits_confInputMuxSel,
  output [31:0] io_out_bits_confPCANormalizationData_0_0,
  output [31:0] io_out_bits_confPCANormalizationData_0_1,
  output [31:0] io_out_bits_confPCANormalizationData_1_0,
  output [31:0] io_out_bits_confPCANormalizationData_1_1,
  output [31:0] io_out_bits_confPCANormalizationData_2_0,
  output [31:0] io_out_bits_confPCANormalizationData_2_1
);
  wire  pcaVectorMemory_clock; // @[ConfigurationMemory.scala 67:31]
  wire  pcaVectorMemory_reset; // @[ConfigurationMemory.scala 67:31]
  wire  pcaVectorMemory_io_in_valid; // @[ConfigurationMemory.scala 67:31]
  wire [31:0] pcaVectorMemory_io_in_bits; // @[ConfigurationMemory.scala 67:31]
  wire [31:0] pcaVectorMemory_io_out_bits_0_0; // @[ConfigurationMemory.scala 67:31]
  wire [31:0] pcaVectorMemory_io_out_bits_0_1; // @[ConfigurationMemory.scala 67:31]
  wire [31:0] pcaVectorMemory_io_out_bits_0_2; // @[ConfigurationMemory.scala 67:31]
  wire [31:0] pcaVectorMemory_io_out_bits_1_0; // @[ConfigurationMemory.scala 67:31]
  wire [31:0] pcaVectorMemory_io_out_bits_1_1; // @[ConfigurationMemory.scala 67:31]
  wire [31:0] pcaVectorMemory_io_out_bits_1_2; // @[ConfigurationMemory.scala 67:31]
  wire  pcaNormalizationMemory_clock; // @[ConfigurationMemory.scala 79:38]
  wire  pcaNormalizationMemory_reset; // @[ConfigurationMemory.scala 79:38]
  wire  pcaNormalizationMemory_io_in_valid; // @[ConfigurationMemory.scala 79:38]
  wire [31:0] pcaNormalizationMemory_io_in_bits; // @[ConfigurationMemory.scala 79:38]
  wire [31:0] pcaNormalizationMemory_io_out_bits_0_0; // @[ConfigurationMemory.scala 79:38]
  wire [31:0] pcaNormalizationMemory_io_out_bits_0_1; // @[ConfigurationMemory.scala 79:38]
  wire [31:0] pcaNormalizationMemory_io_out_bits_1_0; // @[ConfigurationMemory.scala 79:38]
  wire [31:0] pcaNormalizationMemory_io_out_bits_1_1; // @[ConfigurationMemory.scala 79:38]
  wire [31:0] pcaNormalizationMemory_io_out_bits_2_0; // @[ConfigurationMemory.scala 79:38]
  wire [31:0] pcaNormalizationMemory_io_out_bits_2_1; // @[ConfigurationMemory.scala 79:38]
  wire  logisticWeightsVectorMemory_clock; // @[ConfigurationMemory.scala 91:43]
  wire  logisticWeightsVectorMemory_reset; // @[ConfigurationMemory.scala 91:43]
  wire  logisticWeightsVectorMemory_io_in_valid; // @[ConfigurationMemory.scala 91:43]
  wire [31:0] logisticWeightsVectorMemory_io_in_bits; // @[ConfigurationMemory.scala 91:43]
  wire [31:0] logisticWeightsVectorMemory_io_out_bits_0_0; // @[ConfigurationMemory.scala 91:43]
  wire [31:0] logisticWeightsVectorMemory_io_out_bits_0_1; // @[ConfigurationMemory.scala 91:43]
  wire  logisticInterceptMemory_clock; // @[ConfigurationMemory.scala 104:39]
  wire  logisticInterceptMemory_reset; // @[ConfigurationMemory.scala 104:39]
  wire  logisticInterceptMemory_io_in_valid; // @[ConfigurationMemory.scala 104:39]
  wire [31:0] logisticInterceptMemory_io_in_bits; // @[ConfigurationMemory.scala 104:39]
  wire [31:0] logisticInterceptMemory_io_out_bits_0_0; // @[ConfigurationMemory.scala 104:39]
  wire  _T; // @[ConfigurationMemory.scala 70:55]
  wire  _T_2; // @[ConfigurationMemory.scala 82:62]
  wire  _T_4; // @[ConfigurationMemory.scala 94:67]
  wire  _T_6; // @[ConfigurationMemory.scala 107:63]
  reg  inputMuxSel; // @[ConfigurationMemory.scala 111:28]
  reg [31:0] _RAND_0;
  wire  _T_8; // @[ConfigurationMemory.scala 112:29]
  wire  _T_9; // @[ConfigurationMemory.scala 112:20]
  wire [31:0] _T_10; // @[ConfigurationMemory.scala 112:90]
  wire  _T_11; // @[ConfigurationMemory.scala 112:92]
  MemoryBuffer pcaVectorMemory ( // @[ConfigurationMemory.scala 67:31]
    .clock(pcaVectorMemory_clock),
    .reset(pcaVectorMemory_reset),
    .io_in_valid(pcaVectorMemory_io_in_valid),
    .io_in_bits(pcaVectorMemory_io_in_bits),
    .io_out_bits_0_0(pcaVectorMemory_io_out_bits_0_0),
    .io_out_bits_0_1(pcaVectorMemory_io_out_bits_0_1),
    .io_out_bits_0_2(pcaVectorMemory_io_out_bits_0_2),
    .io_out_bits_1_0(pcaVectorMemory_io_out_bits_1_0),
    .io_out_bits_1_1(pcaVectorMemory_io_out_bits_1_1),
    .io_out_bits_1_2(pcaVectorMemory_io_out_bits_1_2)
  );
  MemoryBuffer_1 pcaNormalizationMemory ( // @[ConfigurationMemory.scala 79:38]
    .clock(pcaNormalizationMemory_clock),
    .reset(pcaNormalizationMemory_reset),
    .io_in_valid(pcaNormalizationMemory_io_in_valid),
    .io_in_bits(pcaNormalizationMemory_io_in_bits),
    .io_out_bits_0_0(pcaNormalizationMemory_io_out_bits_0_0),
    .io_out_bits_0_1(pcaNormalizationMemory_io_out_bits_0_1),
    .io_out_bits_1_0(pcaNormalizationMemory_io_out_bits_1_0),
    .io_out_bits_1_1(pcaNormalizationMemory_io_out_bits_1_1),
    .io_out_bits_2_0(pcaNormalizationMemory_io_out_bits_2_0),
    .io_out_bits_2_1(pcaNormalizationMemory_io_out_bits_2_1)
  );
  MemoryBuffer_2 logisticWeightsVectorMemory ( // @[ConfigurationMemory.scala 91:43]
    .clock(logisticWeightsVectorMemory_clock),
    .reset(logisticWeightsVectorMemory_reset),
    .io_in_valid(logisticWeightsVectorMemory_io_in_valid),
    .io_in_bits(logisticWeightsVectorMemory_io_in_bits),
    .io_out_bits_0_0(logisticWeightsVectorMemory_io_out_bits_0_0),
    .io_out_bits_0_1(logisticWeightsVectorMemory_io_out_bits_0_1)
  );
  MemoryBuffer_3 logisticInterceptMemory ( // @[ConfigurationMemory.scala 104:39]
    .clock(logisticInterceptMemory_clock),
    .reset(logisticInterceptMemory_reset),
    .io_in_valid(logisticInterceptMemory_io_in_valid),
    .io_in_bits(logisticInterceptMemory_io_in_bits),
    .io_out_bits_0_0(logisticInterceptMemory_io_out_bits_0_0)
  );
  assign _T = io_in_bits_wraddr == 3'h0; // @[ConfigurationMemory.scala 70:55]
  assign _T_2 = io_in_bits_wraddr == 3'h4; // @[ConfigurationMemory.scala 82:62]
  assign _T_4 = io_in_bits_wraddr == 3'h1; // @[ConfigurationMemory.scala 94:67]
  assign _T_6 = io_in_bits_wraddr == 3'h2; // @[ConfigurationMemory.scala 107:63]
  assign _T_8 = io_in_bits_wraddr == 3'h3; // @[ConfigurationMemory.scala 112:29]
  assign _T_9 = io_in_valid & _T_8; // @[ConfigurationMemory.scala 112:20]
  assign _T_10 = $unsigned(io_in_bits_wrdata); // @[ConfigurationMemory.scala 112:90]
  assign _T_11 = _T_10[0]; // @[ConfigurationMemory.scala 112:92]
  assign io_out_bits_confPCAVector_0_0 = pcaVectorMemory_io_out_bits_0_0; // @[ConfigurationMemory.scala 71:29]
  assign io_out_bits_confPCAVector_0_1 = pcaVectorMemory_io_out_bits_0_1; // @[ConfigurationMemory.scala 71:29]
  assign io_out_bits_confPCAVector_0_2 = pcaVectorMemory_io_out_bits_0_2; // @[ConfigurationMemory.scala 71:29]
  assign io_out_bits_confPCAVector_1_0 = pcaVectorMemory_io_out_bits_1_0; // @[ConfigurationMemory.scala 71:29]
  assign io_out_bits_confPCAVector_1_1 = pcaVectorMemory_io_out_bits_1_1; // @[ConfigurationMemory.scala 71:29]
  assign io_out_bits_confPCAVector_1_2 = pcaVectorMemory_io_out_bits_1_2; // @[ConfigurationMemory.scala 71:29]
  assign io_out_bits_confLogisticWeightsVector_0_0 = logisticWeightsVectorMemory_io_out_bits_0_0; // @[ConfigurationMemory.scala 95:41]
  assign io_out_bits_confLogisticWeightsVector_0_1 = logisticWeightsVectorMemory_io_out_bits_0_1; // @[ConfigurationMemory.scala 95:41]
  assign io_out_bits_confLogisticIntercept_0_0 = logisticInterceptMemory_io_out_bits_0_0; // @[ConfigurationMemory.scala 108:37]
  assign io_out_bits_confInputMuxSel = inputMuxSel; // @[ConfigurationMemory.scala 113:31]
  assign io_out_bits_confPCANormalizationData_0_0 = pcaNormalizationMemory_io_out_bits_0_0; // @[ConfigurationMemory.scala 83:40]
  assign io_out_bits_confPCANormalizationData_0_1 = pcaNormalizationMemory_io_out_bits_0_1; // @[ConfigurationMemory.scala 83:40]
  assign io_out_bits_confPCANormalizationData_1_0 = pcaNormalizationMemory_io_out_bits_1_0; // @[ConfigurationMemory.scala 83:40]
  assign io_out_bits_confPCANormalizationData_1_1 = pcaNormalizationMemory_io_out_bits_1_1; // @[ConfigurationMemory.scala 83:40]
  assign io_out_bits_confPCANormalizationData_2_0 = pcaNormalizationMemory_io_out_bits_2_0; // @[ConfigurationMemory.scala 83:40]
  assign io_out_bits_confPCANormalizationData_2_1 = pcaNormalizationMemory_io_out_bits_2_1; // @[ConfigurationMemory.scala 83:40]
  assign pcaVectorMemory_clock = clock;
  assign pcaVectorMemory_reset = reset;
  assign pcaVectorMemory_io_in_valid = io_in_valid & _T; // @[ConfigurationMemory.scala 70:31]
  assign pcaVectorMemory_io_in_bits = io_in_bits_wrdata; // @[ConfigurationMemory.scala 68:30]
  assign pcaNormalizationMemory_clock = clock;
  assign pcaNormalizationMemory_reset = reset;
  assign pcaNormalizationMemory_io_in_valid = io_in_valid & _T_2; // @[ConfigurationMemory.scala 82:38]
  assign pcaNormalizationMemory_io_in_bits = io_in_bits_wrdata; // @[ConfigurationMemory.scala 80:37]
  assign logisticWeightsVectorMemory_clock = clock;
  assign logisticWeightsVectorMemory_reset = reset;
  assign logisticWeightsVectorMemory_io_in_valid = io_in_valid & _T_4; // @[ConfigurationMemory.scala 94:43]
  assign logisticWeightsVectorMemory_io_in_bits = io_in_bits_wrdata; // @[ConfigurationMemory.scala 92:42]
  assign logisticInterceptMemory_clock = clock;
  assign logisticInterceptMemory_reset = reset;
  assign logisticInterceptMemory_io_in_valid = io_in_valid & _T_6; // @[ConfigurationMemory.scala 107:39]
  assign logisticInterceptMemory_io_in_bits = io_in_bits_wrdata; // @[ConfigurationMemory.scala 105:38]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  inputMuxSel = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      inputMuxSel <= 1'h0;
    end else begin
      if (_T_9) begin
        inputMuxSel <= _T_11;
      end
    end
  end
endmodule
module TLWellnessGenDataPathBlock(
  input         clock,
  input         reset,
  output        in_ready,
  input         in_valid,
  input  [63:0] in_bits_data,
  input         in_bits_last,
  input         out_ready,
  output        out_valid,
  output [63:0] out_bits_data,
  output        out_bits_last,
  output        in2_ready,
  input         in2_valid,
  input  [63:0] in2_bits_data,
  input         in2_bits_last,
  input         streamIn_valid,
  input  [31:0] streamIn_bits,
  input         streamIn_sync
);
  wire  converter_auto_in_ready; // @[Nodes.scala 106:31]
  wire  converter_auto_in_valid; // @[Nodes.scala 106:31]
  wire [63:0] converter_auto_in_bits_data; // @[Nodes.scala 106:31]
  wire  converter_auto_in_bits_last; // @[Nodes.scala 106:31]
  wire  converter_auto_out_ready; // @[Nodes.scala 106:31]
  wire  converter_auto_out_valid; // @[Nodes.scala 106:31]
  wire [63:0] converter_auto_out_bits_data; // @[Nodes.scala 106:31]
  wire  converter_auto_out_bits_last; // @[Nodes.scala 106:31]
  wire  converter_1_auto_in_ready; // @[Nodes.scala 142:31]
  wire  converter_1_auto_in_valid; // @[Nodes.scala 142:31]
  wire [63:0] converter_1_auto_in_bits_data; // @[Nodes.scala 142:31]
  wire  converter_1_auto_in_bits_last; // @[Nodes.scala 142:31]
  wire  converter_1_auto_out_ready; // @[Nodes.scala 142:31]
  wire  converter_1_auto_out_valid; // @[Nodes.scala 142:31]
  wire [63:0] converter_1_auto_out_bits_data; // @[Nodes.scala 142:31]
  wire  converter_1_auto_out_bits_last; // @[Nodes.scala 142:31]
  wire  converter_2_auto_in_ready; // @[Nodes.scala 142:31]
  wire  converter_2_auto_in_valid; // @[Nodes.scala 142:31]
  wire [63:0] converter_2_auto_in_bits_data; // @[Nodes.scala 142:31]
  wire  converter_2_auto_in_bits_last; // @[Nodes.scala 142:31]
  wire  converter_2_auto_out_ready; // @[Nodes.scala 142:31]
  wire  converter_2_auto_out_valid; // @[Nodes.scala 142:31]
  wire [63:0] converter_2_auto_out_bits_data; // @[Nodes.scala 142:31]
  wire  converter_2_auto_out_bits_last; // @[Nodes.scala 142:31]
  wire  wellnessGen_clock; // @[WellnessGen.scala 731:29]
  wire  wellnessGen_reset; // @[WellnessGen.scala 731:29]
  wire  wellnessGen_io_streamIn_valid; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_streamIn_bits; // @[WellnessGen.scala 731:29]
  wire  wellnessGen_io_in_valid; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_in_bits; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCAVector_0_0; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCAVector_0_1; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCAVector_0_2; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCAVector_1_0; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCAVector_1_1; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCAVector_1_2; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confLogisticWeightsVector_0_0; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confLogisticWeightsVector_0_1; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confLogisticIntercept_0_0; // @[WellnessGen.scala 731:29]
  wire  wellnessGen_io_inConf_bits_confInputMuxSel; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCANormalizationData_0_0; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCANormalizationData_0_1; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCANormalizationData_1_0; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCANormalizationData_1_1; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCANormalizationData_2_0; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_inConf_bits_confPCANormalizationData_2_1; // @[WellnessGen.scala 731:29]
  wire  wellnessGen_io_out_valid; // @[WellnessGen.scala 731:29]
  wire  wellnessGen_io_out_bits; // @[WellnessGen.scala 731:29]
  wire [31:0] wellnessGen_io_rawVotes; // @[WellnessGen.scala 731:29]
  wire  configurationMemory_clock; // @[WellnessGen.scala 740:37]
  wire  configurationMemory_reset; // @[WellnessGen.scala 740:37]
  wire  configurationMemory_io_in_valid; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_in_bits_wrdata; // @[WellnessGen.scala 740:37]
  wire [2:0] configurationMemory_io_in_bits_wraddr; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCAVector_0_0; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCAVector_0_1; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCAVector_0_2; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCAVector_1_0; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCAVector_1_1; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCAVector_1_2; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confLogisticWeightsVector_0_0; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confLogisticWeightsVector_0_1; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confLogisticIntercept_0_0; // @[WellnessGen.scala 740:37]
  wire  configurationMemory_io_out_bits_confInputMuxSel; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCANormalizationData_0_0; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCANormalizationData_0_1; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCANormalizationData_1_0; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCANormalizationData_1_1; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCANormalizationData_2_0; // @[WellnessGen.scala 740:37]
  wire [31:0] configurationMemory_io_out_bits_confPCANormalizationData_2_1; // @[WellnessGen.scala 740:37]
  wire [63:0] in_1_bits_data; // @[Nodes.scala 333:76 LazyModule.scala 167:31]
  wire [63:0] _T_4; // @[WellnessGen.scala 754:52]
  wire [31:0] _T_5; // @[WellnessGen.scala 758:89]
  wire [32:0] _T_6; // @[Cat.scala 30:58]
  wire [63:0] inConf_bits_data; // @[Nodes.scala 333:76 LazyModule.scala 167:31]
  wire [31:0] _T_7; // @[WellnessGen.scala 764:62]
  wire [31:0] _GEN_0; // @[WellnessGen.scala 754:52 WellnessGen.scala 754:52]
  AXI4StreamToBundleBridge converter ( // @[Nodes.scala 106:31]
    .auto_in_ready(converter_auto_in_ready),
    .auto_in_valid(converter_auto_in_valid),
    .auto_in_bits_data(converter_auto_in_bits_data),
    .auto_in_bits_last(converter_auto_in_bits_last),
    .auto_out_ready(converter_auto_out_ready),
    .auto_out_valid(converter_auto_out_valid),
    .auto_out_bits_data(converter_auto_out_bits_data),
    .auto_out_bits_last(converter_auto_out_bits_last)
  );
  AXI4StreamToBundleBridge converter_1 ( // @[Nodes.scala 142:31]
    .auto_in_ready(converter_1_auto_in_ready),
    .auto_in_valid(converter_1_auto_in_valid),
    .auto_in_bits_data(converter_1_auto_in_bits_data),
    .auto_in_bits_last(converter_1_auto_in_bits_last),
    .auto_out_ready(converter_1_auto_out_ready),
    .auto_out_valid(converter_1_auto_out_valid),
    .auto_out_bits_data(converter_1_auto_out_bits_data),
    .auto_out_bits_last(converter_1_auto_out_bits_last)
  );
  AXI4StreamToBundleBridge converter_2 ( // @[Nodes.scala 142:31]
    .auto_in_ready(converter_2_auto_in_ready),
    .auto_in_valid(converter_2_auto_in_valid),
    .auto_in_bits_data(converter_2_auto_in_bits_data),
    .auto_in_bits_last(converter_2_auto_in_bits_last),
    .auto_out_ready(converter_2_auto_out_ready),
    .auto_out_valid(converter_2_auto_out_valid),
    .auto_out_bits_data(converter_2_auto_out_bits_data),
    .auto_out_bits_last(converter_2_auto_out_bits_last)
  );
  wellnessGenModule wellnessGen ( // @[WellnessGen.scala 731:29]
    .clock(wellnessGen_clock),
    .reset(wellnessGen_reset),
    .io_streamIn_valid(wellnessGen_io_streamIn_valid),
    .io_streamIn_bits(wellnessGen_io_streamIn_bits),
    .io_in_valid(wellnessGen_io_in_valid),
    .io_in_bits(wellnessGen_io_in_bits),
    .io_inConf_bits_confPCAVector_0_0(wellnessGen_io_inConf_bits_confPCAVector_0_0),
    .io_inConf_bits_confPCAVector_0_1(wellnessGen_io_inConf_bits_confPCAVector_0_1),
    .io_inConf_bits_confPCAVector_0_2(wellnessGen_io_inConf_bits_confPCAVector_0_2),
    .io_inConf_bits_confPCAVector_1_0(wellnessGen_io_inConf_bits_confPCAVector_1_0),
    .io_inConf_bits_confPCAVector_1_1(wellnessGen_io_inConf_bits_confPCAVector_1_1),
    .io_inConf_bits_confPCAVector_1_2(wellnessGen_io_inConf_bits_confPCAVector_1_2),
    .io_inConf_bits_confLogisticWeightsVector_0_0(wellnessGen_io_inConf_bits_confLogisticWeightsVector_0_0),
    .io_inConf_bits_confLogisticWeightsVector_0_1(wellnessGen_io_inConf_bits_confLogisticWeightsVector_0_1),
    .io_inConf_bits_confLogisticIntercept_0_0(wellnessGen_io_inConf_bits_confLogisticIntercept_0_0),
    .io_inConf_bits_confInputMuxSel(wellnessGen_io_inConf_bits_confInputMuxSel),
    .io_inConf_bits_confPCANormalizationData_0_0(wellnessGen_io_inConf_bits_confPCANormalizationData_0_0),
    .io_inConf_bits_confPCANormalizationData_0_1(wellnessGen_io_inConf_bits_confPCANormalizationData_0_1),
    .io_inConf_bits_confPCANormalizationData_1_0(wellnessGen_io_inConf_bits_confPCANormalizationData_1_0),
    .io_inConf_bits_confPCANormalizationData_1_1(wellnessGen_io_inConf_bits_confPCANormalizationData_1_1),
    .io_inConf_bits_confPCANormalizationData_2_0(wellnessGen_io_inConf_bits_confPCANormalizationData_2_0),
    .io_inConf_bits_confPCANormalizationData_2_1(wellnessGen_io_inConf_bits_confPCANormalizationData_2_1),
    .io_out_valid(wellnessGen_io_out_valid),
    .io_out_bits(wellnessGen_io_out_bits),
    .io_rawVotes(wellnessGen_io_rawVotes)
  );
  ConfigurationMemory configurationMemory ( // @[WellnessGen.scala 740:37]
    .clock(configurationMemory_clock),
    .reset(configurationMemory_reset),
    .io_in_valid(configurationMemory_io_in_valid),
    .io_in_bits_wrdata(configurationMemory_io_in_bits_wrdata),
    .io_in_bits_wraddr(configurationMemory_io_in_bits_wraddr),
    .io_out_bits_confPCAVector_0_0(configurationMemory_io_out_bits_confPCAVector_0_0),
    .io_out_bits_confPCAVector_0_1(configurationMemory_io_out_bits_confPCAVector_0_1),
    .io_out_bits_confPCAVector_0_2(configurationMemory_io_out_bits_confPCAVector_0_2),
    .io_out_bits_confPCAVector_1_0(configurationMemory_io_out_bits_confPCAVector_1_0),
    .io_out_bits_confPCAVector_1_1(configurationMemory_io_out_bits_confPCAVector_1_1),
    .io_out_bits_confPCAVector_1_2(configurationMemory_io_out_bits_confPCAVector_1_2),
    .io_out_bits_confLogisticWeightsVector_0_0(configurationMemory_io_out_bits_confLogisticWeightsVector_0_0),
    .io_out_bits_confLogisticWeightsVector_0_1(configurationMemory_io_out_bits_confLogisticWeightsVector_0_1),
    .io_out_bits_confLogisticIntercept_0_0(configurationMemory_io_out_bits_confLogisticIntercept_0_0),
    .io_out_bits_confInputMuxSel(configurationMemory_io_out_bits_confInputMuxSel),
    .io_out_bits_confPCANormalizationData_0_0(configurationMemory_io_out_bits_confPCANormalizationData_0_0),
    .io_out_bits_confPCANormalizationData_0_1(configurationMemory_io_out_bits_confPCANormalizationData_0_1),
    .io_out_bits_confPCANormalizationData_1_0(configurationMemory_io_out_bits_confPCANormalizationData_1_0),
    .io_out_bits_confPCANormalizationData_1_1(configurationMemory_io_out_bits_confPCANormalizationData_1_1),
    .io_out_bits_confPCANormalizationData_2_0(configurationMemory_io_out_bits_confPCANormalizationData_2_0),
    .io_out_bits_confPCANormalizationData_2_1(configurationMemory_io_out_bits_confPCANormalizationData_2_1)
  );
  assign in_1_bits_data = converter_1_auto_out_bits_data; // @[Nodes.scala 333:76 LazyModule.scala 167:31]
  assign _T_4 = $signed(in_1_bits_data); // @[WellnessGen.scala 754:52]
  assign _T_5 = $unsigned(wellnessGen_io_rawVotes); // @[WellnessGen.scala 758:89]
  assign _T_6 = {wellnessGen_io_out_bits,_T_5}; // @[Cat.scala 30:58]
  assign inConf_bits_data = converter_2_auto_out_bits_data; // @[Nodes.scala 333:76 LazyModule.scala 167:31]
  assign _T_7 = inConf_bits_data[31:0]; // @[WellnessGen.scala 764:62]
  assign _GEN_0 = _T_4[31:0]; // @[WellnessGen.scala 754:52 WellnessGen.scala 754:52]
  assign in_ready = converter_1_auto_in_ready; // @[BundleBridge.scala 39:12]
  assign out_valid = converter_auto_out_valid; // @[BundleBridge.scala 27:8]
  assign out_bits_data = converter_auto_out_bits_data; // @[BundleBridge.scala 27:8]
  assign out_bits_last = converter_auto_out_bits_last; // @[BundleBridge.scala 27:8]
  assign in2_ready = converter_2_auto_in_ready; // @[BundleBridge.scala 39:12]
  assign converter_auto_in_valid = wellnessGen_io_out_valid; // @[LazyModule.scala 167:57]
  assign converter_auto_in_bits_data = {{31'd0}, _T_6}; // @[LazyModule.scala 167:57]
  assign converter_auto_in_bits_last = 1'h0; // @[LazyModule.scala 167:57]
  assign converter_auto_out_ready = out_ready; // @[LazyModule.scala 167:31]
  assign converter_1_auto_in_valid = in_valid; // @[LazyModule.scala 167:57]
  assign converter_1_auto_in_bits_data = in_bits_data; // @[LazyModule.scala 167:57]
  assign converter_1_auto_in_bits_last = in_bits_last; // @[LazyModule.scala 167:57]
  assign converter_1_auto_out_ready = 1'h1; // @[LazyModule.scala 167:31]
  assign converter_2_auto_in_valid = in2_valid; // @[LazyModule.scala 167:57]
  assign converter_2_auto_in_bits_data = in2_bits_data; // @[LazyModule.scala 167:57]
  assign converter_2_auto_in_bits_last = in2_bits_last; // @[LazyModule.scala 167:57]
  assign converter_2_auto_out_ready = 1'h1; // @[LazyModule.scala 167:31]
  assign wellnessGen_clock = clock;
  assign wellnessGen_reset = reset;
  assign wellnessGen_io_streamIn_valid = streamIn_valid; // @[WellnessGen.scala 747:35]
  assign wellnessGen_io_streamIn_bits = streamIn_bits; // @[WellnessGen.scala 746:34]
  assign wellnessGen_io_in_valid = converter_1_auto_out_valid; // @[WellnessGen.scala 753:29]
  assign wellnessGen_io_in_bits = $signed(_GEN_0); // @[WellnessGen.scala 754:28]
  assign wellnessGen_io_inConf_bits_confPCAVector_0_0 = configurationMemory_io_out_bits_confPCAVector_0_0; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confPCAVector_0_1 = configurationMemory_io_out_bits_confPCAVector_0_1; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confPCAVector_0_2 = configurationMemory_io_out_bits_confPCAVector_0_2; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confPCAVector_1_0 = configurationMemory_io_out_bits_confPCAVector_1_0; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confPCAVector_1_1 = configurationMemory_io_out_bits_confPCAVector_1_1; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confPCAVector_1_2 = configurationMemory_io_out_bits_confPCAVector_1_2; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confLogisticWeightsVector_0_0 = configurationMemory_io_out_bits_confLogisticWeightsVector_0_0; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confLogisticWeightsVector_0_1 = configurationMemory_io_out_bits_confLogisticWeightsVector_0_1; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confLogisticIntercept_0_0 = configurationMemory_io_out_bits_confLogisticIntercept_0_0; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confInputMuxSel = configurationMemory_io_out_bits_confInputMuxSel; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confPCANormalizationData_0_0 = configurationMemory_io_out_bits_confPCANormalizationData_0_0; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confPCANormalizationData_0_1 = configurationMemory_io_out_bits_confPCANormalizationData_0_1; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confPCANormalizationData_1_0 = configurationMemory_io_out_bits_confPCANormalizationData_1_0; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confPCANormalizationData_1_1 = configurationMemory_io_out_bits_confPCANormalizationData_1_1; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confPCANormalizationData_2_0 = configurationMemory_io_out_bits_confPCANormalizationData_2_0; // @[WellnessGen.scala 766:27]
  assign wellnessGen_io_inConf_bits_confPCANormalizationData_2_1 = configurationMemory_io_out_bits_confPCANormalizationData_2_1; // @[WellnessGen.scala 766:27]
  assign configurationMemory_clock = clock;
  assign configurationMemory_reset = reset;
  assign configurationMemory_io_in_valid = converter_2_auto_out_valid; // @[WellnessGen.scala 762:37]
  assign configurationMemory_io_in_bits_wrdata = $signed(_T_7); // @[WellnessGen.scala 764:43]
  assign configurationMemory_io_in_bits_wraddr = inConf_bits_data[34:32]; // @[WellnessGen.scala 765:43]
endmodule
