`timescale 1ns / 1ps

module sdcard(
  input logic clk, rst,

  input logic enable, input logic we,
  input [31:0]addr, input [31:0]in,
  output logic [31:0]out, output logic valid,

  output spi_ss_n, output spi_sclk,
  output spi_mosi, input spi_miso
  );


  localparam logic [9:0]sd_blocklen = 512;

  logic [31:0]cache_addr, cache_in, cache_out, cache_dirty_addr;
  logic cache_enable, cache_we, cache_overwrite, cache_valid, cache_dirty, cache_invalid;
  sdcardcache cache(
    .clk(clk), .rst(rst),
    .addr(cache_addr), .in(cache_in), .invalid(cache_invalid),
    .enable(cache_enable), .we(cache_we), .overwrite(cache_overwrite),
    .valid(cache_valid), .out(cache_out), .dirty(cache_dirty),
    .dirty_addr(cache_dirty_addr)
    );

  logic [31:0]int_addr;
  logic [7:0]int_in, int_out;
  logic int_enable, int_we, int_valid, int_outvalid;
  sdcardinterface #(.SD_BLOCKLEN(sd_blocklen)) inter(
    .clk(clk), .rst(rst),
    .addr(int_addr), .in(int_in),
    .enable(int_enable), .we(int_we),
    .valid(int_valid), .out(int_out), .outvalid(int_outvalid),
    .spi_ss_n(spi_ss_n), .spi_sclk(spi_sclk),
    .spi_mosi(spi_mosi), .spi_miso(spi_miso)
    );

  typedef enum { SDC_WAITING, SDC_TRY_CACHE, SDC_CACHE_FLUSH, SDC_CACHE_FLUSH_INT, SDC_CACHE_FILL } op_state_t;
  op_state_t state; 
  logic [23:0]block_cval;
  logic [9:0]block_pos;
  logic [1:0]block_byte_pos;

  task automatic start_cache_fill;
    state <= SDC_CACHE_FILL;
    block_pos <= 0;
    block_byte_pos <= 0;
    block_cval <= 0;
    int_enable <= 1;
    int_we <= 0;
    int_addr <= addr;
  endtask

  task automatic start_do_wait;
    cache_enable <= 1;
    cache_in <= in;
    cache_addr <= addr;
    state <= SDC_TRY_CACHE;
    if (we) begin
      cache_we <= 1;
    end else begin
      cache_we <= 0;
    end
  endtask

  always_ff @(posedge clk) begin
    cache_enable <= 0;
    int_enable <= 0;
    valid <= 0;
    state <= SDC_WAITING;
    if (rst) begin
      cache_we <= 0;
      cache_addr <= 0;
      cache_overwrite <= 0;
      int_addr <= 0;
      int_in <= 0;
      int_we <= 0;
      block_pos <= 0;
      block_byte_pos <= 0;
      block_cval <= 0;
      out <= 0;
    end else begin
      if (enable) begin
        case (state)
          SDC_WAITING: begin start_do_wait; end
          SDC_TRY_CACHE: begin
            state <= SDC_TRY_CACHE;
            if (cache_valid) begin
              valid <= 1;
              out <= cache_out;
              state <= SDC_WAITING;
            end else begin
              if (cache_invalid) begin
                if (cache_dirty) begin
                  state <= SDC_CACHE_FLUSH;
                  cache_addr <= cache_dirty_addr;
                  cache_enable <= 1;
                  cache_we <= 0;
                  block_pos <= 0;
                end else begin
                  start_cache_fill;
                end
              end
            end
          end
          SDC_CACHE_FLUSH: begin
            /*
            cache_enable <= 1;
            cache_we <= 0;
            cache_addr <= cache_dirty_addr + block_pos;
            if (block_pos < sd_blocklen) begin
              if (cache_valid) begin
                int_enable <= 1;
                int_we <= 1;
                state <= SDC_CACHE_FLUSH_INT;
                block_pos <= block_pos + 1;
                cache_addr <= cache_dirty_addr + block_pos + 1;
              end
            end else begin
              start_cache_fill;
            end*/
          end
          SDC_CACHE_FILL: begin
            state <= SDC_CACHE_FILL;
            int_enable <= 1;
            int_we <= 0;
            int_addr <= addr;
            if (block_pos < sd_blocklen) begin
              if (int_outvalid) begin
                block_byte_pos <= block_byte_pos + 1;
                unique case (block_byte_pos) /// TODO: Could be done as a fifo
                  2'b00: block_cval[7:0] <= int_out;
                  2'b01: block_cval[15:8] <= int_out;
                  2'b10: block_cval[23:16] <= int_out;
                  2'b11: begin
                    block_byte_pos <= 0;
                    block_pos <= block_pos + 1;
                    cache_enable <= 1;
                    cache_addr <= {addr[31:9], block_pos[8:0]};
                    cache_in <= {int_out, block_cval[23:0]};
                    cache_we <= 1;
                    cache_overwrite <= 1; 
                    /// Here we aren't waiting for cache_valid cuz ig we're fast enough i hope?))))
                  end
                endcase
              end
            end else begin
              start_do_wait;
            end
          end
          default:;
        endcase
      end
    end
  end
endmodule
