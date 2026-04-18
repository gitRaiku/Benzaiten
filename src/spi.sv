`timescale 1ns / 1ps

module spi(
  input clk, input rst,
  /* (* mark_debug = "true" *) */ input enable, /* (* mark_debug = "true" *) */ output valid,

  input cclk, input cs,
  /* (* mark_debug = "true" *) */ input logic [7:0]obuf, /* (* mark_debug = "true" *) */ output logic [7:0]ibuf,

  /* (* mark_debug = "true" *) */ output logic ss_n, /* (* mark_debug = "true" *) */ output logic sclk,
  /* (* mark_debug = "true" *) */ output logic mosi, /* (* mark_debug = "true" *) */ input miso
  );

  logic internal_valid;
  assign valid = enable & internal_valid;

  /* (* mark_debug = "true" *) */ logic [5:0]cpos;
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
