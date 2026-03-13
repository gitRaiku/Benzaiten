`timescale 1ns / 1ps

module internalRam #(parameter GPIO_ADDR=32'hFFFFFFFF) (
  input logic clk, rst,
  input logic enable, output logic valid,
  input logic [31:0]addr,
  input logic [1:0]oplen, input logic we,   /// TODO: Add input logic for non 8-bit values
  input logic [31:0]in, output logic [31:0]out, /// TODO: Currently top 8-bits for every cell
  output logic [31:0]gpio
  );

  // TODO: Make the ram actually use the correct fabric
  (* ram_style = "block" *) logic [31:0]ram[512]; /// TODO: Fix

  initial begin
    $readmemh("ram.mem", ram);
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      valid <= 0;
      out <= 0;
      gpio <= 0;
    end else begin
      valid <= 0;
      if (enable) begin
        if (addr == GPIO_ADDR) begin
          if (we) begin
            gpio <= in;
          end else begin
            out <= gpio;
          end
        end else begin
          out <= ram[addr >> 2];
        end
        valid <= 1;
      end
    end
  end

  logic _unused_ok;
  assign _unused_ok = &oplen;

endmodule
