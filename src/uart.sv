`timescale 1ns / 1ps

module uart #(parameter logic [7:0]BUFLEN=8, parameter BAUDRATE=115200, parameter logic [3:0]DATA_BITS=8, parameter logic [1:0]PARITY=1, parameter logic [1:0]STOPBITS=1) (
  input logic clk, rst,
  input logic uart_in, output logic uart_out,
  input logic enable, output logic valid,
  input logic [7:0]inbuf[7:0], input logic [7:0]inlen,

  input logic [7:0]outpos, /// TODO: Add error handling
  output logic [7:0]outbuf[7:0], output logic [7:0]outlen
  );

  logic clkin, rstin;
  uart_clk #(.BAUDRATE(BAUDRATE)) uclkin(.clk(clk), .rst(rstin), .out(clkin));
  logic clkout, rstout;
  uart_clk #(.BAUDRATE(BAUDRATE)) uclkout(.clk(clk), .rst(rstout), .out(clkout));

  typedef enum { 
    MC_IDLE,
    MC_START,
    MC_DATA
  } uart_state_t;

  uart_state_t statein;
  logic [7:0]inpos;
  logic [3:0]inbitpos;
  logic lastclkin;
  always @(posedge clk) begin
    valid <= 0;
    rstin <= 0;
    if (rst || !enable) begin
      lastclkin <= 0;
      statein <= MC_IDLE;
      uart_out <= 1;
      inpos <= 0;
      rstin <= 1;
      inbitpos <= 0;
    end else begin
      lastclkin <= clkin;
      unique case (statein)
        MC_IDLE: begin
          uart_out <= 1;
          if (inpos < inlen) begin
            rstin <= 1;
            statein <= MC_DATA;
            inbitpos <= 0;
          end
        end
        MC_DATA: begin
          if (lastclkin != clkin && clkin) begin
            inbitpos <= inbitpos + 1;
            if (inbitpos == 0) begin
              uart_out <= 0;
            end else if (inbitpos < 1 + DATA_BITS) begin
              uart_out <= inbuf[inpos[2:0]][inbitpos - 1];
            end else if (inbitpos == 1 + DATA_BITS && !PARITY[1]) begin
              uart_out <= (^inbuf[inpos[2:0]]) ^ PARITY[0];
            end else if (inbitpos < 1 + DATA_BITS + {3'h0, !PARITY[1]} + {2'h0, STOPBITS} - 1) begin
              uart_out <= 1;
            end else begin
              statein <= MC_IDLE;
              inpos <= inpos + 1;
              if (inpos == inlen - 1) begin
                valid <= 1;
              end
            end
          end
        end
      endcase
    end
  end

  uart_state_t stateout;
  logic [7:0]outbyte;
  logic [3:0]outbitpos;
  logic lastclkout;
  logic errout;
  always @(posedge clk) begin
    rstout <= 0;
    if (rst) begin outlen <= 0; end
    if (rst || !enable) begin
      lastclkout <= 0;
      stateout <= MC_IDLE;
      rstout <= 1;
      outbitpos <= 0;
      errout <= 0;
      outbyte <= 0;
    end else begin
      lastclkout <= clkout;
      unique case (stateout)
        MC_IDLE: begin
          if (!uart_in) begin
            stateout <= MC_DATA;
            outbitpos <= 0;
            errout <= 0;
            rstout <= 1;
          end
        end
        MC_DATA: begin
          if (lastclkout != clkout && clkout) begin
            outbitpos <= outbitpos + 1;
            if (outbitpos == 0) begin
              if (uart_in != 0) begin errout <= errout | 1; end
            end else if (outbitpos < 9) begin
              outbyte <= {outbyte[7:1], uart_in};
            end else if (outbitpos == 9 && !PARITY[1]) begin
              if ((^outbyte) ^ PARITY[0] != uart_in) begin errout <= errout | 1; end
            end else if (outbitpos < 9 + {3'h0, !PARITY[1]} + {2'h0, STOPBITS} - 1) begin
              if (!uart_in) begin errout <= errout | 1; end
            end else begin
              stateout <= MC_IDLE;
              if (outlen == outpos) begin
                outlen <= outlen + 1;
                if (outlen == BUFLEN) begin outlen <= 0; end
                outbuf[outlen[2:0]] <= outbyte;
              end else begin
                errout <= errout | 1;
              end
            end
          end
        end
      endcase
    end
  end


endmodule

// verilator lint_off DECLFILENAME
module uart_clk #(parameter BAUDRATE=115200) (
    input logic clk, input logic rst,
    output wire out
  );

  localparam [31:0]timer = 50000000/BAUDRATE;
  logic [31:0]clkcounter;
  assign out = clkcounter < (timer / 2);
  always_ff @(posedge clk) begin
    if (rst) begin
      clkcounter <= 0;
    end else begin
      clkcounter <= clkcounter + 1;
      if (clkcounter == timer) begin
        clkcounter <= 0;
      end
    end
  end
endmodule
