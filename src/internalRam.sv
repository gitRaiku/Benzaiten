`timescale 1ns / 1ps

module internalRam(
  input logic clk, rst,
  input logic enable, output logic valid,
  input logic [31:0]addr,
  input logic [1:0]oplen, input logic we,   /// TODO: Add input logic for non 8-bit values
  input logic [31:0]data, output logic [31:0]result, /// TODO: Currently top 8-bits for every cell
  output logic [15:0]gpio
  );

  // TODO: Make the ram actually use the correct fabric
  (* ram_style = "block" *) logic [31:0]ram[300]; /// TODO: Fix

  initial begin
    $readmemh("ram.mem", ram);
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      valid <= 0;
      result <= 0;
      gpio <= 0;
    end else begin
      valid <= 0;
      if (enable) begin
        if (addr == 32'hFFFFFFFF) begin
          if (we) begin
            gpio <= data[15:0];
          end else begin
            result <= {16'h0000, gpio};
          end
        end else begin
          result <= ram[addr >> 2];
        end
        valid <= 1;
      end
    end
  end


endmodule
