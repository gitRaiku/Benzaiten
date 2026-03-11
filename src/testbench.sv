`timescale 1ns / 1ps

module testbench();
  logic clk;
  logic rst;

  /*
  main pula(
  .clk_50_in(clk),
  .rst_n_in(1'b1));
  */
  logic [31:0]cache_addr, cache_in;
  logic [31:0]cache_out;
  logic cache_rw, cache_enable;
  logic cache_overwrite, cache_valid;
  memcache cache(
    .clk(clk), .rst(rst),
    .addr(cache_addr), .in(cache_in),
    .rw(cache_rw), .enable(cache_enable), 
    .overwrite(cache_overwrite), .valid(cache_valid),
    .out(cache_out)
    );

  task automatic pula; input logic [31:0]addr; input overwrite; input logic [31:0]in;
    #10;
    cache_addr <= addr;
    cache_in <= in;
    cache_overwrite <= overwrite;
    cache_rw <= 1;
    cache_enable <= 1;
    #1;
  endtask

  task automatic pzda; input logic [31:0]addr;
    #10;
    cache_addr <= addr;
    cache_overwrite <= 0;
    cache_rw <= 0;
    cache_enable <= 1;
    #1;
  endtask

  initial begin
    clk <= 0;
    rst <= 1;
    #10;
    rst <= 0;
    #30;
    pula(32'h001000, 1, 32'h1);
    pula(32'h001200, 1, 32'h2);
    pula(32'h011200, 1, 32'h3);
    pula(32'h021200, 1, 32'h4);
    pula(32'h031200, 1, 32'h5);
    pula(32'h041200, 1, 32'h6);
    pula(32'h051200, 1, 32'h7);
    pula(32'h061200, 1, 32'h8);
    pula(32'h071200, 1, 32'h9);
    pula(32'h081200, 1, 32'h10);
    pula(32'h091200, 1, 32'h11);
    pula(32'h101200, 1, 32'h12);
    pzda(32'h101200);
    pzda(32'h091200);
    pzda(32'h081200);
    pzda(32'h071200);
    pzda(32'h061200);
    pzda(32'h051200);
    pzda(32'h041200);
    pzda(32'h031200);
    pzda(32'h021200);
    pzda(32'h011200);
    pzda(32'h001200);
    pzda(32'h001000);






    pula(32'h101200, 1, 32'h3);
    pula(32'h101200, 1, 32'h3);
    pula(32'h101400, 1, 32'h4);
    pula(32'h101800, 1, 32'h5);
    pula(32'h111800, 1, 32'h6);
    pzda(32'h111800);
    pzda(32'h101800);
    pzda(32'h101400);
    pzda(32'h101200);
    pzda(32'h001200);
    pzda(32'h001000);






    pula(32'h001000, 1, 32'hdeadbeef);
    pula(32'h001000, 1, 32'hdeadbeef);
    pula(32'h001001, 1, 32'hdeadbeef);
    pula(32'h001002, 1, 32'hdeadbeef);
    pula(32'h001003, 1, 32'hdeadbeef);
    pula(32'h001100, 1, 32'hdeadbeef);
    pula(32'h001101, 1, 32'hdeadbeef);
    pula(32'h001103, 1, 32'hdeadbeef);
    pula(32'h001114, 1, 32'hdeadbeef);
    pula(32'h001200, 1, 32'hdeadbeef);
    pula(32'h001300, 1, 32'hdeadbeef);
    pula(32'h010000, 1, 32'hdeadbeef);
    pula(32'h010100, 1, 32'hdeadbeef);
    pula(32'h010200, 1, 32'hdeadbeef);
    pula(32'h010300, 1, 32'hdeadbeef);
    pula(32'h010300, 1, 32'hdeadbeef);
    pula(32'h011000, 1, 32'hdeadbeef);
    pula(32'h021000, 1, 32'hdeadbeef);
    pula(32'h031000, 1, 32'hdeadbeef);
    pula(32'h041000, 1, 32'hdeadbeef);
    pula(32'h051000, 1, 32'hdeadbeef);
    pula(32'h061000, 1, 32'hdeadbeef);
    pula(32'h071000, 1, 32'hdeadbeef);
    pula(32'h081000, 1, 32'hdeadbeef);
    pula(32'h091000, 1, 32'hdeadbeef);
    pula(32'h101000, 1, 32'hdeadbeef);
    pzda(32'h0010);
    pzda(32'h0010);
    pzda(32'h0010);
    pzda(32'h1030);
    pzda(32'h0010);
    pzda(32'h0010);
  end

  always begin
    clk <= 0;
    #2;
    clk <= 1;
    #2;
  end

endmodule
