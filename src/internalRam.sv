`timescale 1ns / 1ps

module internalRam(
  input logic clk, rst_n,
  input logic enable, output logic valid,
  input logic [24:0]addr,
  input logic [1:0]oplen, input logic writeEnable,   /// TODO: Add input logic for non 8-bit values
  input logic [31:0]data, output logic [31:0]result /// TODO: Currently top 8-bits for every cell
  );

  logic [7:0]ram[400];
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      {ram[ 3], ram[ 2], ram[ 1], ram[ 0]} <= 32'h00100093;
      {ram[ 7], ram[ 6], ram[ 5], ram[ 4]} <= 32'h00100113;
      {ram[11], ram[10], ram[ 9], ram[ 8]} <= 32'h00000513;
      {ram[15], ram[14], ram[13], ram[12]} <= 32'h02000593;
      {ram[19], ram[18], ram[17], ram[16]} <= 32'h00450513;
      {ram[23], ram[22], ram[21], ram[20]} <= 32'h002081b3;
      {ram[27], ram[26], ram[25], ram[24]} <= 32'h00010093;
      {ram[31], ram[30], ram[29], ram[28]} <= 32'h00018113;
      {ram[35], ram[34], ram[33], ram[32]} <= 32'h00152023;
      {ram[39], ram[38], ram[37], ram[36]} <= 32'hfeb516e3;
      valid <= 0;
      result <= 0;
    end else begin
      valid <= 0;
      if (enable) begin
        if (writeEnable) begin
          unique case (oplen)
            2'b00: ram[addr + 0] <= data[7:0];
            2'b01: ram[addr + 1] <= data[15:0];
            2'b10: ram[addr + 2] <= data[23:0];
            2'b11: ram[addr + 3] <= data[31:0];
          endcase
        end else begin
          unique case (oplen)
            2'b00: result <= {24'h0000, ram[addr + 0]};
            2'b01: result <= {16'h0000, ram[addr + 1], ram[addr + 0]};
            2'b10: result <= { 8'h0000, ram[addr + 2], ram[addr + 1],
                                        ram[addr + 0]};
            2'b11: result <= {ram[addr + 3], ram[addr + 2],
                              ram[addr + 1], ram[addr + 0]};
          endcase
        end
        valid <= 1;
      end
    end
  end


endmodule
