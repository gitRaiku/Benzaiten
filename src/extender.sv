`timescale 1ns / 1ps

/// I LOVE EXTENDER!!
module extender(
  input logic [31:0]num,
  input logic immU,
  output logic [31:0]out
  );

  assign out = immU ? num : { {20{num[12]}}, num[11:0] };

endmodule

