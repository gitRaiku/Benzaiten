`timescale 1ns / 1ps
import defs::*;

module alucon(
  input logic clk, rst_n,
  input logic [6:0]op, [9:0]func,
  input logic [31:0]pc, 
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
      INS_S: begin
        op1 <= rf1;
        op2 <= imm;
      end
      INS_U: begin
        if (op == 7'b00101_11) begin
          op1 <= pc;
        end else begin
          op1 <= 32'h0000;
        end
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
      7'b00100_11:
        case (func[2:0])
          3'b000: caluhop <= ALU_ADD;
          3'b010: caluhop <= ALU_SLT;
          3'b010: caluhop <= ALU_LT;
          3'b010: caluhop <= ALU_LT;
          3'b111: caluhop <= ALU_AND;
          3'b110: caluhop <= ALU_OR;
          3'b100: caluhop <= ALU_XOR;
          3'b001: caluhop <= ALU_SLL; /// TODO CHECK
          3'b101: caluhop <= ALU_SAL;
        endcase
      7'b01100_11:
        case (func)
          9'b0000000_000: caluhop <= ALU_ADD;
          9'b0100000_000: caluhop <= ALU_SUB;
          9'b0000000_010: caluhop <= ALU_SLT;
          9'b0000000_010: caluhop <= ALU_LT;
          9'b0000000_010: caluhop <= ALU_LT;
          9'b0000000_111: caluhop <= ALU_AND;
          9'b0000000_110: caluhop <= ALU_OR;
          9'b0000000_100: caluhop <= ALU_XOR;
          9'b0000000_001: caluhop <= ALU_SLL;
          9'b0000000_101: caluhop <= ALU_SAL;
        endcase
      7'b01000_11: caluhop <= ALU_ADD;
      7'b01101_11: caluhop <= ALU_ADD;
      7'b00101_11: caluhop <= ALU_ADD;
    endcase
  end

endmodule
