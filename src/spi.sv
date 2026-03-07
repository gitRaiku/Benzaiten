`timescale 1ns / 1ps

module spi(
  input rst,
  input enable, output valid,

  input cclk, input cs,
  input [7:0]obuf, output [7:0]ibuf,

  output ss_n, output sclk,
  output mosi, input miso
  );

  logic internal_valid;
  assign valid = enable & internal_valid;

  logic [3:0]cpos;
  always_ff @(posedge cclk) begin
    if (rst) begin
      ss_n <= 1;
      sclk <= 1;
      mosi <= 1;
      cpos <= 0;
      internal_valid <= 0;
    end else begin
      if (enable) begin
        ss_n <= !cs;
        if (cpos == 8) begin
          internal_valid <= 1;
        end else begin
          sclk <= ~sclk;
          if (sclk) begin
            cpos <= cpos + 1;
            mosi <= obuf[7];
            obuf <= {obuf[6:0], 1'b0};
          end else begin
            ibuf <= {ibuf[6:0], miso};
          end
        end
      end else begin
        ss_n <= 1;
        sclk <= 1;
        mosi <= 1;
        cpos <= 0;
        internal_valid <= 0;
      end
    end
  end
endmodule
