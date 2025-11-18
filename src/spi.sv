`timescale 1ns / 1ps

module spi(
  input logic clk, rst,
  input enable, output valid,

  input cclk, input cs,

  input [79:0]obuf_in, input [3:0]olen,
  output [79:0]ibuf, output [3:0]ilen,

  output ss_n, output sclk,
  output mosi, input miso
  );

  logic opos;
  logic oldenable;
  logic [79:0]obuf;
  always_ff @(posedge cclk) begin
    if (rst) begin
      ss_n <= 1;
      sclk <= 0;
      mosi <= 1;
    end else begin
      sclk <= ~sclk;
      oldenable <= enable;
      valid <= 0;
      if (enable && !oldenable) begin
        opos <= 0;
        obuf <= obuf_in;
        ss_n <= !cs;
      end
      if (sclk) begin
        ibuf <= {ibuf[78:0], miso};
      end else begin
        if (opos == olen) begin
          valid <= 1;
        end
        mosi <= obuf[0];
        obuf <= {0, obuf[78:0]};
        opos <= opos + 1;
      end
    end
  end

endmodule
