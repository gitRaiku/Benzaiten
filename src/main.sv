`timescale 1ns / 1ps
import defs::*;

// inout io_sd_dat0, io_sd_dat1, io_sd_dat2, io_sd_dat3, io_sd_cmd, io_sd_clk,
module main(
  input logic clk_50_in, rst_n, button_1_n,
  output led_1_n, led_2_n,

  output s_clk, s_cs_n, s_ras_n, s_cas_n, s_we_n, s_cke,
  output [1:0]s_dqm,
  output [1:0]s_bs,
  output [12:0]s_addr,
  inout  [15:0]s_dq
  );

  /*
  logic clk_locked;
  logic clk_10, clk_50, clk_100;
  clk_wiz_1 clankka(.clk_out1(clk_50), .clk_out2(clk_100), .clk_out3(clk_10), .locked(clk_locked),
                    .resetn(rst_n), .clk_in1(clk_50_in));
  */
  assign clk = clk_50_in;
  assign clk_out = clk;

  assign led_2_n = 1;
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

  logic [31:0]ram_instr_result;
  logic [31:0]ram_instr_addr;
  logic ram_instr_enable, ram_instr_valid;
  logic ram_data_enable, ram_data_valid;
  logic ram_data_unsigned;
  logic [1:0]ram_data_oplen;
  logic [24:0]ram_data_addr;
  logic [31:0]ram_data_wdata;
  logic [31:0]ram_data_result;
  logic ram_data_rw;

  logic [31:0]instruction;
  logic [31:0]pc;
  logic [31:0]jumplen;

  cpustage_t state;
  always_ff @(negedge rst_n or posedge clk) begin
    if (!rst_n) begin
      pc <= 32'h0000;
      ram_instr_enable <= 1'b0;
      ram_data_enable <= 1'b0;
      regfile_data <= 32'h0000;
      regfile_we <= 1'b0;
      state <= CPU_FETCH;

      ram_instr_addr <= 32'h00000000;
      ram_data_addr <= 32'h00000000;
      ram_data_rw <= 1'b0;
      ram_data_oplen <= 1'b0;
      ram_data_unsigned <= 1'b0;
      ram_data_wdata <= 32'h00000000;

      instruction <= 32'h00000013;
      jumplen <= 32'h00000000;
    end else begin
      /*
      * Read Instr
      * (Read Data)
      * Execute
      */
      regfile_we <= 1'b0;
      ram_instr_enable <= 1'b0;
      ram_data_enable  <= 1'b0;
      unique case (state)
        CPU_FETCH: begin
          ram_instr_addr <= pc;
          ram_instr_enable <= 1'b1;
          if (ram_instr_valid) begin
            ram_instr_enable <= 1'b0;
            instruction <= ram_instr_result;
            state <= CPU_EX;
          end
        end
        CPU_EX: begin
          case (instr_op)
            7'b00000_11: begin // Load from ram
              ram_data_enable <= 1'b1;
              ram_data_addr <= alu_result;
              ram_data_rw <= 1'b0;
              ram_data_oplen <= instr_oplen;
              ram_data_unsigned <= instr_func[2];
              regfile_data <= 32'h0000;
            end
            7'b01000_11: begin // Store to ram
              ram_data_enable <= 1'b1;
              ram_data_addr <= alu_result;
              ram_data_rw <= 1'b1;
              ram_data_wdata <= regfile_res2;
              ram_data_oplen <= instr_oplen;
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
            7'b11001_11: jumplen <= alu_result; // JALR
            7'b11011_11: jumplen <= instr_imm; // JAL
            7'b11000_11: jumplen <= (alu_result[0] != instr_func[0]) ? instr_imm : 32'h0004; // BXX
            default: jumplen <= 32'h0004;
          endcase
          state <= CPU_MEM; /// TODO: Shortcircuit
        end
        CPU_MEM: begin
          if (ram_data_enable) begin
            ram_data_enable <= 1'b1;
            if (ram_data_valid) begin
              ram_data_enable <= 1'b0;
              regfile_data <= ram_data_result;
              state <= CPU_WB;
            end
          end else begin
            state <= CPU_WB;
          end
        end
        CPU_WB: begin
          if (instr_op != 7'b01000_11) begin // Store instructions
            regfile_we <= 1'b1;
          end
          pc <= pc + jumplen;
          state <= CPU_FETCH;
        end
      endcase
    end
  end

  sdramController sdram(
    .clk(clk), .rst_n(rst_n),

    .instr_addr(ram_instr_addr[24:0]),
    .instr_result(ram_instr_result),

    .instr_enable(ram_instr_enable), .instr_valid(ram_instr_valid), .data_enable(ram_data_enable),
    .data_valid(ram_data_valid), .data_oplen(ram_data_oplen), .data_unsigned(ram_data_unsigned),
    .data_addr(ram_data_addr), .data_wdata(ram_data_wdata), .data_rw(ram_data_rw),
    .data_result(ram_data_result),

    .s_clk(s_clk), .s_cs_n(s_cs_n),
    .s_ras_n(s_ras_n), .s_cas_n(s_cas_n),
    .s_we_n(s_we_n), .s_cke(s_cke),
    .s_dqm(s_dqm), .s_addr(s_addr),
    .s_bs(s_bs), .s_dq(s_dq)
    );

  instructionDecoder idec(.instr(instruction), .op(instr_op),
                          .func(instr_func), .rs1(instr_rs1),
                          .rs2(instr_rs2), .rd(instr_rd),
                          .imm(instr_imm), .oplen(instr_oplen),
                          .instrType(instr_type)
  );

  regfile rf(.clk(clk), .rst_n(rst_n), .write_enabled(regfile_we),
             .rs1(instr_rs1), .rs2(instr_rs2), .rd(instr_rd),
             .data(regfile_data), .res1(regfile_res1), .res2(regfile_res2));

  alucon acon(.op(instr_op), .func(instr_func), .pc(pc), .itype(instr_type),
              .rf1(regfile_res1), .rf2(regfile_res2), .imm(instr_imm), .result(alu_result));

endmodule
