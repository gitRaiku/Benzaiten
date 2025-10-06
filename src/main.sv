`timescale 1ns / 1ps

// inout io_sd_dat0, io_sd_dat1, io_sd_dat2, io_sd_dat3, io_sd_cmd, io_sd_clk,
module main(
  input logic clk_50_in, rst_n, button_1_n,
  output led_1_n, led_2_n,

  output clk_out, rst_n_out, led_1_n_out, clk_out_true,

  output s_clk, s_cs_n, s_ras_n, s_cas_n, s_we_n, s_cke,
  output [1:0]s_dqm,
  output [1:0]s_bs,
  output [12:0]s_addr,
  inout  [15:0] s_dq
  );

  logic clk_locked;
  logic clk_10, clk_50, clk_100;
  clk_wiz_1 clankka(.clk_out1(clk_50), .clk_out2(clk_100), .clk_out3(clk_10), .locked(clk_locked),
                    .resetn(rst_n), .clk_in1(clk_50_in));
  assign clk_out = clk_50;

  logic [31:0]addr;


  assign led_2_n = !addr[25];

  assign led_1_n_out = led_1_n;
  assign rst_n_out = rst_n;
  assign clk_out_true = clk_50;

  always_ff @(posedge clk_50) begin
    if (!rst_n) begin
      addr <= 32'h0000;
    end else begin
      if (button_1_n) begin
        addr <= addr + 1;
      end
    end
  end

  logic [24:0]sd_addr;
  logic [ 1:0]sd_oplen;
  logic [31:0]sd_wdata;
  logic [31:0]sd_result;
  logic sd_rw;
  logic sd_enable;

  always_ff @(posedge clk_50) begin
    sd_addr <= 0;
    sd_oplen <= 1;
    sd_wdata <= 0;
    sd_rw <= 0;
    sd_enable <= 1;
  end

  assign s_clk = clk_50;
  sdramController sukondez(
    .clk(s_clk),
    .rst_n(rst_n),
    .addr(sd_addr),
    .oplen(sd_oplen),
    .wdata(sd_wdata),
    .rw(sd_rw),
    .enable(sd_enable),
    .result(sd_result),
    .s_cs_n(s_cs_n),
    .s_ras_n(s_ras_n),
    .s_cas_n(s_cas_n),
    .s_we_n(s_we_n),
    .s_cke(s_cke),
    .s_dqm(s_dqm),
    .s_addr(s_addr),
    .s_bs(s_bs),
    .s_dq(s_dq)
    );

  assign led_1_n = !(sd_result == 16'h00be);

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

endmodule
