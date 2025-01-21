module testbench();
  logic clk;
  logic rst_n; 

  controller con(clk, rst_n);

  initial begin
    rst_n = 1;
    #2;
    rst_n = 0;
    #2;
    rst_n = 1;
    #2;
  end

  always begin
    clk <= 1; #5;
    clk <= 0; #5;
  end
endmodule
