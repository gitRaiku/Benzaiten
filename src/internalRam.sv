`timescale 1ns / 1ps

module internalRam
  #(parameter logic [7:0]MEM_LEN=50) (
  input logic clk, rst,
  input logic enable, output logic valid,
  input logic [31:0]addr,
  input logic [1:0]oplen, input logic we,   /// TODO: Add input logic for non 8-bit values
  input logic [31:0]data, output logic [31:0]result, /// TODO: Currently top 8-bits for every cell
  output logic [15:0]gpio
  );

  // (* ram_style = "block" *)
  // TODO: Make the ram actually use the correct fabric
  logic [7:0]ram[MEM_LEN]; /// TODO: Fix
  /*
  initial begin
    $readmemh(MEM_INIT_FILE, ram);
  end
  */
  always_ff @(posedge clk) begin
    if (rst) begin
      {ram[ 3], ram[ 2], ram[ 1], ram[ 0]} <= 32'h00100093;
      {ram[ 7], ram[ 6], ram[ 5], ram[ 4]} <= 32'h00100113;
      {ram[11], ram[10], ram[ 9], ram[ 8]} <= 32'h00000513;
      {ram[15], ram[14], ram[13], ram[12]} <= 32'h03600593;
      {ram[19], ram[18], ram[17], ram[16]} <= 32'h02000a13;
      {ram[23], ram[22], ram[21], ram[20]} <= 32'h00100113;
      {ram[27], ram[26], ram[25], ram[24]} <= 32'h00000313;
      {ram[31], ram[30], ram[29], ram[28]} <= 32'h002081b3;
      {ram[35], ram[34], ram[33], ram[32]} <= 32'h00010093;
      {ram[39], ram[38], ram[37], ram[36]} <= 32'h00018113;
      {ram[43], ram[42], ram[41], ram[40]} <= 32'h00130313;
      {ram[47], ram[46], ram[45], ram[44]} <= 32'h02602aa3;
      {ram[51], ram[50], ram[49], ram[48]} <= 32'hfeb516e3;
      valid <= 0;
      result <= 0;
      gpio <= 0;
    end else begin
      valid <= 0;
      if (enable) begin
        if (addr == 32'hFFFFFFFF) begin
          if (we) begin
            gpio <= data[15:0];
          end else begin
            result <= {16'h0000, gpio};
          end
          valid <= 1;
        end else begin
          if (we) begin
            unique case (oplen)
              2'b00: {ram[addr + 0]                                             } <= data[ 7:0];
              2'b01: {ram[addr + 1], ram[addr + 0]                              } <= data[15:0];
              2'b10: {ram[addr + 2], ram[addr + 1], ram[addr + 0]               } <= data[23:0];
              2'b11: {ram[addr + 3], ram[addr + 2], ram[addr + 1], ram[addr + 0]} <= data[31:0];
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
        end
        valid <= 1;
      end
    end
  end


endmodule
