`timescale 1ns / 1ps

module sdram(
  input logic clk, rst_n,
  input logic enable, output logic valid,
  input logic [24:0]addr,
  input logic [1:0]oplen, input logic writeEnable,   /// TODO: Add input logic for non 8-bit values
  input logic [31:0]data, output logic [31:0]result, /// TODO: Currently top 8-bits for every cell
  output logic        s_clk,   output logic        s_cs_n, /// Get discarded
  output logic        s_ras_n, output logic        s_cas_n,
  output logic        s_we_n,  output logic        s_cke,
  output logic [1:0]  s_dqm,   output logic [12:0] s_addr,
  output logic [1:0]  s_bs,    inout  logic [15:0] s_dq
  );

logic [15:0]dq;
assign s_dq = dq;

typedef enum { RAM_WAIT, RAM_INIT, RAM_PRECHARGE, RAM_ACTIVATE, RAM_READ, RAM_WRITE } sdramstate_t;
sdramstate_t state;
logic [1:0]bankSelect;
logic [12:0]rowSelect;
logic [8:0]columnSelect;
logic [15:0]dqSelect;
logic [15:0]readResult;

localparam logic[15:0] HI_Z = 16'hZZZZ;
task automatic op;
  input cke, cs_n, ras_n, cas_n, we_n;
  input [1:0]dqm;
  input [1:0]bs;
  input [12:0]addr;
  input [15:0]cdq;
  s_cke   <= cke;
  s_cs_n  <= cs_n;
  s_ras_n <= ras_n;
  s_cas_n <= cas_n;
  s_we_n  <= we_n;
  s_dqm   <= dqm;
  s_bs    <= bs;
  s_addr  <= addr;
  dq    <= cdq;
endtask

task automatic nop;
  begin op(1,0,1,1,1,0,0,0,HI_Z); end
endtask

task automatic bank_precharge;
  input [1 : 0]bank;
  begin op(1,0,0,1,0,0,bank,0,HI_Z); end
endtask

task automatic banks_precharge;
  begin op(1,0,0,1,0,0,0,1024,HI_Z); end
endtask

task automatic auto_refresh;
  begin op(1,0,0,0,1,0,0,0,HI_Z); end
endtask

task automatic load_mode_reg;
  input [12 : 0] op_code;
  begin op(1,0,0,0,0,0,0,op_code,HI_Z); end
endtask

task automatic bank_activate;
  input [1 : 0] bank; input [12 : 0] row;
  begin op(1,0,0,1,1,0,bank,row,HI_Z); end
endtask

task automatic write;
  input [1 : 0] bank; input [8 : 0] column; input [15 : 0] dq_in;
  begin op(1,0,1,0,0,0,bank,column,dq_in); end
endtask

task automatic read;
  input [1 : 0] bank; input [8 : 0] column;
  begin op(1,0,1,0,1,0,bank,column,HI_Z); end
endtask

/// tRAS Max time a bank can be active before being precharged is 100000 nS
/// tRRD between two bank activate for two banks is 2tCK
/// tRCD Time between activate and read/write = 18ns
/// tRP Prechargo to active: 18ns

logic [7:0]curState;

task automatic enter_wait; begin state <= RAM_WAIT; curState <= 0; end endtask
always_ff @(posedge clk) begin
  if (!rst_n) begin
    state <= RAM_INIT;
    curState <= 7'h00;
  end else begin
    curState <= 7'h00;
    case (state)
      RAM_WAIT: begin nop; end
      RAM_INIT: begin
        case (curState)
          'd1: nop;  //0-8 Nop
          'd9: banks_precharge;  //9 Precharge ALL Bank
          'd10: nop;  //10-11 Nop, tRP's minimum value is 20ns
          'd12: auto_refresh;  //12 Auto Refresh
          'd13: nop;  //13-20 Nop, tRFC's minimum value is 66ns
          'd21: auto_refresh;  //21 Auto Refresh
          'd22: nop;  //22-29 Nop, tRFC's minimum value is 66ns
          'd30: load_mode_reg(13'b0001000100011);  //30 Load Mode: Lat = 2, BL = 8, Seq
          'd31: nop;  //31 Nop, 2tCLK
          'd33: enter_wait;
          default:;
        endcase
        curState <= curState + 1;
      end
      RAM_PRECHARGE: begin /// TODO: For 50Mhz no nop needed, but not always 50MHz
        case (curState)
          'd0: bank_precharge(bankSelect);
          'd1: nop;
          'd2: enter_wait;
          default:;
        endcase
        curState <= curState + 1;
      end
      RAM_ACTIVATE: begin
        case (curState)
          'd0: bank_activate(bankSelect, rowSelect);
          'd1: nop;
          'd2: enter_wait;
          default:;
        endcase
        curState <= curState + 1;
      end
      RAM_READ: begin /// TODO: Implement burst reading
        case (curState)
          'd0: read(bankSelect, columnSelect);
          'd1: nop;
          'd2: nop;
          'd3: begin readResult <= s_dq; enter_wait; end
          default:;
        endcase
        curState <= curState + 1;
      end
      RAM_WRITE: begin
        case (curState)
          'd0: write(bankSelect, columnSelect, dqSelect);
          'd1: nop;
          'd2: nop;
          'd3: begin enter_wait; end
          default:;
        endcase
        curState <= curState + 1;
      end
      default:;
    endcase
  end
end

endmodule
