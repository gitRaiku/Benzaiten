`timescale 1ns / 1ps

module testbench();
  logic clk;
  logic rst;

  main pula(
  .clk_50_in(clk),
  .rst_n_in(1'b1));

  initial begin
    clk <= 0;
    rst <= 1;
    #10;
    rst <= 0;
  end

  always begin
    clk <= 0;
    #2;
    clk <= 1;
    #2;
  end

endmodule
