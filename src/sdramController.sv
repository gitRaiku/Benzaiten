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

logic [31:0]internal_data_result;
sextender_m sextender(
  .in(internal_data_result), .usgn(data_unsigned),
  .len(data_oplen), .out(data_result));

assign s_clk = clk;

logic [3:0]startupStep;
logic [15:0]dq;
assign s_dq = dq;

logic [15:0]instr_read_delay;
logic [15:0]data_read_delay;

logic [31:0]ops[30];
logic [31:0]shittyram[100];
always_ff @(posedge clk) begin
  if (!rst_n) begin
    ops[ 0] <= 32'b0000000_00000_00000_000_00000_0110011; /// NOP
    ops[ 1] <= 32'b0000000_00000_00000_000_00000_0110011; /// NOP
    ops[ 2] <= 32'b0000000_00000_00000_000_00000_0110011; /// NOP

    ops[ 3] <= 32'b000000000110_00010_000_00010_0010011 ; /// x2 = x2 + 0x06
    ops[ 4] <= 32'b000000100001_00000_000_00001_0010011 ; /// x1 = x0 + 0x21
    ops[ 5] <= 32'b0000000_00000_00000_000_00000_0110011; /// NOP
    // ops[ 5] <= 32'b1111111_00001_00010_010_11111_0100011; /// sw x1, (-1)x2
    // ops[ 6] <= 32'b0000000_00000_00000_000_00000_0110011; /// NOP
    ops[ 6] <= 32'b111111111111_00010_010_00011_0000011 ; /// lw x3, (-1)x2
    ops[ 7] <= 32'b01010101010101010101_00100_0110111   ; /// x4 = 0x0101 << 12
    ops[ 8] <= 32'b010101010101_00100_000_00100_0010011 ; /// x4 = x0 + 0x01
    ops[ 9] <= 32'b01010101010101010101_00100_0010111   ; /// x4 = 0x0101 << 12 + pc
    ops[10] <= 32'b0000000_00011_00001_100_00001_0110011; /// x1 = x1 ^ x3
    ops[11] <= 32'b0000000_00011_00001_100_00011_0110011; /// x3 = x2 ^ x3
    ops[12] <= 32'b0000000_00011_00001_100_00001_0110011; /// x1 = x1 ^ x3
    ops[13] <= 32'b000000000000_00000_000_00001_0010011 ; /// x1 = 0
    ops[14] <= 32'b000000010000_00000_000_00010_0010011 ; /// x2 = 16
    ops[15] <= 32'b000000000001_00001_000_00001_0010011 ; /// x1 = x1 + 1
    ops[16] <= 32'b1111111_00010_00001_001_11001_1100011; /// bne x1, x2, -8
    ops[17] <= 32'b000000000000_00000_000_00001_0010011 ; /// x1 = 0
    ops[18] <= 32'b000000000000_00000_000_00001_0010011 ; /// x1 = 0
    ops[19] <= 32'b000000000000_00000_000_00001_0010011 ; /// x1 = 0
    ops[20] <= 32'b000000000000_00000_000_00001_0010011 ; /// x1 = 0
    shittyram[0] <= 32'h0001; shittyram[1] <= 32'h0002; shittyram[2] <= 32'h0003;
    shittyram[3] <= 32'h0004; shittyram[4] <= 32'h0005; shittyram[5] <= 32'h0006;
    shittyram[6] <= 32'h0007; shittyram[7] <= 32'h0008; shittyram[8] <= 32'h0009;

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
          2'b00:internal_data_result <= {16'h0000, shittyram[data_addr >> 2][15:0]};
          2'b00:internal_data_result <= {8'h0000, shittyram[data_addr >> 2][23:0]};
          2'b00:internal_data_result <= {shittyram[data_addr >> 2][31:0]};
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

/*
 * StartUp
 *
 * WaitStart, Precharge, Mode Register State
 * AutoRefresh 1-8,
 *
 */


