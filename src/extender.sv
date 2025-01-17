`timescale 1ns / 1ps

/// I LOVE EXTENDER!!
module extender(
  input logic [11:0]num,
  output logic [31:0]out
  );

  assign out = { {20{num[11]}}, num[10:0] };

endmodule
