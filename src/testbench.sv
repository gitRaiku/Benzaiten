`timescale 1ns / 1ps

module testbench();
  logic clk, rst_n;
  logic led_1;

  main pula(
  .clk_50_in(clk),
  .rst_n(rst_n));

  initial begin
    clk <= 0;
    rst_n <= 0;
    #5;
    rst_n <= 1;
  end

  always begin
    clk <= 0;
    #2;
    clk <= 1;
    #2;
  end

endmodule
