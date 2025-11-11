`timescale 1ns / 1ps

module sdram(
  input logic clk, rst,
  input logic enable, output logic valid,
  input logic [24:0]addr,
  input logic [1:0]oplen, input logic we,   /// TODO: Add input logic for non 8-bit values
  input logic [31:0]data, output logic [31:0]result, /// TODO: Currently top 8-bits for every cell
  output logic        s_clk,   output logic        s_cs_n, /// Get discarded
  output logic        s_ras_n, output logic        s_cas_n,
  output logic        s_we_n,  output logic        s_cke,
  output logic [1:0]  s_dqm,   output logic [12:0] s_addr,
  output logic [1:0]  s_bs,    inout  logic [15:0] s_dq
  );

assign s_clk = clk;

logic [15:0]dq;
assign s_dq = dq;

typedef enum { RAM_WAIT, RAM_INIT, RAM_PRECHARGE, RAM_ACTIVATE, RAM_READ, RAM_WRITE } sdramstate_t;
sdramstate_t targetState;
sdramstate_t state;
logic [1:0]bankSelect;
logic [12:0]rowSelect;
logic [8:0]columnSelect;
logic [15:0]dqSelect;

logic [15:0]readResult;
logic [7:0]curState;
logic returnToWait;

typedef enum { RAM_M_NEVER_INIT, RAM_M_READY, RAM_M_PRECHARGE,
               RAM_M_ACTIVATE, RAM_M_ACCESS } sdram_mstate_t;
sdram_mstate_t macrostate;
logic mstatefc; /// Macro state first command

localparam logic[15:0] BANK_ACTIVE_TIME = 4500; // Could be 5000 but meh

logic activeBank[4];
logic [12:0]activeRow[4];
logic [15:0]activeBankTimeout[4];

task automatic ff_timeout; input [1:0]bank;
  if (activeBank[bank] && activeBankTimeout[bank] > 0) begin
    activeBankTimeout[bank] <= activeBankTimeout[bank] - 1; end endtask

task automatic ff_timeout_precharge; input [1:0]bank;
  if (activeBank[bank] && activeBankTimeout[bank] == 0) begin
     mstatefc <= 0; macrostate <= RAM_M_PRECHARGE; bankSelect <= bank; end endtask

task automatic wait_for_ram_wait; if (returnToWait) begin
  mstatefc <= 0; macrostate <= RAM_M_READY; end endtask

wire [1:0]targetBank;
assign targetBank = addr[24:23];
wire [12:0]targetRow;
assign targetRow = addr[22:10];
wire [8:0]targetColumn;
assign targetColumn = addr[9:1];
logic targetUL;
assign targetUL = addr[0];

always_ff @(posedge clk) begin
  if (rst) begin
    macrostate <= RAM_M_NEVER_INIT;
    mstatefc <= 0;
    valid <= 0;
    activeBank[0] <= 0;
    activeBank[1] <= 0;
    activeBank[2] <= 0;
    activeBank[3] <= 0;
    activeRow[0] <= 0;
    activeRow[1] <= 0;
    activeRow[2] <= 0;
    activeRow[3] <= 0;
    activeBankTimeout[0] <= 0;
    activeBankTimeout[1] <= 0;
    activeBankTimeout[2] <= 0;
    activeBankTimeout[3] <= 0;
    result <= 32'h00000000;
  end else begin
    mstatefc <= 1;
    valid <= 0;
    targetState <= RAM_WAIT;
    case (macrostate)
      RAM_M_READY: begin /// TODO: Handle 32 bit access and non-aligned access
        if (enable) begin
          valid <= valid;
          if (!valid) begin
            if ((activeBank[targetBank] == 1) && (activeRow[targetBank] == targetRow) &&
                     activeBankTimeout[targetBank] > 30) begin
              bankSelect <= targetBank; /// TODO Handle non 16 bit values
              rowSelect <= targetRow;
              columnSelect <= targetColumn;
              dqSelect <= data[15:0];
              macrostate <= RAM_M_ACCESS;
            end else if (activeBank[targetBank == 1]) begin
              // Implied: && activeRow[targetBank] != targetRow
              bankSelect <= targetBank;
              rowSelect <= targetRow;
              macrostate <= RAM_M_PRECHARGE;
            end else begin
              // Implied: activeBank[targetBank != 1]
              bankSelect <= targetBank;
              rowSelect <= targetRow;
              macrostate <= RAM_M_ACTIVATE;
            end
            mstatefc <= 0;
          end
        end

        ff_timeout_precharge(0);
        ff_timeout_precharge(1);
        ff_timeout_precharge(2);
        ff_timeout_precharge(3);
      end
      RAM_M_ACCESS: begin
        if (mstatefc == 0) begin
          if (we) begin
            targetState <= RAM_WRITE;
          end else begin
            targetState <= RAM_READ;
          end
        end else begin
          wait_for_ram_wait;
          if (returnToWait) begin
            if (!we) begin
              result <= {16'h00, readResult}; /// TODO: Non 16 bits
            end
            valid <= 1;
          end
        end
      end
      RAM_M_PRECHARGE: begin
        if (mstatefc == 0) begin
          targetState <= RAM_PRECHARGE;
        end else begin
          wait_for_ram_wait;
          if (returnToWait) begin
            activeBank[bankSelect] <= 0;
          end
        end
      end
      RAM_M_ACTIVATE: begin
        if (mstatefc == 0) begin
          targetState <= RAM_ACTIVATE;
        end else begin
          wait_for_ram_wait;
          if (returnToWait) begin
            activeBank[bankSelect] <= 1;
            activeRow[bankSelect] <= rowSelect;
            activeBankTimeout[bankSelect] <= BANK_ACTIVE_TIME;
          end
        end
      end
      RAM_M_NEVER_INIT: begin
        if (mstatefc == 0) begin
          targetState <= RAM_INIT;
        end else begin
          wait_for_ram_wait;
          if (returnToWait) begin
            activeBank[0] <= 0;
            activeBank[1] <= 0;
            activeBank[2] <= 0;
            activeBank[3] <= 0;
          end
        end
      end
      default:;
    endcase

    ff_timeout(0);
    ff_timeout(1);
    ff_timeout(2);
    ff_timeout(3);
  end
end



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

/// tCK = 20nS
/// tRAS Max time a bank can be active before being precharged is 100000 nS (5000 cycles)
/// tRRD between two bank activate for two banks is 2tCK
/// tRCD Time between activate and read/write = 18ns
/// tRP Prechargo to active: 18ns

logic goToTargetState;
task automatic enter_wait; begin state <= RAM_WAIT; returnToWait <= 1; curState <= 0; end endtask
always_ff @(posedge clk) begin
  if (rst) begin
    state <= RAM_INIT;
    curState <= 7'h00;
    readResult <= 16'h0000;
  end else begin
    curState <= 7'h00;
    goToTargetState <= 0;
    returnToWait <= 0;
    case (state)
      RAM_WAIT: begin
        goToTargetState <= 1;
        if (goToTargetState) begin
          state <= targetState;
        end else begin
          nop;
        end
      end
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
