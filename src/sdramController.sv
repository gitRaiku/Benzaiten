module sdramController(
  input logic clk, rst_n,
  input logic [24:0]  addr,
  input logic [1:0]   oplen,
  input logic [31:0]  wdata,
  input logic         rw,
  input logic         enable,
  output logic [31:0] result,
  output logic        s_cs_n,
  output logic        s_ras_n,
  output logic        s_cas_n,
  output logic        s_we_n,
  output logic        s_cke,
  output logic [1:0]  s_dqm,
  output logic [12:0] s_addr,
  output logic [1:0]  s_bs,
  output logic [15:0] s_dq
);

logic [3:0]startupStep;

/*
 * StartUp
 *
 * WaitStart, Precharge, Mode Register State
 * AutoRefresh 1-8,
 *
 */

logic [6:0]powerupState;
localparam logic[6:0] MAX_POWERUP_STATE = 7'd57;
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
    s_cke   <= 0;
    s_cs_n  <= 0;
    s_ras_n <= 1;
    s_cas_n <= 1;
    s_we_n  <= 1;
    s_dqm   <= 0;
    s_bs    <= 0;
    s_addr  <= 0;
    s_dq    <= HI_Z;
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
    s_dq    <= HI_Z;
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
    s_dq    <= HI_Z;
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
    s_dq    <= HI_Z;
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
    s_dq    <= HI_Z;
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
    s_dq    <= dq_in;
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
    s_dq    <= HI_Z;
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
      'd36: write(0, 200, 16'hbe);  //36 Write : Bank = 0, Col = 0
      // , Dqm = 0
      'd37: nop;  //37 Nop
      'd38: nop;  //38 Nop
      'd39: nop;  //39-40 Nop
      'd50: bank_active(0, 0);  //50 Active: Bank = 0, Row = 0
      'd51: nop;  //51-52 Nop
      'd53: read(0, 200);  //53 Read
      'd54: nop;  //54 Nop
      'd55: nop;  //55 Nop
      'd56: result <= {16'h00, s_dq};  //55 Nop
      default:;
    endcase
  end

end

endmodule
