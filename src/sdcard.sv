`timescale 1ns / 1ps

module sdcard(
  input logic clk, rst,

  output spi_ss_n, output spi_sclk,
  output spi_mosi, input spi_miso
  );

  typedef enum { SDC_NEVER_INIT, SDC_WAIT_FIRST_INIT, SDC_READY } sdc_mstate_t;
  sdc_mstate_t state;
  logic statefc;

  logic spi_enable, spi_valid;
  logic spi_cclk;
  logic spi_cs;
  logic [7:0]spi_obuf, spi_ibuf;

  task automatic wait_valid; input sdc_mstate_t next_state;
    if (spi_valid) begin statefc <= 0; state <= next_state; end
  endtask

  spi sdspi(
      .rst(rst),
      .enable(spi_enable), .valid(spi_valid),
      .cclk(spi_cclk), .cs(spi_cs),
      .obuf(spi_obuf), .ibuf(spi_ibuf),
      .ss_n(spi_ss_n), .sclk(spi_sclk),
      .mosi(spi_mosi), .miso(spi_miso)
    );


  logic [7:0]send_buffer[6];
  logic [7:0]send_buffer_len;
  logic send_enable;


  sdc_mstate_t nstate;
  always_ff @(posedge clk) begin
    unique case (state)
      SDC_NEVER_INIT: begin
        spi_enable <= 1;
        spi_cs <= 0;
        send_buffer[0] <= 8'h95;
        send_buffer[1] <= 8'h00;
        send_buffer[2] <= 8'h00;
        send_buffer[3] <= 8'h00;
        send_buffer[4] <= 8'h00;
        send_buffer[5] <= 8'h40;
        send_buffer_len <= 6;
        send_enable <= 1;
        nstate <= SDC_WAIT_FIRST_INIT;
      end
      SDC_WAIT_FIRST_INIT: begin end
      SDC_READY: begin end
    endcase
  end
endmodule
