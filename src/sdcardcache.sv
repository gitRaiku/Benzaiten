`timescale 1ns / 1ps

module sdcardcache(
  input logic clk, rst,
// verilator lint_off UNUSEDSIGNAL
  input logic [31:0]addr,
// verilator lint_on UNUSEDSIGNAL
  input logic [31:0]in,
  input logic enable, input logic we, input logic overwrite,
  output logic valid, output logic [31:0]out,
  output logic [31:0]dirty_addr,
  output logic dirty, output logic invalid
  );
  /// TODO: Make this good as well
  /// Currently sequential flushes always flush the same buffer

  (* ram_style = "block" *) logic [31:0]cache_buf[2 * 512 / 4 - 1:0];

  logic [1:0][22:0]cache_addr;
  logic [1:0]cache_dirty;
  logic [1:0]cache_filled;
  logic overwrite_cache;

  logic addr_invalid;
  logic ccache;

  logic [7:0]cache_sel;
  always_comb begin
    addr_invalid = 0;
    ccache = 0;
    if (cache_addr[0] == addr[31:9] && cache_filled[0]) ccache = 0;
    else if (cache_addr[1] == addr[31:9] && cache_filled[1]) ccache = 1;
    else begin
      addr_invalid = 1;
      if (cache_filled[0]) ccache = 1; /// TODO: Make better
    end

    cache_sel = {ccache, addr[8:2]};
    if (addr_invalid && overwrite) begin
      cache_sel = {overwrite_cache, addr[8:2]};
    end
  end

  always @(posedge clk) begin
    valid <= 0;
    dirty <= 0;
    invalid <= 0;
    if (rst) begin
      cache_dirty[0] <= 0;
      cache_dirty[1] <= 0;
      cache_addr[0] <= 0;
      cache_addr[1] <= 0;
      cache_filled[0] <= 0;
      cache_filled[1] <= 0;
      overwrite_cache <= 0;
      dirty_addr <= 0;
      out <= 0;
    end else begin
      if (enable) begin
        if (addr_invalid == 0) begin
          valid <= 1;
          if (we) begin
            overwrite_cache <= ~ccache;
            cache_buf[cache_sel] <= in;
            if (!overwrite) begin
              cache_dirty[ccache] <= 1;
            end
          end else begin
            out <= cache_buf[cache_sel];
          end
        end else begin
          if (overwrite) begin
            cache_buf[cache_sel] <= in;
            if (addr[8:0] == 508) begin
              cache_addr[overwrite_cache] <= addr[31:9];
              cache_dirty[overwrite_cache] <= 0;
              cache_filled[overwrite_cache] <= 1;
              overwrite_cache <= ~overwrite_cache;
            end
            valid <= 1;
          end else begin
            invalid <= 1;
            dirty <= cache_dirty[overwrite_cache];
            dirty_addr <= {cache_addr[overwrite_cache], 9'h0};
          end
        end
      end
    end
  end
  
endmodule
