`timescale 1ns / 1ps

module ram(
  input logic clk, rst_n,
  input logic [31:0]address,
  input logic [31:0]data,
  input logic writeLen,
  output logic [31:0]out
  );

  reg [7:0]data[200];

  always @(negedge clk) begin
    if (writeLen > 3) data[address + 3] < data[31:24];
    if (writeLen > 2) data[address + 2] < data[23:16];
    if (writeLen > 1) data[address + 1] < data[15:8];
    if (writeLen > 0) data[address + 0] < data[7:0];
  end

  always_comb begin
    case (address) 
      0: out <= 32'b0000000_00000_00000_000_00000_0110011; /// NOP
      4: out <= 32'b0000000_00000_00000_000_00000_0110011; /// NOP
      8: out <= 32'b0000000_00000_00000_000_00000_0110011; /// NOP
     12: out <= 32'b000000000001_00010_000_00010_0010011 ; /// x2 = 0 + 1
     16: out <= 32'b000000100001_00000_000_00001_0010011 ; /// x1 = 0 + 100001
     20: out <= 32'b1111111_00001_00010_010_11111_0100011; /// sw x1, (-1)x2
     24: out <= 32'b000000000010_00011_000_00011_0010011 ; /// x3 = 0 + 2
     28: out <= 32'b0000000_00011_00010_100_00010_0110011; /// x2 = x2 ^ x3
     32: out <= 32'b0000000_00011_00010_100_00011_0110011; /// x3 = x2 ^ x3
     36: out <= 32'b0000000_00011_00010_100_00010_0110011; /// x2 = x2 ^ x3
     40: $stop; 
     default: out <= 32'hZZZZ;
    endcase
  end

endmodule
