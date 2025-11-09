`timescale 1ns / 1ps

module regfile(
  input logic clk, rst,
  input logic write_enabled,
  input logic [4:0]rs1,
  input logic [4:0]rs2,
  input logic [4:0]rd,
  input logic [31:0]data,
  output logic [31:0]res1,
  output logic [31:0]res2
  );

  /// TODO: See if you can use a better primitive than registers for this
  (* ram_style = "distributed" *) logic [31:0]memory1[32];
  (* ram_style = "distributed" *) logic [31:0]memory2[32];
  assign res1 = memory1[rs1];
  assign res2 = memory2[rs2];

  logic [7:0]cpos;

  always @(posedge clk) begin
    if (rst) begin
      cpos <= 0;
    end else begin
      if (cpos != 32) begin
        memory1[cpos] <= 32'h00000000;
        memory2[cpos] <= 32'h00000000;
        cpos <= cpos + 1;
      end else if (write_enabled && rd != 0) begin
        memory1[rd] <= data;
        memory2[rd] <= data;
      end
    end
  end


endmodule
