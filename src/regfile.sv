`timescale 1ns / 1ps

module regfile(
  input logic clk, rst_n,
  input logic write_enabled,
  input logic [4:0]rs1,
  input logic [4:0]rs2,
  input logic [4:0]rd,
  input logic [31:0]data,
  output logic [31:0]res1,
  output logic [31:0]res2
  );

  logic [31:0]memory[32];
  always_comb begin
    res1 = memory[rs1];
    res2 = memory[rs2];
  end

  always @(posedge clk) begin
    if (!rst_n) begin
      int i;
      for (i = 0; i < 32; i = i + 1) begin
        memory[i] <= 32'h0000;
      end
    end else if (write_enabled && rd != 0) begin
      memory[rd] <= data;
    end
  end


endmodule
