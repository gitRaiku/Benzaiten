`timescale 1ns / 1ps

module spi(
  input clk, input rst,
  input enable, output valid,

  input cclk, input cs,
  input logic [7:0]obuf, output logic [7:0]ibuf,

  output logic ss_n, output logic sclk,
  output logic mosi, input miso
  );

  logic internal_valid;
  assign valid = enable & internal_valid;

  logic [5:0]cpos;
  logic oldcclk;
  always_ff @(posedge clk) begin
    internal_valid <= 0;
    oldcclk <= cclk;
    ss_n <= !cs;
    if (rst) begin
      ss_n <= 1;
      sclk <= 1;
      mosi <= 1;
      cpos <= 0;
      ibuf <= 0;
    end else begin
      if (enable) begin
        if (!oldcclk && cclk) begin
          sclk <= ~sclk;
          if (sclk) begin
            cpos <= cpos + 1;
            mosi <= obuf[7 - cpos];
          end else begin
            ibuf <= {ibuf[6:0], miso};
          end
          if (cpos == 8 && sclk == 0) begin
            internal_valid <= 1;
            cpos <= 0;
          end
        end
      end else begin
        // ss_n <= 1;
        sclk <= 1;
        mosi <= 1;
        cpos <= 0;
        ibuf <= 0;
      end
    end
  end
endmodule
