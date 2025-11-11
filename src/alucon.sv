`timescale 1ns / 1ps
import defs::*;

module alucon(
  input logic [6:0]op,
  input logic [9:0]func,
  input logic [31:0]pc,
  input instype_t itype,
  input logic [31:0]rf1,
  input logic [31:0]rf2,
  input logic [31:0]imm,
  output logic [31:0]result
  );

  aluop_t aluop;
  logic [31:0]op1;
  logic [31:0]op2;
  alu calu(.op(aluop), .in1(op1),
           .in2(op2), .out(result));

  always_comb begin
    case (itype)
      INS_R, INS_B: begin
        op1 = rf1;
        op2 = rf2;
      end
      INS_I: begin
        op1 = rf1;
        op2 = imm;
      end
      INS_S: begin
        op1 = rf1;
        op2 = imm;
      end
      INS_U: begin
        if (op == 7'b00101_11) begin /// AUIPC
          op1 = pc;
        end else begin
          op1 = 32'h0000;
        end
        op2 = imm;
      end
      INS_J: begin
        op1 = 32'h0000;
        op2 = 32'h0000;
      end
      default: begin
        op1 = 32'hZZZZ;
        op2 = 32'hZZZZ;
      end
    endcase
  end

  always_comb begin
    case (op)
      7'b00100_11:
        if (func[1:0] == 2'b01) begin
          case (func)
            9'b000000_001: aluop = ALU_SLL;
            9'b000000_101: aluop = ALU_SLR;
            9'b010000_101: aluop = ALU_SAR;
            default: aluop = ALU_INVALID;
          endcase
        end else begin
          case (func[2:0])
            3'b000: aluop = ALU_ADD;
            3'b010: aluop = ALU_LT;
            3'b011: aluop = ALU_LTU;
            3'b111: aluop = ALU_AND;
            3'b110: aluop = ALU_OR;
            3'b100: aluop = ALU_XOR;
            default: aluop = ALU_INVALID;
          endcase
        end
      7'b01100_11:
        case (func)
          9'b000000_000: aluop = ALU_ADD;
          9'b100000_000: aluop = ALU_SUB;
          9'b000000_010: aluop = ALU_LT;
          9'b000000_011: aluop = ALU_LTU;
          9'b000000_111: aluop = ALU_AND;
          9'b000000_110: aluop = ALU_OR;
          9'b000000_100: aluop = ALU_XOR;
          9'b000000_001: aluop = ALU_SLL;
          9'b000000_101: aluop = ALU_SLR;
          9'b010000_101: aluop = ALU_SAR;
          default: aluop = ALU_INVALID;
        endcase
      7'b11000_11:
        case (func[2:0])
          3'b000,3'b001: aluop = ALU_EQN;
          3'b100,3'b101: aluop = ALU_LT;
          3'b110,3'b111: aluop = ALU_LTU;
          default: aluop = ALU_INVALID;
        endcase
      default: aluop = ALU_ADD;
    endcase
  end

endmodule
