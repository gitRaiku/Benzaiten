`timescale 1ns / 1ps

module memcon2(
  input logic clk, rst,
  input logic [31:0]addr, input logic we,
  input logic [1:0]oplen,
  input logic [31:0]in, output logic[31:0]out,
  input logic enable, output logic valid,

  output logic        pram_clk,   output logic        pram_cs_n,
  output logic        pram_ras_n, output logic        pram_cas_n,
  output logic        pram_we_n,  output logic        pram_cke,
  output logic [1:0]  pram_dqm,   output logic [12:0] pram_addr,
  output logic [1:0]  pram_bs,    inout  logic [15:0] pram_dq,

  output logic spi_ss_n, output logic spi_sclk,
  output logic spi_mosi, input logic spi_miso,

  output logic [31:0] gpio
  );

/// /////////////////////////////////////////////////////////// ///
///                                                             ///
/// Memory layout TODO: Find actual memory limits               ///
/// 0x00000000 - 0x0FFFFFFF Internal memory (first 4096 bytes)  ///
/// 0x10000000 - 0x3FFFFFFF Ram (1E00000 bytes)                 ///
/// 0x40000000 - 0xFFFFFFFF sdcard                              ///
///                                                             ///
/// /////////////////////////////////////////////////////////// ///

localparam logic [31:0]LIMIT_IRAM = 32'h0FFFFFFF;
localparam logic [31:0]START_RAM  = 32'h10000000;
localparam logic [31:0]LIMIT_RAM  = 32'h3FFFFFFF;
localparam logic [31:0]START_SDC  = 32'h40000000;
// verilator lint_off UNUSEDPARAM
localparam logic [31:0]LIMIT_SDC  = 32'hFFFFFFFF;
// verilator lint_on UNUSEDPARAM

/// TODO: Learn secrets of hyperborea and write this code better
/// TODO: Support non-aligned sub-32bit ops
logic cache_we, cache_enable, cache_valid, cache_overwrite, cache_dirty;
logic [31:0]cache_addr, cache_in, cache_out;
logic cache_missed;
assign cache_missed = !cache_valid & cache_dirty;
memcache cache(
  .clk(clk), .rst(rst), .addr(cache_addr), .in(cache_in),
  .dirty(cache_dirty), .we(cache_we), .enable(cache_enable), 
  .out(cache_out),
  .overwrite(cache_overwrite), .valid(cache_valid));
  

logic iram_enable, iram_valid, iram_we;
logic [1:0]iram_oplen;
logic [31:0]iram_addr, iram_in, iram_out;
internalRam #(.GPIO_ADDR(LIMIT_IRAM)) iram(
  .clk(clk), .rst(rst), .enable(iram_enable), .valid(iram_valid),
  .addr(iram_addr), .oplen(iram_oplen), .we(iram_we),
  .in(iram_in), .out(iram_out), .gpio(gpio));

logic ram_enable, ram_valid, ram_we;
logic [1:0]ram_oplen;
logic [31:0]ram_addr, ram_in, ram_out;
sdram ram(
    .clk(clk), .rst(rst), .enable(ram_enable), .valid(ram_valid),
    .addr(ram_addr), .in(ram_in), .out(ram_out), .we(ram_we), 
    .oplen(ram_oplen), .s_clk(pram_clk), .s_cs_n(pram_cs_n), 
    .s_ras_n(pram_ras_n), .s_cas_n(pram_cas_n), .s_we_n(pram_we_n), 
    .s_cke(pram_cke), .s_dqm(pram_dqm), .s_addr(pram_addr), 
    .s_bs(pram_bs), .s_dq(pram_dq));

/// TODO: Implement sdcard
logic [31:0]card_addr, card_in, card_out;
logic card_enable, card_we, card_valid;
sdcard card(
    .clk(clk), .rst(rst), .enable(card_enable), .valid(card_valid),
    .we(card_we), .in(card_in), .out(card_out), .addr(card_addr),
    .spi_ss_n(spi_ss_n), .spi_sclk(spi_sclk),
    .spi_mosi(spi_mosi), .spi_miso(spi_miso));

typedef enum { 
  MC_READY = 10, 
  MC_FLUSH = 20, 
  MC_RAM_FLUSH = 30, 
  MC_RAM_FLUSH_WAIT = 31, 
  MC_RAM_READ = 40, 
  MC_RAM_READ_WAIT = 41
  } mc_state_t;

(* mark_debug = "true" *) mc_state_t state;

task automatic cache_access; input logic [31:0]in_addr;
  cache_enable <= 1;
  cache_overwrite <= 0;
  cache_addr <= in_addr;
  cache_in <= in;
  cache_we <= we;

  if (cache_valid) begin
    cache_enable <= 0;
    out <= cache_out;
    valid <= 1;
  end
  if (cache_missed) begin
    state <= MC_FLUSH;
  end
endtask

task automatic card_access; input logic [31:0]in_addr;
  card_enable <= 1;
  card_addr <= in_addr - START_SDC;
  card_in <= in;
  card_we <= we;

  if (card_valid) begin
    card_enable <= 0;
    out <= card_out;
    valid <= 1;
  end
endtask

logic [31:0]flush_addr;
logic [31:0]flush_caddr;

always_ff @(posedge clk) begin
  iram_enable <= 0;
  cache_enable <= 0;
  ram_enable <= 0;
  card_enable <= 0;
  valid <= 0;

  if (rst) begin
    state <= MC_READY;
    cache_addr <= 0;
    cache_in <= 0;
    iram_addr <= 0;
    iram_in <= 0;
    iram_we <= 0;
    iram_oplen <= 0;
    ram_addr <= 0;
    ram_in <= 0;
    ram_we <= 0;
    ram_oplen <= 0;
    card_addr <= 0;
    card_in <= 0;
    card_we <= 0;
    out <= 0;
    flush_addr <= 0;
    flush_caddr <= 0;
  end else if (enable) begin
    unique case (state)
      MC_READY: begin
        if (addr <= LIMIT_IRAM) begin
          iram_enable <= 1;
          iram_addr <= addr;
          iram_oplen <= oplen;
          iram_in <= in;
          iram_we <= we;
          if (iram_valid) begin 
            iram_enable <= 0; 
            out <= iram_out;
            valid <= 1; 
          end
        end else if (addr <= LIMIT_RAM) begin
          cache_access(addr);
        end else begin
          card_access(addr);
        end
      end
      MC_FLUSH: begin
        flush_addr <= cache_out;
        flush_caddr <= cache_out + 1;

        cache_enable <= 1;
        cache_overwrite <= 0;
        cache_addr <= cache_out;
        cache_in <= in;
        cache_we <= 0;

        if (cache_dirty) begin /// TODO: Move ram flushing to the ram module as well
          if (flush_addr <= LIMIT_RAM) begin state <= MC_RAM_FLUSH; end 
          else begin state <= MC_READY; end
        end else begin 
          flush_caddr <= {addr[31:9], 9'h00000};
          flush_addr <= {addr[31:9], 9'h00000};
          if (flush_addr <= LIMIT_RAM) begin state <= MC_RAM_READ; end 
          else begin state <= MC_READY; end
        end
      end
      MC_RAM_FLUSH: begin
        if ((&flush_caddr[8:0] == 0) & (flush_caddr != flush_addr)) begin
          state <= MC_RAM_READ;
          flush_caddr <= {addr[31:9], 9'h00000};
          flush_addr <= {addr[31:9], 9'h00000};
        end else begin
          cache_enable <= 1;
          cache_overwrite <= 0;
          cache_addr <= flush_caddr;
          cache_in <= in;
          cache_we <= 0;

          ram_enable <= 1;
          ram_addr <= flush_caddr - START_RAM;
          ram_we <= 1;
          ram_oplen <= 2'h3;
          ram_in <= cache_out;
          state <= MC_RAM_FLUSH_WAIT;
        end
      end
      MC_RAM_FLUSH_WAIT: begin
        ram_enable <= 1;
        if (ram_valid) begin /// TODO: consider timeouts
          ram_enable <= 0;
          flush_caddr <= flush_caddr + 1;
          state <= MC_RAM_FLUSH;
        end
      end
      MC_RAM_READ: begin
        if ((&flush_caddr[8:0] == 0) & (flush_caddr != flush_addr)) begin
          cache_enable <= 0;
          state <= MC_READY;
        end else begin
          ram_enable <= 1;
          ram_addr <= addr - START_RAM;
          ram_we <= 0;
          ram_oplen <= 2'h3;
          state <= MC_RAM_READ_WAIT;
        end
      end
      MC_RAM_READ_WAIT: begin
        ram_enable <= 1;
        if (ram_valid) begin
          ram_enable <= 0;
          flush_caddr <= flush_caddr + 1;
          state <= MC_RAM_READ;

          cache_enable <= 1;
          cache_overwrite <= 1;
          cache_addr <= flush_caddr;
          cache_we <= 1;
          cache_in <= ram_out;
        end
      end
    endcase
  end

end

endmodule
