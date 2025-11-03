`timescale 1ns / 1ps

module sdramController(
  input logic clk, rst_n,
  input  logic        instr_enable,
  output logic        instr_valid,
  input  logic [24:0] instr_addr,
  output logic [31:0] instr_result,

  input  logic         data_enable,
  output logic         data_valid,
  input logic  [1:0]   data_oplen,
  input logic          data_unsigned,
  input logic  [24:0]  data_addr,
  input logic  [31:0]  data_wdata,
  input logic          data_rw,
  output logic [31:0]  data_result,

  output logic        s_clk,   output logic        s_cs_n,
  output logic        s_ras_n, output logic        s_cas_n,
  output logic        s_we_n,  output logic        s_cke,
  output logic [1:0]  s_dqm,   output logic [12:0] s_addr,
  output logic [1:0]  s_bs,    inout  logic [15:0] s_dq
);

module sextender_m(input logic [31:0]in, input logic usgn,
                 input logic [1:0]len, output logic [31:0]out);
  always_comb begin
    if (usgn) begin
      unique case (len)
        2'b00: out = { {24{1'b0}}, in[7:0] } ;
        2'b01: out = { {24{1'b0}}, in[15:0] } ;
        2'b10: out = { {24{1'b0}}, in[23:0] } ;
        2'b11: out = { in[31:0] } ;
      endcase
    end else begin
      unique case (len)
        2'b00: out = { {24{in[7]}}, in[7:0] } ;
        2'b01: out = { {24{in[15]}}, in[15:0] } ;
        2'b10: out = { {24{in[23]}}, in[23:0] } ;
        2'b11: out = { in[31:0] } ;
      endcase
    end
  end
endmodule

assign s_clk = clk;

logic [31:0]internal_data_result;
sextender_m sextender(
  .in(internal_data_result), .usgn(data_unsigned),
  .len(data_oplen), .out(data_result));

logic ram_enable, ram_valid, ram_oplen;
logic [24:0]ram_addr, ram_writeEnable;
logic [31:0]ram_data;
logic [31:0]ram_result;
sdram ram(
  .clk(clk),           .rst_n(rst_n),
  .enable(ram_enable), .valid(ram_valid),
  .addr(ram_addr),
  .oplen(ram_oplen),   .writeEnable(ram_writeEnable),
  .data(ram_data),     .result(ram_result),
  .s_clk(s_clk),       .s_cs_n(s_cs_n),
  .s_ras_n(s_ras_n),   .s_cas_n(s_cas_n),
  .s_we_n(s_we_n),     .s_cke(s_cke),
  .s_dqm(s_dqm),       .s_addr(s_addr),
  .s_bs(s_bs),         .s_dq(s_dq));

logic iram_enable, iram_valid;
logic [24:0]iram_addr;
logic [ 1:0]iram_oplen, iram_writeEnable;
logic [31:0]iram_data;
logic [31:0]iram_result;
internalRam iram(
  .clk(clk), .rst_n(rst_n),
  .enable(iram_enable), .valid(iram_valid),
  .addr(iram_addr), .oplen(iram_oplen), .writeEnable(iram_writeEnable),
  .data(iram_data), .result(iram_result));

logic [1:0]instr_source;
assign instr_valid = (instr_source == 0) ? iram_valid : ram_valid;
assign instr_result = (instr_source == 0) ? iram_result : ram_result;
logic [1:0]data_source;
assign data_valid = (data_source == 0) ? iram_valid : ram_valid;
assign data_result = (data_source == 0) ? iram_result : ram_result;

always_ff @(posedge clk) begin
  if (!rst_n) begin
    instr_valid <= 0;
    data_valid <= 0;
  end else begin
    instr_valid <= 0;
    data_valid <= 0;
    if (instr_enable && !instr_valid) begin
      iram_enable <= 1;
      iram_addr <= instr_addr;
      iram_oplen <= 3;
      instr_source <= 0;
    end else if (instr_enable && instr_valid) begin
      iram_enable <= 0;
    end
  end
end

endmodule
