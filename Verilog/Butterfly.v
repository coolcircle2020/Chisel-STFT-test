module ComplexAdd(
  input  [31:0] io_op1_re,
  input  [31:0] io_op1_im,
  input  [31:0] io_op2_re,
  input  [31:0] io_op2_im,
  output [31:0] io_res_re,
  output [31:0] io_res_im
);
  assign io_res_re = $signed(io_op1_re) + $signed(io_op2_re); // @[Butterfly.scala 21:13]
  assign io_res_im = $signed(io_op1_im) + $signed(io_op2_im); // @[Butterfly.scala 22:13]
endmodule
module ComplexSub(
  input  [31:0] io_op1_re,
  input  [31:0] io_op1_im,
  input  [31:0] io_op2_re,
  input  [31:0] io_op2_im,
  output [31:0] io_res_re,
  output [31:0] io_res_im
);
  assign io_res_re = $signed(io_op1_re) - $signed(io_op2_re); // @[Butterfly.scala 35:13]
  assign io_res_im = $signed(io_op1_im) - $signed(io_op2_im); // @[Butterfly.scala 36:13]
endmodule
module ComplexMul(
  input  [31:0] io_op1_re,
  input  [31:0] io_op1_im,
  input  [31:0] io_op2_re,
  input  [31:0] io_op2_im,
  output [31:0] io_res_re,
  output [31:0] io_res_im
);
  wire [63:0] _T = $signed(io_op1_re) * $signed(io_op2_re); // @[Butterfly.scala 57:28]
  wire [63:0] _T_1 = $signed(io_op1_im) * $signed(io_op2_im); // @[Butterfly.scala 57:52]
  wire [63:0] _T_4 = $signed(_T) - $signed(_T_1); // @[Butterfly.scala 57:40]
  wire [63:0] _T_5 = $signed(io_op1_re) * $signed(io_op2_im); // @[Butterfly.scala 58:28]
  wire [63:0] _T_6 = $signed(io_op1_im) * $signed(io_op2_re); // @[Butterfly.scala 58:52]
  wire [63:0] _T_9 = $signed(_T_5) + $signed(_T_6); // @[Butterfly.scala 58:40]
  wire [47:0] _GEN_0 = _T_4[63:16]; // @[Butterfly.scala 57:15]
  wire [47:0] _GEN_2 = _T_9[63:16]; // @[Butterfly.scala 58:15]
  assign io_res_re = _GEN_0[31:0]; // @[Butterfly.scala 57:15]
  assign io_res_im = _GEN_2[31:0]; // @[Butterfly.scala 58:15]
