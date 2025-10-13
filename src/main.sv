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
  logic [2:0]instr_wlen;
  instype_t instr_type;

  logic regfile_we;
  logic [31:0]regfile_data;
  logic [31:0]regfile_r1;
  logic [31:0]regfile_r2;

  logic [31:0]alu_result;

  logic ram_instr_enable, ram_instr_valid;
  logic ram_data_enable, ram_data_valid;
  logic [1:0]ram_data_oplen;
  logic [24:0]ram_data_addr;
  logic [31:0]ram_data_wdata;
  logic ram_data_rw;
  assign ram_data_oplen = 2'bZZ;
  assign ram_data_addr = 32'hZZZZ;
  assign ram_data_wdata = 32'hbeef;
  assign ram_data_rw = 1'b1;

  logic [31:0]instruction;
  logic [31:0]pc;
  logic [31:0]jumplen;

  logic bus_stall;
  assign bus_stall = !ram_instr_valid || !ram_data_valid;

  task automatic handle_instr_op;
    begin
        //// TODO LOAD INSTRUCTIONS
        //// TODO LOAD INSTRUCTIONS
        //// TODO LOAD INSTRUCTIONS
        //// TODO LOAD INSTRUCTIONS
        //// TODO LOAD INSTRUCTIONS
        //// TODO LOAD INSTRUCTIONS
        //// TODO LOAD INSTRUCTIONS
        //// TODO LOAD INSTRUCTIONS
      case (instr_op)
        7'b00000_11: begin // Load from ram
        //// TODO LOAD INSTRUCTIONS
        //// TODO LOAD INSTRUCTIONS
          //ram_data_enable <= 1'b1;
          // ram_data_addr <= regfile_r1 + instr_imm;
          regfile_data <= (instr_imm << 12);
          regfile_we <= 1'b1;
        end
        7'b01000_11: begin // Store from mem
        //// TODO STORE INSTRUCTIONS
        //// TODO STORE INSTRUCTIONS
          regfile_data <= (instr_imm << 12) + pc;
          regfile_we <= 1'b0;
        end
        7'b11001_11,7'b11011_11: begin // JAL JALR
          regfile_data <= pc + 4;
          regfile_we <= 1'b1;
        end
        default: begin // ALU operation
          regfile_data <= alu_result;
          regfile_we <= 1'b1;
        end
      endcase
    end
  endtask

  always_comb begin
    case (instr_op)
      7'b11001_11: jumplen = alu_result; // JALR
      7'b11011_11: jumplen = instr_imm; // JAL
      7'b11000_11: jumplen = (alu_result[0] != instr_func[0]) ? instr_imm : 32'h0004; // BXX
      default: jumplen = 32'h0004;
    endcase
  end


  always_ff @(negedge rst_n or posedge clk) begin
    if (!rst_n) begin
      pc <= 32'h0000;
      ram_instr_enable <= 1'b1;
      ram_data_enable <= 1'b0;
      regfile_data <= 32'h0000;
      regfile_we <= 1'b0;
    end else begin
      if (!bus_stall) begin
        pc <= pc + jumplen;
        ram_instr_enable <= 1;

        handle_instr_op;
      end
    end
  end

  sdramController sdram(
    .clk(clk), .rst_n(rst_n),

    .instr_addr(pc[24:0]),
    .instr_result(instruction),

    .instr_enable(ram_instr_enable), .instr_valid(ram_instr_valid),
    .data_enable(ram_data_enable), .data_valid(ram_data_valid), .data_oplen(ram_data_oplen),
    .data_addr(ram_data_addr), .data_wdata(ram_data_wdata), .data_rw(ram_data_rw),

    .s_clk(s_clk), .s_cs_n(s_cs_n),
    .s_ras_n(s_ras_n), .s_cas_n(s_cas_n),
    .s_we_n(s_we_n), .s_cke(s_cke),
    .s_dqm(s_dqm), .s_addr(s_addr),
    .s_bs(s_bs), .s_dq(s_dq)
    );

  instructionDecoder idec(.instr(instruction), .op(instr_op),
                          .func(instr_func), .rs1(instr_rs1),
                          .rs2(instr_rs2), .rd(instr_rd),
                          .imm(instr_imm), .writeLen(instr_wlen),
                          .instrType(instr_type)
  );

  regfile rf(.clk(clk), .rst_n(rst_n), .write_enabled(regfile_we),
             .rs1(instr_rs1), .rs2(instr_rs2), .rd(instr_rd),
             .data(regfile_data), .res1(regfile_r1), .res2(regfile_r2));

  alucon acon(.op(instr_op), .func(instr_func), .pc(pc), .itype(instr_type),
              .rf1(regfile_r1), .rf2(regfile_r2), .imm(instr_imm), .result(alu_result));

endmodule
