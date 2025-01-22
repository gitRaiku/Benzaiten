`timescale 1ns / 1ps
import defs::*;

module ramcon(
  input logic clk, rst_n,
  input logic [31:0]pc,
  input logic [31:0]aluaddress,
  input logic [31:0]outaddress,
  input logic [6:0]op, [2:0]func,
  input logic [2:0]opLen, 
  input logic [31:0]writeData,
  output logic [31:0]out
  );

  logic [31:0]inaddr;
  logic [2:0]rlen;
  logic rw;

  always_comb begin
    if (clk) begin
      case (op) 
        7'b00000_11: rw <= 1'b0;
        7'b01000_11: rw <= 1'b1;
        default: rw <= 1'b0;
      endcase
      inaddr <= aluaddress;
      rlen <= opLen;
    end else begin
      inaddr <= pc;
      rlen <= 3'h4;
    end
  end

  ram cram(clk, rst_n, inaddr, rw, rlen, writedata, out);

endmodule
