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
  input aluop op,
  input logic [31:0]in1,
  input logic [31:0]in2,
  output logic [31:0]out
  );
  aluop temp;
    
  logic [31:0]result;
  assign out = result;
  always_comb begin
    case(op)
      ALU_ADD: result <= in1 + in2;
      ALU_SUB: result <= in1 - in2;
      ALU_AND: result <= in1 & in2;
      ALU_OR : result <= in1 | in2;
      ALU_XOR: result <= in1 ^ in2;
      ALU_EQN: result <= in1 == in2;
      ALU_LT : result <= in1 < in2;
      ALU_SLT: result <= $signed(in1) < $signed(in2);
      /*
      ALU_GT: result <= in1 in2;
      ALU_SGT: result <= in1 in2;
      ALU_SLL: result <= in1 in2;
      ALU_SAL: result <= in1 in2;
      ALU_SLR: result <= in1 in2;
      ALU_SAR: result <= in1 in2;
      */
      default: result <= 32'hXXXX;
    endcase
  end

endmodule
