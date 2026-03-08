`timescale 1ns / 1ps

module memcache(
  input logic clk, rst,

  input logic [31:0]addr, input logic [31:0] in,
  input logic rw, input logic enable, input logic overwrite,
  output logic valid, output logic [31:0]out
  );

  (* ram_style = "distributed" *) logic [7:0][7:0][511:0][31:0]cache; 
  /// cache[tag][redir[tag][gat]][addr] = int
  
  logic [2:0]tag;  // 8x (small)
  logic [20:0]id;  // 8x (big)

  logic [7:0][7:0][20:0]mapping; /// mapping[tag][gat] = id (in accessing order)
  logic [7:0][7:0]fdn; /// fdn[tag][gat] = funky dirty native HTML5
  logic [7:0][7:0][2:0]redir; /// mapping[tag][gat] = id (in accessing order)

  logic [2:0]gat;

  always_comb begin
    tag = addr[10:8];
    id = addr[31:11];

         if (mapping[tag][0] == id) gat = 0;
    else if (mapping[tag][1] == id) gat = 1;
    else if (mapping[tag][2] == id) gat = 2;
    else if (mapping[tag][3] == id) gat = 3;
    else if (mapping[tag][4] == id) gat = 4;
    else if (mapping[tag][5] == id) gat = 5;
    else if (mapping[tag][6] == id) gat = 6;
    else                            gat = 7;

    out = cache[tag][gat][addr[7:0]];
    valid = (mapping[tag][gat] == id);
  end

  logic [3:0]cpos;
  always_ff @(posedge clk) begin
    if (rst) begin
      cpos <= 0;
    end else begin
      if (cpos < 7) begin
        cpos <= cpos + 1;
        fdn[cpos] <= 0;
        redir[cpos] <= {3'h0, 3'h1, 3'h2, 3'h3, 3'h4, 3'h5, 3'h6, 3'h7}; 
      end else begin /// TODO: Make it so it's actually the last accessed cache line
        if (enable && rw) begin
          if (valid) begin
            cache[tag][redir[tag][gat]][addr] <= in;
            fdn[tag][gat] <= 1;
          end else begin
            if (overwrite) begin
              mapping[tag] <= {id, mapping[tag][7:1]};
              redir[tag] <= {redir[tag][0], redir[tag][7:1]};
              fdn[tag] <= {1'b1, fdn[tag][7:1]};
              cache[tag][0][addr] <= in;
            end
          end
        end
      end
    end
  end

  /***************
  *
  *
  * 
  *     00 01 02 03 04 05 06 07
  * 00: -- -- -- -- -- -- -- --
  * 01: -- -- -- -- -- -- -- --
  * 02: -- -- -- -- -- -- -- --
  * 03: -- -- -- -- -- -- -- --
  * 04: -- -- -- -- -- -- -- --
  * 05: -- -- -- -- -- -- -- --
  * 06: -- -- -- -- -- -- -- --
  *
  *
  *
  ****************/
endmodule
