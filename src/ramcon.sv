`timescale 1ns / 1ps
import defs::*;

module ramcon(
  input logic clk, rst_n,
  input logic [31:0]pc,
  input logic [31:0]address,
  input logic [6:0]op,
  input logic [2:0]opLen, 
  input logic [31:0]writedata,
  output logic [31:0]out
  );

  logic [31:0]addr;
  logic [2:0]rlen;
  logic rw;

  /*
  always_comb begin
    if (pc == 32'h60) $stop;
  end
  */

  always_comb begin
    if (!rst_n) begin
      rlen <= 3'h4;
      rw <= 1'b0;
      addr <= 32'h0000;
    end else begin
      if (clk) begin
        case (op) 
          7'b00000_11: rw <= 1'b0;
          7'b01000_11: rw <= 1'b1;
          default: rw <= 1'b0;
        endcase
        rlen <= opLen;
        addr <= address;
      end else begin
        rw <= 1'b0;
        addr <= pc;
        rlen <= 3'h4;
      end
    end
  end

  ram cram(clk, rst_n, addr, rw, rlen, writedata, out);

endmodule
