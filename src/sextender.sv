module sextender(input logic [31:0]in, input logic usgn,
                 input logic [1:0]len, output logic [31:0]out);
  always_comb begin
    if (usgn) begin
      unique case (len)
        2'b00: out = { {24{1'b0}}, in[7:0] } ;
        2'b01: out = { {16{1'b0}}, in[15:0] } ;
        2'b10: out = { {8{1'b0}}, in[23:0] } ;
        2'b11: out = { in[31:0] } ;
      endcase
    end else begin
      unique case (len)
        2'b00: out = { {24{in[7]}}, in[7:0] } ;
        2'b01: out = { {16{in[15]}}, in[15:0] } ;
        2'b10: out = { {8{in[23]}}, in[23:0] } ;
        2'b11: out = { in[31:0] } ;
      endcase
    end
  end
endmodule
