module testbench();
  logic clk;
  logic rst_n; 

  controller con(clk, rst_n);

  logic [31:0]instructions[8];
  logic [5:0]maxInstr;
  logic [5:0]curi;

  initial begin
    rst_n = 1;
    instructions[0] = 32'b0000000_00000_00000_000_00000_0110011; /// NOP
    instructions[1] = 32'b0000000_00000_00000_000_00000_0110011; /// NOP
    instructions[2] = 32'b0000000_00000_00000_000_00000_0110011; /// NOP
    instructions[3] = 32'b000000000001_00010_000_00010_0010011 ; /// x1 = 0 + 1
    instructions[4] = 32'b000000000010_00011_000_00011_0010011 ; /// x1 = 0 + 1
    instructions[5] = 32'b0000000_00011_00010_100_00010_0110011; /// x1 = x1 + x1
    instructions[6] = 32'b0000000_00011_00010_100_00011_0110011; /// x1 = x1 + x1
    instructions[7] = 32'b0000000_00011_00010_100_00010_0110011; /// x1 = x1 + x1

    /*
    * x2 = 0 + 100
    * x3 = 0 + 011
    * x2 = x2 ^ x3
    * x3 = x2 ^ x3
    * x2 = x2 ^ x3
    */

    curi = 0;
    maxInstr = 7;
    #2;
    rst_n = 0;
    #2;
    rst_n = 1;
    #2;
  end

  always @(posedge clk) begin
    if (curi == maxInstr + 1) begin
      $stop;
    end
    con.instruction = instructions[curi];
    curi = curi + 1;
  end

  always begin
    clk <= 1; #5;
    clk <= 0; #5;
  end
endmodule
