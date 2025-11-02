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

logic ram_enable, ram_valid;
logic [24:0]ram_addr, ram_writeEnable;
logic [31:0]ram_data;
logic [31:0]ram_result;
sdram ram(
  .clk(clk),           .rst_n(rst_n),
  .enable(ram_enable), .valid(ram_valid),
  .addr(ram_addr),     .writeEnable(ram_writeEnable),
  .data(ram_data),     .result(ram_result),
  .s_clk(s_clk),       .s_cs_n(s_cs_n),
  .s_ras_n(s_ras_n),   .s_cas_n(s_cas_n),
  .s_we_n(s_we_n),     .s_cke(s_cke),
  .s_dqm(s_dqm),       .s_addr(s_addr),
  .s_bs(s_bs),         .s_dq(s_dq));

logic [15:0]instr_read_delay;
logic [15:0]data_read_delay;

logic [31:0]ops[30];
logic [31:0]shittyram[100];

sdramstate_t state;
logic [1:0]bankSelect;
logic [12:0]rowSelect;
logic [8:0]columnSelect;
logic [15:0]dqSelect;
logic [15:0]readResult;

always_ff @(posedge clk) begin
  if (!rst_n) begin
ops[0] <= 32'h00100093;
ops[1] <= 32'h00100113;
ops[2] <= 32'h00000513;
ops[3] <= 32'h02000593;
ops[4] <= 32'h00450513;
ops[5] <= 32'h002081b3;
ops[6] <= 32'h00010093;
ops[7] <= 32'h00018113;
ops[8] <= 32'h00152023;
ops[9] <= 32'hfeb516e3;

    instr_valid <= 1'b0;
    instr_read_delay <= 16'h00;
    data_valid <= 1'b0;
    data_read_delay <= 16'h00;
  end else begin
    // TODO: Handle non aligned reads
    data_valid <= 1'b0;
    instr_valid <= 1'b0;
    if (data_enable && !data_valid && data_read_delay == 16'h00) begin
      if (data_rw) begin
        unique case (data_oplen)
          2'b00: shittyram[data_addr >> 2][7:0] <= data_wdata[7:0];
          2'b01: shittyram[data_addr >> 2][15:0] <= data_wdata[15:0];
          2'b10: shittyram[data_addr >> 2][23:0] <= data_wdata[23:0];
          2'b11: shittyram[data_addr >> 2][31:0] <= data_wdata[31:0];
        endcase
      end else begin
        unique case (data_oplen)
          2'b00:internal_data_result <= {24'h0000, shittyram[data_addr >> 2][7:0]};
          2'b01:internal_data_result <= {16'h0000, shittyram[data_addr >> 2][15:0]};
          2'b10:internal_data_result <= {8'h0000, shittyram[data_addr >> 2][23:0]};
          2'b11:internal_data_result <= {shittyram[data_addr >> 2][31:0]};
        endcase
      end
      data_read_delay <= 8;
    end else if (data_read_delay > 0) begin
      data_valid <= 1'b0;
      data_read_delay <= data_read_delay - 1;
      if (data_read_delay == 1) begin
        data_valid <= 1'b1;
        if (instr_enable) begin instr_valid <= 1'b0; end
      end
    end else if (instr_enable && !instr_valid && instr_read_delay == 16'h00) begin
      if ((instr_addr >> 2) > 18) begin $stop(); end
      instr_result <= {ops[instr_addr >> 2][31:0]};
      instr_read_delay <= 8;
      instr_valid <= 1'b0;
    end else if (instr_read_delay > 0) begin
      instr_valid <= 1'b0;
      instr_read_delay <= instr_read_delay - 1;
      if (instr_read_delay == 1) begin
        instr_valid <= 1'b1;
      end
    end
  end
end

endmodule