endmodule
module Butterfly(
  input         clock,
  input         reset,
  input  [31:0] io_in1_re,
  input  [31:0] io_in1_im,
  input  [31:0] io_in2_re,
  input  [31:0] io_in2_im,
  input  [31:0] io_wn_re,
  input  [31:0] io_wn_im,
  output [31:0] io_out1_re,
  output [31:0] io_out1_im,
  output [31:0] io_out2_re,
  output [31:0] io_out2_im
);
  wire [31:0] ComplexAdd_io_op1_re; // @[Butterfly.scala 26:22]
  wire [31:0] ComplexAdd_io_op1_im; // @[Butterfly.scala 26:22]
  wire [31:0] ComplexAdd_io_op2_re; // @[Butterfly.scala 26:22]
  wire [31:0] ComplexAdd_io_op2_im; // @[Butterfly.scala 26:22]
  wire [31:0] ComplexAdd_io_res_re; // @[Butterfly.scala 26:22]
  wire [31:0] ComplexAdd_io_res_im; // @[Butterfly.scala 26:22]
  wire [31:0] ComplexSub_io_op1_re; // @[Butterfly.scala 40:22]
  wire [31:0] ComplexSub_io_op1_im; // @[Butterfly.scala 40:22]
  wire [31:0] ComplexSub_io_op2_re; // @[Butterfly.scala 40:22]
  wire [31:0] ComplexSub_io_op2_im; // @[Butterfly.scala 40:22]
  wire [31:0] ComplexSub_io_res_re; // @[Butterfly.scala 40:22]
  wire [31:0] ComplexSub_io_res_im; // @[Butterfly.scala 40:22]
  wire [31:0] ComplexMul_io_op1_re; // @[Butterfly.scala 63:22]
  wire [31:0] ComplexMul_io_op1_im; // @[Butterfly.scala 63:22]
  wire [31:0] ComplexMul_io_op2_re; // @[Butterfly.scala 63:22]
  wire [31:0] ComplexMul_io_op2_im; // @[Butterfly.scala 63:22]
  wire [31:0] ComplexMul_io_res_re; // @[Butterfly.scala 63:22]
  wire [31:0] ComplexMul_io_res_im; // @[Butterfly.scala 63:22]
  ComplexAdd ComplexAdd ( // @[Butterfly.scala 26:22]
    .io_op1_re(ComplexAdd_io_op1_re),
    .io_op1_im(ComplexAdd_io_op1_im),
    .io_op2_re(ComplexAdd_io_op2_re),
    .io_op2_im(ComplexAdd_io_op2_im),
    .io_res_re(ComplexAdd_io_res_re),
    .io_res_im(ComplexAdd_io_res_im)
  );
  ComplexSub ComplexSub ( // @[Butterfly.scala 40:22]
    .io_op1_re(ComplexSub_io_op1_re),
    .io_op1_im(ComplexSub_io_op1_im),
    .io_op2_re(ComplexSub_io_op2_re),
    .io_op2_im(ComplexSub_io_op2_im),
    .io_res_re(ComplexSub_io_res_re),
    .io_res_im(ComplexSub_io_res_im)
  );
  ComplexMul ComplexMul ( // @[Butterfly.scala 63:22]
    .io_op1_re(ComplexMul_io_op1_re),
    .io_op1_im(ComplexMul_io_op1_im),
    .io_op2_re(ComplexMul_io_op2_re),
    .io_op2_im(ComplexMul_io_op2_im),
    .io_res_re(ComplexMul_io_res_re),
    .io_res_im(ComplexMul_io_res_im)
  );
  assign io_out1_re = ComplexAdd_io_res_re; // @[Butterfly.scala 84:11]
  assign io_out1_im = ComplexAdd_io_res_im; // @[Butterfly.scala 84:11]
  assign io_out2_re = ComplexMul_io_res_re; // @[Butterfly.scala 85:11]
  assign io_out2_im = ComplexMul_io_res_im; // @[Butterfly.scala 85:11]
  assign ComplexAdd_io_op1_re = io_in1_re; // @[Butterfly.scala 27:17]
  assign ComplexAdd_io_op1_im = io_in1_im; // @[Butterfly.scala 27:17]
  assign ComplexAdd_io_op2_re = io_in2_re; // @[Butterfly.scala 28:17]
  assign ComplexAdd_io_op2_im = io_in2_im; // @[Butterfly.scala 28:17]
  assign ComplexSub_io_op1_re = io_in1_re; // @[Butterfly.scala 41:17]
  assign ComplexSub_io_op1_im = io_in1_im; // @[Butterfly.scala 41:17]
  assign ComplexSub_io_op2_re = io_in2_re; // @[Butterfly.scala 42:17]
  assign ComplexSub_io_op2_im = io_in2_im; // @[Butterfly.scala 42:17]
  assign ComplexMul_io_op1_re = ComplexSub_io_res_re; // @[Butterfly.scala 64:17]
  assign ComplexMul_io_op1_im = ComplexSub_io_res_im; // @[Butterfly.scala 64:17]
  assign ComplexMul_io_op2_re = io_wn_re; // @[Butterfly.scala 65:17]
  assign ComplexMul_io_op2_im = io_wn_im; // @[Butterfly.scala 65:17]
endmodule
