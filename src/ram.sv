`timescale 1ns / 1ps

module ram(
  input logic clk, rst_n,
  input logic [31:0]addr,
  input logic readWrite, /// 0 = read 1 = write
  input logic [2:0]oplen,
  input logic [31:0]writeData,
  output logic [31:0]out
  );

  reg [7:0]data[200];

  initial begin
    logic [31:0]ops[20];
    ops[0] <= 32'b0000000_00000_00000_000_00000_0110011; /// NOP
    ops[1] <= 32'b0000000_00000_00000_000_00000_0110011; /// NOP
    ops[2] <= 32'b0000000_00000_00000_000_00000_0110011; /// NOP
    ops[3] <= 32'b000000000001_00010_000_00010_0010011 ; /// x2 = 0 + 1
    ops[4] <= 32'b000000100001_00000_000_00001_0010011 ; /// x1 = 0 + 100001
    ops[5] <= 32'b1111111_00001_00010_010_11111_0100011; /// sw x1, (-1)x2
    ops[6] <= 32'b000000000010_00011_000_00011_0010011 ; /// x3 = 0 + 2
    ops[7] <= 32'b0000000_00011_00010_100_00010_0110011; /// x2 = x2 ^ x3
    ops[8] <= 32'b0000000_00011_00010_100_00011_0110011; /// x3 = x2 ^ x3
    ops[9] <= 32'b0000000_00011_00010_100_00010_0110011; /// x2 = x2 ^ x3

    integer i;
    for (i = 0; i < 10; i = i + 1) begin
      data[4 * i + 0] <= ops[i][31:24];
      data[4 * i + 1] <= ops[i][23:16];
      data[4 * i + 2] <= ops[i][15:8];
      data[4 * i + 3] <= ops[i][7:0];
    end
  end

  always @(edge oplen) begin
    if (readWrite && clk == 0) begin
      case (oplen)
        3'h4: begin
          data[addr + 3] <= writeData[7:0];
          data[addr + 2] <= writeData[15:8];
          data[addr + 1] <= writeData[23:16];
          data[addr + 0] <= writeData[31:24];
        end
        3'h3: begin
          data[addr + 2] <= writeData[7:0];
          data[addr + 1] <= writeData[15:8];
          data[addr + 0] <= writeData[23:16];
        end
        3'h2: begin
          data[addr + 1] <= writeData[7:0];
          data[addr + 0] <= writeData[15:8];
        end
        3'h1: begin
          data[addr + 0] <= writeData[7:0];
        end
        default: ;
      endcase
    end else begin
      case (oplen)
        3'h4: begin
          out[7:0] <= data[addr + 3];
          out[15:8] <= data[addr + 2];
          out[23:16] <= data[addr + 1];
          out[31:24] <= data[addr + 0];
        end
        3'h3: begin
          out[7:0] <= data[addr + 2];
          out[15:8] <= data[addr + 1];
          out[23:16] <= data[addr + 0];
        end
        3'h2: begin
          out[7:0] <= data[addr + 1];
          out[15:8] <= data[addr + 0];
        end
        3'h1: begin
          out[7:0] <= data[addr + 0];
        end
        default: out <= 32'h0000;
      endcase
    end
  end

endmodule