/*
logic [6:0]powerupState;
localparam logic[6:0] MAX_POWERUP_STATE = 7'd80;
localparam logic[15:0] HI_Z = 16'hZZZZ;

always_ff @(posedge clk) begin
  if (!rst_n) begin
    powerupState <= 7'h00;
  end else begin
    if (powerupState <= MAX_POWERUP_STATE) begin
      powerupState <= powerupState + 1;
    end
  end
end

task automatic nop;
  begin
    s_cke   <= 1;
    s_cs_n  <= 0;
    s_ras_n <= 1;
    s_cas_n <= 1;
    s_we_n  <= 1;
    s_dqm   <= 0;
    s_bs    <= 0;
    s_addr  <= 0;
    dq    <= HI_Z;
  end
endtask

task precharge_bank_0;
  input [1 : 0] dqm_in;
  input [15 : 0] dq_in;
  begin
    cke   = 1;
    cs_n  = 0;
    ras_n = 0;
    cas_n = 1;
    we_n  = 0;
    dqm   = dqm_in;
    ba    = 0;
    addr  = 0;
    dq    = dq_in;
  end
endtask

task precharge_bank_1;
  input [1 : 0] dqm_in;
  input [15 : 0] dq_in;
  begin
    cke   = 1;
    cs_n  = 0;
    ras_n = 0;
    cas_n = 1;
    we_n  = 0;
    dqm   = dqm_in;
    ba    = 1;
    addr  = 0;
    dq    = dq_in;
  end
endtask

task automatic precharge_banks;
  begin
    s_cke   <= 1;
    s_cs_n  <= 0;
    s_ras_n <= 0;
    s_cas_n <= 1;
    s_we_n  <= 0;
    s_dqm   <= 0;
    s_bs    <= 0;
    s_addr  <= 1024; // A10 = 1
    dq    <= HI_Z;
  end
endtask

task automatic auto_refresh;
  begin
    s_cke   <= 1;
    s_cs_n  <= 0;
    s_ras_n <= 0;
    s_cas_n <= 0;
    s_we_n  <= 1;
    s_dqm   <= 0;
    s_bs    <= 0;
    s_addr  <= 0;
    dq    <= HI_Z;
  end
endtask

task automatic load_mode_reg;
  input [12 : 0] op_code;
  begin
    s_cke   <= 1;
    s_cs_n  <= 0;
    s_ras_n <= 0;
    s_cas_n <= 0;
    s_we_n  <= 0;
    s_dqm   <= 0;
    s_bs    <= 0;
    s_addr  <= op_code;
    dq    <= HI_Z;
  end
endtask


task automatic bank_active;
  input [ 1 : 0] bank;
  input [12 : 0] row;
  begin
    s_cke   <= 1;
    s_cs_n  <= 0;
    s_ras_n <= 0;
    s_cas_n <= 1;
    s_we_n  <= 1;
    s_dqm   <= 0;
    s_bs    <= bank;
    s_addr  <= row;
    dq    <= HI_Z;
  end
endtask

task automatic write;
  input [ 1 : 0] bank;
  input [ 8 : 0] column;
  input [15 : 0] dq_in;
  begin
    s_cke   <= 1;
    s_cs_n  <= 0;
    s_ras_n <= 1;
    s_cas_n <= 0;
    s_we_n  <= 0;
    s_dqm   <= 0;
    s_bs    <= bank;
    s_addr  <= column;
    dq    <= dq_in;
  end
endtask

task automatic read;
  input [ 1 : 0] bank;
  input [ 8 : 0] column;
  begin
    s_cke   <= 1;
    s_cs_n  <= 0;
    s_ras_n <= 1;
    s_cas_n <= 0;
    s_we_n  <= 1;
    s_dqm   <= 0;
    s_bs    <= bank;
    s_addr  <= column;
    dq    <= HI_Z;
  end
endtask

always_ff @(posedge clk) begin
  if (!rst_n) begin
    result <= 32'h0000;
  end else begin
    case (powerupState)
      'd1: nop;  //0-8 Nop
      'd9: precharge_banks;  //9 Precharge ALL Bank
      'd10: nop;  //10-11 Nop, tRP's minimum value is 20ns
      'd12: auto_refresh;  //12 Auto Refresh
      'd13: nop;  //13-20 Nop, tRFC's minimum value is 66ns
      'd21: auto_refresh;  //21 Auto Refresh
      'd22: nop;  //22-29 Nop, tRFC's minimum value is 66ns
      'd30: load_mode_reg(13'b0001000100011);  //30 Load Mode: Lat = 2, BL = 8, Seq
      'd31: nop;  //31 Nop, 2tCLK
      'd33: bank_active(0, 0);  //33 Active: Bank = 0, Row = 0
      'd34: nop;  //34-35 Nop
      'd36: write(0, 200, result + 1);  //36 Write : Bank = 0, Col = 200
      'd37: begin result <= 32'h0000; nop; end  //37 Nop
      'd38: nop;  //38 Nop
      'd39: nop;  //39-40 Nop
      'd50: bank_active(0, 0);  //50 Active: Bank = 0, Row = 0
      'd51: nop;  //51-52 Nop
      'd53: read(0, 200);  //53 Read Bank = 0, Col = 200
      'd54: nop;  //54 Nop
      'd55: nop;
      'd56: result <= {16'h00, s_dq};  //55 Nop
      default:;
    endcase
  end
end*/

endmodule
