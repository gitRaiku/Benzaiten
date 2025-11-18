`timescale 1ns / 1ps

module sdcard(
  input logic clk, rst,

  output spi_ss_n, output spi_sclk,
  output spi_mosi, input spi_miso
  );

  typedef enum { SDC_NEVER_INIT, SDC_READY } sdc_mstate_t;
  sdc_mstate_t state;
  logic statefc;

  logic spienable, spivalid;
  logic spicclk;
  logic spics;
  logic [79:0]spi_obuf; logic [3:0]spi_olen;
  logic [79:0]spi_ibuf; logic [3:0]spi_ilen;

  logic spienable, spivalid;
  task automatic wait_valid; input sdc_mstate_t next_state;
    if (spivalid) begin statefc <= 0; state <= next_state; end
  endtask

  spi sdspi(
        .clk(clk), .rst(rst),

        .enable(spienable), .valid(spivalid),

        .cclk(spicclk), .cs(spics),

        .obuf_in(spi_obuf), .olen(spi_olen),
        .ibuf(spi_ibuf), .ilen(spi_ilen),

        .ss_n(spi_ss_n), .sclk(spi_sclk),
        .mosi(spi_mosi), .miso(spi_miso)
    );

  always_ff @(posedge clk) begin
    unique case (state) begin
      SDC_NEVER_INIT: begin
        spienable <= 1
        spics <= 0;
        spi_obuf <= 48'h95_00_00_00_00_40;
        spi_olen <= 6;

      end
      SDC_READY: begin end
    end
  end
endmodule
