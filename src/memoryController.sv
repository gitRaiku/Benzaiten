`timescale 1ns / 1ps

module memoryController(
  input logic clk, rst,
  input  logic        instr_enable,
  output logic        instr_valid,
  input  logic [31:0] instr_addr,
  output logic [31:0] instr_result,

  input  logic         data_enable,
  output logic         data_valid,
  input logic  [1:0]   data_oplen,
  input logic          data_unsigned,
  input logic  [31:0]  data_addr,
  input logic  [31:0]  data_wdata,
  input logic          data_we,
  output logic [31:0]  data_result,

  output logic        s_clk,   output logic        s_cs_n,
  output logic        s_ras_n, output logic        s_cas_n,
  output logic        s_we_n,  output logic        s_cke,
  output logic [1:0]  s_dqm,   output logic [12:0] s_addr,
  output logic [1:0]  s_bs,    inout  logic [15:0] s_dq,
  output logic [15:0] gpio
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

logic [31:0]internal_data_result;
sextender_m sextender(
  .in(internal_data_result), .usgn(data_unsigned),
  .len(data_oplen), .out(data_result));

logic ram_enable, ram_valid, ram_we;
logic [1:0]ram_oplen;
logic [24:0]ram_addr;
logic [31:0]ram_data;
logic [31:0]ram_result;
sdram ram(
  .clk(clk),           .rst(rst),
  .enable(ram_enable), .valid(ram_valid),
  .addr(ram_addr),
  .oplen(ram_oplen),   .we(ram_we),
  .data(ram_data),     .result(ram_result),
  .s_clk(s_clk),       .s_cs_n(s_cs_n),
  .s_ras_n(s_ras_n),   .s_cas_n(s_cas_n),
  .s_we_n(s_we_n),     .s_cke(s_cke),
  .s_dqm(s_dqm),       .s_addr(s_addr),
  .s_bs(s_bs),         .s_dq(s_dq));

localparam logic [7:0]IMEM_LEN = 54;
localparam logic [7:0]IMEM_CUTOFF = 8'hFF;
logic iram_enable, iram_valid, iram_we;
logic [31:0]iram_addr;
logic [ 1:0]iram_oplen;
logic [31:0]iram_data;
logic [31:0]iram_result;
internalRam #(.MEM_LEN(IMEM_LEN)) iram(
  .clk(clk), .rst(rst),
  .enable(iram_enable), .valid(iram_valid),
  .addr(iram_addr), .oplen(iram_oplen), .we(iram_we),
  .data(iram_data), .result(iram_result), .gpio(gpio));

logic [1:0]instr_source;
assign instr_valid = (instr_source == 0) ? iram_valid : ram_valid;
assign instr_result = (instr_source == 0) ? iram_result : ram_result;
logic [1:0]data_source;
assign data_valid = (data_source == 0) ? iram_valid : ram_valid;
assign internal_data_result = (data_source == 0) ? iram_result : ram_result;

/// TODO: Learn secrets of hyperborea and write this code better
task automatic reset_values;
  begin
    instr_source <= 0;
    data_source <= 0;
    iram_enable <= 0;
    iram_addr <= 0;
    iram_data <= 0;
    iram_we <= 0;
    ram_enable <= 0;
    ram_addr <= 0;
    ram_data <= 0;
    ram_we <= 0;
  end
endtask
always_ff @(posedge clk) begin
  if (rst) begin
    reset_values;
  end else begin
    reset_values;
    if (instr_enable && !instr_valid) begin
      iram_enable <= 1;
      iram_addr <= instr_addr;
      iram_oplen <= 3;
      instr_source <= 0;
    end else if (data_enable && !data_valid) begin
      if (data_addr < IMEM_CUTOFF || data_addr == 32'hFFFFFFFF) begin
        iram_enable <= 1;
        iram_addr <= data_addr;
        iram_we <= data_we;
        iram_data <= data_wdata;
        iram_oplen <= data_oplen;
        data_source <= 0;
      end else begin
        ram_enable <= 1;
        ram_addr <= data_addr[31:8];
        ram_we <= data_we;
        ram_data <= data_wdata;
        ram_oplen <= data_oplen;
        data_source <= 1;
      end
  end
  end
end

endmodule
