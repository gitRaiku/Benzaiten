`timescale 1ns / 1ps

module uart #(parameter BUFLEN=8, parameter BAUDRATE=115200) (
  input logic clk, rst,
  input logic enable, output logic valid,
  input logic [8 * BUFLEN - 1:0]inbuf, input logic [7:0]inlen,

  input logic [7:0]outpos,
  output logic [8 * BUFLEN - 1:0]outbuf, input logic [7:0]outlen,
  output logic error, output logic recieved,
  );

endmodule
