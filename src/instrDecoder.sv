`timescale 1ns / 1ps
import defs::*;

//// TODO: COMPLETE

module instrDecoder(input logic [31:0]instr);
  logic [6:0]op;
  instype instrType;
  logic [9:0]func;
  logic [4:0]rs1;
  logic [4:0]rs2;
  logic [4:0]rd;
  logic [31:0]imm;

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
    * 010 U-Type (Upper Imm)
    * imm   = [31:12]
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
    * 101 B-Type (Branch)
    * imm = {[31], [7], [30:25], [11:8], 0}
    * rs2 = [24:20]
    * rs1 = [19:15]
    * funct = [14:12]
    *
    * 110 J-Type (Branch)
    * imm = {[31], [19:12], [20], [30:21], 0}
    * rd  = [11:7]
    *
  */

  assign op = instr[6:0]; 
  assign instrType = (op == 7'b0110011) ? INS_R : INS_I; /// TODO: Better logic
  always_comb begin
    case (instrType)
      INS_R: func <= {instr[31:25], instr[14:12]};
      INS_I: func <= {instr[14:12]};
      default: func <= 10'hZZ;
    endcase
  end
  assign rs1 = instr[19:15];
  assign rs2 = instr[24:20];
  assign rd = instr[11:7];

  logic [11:0]simm;

  always_comb begin
    case (instrType)
      INS_R: simm <= 12'hZZ;
      INS_I: simm <= instr[31:20];
      default: simm <= 12'hXX;
    endcase
  end
  /// TODO: Decode imm
  extender exte(simm, imm);

endmodule
