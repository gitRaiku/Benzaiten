`timescale 1ns / 1ps

module internalRam #(parameter GPIO_ADDR=32'hFFFFFFFF) (
  input logic clk, rst,
  input logic enable, output logic valid,
  input logic [31:0]addr,
  input logic [1:0]oplen, input logic we,   /// TODO: Add input logic for non 8-bit values
  input logic [31:0]in, output logic [31:0]out, /// TODO: Currently top 8-bits for every cell
  output logic [31:0]gpio,

  input logic uart_in, output logic uart_out
  );

  // TODO: Make the ram actually use the correct fabric
  (* ram_style = "block" *) logic [31:0]ram[512]; /// TODO: Fix

  initial begin
    $readmemh("ram.mem", ram);
  end

  logic uart_enable, uart_valid;
  localparam [7:0]UART_BUFLEN = 8;
  logic [7:0]uart_inbuf[7:0];
  logic [7:0]uart_outbuf[7:0];
  logic [7:0]uart_inlen, uart_outpos, uart_outlen;
  uart #(.BUFLEN(UART_BUFLEN)) uart_1(
      .clk(clk), .rst(rst), .enable(uart_enable), .valid(uart_valid),
      .uart_in(uart_in), .uart_out(uart_out),
      .inbuf(uart_inbuf), .inlen(uart_inlen), .outpos(uart_outpos),
      .outbuf(uart_outbuf), .outlen(uart_outlen)
    );

  logic _unused_ok;
  assign _unused_ok = &oplen;

  localparam logic[31:0]UART_WRITE_BYTE = GPIO_ADDR - 1;
  localparam logic[31:0]UART_WRITE_FLUSH = GPIO_ADDR - 2;
  localparam logic[31:0]UART_READ_AVAILABLE = GPIO_ADDR - 3;
  localparam logic[31:0]UART_READ_BYTE = GPIO_ADDR - 4;

  always_comb begin
    valid = 0;
    if (enable) begin
      case (addr)
        UART_WRITE_FLUSH: if (uart_inlen > 0) valid = uart_valid;
        default: valid = 1;
      endcase
    end
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      out <= 0;
      gpio <= 0;
      uart_inlen <= 0;
      uart_outpos <= 0;
      uart_enable <= 0;
    end else begin
      uart_enable <= 0;
      if (enable) begin
        case (addr)
          GPIO_ADDR: begin
            if (we) begin
              gpio <= in;
            end else begin
              out <= gpio;
            end
          end
          UART_WRITE_BYTE: begin
            if (uart_inlen + {6'h0, oplen} + 1 > UART_BUFLEN) begin
              /// TODO: Add erroring
            end else begin
                             uart_inbuf[uart_inlen[2:0] + {1'b0, oplen} - 0] <= in[ 7: 0];
              if (oplen > 0) uart_inbuf[uart_inlen[2:0] + {1'b0, oplen} - 1] <= in[15: 8];
              if (oplen > 1) uart_inbuf[uart_inlen[2:0] + {1'b0, oplen} - 2] <= in[23:16];
              if (oplen > 2) uart_inbuf[uart_inlen[2:0] + {1'b0, oplen} - 3] <= in[31:24];
              uart_inlen <= uart_inlen + {6'h0, oplen} + 1;
            end
          end
          UART_WRITE_FLUSH: begin
            if (uart_inlen > 0) begin
              if (uart_valid) begin
                uart_inlen <= 0;
              end else begin
                uart_enable <= 1;
              end
            end
          end
          UART_READ_AVAILABLE: begin
            out <= {31'h0, uart_outpos != uart_outlen};
          end
          UART_READ_BYTE: begin
            if (oplen != 1 || uart_outpos == uart_outlen) begin
              out <= -1;
            end else begin
              out <= {24'h0, uart_outbuf[uart_outpos[2:0]]};
              uart_outpos <= uart_outpos + 1;
              if (uart_outpos == UART_BUFLEN - 1) begin
                uart_outpos <= 0;
              end
            end
          end

          default: begin out <= ram[addr >> 2]; end
        endcase
      end
    end
  end

endmodule
