`timescale 1ns / 1ps
import defs::*;

// inout io_sd_dat0, io_sd_dat1, io_sd_dat2, io_sd_dat3, io_sd_cmd, io_sd_clk,
module main(
  input logic clk_50_in, rst_n_in, button_1_n,
  output logic led_1_n, led_2_n,

  output logic s_clk, s_cs_n, s_ras_n, s_cas_n, s_we_n, s_cke,
  output logic [1:0]s_dqm, output logic [12:0]s_addr,
  output logic [1:0]s_bs,  inout logic [15:0]s_dq,

  output [31:0]gpio
  );

  wire clk;
  assign clk = clk_50_in;

  wire rst_internal;
  SRL16 #(.INIT(16'h1111)) srl_rst(
    .Q(rst_internal),
    .A0(1'b1), .A1(1'b1),
    .A2(1'b1), .A3(1'b1),
    .CLK(clk), .D(1'b0)
  );

  wire rst;
  assign rst = !rst_n_in || rst_internal;
  /// Create 200k for sdcard
  /*
  logic clk_locked;
  logic clk_10, clk_50, clk_100;
  clk_wiz_1 clankka(.clk_out1(clk_50), .clk_out2(clk_100), .clk_out3(clk_10), .locked(clk_locked),
                    .resetn(rst), .clk_in1(clk_50_in));
  */

  assign led_2_n = rst_n_in;
  assign led_1_n = button_1_n;

  logic [6:0]instr_op;
  logic [9:0]instr_func;
  logic [4:0]instr_rs1;
  logic [4:0]instr_rs2;
  logic [4:0]instr_rd;
  logic [31:0]instr_imm;
  logic [1:0]instr_oplen;
  instype_t instr_type;

  logic regfile_we;
  logic [31:0]regfile_data;
  logic [31:0]regfile_res1;
  logic [31:0]regfile_res2;

  logic [31:0]alu_result;

  /// TODO: Support ecall, ebreak, fence
  logic [31:0]instruction;
  logic [31:0]pc;
  logic [31:0]nextpc;
  logic [7:0]init_wait;

  logic mem_we, mem_enable, mem_valid;
  logic [1:0]mem_oplen;
  logic [31:0]mem_addr, mem_in, mem_out;
  memcon2 memcon(
    .clk(clk), .rst(rst), .enable(mem_enable), .valid(mem_valid),
    .addr(mem_addr), .we(mem_we), .oplen(mem_oplen),
    .in(mem_in), .out(mem_out),

    .pram_clk(s_clk), .pram_cs_n(s_cs_n),
    .pram_ras_n(s_ras_n), .pram_cas_n(s_cas_n),
    .pram_we_n(s_we_n), .pram_cke(s_cke),
    .pram_dqm(s_dqm), .pram_addr(s_addr),
    .pram_bs(s_bs), .pram_dq(s_dq),

    .gpio(gpio)
    );

  instructionDecoder idec(.instr(instruction), .op(instr_op),
                          .func(instr_func), .rs1(instr_rs1),
                          .rs2(instr_rs2), .rd(instr_rd),
                          .imm(instr_imm), .oplen(instr_oplen),
                          .instrType(instr_type)
  );

  regfile rf(.clk(clk), .rst(rst), .write_enabled(regfile_we),
             .rs1(instr_rs1), .rs2(instr_rs2), .rd(instr_rd),
             .data(regfile_data), .res1(regfile_res1), .res2(regfile_res2));

  alucon acon(.op(instr_op), .func(instr_func), .pc(pc), .itype(instr_type),
              .rf1(regfile_res1), .rf2(regfile_res2), .imm(instr_imm), .result(alu_result));

  typedef enum { CPU_NEVER_INITED, CPU_FETCH, CPU_DECODE, CPU_EX, CPU_MEM, CPU_WB } cpustage_t;
  cpustage_t state;
  always_ff @(posedge clk) begin
    regfile_we <= 1'b0;
    mem_enable <= 0;
    if (rst) begin
      pc <= 32'h0000;
      regfile_data <= 32'h0000;
      state <= CPU_NEVER_INITED;
      init_wait <= 8'h00;
      instruction <= 32'h00000013;
      nextpc <= 32'h00000004;
    end else begin
      /*
      * Read Instr
      * (Read Data)
      * Execute
      */
      unique case (state)
        CPU_NEVER_INITED: begin
          if (init_wait == 8'h20) begin
            state <= CPU_FETCH;
          end
          init_wait <= init_wait + 1;
        end
        CPU_FETCH: begin
          mem_addr <= pc;
          mem_we <= 0;
          mem_enable <= 1;
          if (mem_valid) begin
            mem_enable <= 0;
            instruction <= mem_out;
            state <= CPU_EX;
          end
        end
        CPU_EX: begin
          case (instr_op)
            7'b00000_11: begin // Load from ram
              mem_enable <= 1;
              mem_addr <= alu_result;
              mem_we <= 0;
              mem_oplen <= instr_oplen;
              /// mem_unsigned_read_len = instr_func[2];
              regfile_data <= 32'h0000;
            end
            7'b01000_11: begin // Store to ram
              mem_enable <= 1;
              mem_addr <= alu_result;
              mem_we <= 1;
              mem_in <= regfile_res2;
              mem_oplen <= instr_oplen;
              regfile_data <= 32'h0000;
            end
            7'b11001_11,7'b11011_11: begin // JAL JALR
              regfile_data <= pc + 4;
            end
            default: begin // ALU operation
              regfile_data <= alu_result;
            end
          endcase

          case (instr_op)
            7'b11001_11: nextpc <= alu_result; // JALR
            7'b11011_11: nextpc <= pc + instr_imm; // JAL
            7'b11000_11: nextpc <= pc + ((alu_result[0] != instr_func[0]) ? instr_imm : 32'h0004);
                                        // BXX
            default: nextpc <= pc + 32'h0004;
          endcase
          state <= CPU_MEM; /// TODO: Shortcircuit
        end
        CPU_MEM: begin
          if (mem_enable) begin
            mem_enable <= 1'b1;
            if (mem_valid) begin
              mem_enable <= 1'b0;
              regfile_data <= mem_out;
              state <= CPU_WB;
            end
          end else begin
            state <= CPU_WB;
          end
        end
        CPU_WB: begin
          if ((instr_op == 7'b01100_11) || // R-type
              (instr_op == 7'b00100_11) || // I-type arithmetic
              (instr_op == 7'b00000_11) || // Loads
              (instr_op == 7'b01101_11) || // LUI
              (instr_op == 7'b00101_11) || // AUIPC
              (instr_op == 7'b11011_11) || // JAL
              (instr_op == 7'b11001_11)) begin /// JALR
            regfile_we <= 1'b1;
          end
          pc <= nextpc;
          state <= CPU_FETCH;
        end
      endcase
    end
  end

endmodule
