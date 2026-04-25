`timescale 1ns / 1ps
import defs::*;

/// 0b0000 Addition
/// 0b0001 Subtraction
/// 0b0010 And
/// 0b0011 Or
/// 0b0100 Xor
/// 0b0101 Equal
/// 0b0110 lessThan
/// 0b0111 lessSignedThan
/// 0b1000 greaterThan
/// 0b1001 greaterSignedThan
/// 0b1010 logical left shift
/// 0b1011 arithme left shift
/// 0b1100 logical right shift
/// 0b1101 arithme right shift

module alu(
  input aluop_t op,
  input logic [31:0]in1,
  input logic [31:0]in2,
  output logic [31:0]out
  );


  // MUL    = SS
  // MULH   = SS
  // MULHU  = UU
  // MULHSU = SU

  /*
  wire [31:0]ext1;
  wire [31:0]ext2;
  assign ext1 = (op == ALU_MULHU) ? 32'h0 : in1[31];
  assign ext2 = (op == ALU_MULHU || op == ALU_MULHSU) ? 32'h0 : in2[31];
  logic signed [63:0]mul;
  assign mul = $signed({ext1, in1}) * $signed({ext2, in2});
  */

  always_comb begin
    case (op)
      ALU_ADD: out = in1 + in2;
      ALU_SUB: out = in1 - in2;
      ALU_AND: out = in1 & in2;
      ALU_OR : out = in1 | in2;
      ALU_XOR: out = in1 ^ in2;
      ALU_EQN: out = {31'h0, in1 == in2};
      ALU_LT : out = {31'h0, $signed(in1) < $signed(in2)};
      ALU_LTU: out = {31'h0, in1 < in2};
      ALU_GT : out = {31'h0, $signed(in1) > $signed(in2)};
      ALU_GTU: out = {31'h0, in1 > in2};
      ALU_SLL: out = in1 << in2[4:0];
      ALU_SLR: out = in1 >> in2[4:0];
      ALU_SAR: out = $unsigned($signed(in1) >>> $signed(in2[4:0]));
      /*
      ALU_MUL: out = mul[31:0];
      ALU_MULH: out = mul[63:32];
      ALU_MULHU: out = mul[63:32];
      ALU_MULHSU: out = mul[63:32];
      ALU_DIV: out = $unsigned($signed(in1) / $signed(in2));
      ALU_DIVU: out = in1 / in2;
      ALU_REM: out = $unsigned($signed(in1) % $signed(in2));
      ALU_REMU: out = in1 % in2;*/
      default: out = 32'hXXXX;
    endcase
  end

endmodule

