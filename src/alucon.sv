`timescale 1ns / 1ps
import defs::*;

module alucon(
  input logic clk, rst_n,
  input logic [6:0]op, [9:0]func,
  input instype itype,
  input logic [31:0]rf1, 
  input logic [31:0]rf2,
  input logic [31:0]imm,
  output logic [31:0]writeback
  );

  aluop caluhop;
  logic [31:0]op1;
  logic [31:0]op2;
  alu calu(caluhop, op1, op2, writeback);

  always_comb begin
    case (itype)
      INS_R: begin
        op1 <= rf1; 
        op2 <= rf2;
      end
      INS_I: begin
        op1 <= rf1; 
        op2 <= imm;
      end
      default: begin
        op1 <= 32'hZZZZ; 
        op2 <= 32'hZZZZ;
      end
    endcase
  end

  always_comb begin
    case (op)
      7'b0010011:
        case (func)
          9'b000: caluhop <= ALU_ADD;
          9'b010: caluhop <= ALU_SLT;
          9'b010: caluhop <= ALU_LT;
          9'b010: caluhop <= ALU_LT;
          9'b111: caluhop <= ALU_AND;
          9'b110: caluhop <= ALU_OR;
          9'b100: caluhop <= ALU_XOR;
          9'b001: caluhop <= ALU_SLL; /// TODO CHECK
          9'b101: caluhop <= ALU_SAL;
        endcase
      7'b0110011:
        case (func)
          9'b000: caluhop <= ALU_ADD;
          9'b0100000_000: caluhop <= ALU_SUB;
          9'b010: caluhop <= ALU_SLT;
          9'b010: caluhop <= ALU_LT;
          9'b010: caluhop <= ALU_LT;
          9'b111: caluhop <= ALU_AND;
          9'b110: caluhop <= ALU_OR;
          9'b100: caluhop <= ALU_XOR;
          9'b001: caluhop <= ALU_SLL;
          9'b101: caluhop <= ALU_SAL;
        endcase
    endcase
  end

endmodule
