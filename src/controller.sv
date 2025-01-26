`timescale 1ns / 1ps

package defs;
typedef enum { INS_R, INS_I, INS_S, INS_B, INS_U, INS_J, INS_INVALID } instype;
typedef enum { ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_XOR, ALU_EQN, ALU_LT, ALU_LTU, ALU_GT, ALU_GTU, ALU_SLL, ALU_SLR, ALU_SAR, ALU_INVALID } aluop;

endpackage

module controller(input logic clk, rst_n);
  logic [31:0]instruction;
  logic [31:0]pc;
  logic [31:0]pcnext;

  logic rfwe;
  logic [31:0]aluwb;
  logic [31:0]jumpLen;

  logic [31:0]rf1;
  logic [31:0]rf2;

  always @(edge clk or negedge rst_n) begin
    if (!rst_n) begin 
      pc <= 32'h0000;
      pcnext <= 32'h0000;
    end else if (clk) begin
      pcnext <= pc + jumpLen;
    end else if (!clk) begin
      pc <= pcnext;
    end
  end

  always_comb begin
    case (idec.op)
      7'b11001_11: jumpLen <= aluwb; // JALR
      7'b11011_11: jumpLen <= idec.imm; // JAL
      7'b11000_11: jumpLen <= (aluwb[0] != idec.func[0]) ? idec.imm : 32'h0004; // BXX
      default: jumpLen <= 32'h0004;
    endcase
  end

  logic [31:0]rfwb;
  always_comb begin
    if (!clk) begin
      instruction <= cram.out;
      rfwe <= 1'b0;
    end else begin
      case (idec.op) 
        7'b00000_11: begin
          rfwb <= cram.out;
          rfwe <= 1'b1;
        end
        7'b01000_11: rfwe <= 1'b0;
        7'b110?1_11: begin // JAL JALR
          rfwb <= pcnext;
          rfwe <= 1'b1;
        end
        default: begin
          rfwb <= aluwb;
          rfwe <= 1'b1;
        end
      endcase
    end
  end

  ramcon cram(clk, rst_n, pc, aluwb, idec.op, idec.writeLen, rf2);

  instrDecoder idec(instruction);

  regfile rf(clk, rst_n, rfwe, idec.rs1, idec.rs2, idec.rd, rfwb, rf1, rf2);

  alucon acon(clk, rst_n, idec.op, idec.func, pc, idec.instrType, rf1, rf2, idec.imm, aluwb);

endmodule
