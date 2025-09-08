`timescale 1ns / 1ps

// inout io_sd_dat0, io_sd_dat1, io_sd_dat2, io_sd_dat3, io_sd_cmd, io_sd_clk,
module main(
  input logic clk, rst_n, button_1,
  output led_1, led_2,

  output clk_out, rst_n_out, led_1_out, clk_out_true
  );

  logic locked;

  clk_wiz_0 clankka(.clk_out1(clk_out), .reset(!rst_n), .locked(locked), .clk_in1(clk));

  logic [24:0]addr;

  assign led_1 = addr[10];
  assign led_2 = addr[16];

  assign led_1_out = led_1;
  assign rst_n_out = rst_n;
  assign clk_out_true = clk;

  always_ff @(negedge rst_n or posedge clk_out) begin
    if (!rst_n) begin
      addr <= 25'h0000;
    end else begin
      if (!button_1) begin
        addr <= addr + 4;
      end
    end
  end

  /*
  sdramController sukondez(
    .clk(clk),
    .rst_n(rst_n),
    .addr(addr),
    .oplen(),
    .wdata(),
    .rw(),
    .enable(),
    .s_address(),
    .s_bankselect(),
    .s_dq(),
    .s_cs(),
    .s_ras(),
    .s_cas(),
    .s_we(),
    .s_dqm(),
    .s_clk(),
    .s_cke());
    */


  /*
  logic [31:0]pc;
  logic [31:0]pcnext;
  logic [31:0]jumplen;

  logic [31:0]ramread;
  logic [6:0]iop;

  ram ram(
    .clk(clk), .rst_n(rst_n),
    .addr(pc), .val(32'h0000),
    .rw(1'b1), .res(ramread));

  assign led_1 = !ramread[0];
  always_ff @(negedge rst_n or posedge clk) begin
    if (!rst_n) begin
      pc <= 32'h0000;
      pcnext <= 32'h0000;
      jumplen <= 32'h0004;
    end else begin
      pcnext <= pc + jumplen;
      pc <= pcnext;
    end
  end

  instructionDecoder idec(.instr(ramread), .op(iop));
  */

endmodule
