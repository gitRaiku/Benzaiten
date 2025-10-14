`timescale 1ns / 1ps
import defs::*;

module instructionDecoder(
  input logic [31:0]instr,
  output logic [6:0]op,
  output logic [9:0]func,
  output logic [4:0]rs1,
  output logic [4:0]rs2,
  output logic [4:0]rd,
  output logic [31:0]imm,
  output logic [1:0]oplen,
  output instype_t instrType
  );

  /*
    * 000 R-Type (Register / Register)
    * funct = {[31:25], [14:12]}
    * rs2 = [24:20]
    * rs1 = [19:15]
    * rd  = [11:7]
    *
    * 001 I-Type (Immediate)
    * funct = [14:12]
    * imm   = [31:20]
    * rs1   = [19:15]
    * rd    = [11:7]
    *
    * 011 S-Type (Store)
    * imm   = {[31:25], [11:7]}
    * rs2 = [24:20]
    * rs1 = [19:15]
    * funct = [14:12]
    *
    * 100 B-Type (Branch)
    * imm   = {[30:25], [11:8]}
    * rs2 = [24:20]
    * rs1 = [19:15]
    * funct = [14:12]
    *
    * 010 U-Type (Upper Imm)
    * imm   = [31:12]
    * rd    = [11:7]
    *
    * 110 J-Type (Branch)
    * imm = {[31], [19:12], [20], [30:21], 0}
    * rd  = [11:7]
    *
  */

  assign op = instr[6:0];
  always_comb begin
    case (op)
      7'b00100_11: instrType = INS_I;
      7'b01100_11: instrType = INS_R;
      7'b01101_11: instrType = INS_U;
      7'b11011_11: instrType = INS_J;
      7'b11001_11: instrType = INS_I;
      7'b11000_11: instrType = INS_B;
      7'b00000_11: instrType = INS_I;
      7'b01000_11: instrType = INS_S;
      7'b00101_11: instrType = INS_U;
      default: instrType = INS_INVALID;
    endcase
  end
  assign func = {instr[31:25], instr[14:12]};
  assign rs1 = instr[19:15];
  assign rs2 = instr[24:20];
  assign rd = instr[11:7];

  logic [31:0]simm;
  logic immU;
  always_comb begin
    case (instrType)
      INS_R: begin
        simm = 12'hZZ; immU = 1'b0;
      end
      INS_I: begin
        simm = {19'h0000, instr[31], instr[31:20]}; immU = 1'b0;
      end
      INS_S: begin
        simm = {19'h0000,instr[31], instr[31:25], instr[11:7]}; immU = 1'b0;
      end
      INS_B: begin
        simm = {19'h0000,instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; immU = 1'b0;
      end
      INS_U: begin
        simm = {instr[31:12], {12{1'b0}}}; immU = 1'b1;
      end
      INS_J: begin
        simm = {{13{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}; immU = 1'b1;
      end
      default: begin
        simm = 32'hZZ; immU = 1'b0;
      end
    endcase
  end
  extender exte(.num(simm), .immU(immU), .out(imm));

  always_comb begin
    if (instrType == INS_S) begin /// TODO: Pretty
      case (func[2:0])
        3'b000: oplen = 2'h0;
        3'b001: oplen = 2'h1;
        3'b010: oplen = 2'h3;
        default: oplen = 2'h0;
      endcase
    end else if (instrType == INS_I && op == 7'b00000_11) begin
      case (func[2:0])
        3'b000: oplen = 2'h0;
        3'b001: oplen = 2'h1;
        3'b010: oplen = 2'h3;
        default: oplen = 2'h0;
      endcase
    end else begin
      oplen = 3'h0;
    end
  end

endmodule

