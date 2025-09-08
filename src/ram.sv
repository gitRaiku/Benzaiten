`timescale 1ns / 1ps

module ram(
  input logic clk, rst_n,
  input logic [31:0]addr,
  input logic [31:0]val,
  input logic rw,
  output logic [31:0]res
  );

  logic [31:0]ram;

  always_ff @(negedge rst_n or posedge clk) begin
    if (!rst_n) begin
      ram <= 32'hbeef;
    end else begin
      if (rw) begin
        res <= ram;
      end else begin
        ram <= val;
      end
    end
  end

endmodule
