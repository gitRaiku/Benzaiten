`timescale 1ns / 1ps

package defs;
typedef enum { INS_R, INS_I, INS_U, INS_S, INS_B } instype;
typedef enum { ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_XOR, ALU_EQN, ALU_LT, ALU_SLT, ALU_GT, ALU_SGT, ALU_SLL, ALU_SAL, ALU_SLR, ALU_SAR } aluop;

endpackage

module controller(input logic clk, rst_n);
  logic [31:0]instruction;
  logic write_enabled;
  logic [31:0]writeback;

  logic [31:0]rf1;
  logic [31:0]rf2;

  instrDecoder idec(instruction);

  regfile rf(clk, rst_n, 1, idec.rs1, idec.rs2, idec.rd, writeback, rf1, rf2);

  alucon acon(clk, rst_n, idec.op, idec.func, idec.instrType, rf1, rf2, idec.imm, writeback);

endmodule
