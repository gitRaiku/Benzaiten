`timescale 1ns / 1ps

module memcache #(parameter GATLEN=8) (
  input logic clk, rst,

  input logic [31:0]addr, input logic [31:0] in,
  input logic we, input logic enable, 
  input logic overwrite, output logic valid, 
  output logic [31:0]out, output logic dirty
  );

  /// Consider two cycle access from this for faster timing within cycles?
  (* ram_style = "block" *) logic [31:0]cache[6 * (GATLEN-1) * 15:0];  /// 32 byte cache lines
  /// cache[tag][redir[tag][gat]][laddr] = int
  
  logic [2:0]tag;  // 6:0x (small)
  logic [24:0]id;  // 7:0x (big)

  logic [7:0][GATLEN - 1:0][24:0]mapping; /// mapping[tag][gat] = id (in accessing order)
  logic [7:0][GATLEN - 1:0]      fdn; /// fdn[tag][gat] = funky dirty native HTML5
  logic [7:0][GATLEN - 1:0][ 2:0]redir; /// cache[tag][redir[tag][gat]][laddr] = int

  logic [2:0]gat;
  logic [3:0]laddr;

  logic [31:0]memread;
  logic [31:0]cachemissaddr;
  logic cachemiss;
  assign out = cachemiss ? cachemissaddr : memread;

  always_comb begin
    laddr = addr[3:0];
    tag = addr[6:4];
    id = addr[31:7];

         if (mapping[tag][0] == id) gat = 0;
    else if (mapping[tag][1] == id) gat = 1;
    else if (mapping[tag][2] == id) gat = 2;
    else                            gat = 3;

    dirty = fdn[tag][redir[tag][gat]] | (!valid);
  end

  logic [3:0]cpos;
  always_ff @(posedge clk) begin
    valid <= 0;
    cachemiss <= 0;
    if (rst) begin
      cpos <= 0;
      memread <= 0;
    end else begin
      if (cpos < 8) begin
        cpos <= cpos + 1;
        fdn[cpos] <= 0;
        redir[cpos] <= {3'h0, 3'h2, 3'h2, 3'h3, 3'h4, 3'h5, 3'h6, 3'h7}; 
        mapping[cpos] <= {8{~25'h0}};
      end else begin
        if (enable) begin
          valid <= (mapping[tag][gat] == id);
          if (mapping[tag][gat] == id) begin
            if (we) begin
              cache[{tag,redir[tag][gat],laddr}] <= in;
              fdn[tag][gat] <= 1;
            end else begin
              memread <= cache[{tag,redir[tag][gat],laddr}];
            end
          end else begin
            if (overwrite) begin
              mapping[tag] <= {id, mapping[tag][GATLEN-1:1]};
              redir[tag] <= {redir[tag][0], redir[tag][GATLEN-1:1]}; /// TODO: Make it so it's actually the last accessed cache line
              fdn[tag] <= {1'b1, fdn[tag][GATLEN-1:1]};
              cache[{tag,redir[tag][gat],laddr}] <= in;
            end else begin
              cachemissaddr <= {mapping[tag][redir[tag][0]], tag, 4'h0};
              cachemiss <= 1;
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
