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

  always_comb begin
    case (op)
      ALU_ADD: out = in1 + in2;
      ALU_SUB: out = in1 - in2;
      ALU_AND: out = in1 & in2;
      ALU_OR : out = in1 | in2;
      ALU_XOR: out = in1 ^ in2;
      ALU_EQN: out = in1 == in2;
      ALU_LT : out = $signed(in1) < $signed(in2);
      ALU_LTU: out = in1 < in2;
      ALU_GT : out = $signed(in1) > $signed(in2);
      ALU_GTU: out = in1 > in2;
      ALU_SLL: out = in1 << in2[4:0];
      ALU_SLR: out = in1 >> in2[4:0];
      ALU_SAR: out = $signed(in1) >>> $signed(in2[4:0]);
      default: out = 32'hXXXX;
    endcase
  end

endmodule

