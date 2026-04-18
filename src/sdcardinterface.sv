`timescale 1ns / 1ps

module sdcardinterface #(parameter logic [9:0]SD_BLOCKLEN=512) (
  input logic clk, rst,
  input logic enable, input logic we,
  output logic error,
// verilator lint_off UNUSEDSIGNAL
  input logic [31:0]addr, 
// verilator lint_on UNUSEDSIGNAL
  output logic outvalid, output logic [7:0]out,
  output logic valid, 

  output logic invalid, input logic [7:0]in,

  output spi_ss_n, output spi_sclk,
  output spi_mosi, input spi_miso
  );

  /// RPI : black red nothing brown white orange purple
  /// FPGA: black red nothing green purple white blue
/*
Sent 0(0), recieved 1 01
Got init 1
Sent 8(2852126720), recieved 5 05
Got check sdv2 5
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 1 01
Sent 55(0), recieved 1 01
Sent 41(0), recieved 0 00
Get in baebee
Sent 17(0), recieved 0 00
CMD17 00   0 
00020406080a0c0e10121416181a1c1e20222426282a2c2e30323436383a3c3e40424446484a4c4e50525456585a5c5e6062646668
6a6c6e70727476787a7c7e80828486888a8c8e90929496989a9c9ea0a2a4a6a8aaacaeb0b2b4b6b8babcbec0c2c4c6c8caccced0d2
d4d6d8dadcdee0e2e4e6e8eaeceef0f2f4f6f8fafcfe00020406080a0c0e10121416181a1c1e20222426282a2c2e30323436383a3c
3e40424446484a4c4e50525456585a5c5e60626466686a6c6e70727476787a7c7e80828486888a8c8e90929496989a9c9ea0a2a4a6
a8aaacaeb0b2b4b6b8babcbec0c2c4c6c8caccced0d2d4d6d8dadcdee0e2e4e6e8eaeceef0f2f4f6f8fafcfe00020406080a0c0e10
121416181a1c1e20222426282a2c2e30323436383a3c3e40424446484a4c4e50525456585a5c5e60626466686a6c6e70727476787a
7c7e80828486888a8c8e90929496989a9c9ea0a2a4a6a8aaacaeb0b2b4b6b8babcbec0c2c4c6c8caccced0d2d4d6d8dadcdee0e2e4
e6e8eaeceef0f2f4f6f8fafcfe00020406080a0c0e10121416181a1c1e20222426282a2c2e30323436383a3c3e40424446484a4c4e
50525456585a5c5e60626466686a6c6e70727476787a7c7e80828486888a8c8e90929496989a9c9ea0a2a4a6a8aaacaeb0b2b4b6b8
babcbec0c2c4c6c8caccced0d2d4d6d8dadcdee0e2e4e6e8eaeceef0f2f4f6f8fafcfe
*/



  typedef enum { 
    SDC_1_PULSE_1 = 11, 
    SDC_1_PULSE_2 = 12,
    SDC_2_INIT_1 = 21, 
    SDC_2_INIT_2 = 22, 
    SDC_3_CHECKSDV2 = 30, 
    SDC_4_SDV1_1 = 41, 
    SDC_4_SDV1_2 = 42, 
    SDC_4_SDV1_3 = 43, 
    SDC_4_SDV1_4 = 44, 
    SDC_5_INIT_FINISH = 50, 
    SDC_CMD_WAIT = 101, 
    SDC_WAIT = 102, 
    SDC_READY = 103, 
    SDC_ERROR = 404,
    SDC_READ_1 = 81, 
    SDC_READ_2 = 82, 
    SDC_READ_3 = 83, 
    SDC_READ_4 = 84 ,
    SDC_WRITE_1 = 91, 
    SDC_WRITE_2 = 92, 
    SDC_WRITE_3 = 93,
    SDC_WRITE_4 = 94,
    SDC_WRITE_5 = 95
  } sdc_mstate_t;

  typedef enum { 
    SDCE_NONE = 0, 
    SDCE_UNSUPPORTED_VER = 10, 
    SDCE_SDV1_INIT_FAIL = 20, 
    SDCE_CMD_TIMEOUT = 30, 
    SDCE_READ_TIMEOUT = 40, 
    SDCE_READ_2_ERROR = 52, 
    SDCE_READ_3_ERROR = 53, 
    SDCE_WRITE_TIMEOUT = 60 
  } sdc_errors_t;

  (* mark_debug = "true" *) sdc_mstate_t state;
  sdc_mstate_t nstate, nnstate;
// verilator lint_off UNUSEDSIGNAL
  (* mark_debug = "true" *) sdc_errors_t cerror; /// TODO: Error handling
  logic sdver; // 0: SDV1, 1: SDV2 TODO: SDV2
// verilator lint_on UNUSEDSIGNAL
  logic [7:0]state_timeout;
  logic [9:0]state_timeout1;
  (* mark_debug = "true" *) logic [9:0]blockpos;

// verilator lint_off UNDRIVEN
// verilator lint_off UNUSEDSIGNAL
  logic [15:0][7:0]send_buffer;
  logic [15:0][7:0]send_recieve;
// verilator lint_on UNDRIVEN
  (* mark_debug = "true" *) logic [7:0]last_rec_byte; // TODO: Remove
// verilator lint_on UNUSEDSIGNAL
  assign last_rec_byte = send_recieve[0];
  logic [7:0]send_buffer_len;
  logic [7:0]send_curbufpos;
  (* mark_debug = "true" *) logic send_enable, send_valid, send_cs;

  task automatic  rst_recieve_buffer;
    send_recieve[0] <= 8'hff;
    send_recieve[1] <= 8'hff;
    send_recieve[2] <= 8'hff;
    send_recieve[3] <= 8'hff;
    send_recieve[4] <= 8'hff;
    send_recieve[5] <= 8'hff;
    send_recieve[6] <= 8'hff;
    send_recieve[7] <= 8'hff;
    send_recieve[8] <= 8'hff;
    send_recieve[9] <= 8'hff;
    send_recieve[10] <= 8'hff;
    send_recieve[11] <= 8'hff;
    send_recieve[12] <= 8'hff;
    send_recieve[13] <= 8'hff;
    send_recieve[14] <= 8'hff;
    send_recieve[15] <= 8'hff;
  endtask

  task automatic  rst_send_buffer;
    send_buffer[0] <= 8'hff;
    send_buffer[1] <= 8'hff;
    send_buffer[2] <= 8'hff;
    send_buffer[3] <= 8'hff;
    send_buffer[4] <= 8'hff;
    send_buffer[5] <= 8'hff;
    send_buffer[6] <= 8'hff;
    send_buffer[7] <= 8'hff;
    send_buffer[8] <= 8'hff;
    send_buffer[9] <= 8'hff;
    send_buffer[10] <= 8'hff;
    send_buffer[11] <= 8'hff;
    send_buffer[12] <= 8'hff;
    send_buffer[13] <= 8'hff;
    send_buffer[14] <= 8'hff;
    send_buffer[15] <= 8'hff;
  endtask

  task automatic error_out; input sdc_errors_t cur_error;
    cerror <= cur_error;
    state <= SDC_ERROR;
  endtask
  task automatic wait_cmd; input sdc_mstate_t next_state;
    state <= SDC_WAIT; state_timeout <= 100; nstate <= SDC_CMD_WAIT; nnstate <= next_state;
  endtask
  task automatic wait_valid; input sdc_mstate_t next_state;
    state <= SDC_WAIT; nstate <= next_state;
  endtask

  logic spi_enable, spi_valid;
  logic spi_cs;
  logic [7:0]spi_obuf, spi_ibuf;

  localparam logic [31:0]CLK_FAST = 20;
  localparam logic [31:0]CLK_SLOW = 400;
  logic [31:0]clkc_fast;
  logic [31:0]clkc_slow;
  logic spi_clk_fast;
  logic spi_clk_slow;
  assign spi_clk_fast = clkc_fast > (CLK_FAST / 2);
  assign spi_clk_slow = clkc_slow > (CLK_SLOW / 2);
  always @(posedge clk) begin
    if (rst) begin
      clkc_fast <= 0;
      clkc_slow <= 0;
    end else begin
      clkc_fast <= clkc_fast + 1;
      if (clkc_fast == CLK_FAST) begin clkc_fast <= 0; end
      clkc_slow <= clkc_slow + 1;
      if (clkc_slow == CLK_SLOW) begin clkc_slow <= 0; end
    end
  end

  logic spi_clk_speed;
  (* mark_debug = "true" *) wire spi_clk = spi_clk_speed ? spi_clk_fast : spi_clk_slow; /// TODO: Look into this
  // (* mark_debug = "true" *) wire spi_clk = spi_clk_fast;
  (* mark_debug = "true" *) logic [6:0]debug_clk;
  always @(posedge clk) begin
    if (rst) begin
      debug_clk <= 0;
    end else begin
      debug_clk <= debug_clk + 1;
    end
  end
  spi sdspi(
      .clk(clk), .rst(rst),
      .enable(spi_enable), .valid(spi_valid),
      .cclk(spi_clk), .cs(spi_cs),
      .obuf(spi_obuf), .ibuf(spi_ibuf),
      .ss_n(spi_ss_n), .sclk(spi_sclk),
      .mosi(spi_mosi), .miso(spi_miso)
    );

  always_ff @(posedge clk) begin
    send_valid <= 0;
    spi_enable <= 0;
    spi_cs <= 0;
    send_curbufpos <= 0;
    if (rst) begin
      rst_recieve_buffer;
    end else begin
      if (send_enable) begin
        spi_cs <= send_cs;
        spi_enable <= 1;
        send_curbufpos <= send_curbufpos;

        if (send_curbufpos == send_buffer_len) begin
          send_valid <= 1;
          send_curbufpos <= 0;
        end else begin
          if (spi_valid) begin
            send_curbufpos <= send_curbufpos + 1;
            send_recieve <= { send_recieve[14:0], spi_ibuf };
          end else begin
            spi_obuf <= send_buffer[send_curbufpos];
          end
        end
      end
    end
  end

  task automatic send_cmd; input [7:0]cmd; input [31:0]arg;
    send_cs <= 1;
    send_enable <= 1;
    send_buffer[0] <= 8'hff;
    send_buffer[1] <= cmd | 8'h40;
    send_buffer[2] <= arg[31:24];
    send_buffer[3] <= arg[23:16];
    send_buffer[4] <= arg[15:8];
    send_buffer[5] <= arg[7:0];
    if (cmd == 0) begin
      send_buffer[6] <= 8'h95;
    end else if (cmd == 8) begin
      send_buffer[6] <= 8'h87;
    end else if (cmd == 55) begin
      send_buffer[6] <= 8'h01;
    end else begin
      send_buffer[6] <= 8'hFF;
    end
    send_buffer_len <= 7;
  endtask

  always_ff @(posedge clk) begin
    outvalid <= 0;
    invalid <= 0;
    valid <= 0;
    if (rst) begin
      state <= SDC_1_PULSE_1;
      send_cs <= 0;
      send_buffer_len <= 0;
      send_enable <= 0;
      spi_clk_speed <= 0;
      out <= 0;
      valid <= 0;
      sdver <= 0;
      state_timeout <= 0;
      state_timeout1 <= 0;
      blockpos <= 0;
      rst_send_buffer;
      cerror <= SDCE_NONE;
    end else begin
      unique case (state)
        SDC_1_PULSE_1: begin
          send_buffer[0] <= 8'hff;
          send_buffer[1] <= 8'hff;
          send_buffer[2] <= 8'hff;
          send_buffer[3] <= 8'hff;
          send_buffer[4] <= 8'hff;
          send_buffer[5] <= 8'hff;
          send_buffer[6] <= 8'hff;
          send_buffer[7] <= 8'hff;
          send_buffer[8] <= 8'hff;
          send_buffer[9] <= 8'hff;
          send_buffer_len <= 10;
          send_enable <= 1;
          send_cs <= 0;
          spi_clk_speed <= 0;
          state_timeout <= 100;
          wait_valid(SDC_1_PULSE_2);
        end
        SDC_1_PULSE_2: begin
          send_cs <= 0;
          if (state_timeout == 0) begin
            state <= SDC_2_INIT_1;
          end else begin
            state_timeout <= state_timeout - 1;
          end
        end
        SDC_2_INIT_1: begin
          send_cmd(0, 0);
          wait_cmd(SDC_2_INIT_2);
        end
        SDC_2_INIT_2: begin
          send_cmd(8, 32'h1AA);
          wait_cmd(SDC_3_CHECKSDV2);
        end
        SDC_3_CHECKSDV2: begin 
          if ((send_recieve[0] & 8'h04) != 0) begin
            state <= SDC_4_SDV1_1;
            state_timeout1 <= 1000;
          end else begin
            error_out(SDCE_UNSUPPORTED_VER); /// TODO: Implement SDV2
          end
        end
        SDC_4_SDV1_1: begin
          send_cmd(55, 0);
          wait_cmd(SDC_4_SDV1_2);
        end
        SDC_4_SDV1_2: begin
          send_cmd(41, 0);
          wait_cmd(SDC_4_SDV1_3);
        end
        SDC_4_SDV1_3: begin
          if (send_recieve[0] == 0) begin state <= SDC_4_SDV1_4; end 
          else begin 
            state_timeout1 <= state_timeout1 - 1;
            if (state_timeout1 == 0) begin
              error_out(SDCE_SDV1_INIT_FAIL);
            end else begin
              state <= SDC_4_SDV1_1; 
            end
          end
        end
        SDC_4_SDV1_4: begin /// TODO: Maybe useless?
          send_buffer[0] <= 8'hff;
          send_buffer[1] <= 8'hff;
          send_buffer[2] <= 8'hff;
          send_buffer[3] <= 8'hff;
          send_buffer[4] <= 8'hff;
          send_buffer_len <= 5;
          send_enable <= 1;
          send_cs <= 1;
          wait_valid(SDC_5_INIT_FINISH);
        end
        SDC_5_INIT_FINISH: begin
          spi_clk_speed <= 1;
          send_enable <= 0;
          state <= SDC_READY;
        end
        SDC_CMD_WAIT: begin
          if (send_valid) begin
            send_enable <= 0;
            state_timeout <= state_timeout - 1;
            if (state_timeout == 0) begin
              error_out(SDCE_CMD_TIMEOUT);
            end
            if ((send_recieve[0] & 8'h80) == 0) begin
              state <= nstate;
            end
          end else begin
            state <= SDC_CMD_WAIT;
            send_buffer[0] <= 8'hff;
            send_buffer_len <= 1;
            send_enable <= 1;
            send_cs <= 1;
          end
        end
        SDC_WAIT: begin 
          if (send_valid) begin
            state <= nstate;
            nstate <= nnstate;
          end
        end
        SDC_READ_1: begin
          send_cmd(17, {addr[31:8], 8'h0});
          wait_cmd(SDC_READ_2);
        end
        SDC_READ_2: begin
          state <= SDC_READ_3;
          state_timeout1 <= 1000;
          /*
          if (send_recieve[0] != 0) begin
            error_out(SDCE_READ_2_ERROR);
          end
          */
        end
        SDC_READ_3: begin
          if (send_valid) begin
            send_enable <= 0;
            state_timeout1 <= state_timeout1 - 1;
            if (state_timeout1 == 0) begin
              error_out(SDCE_READ_TIMEOUT);
            end
            if (send_recieve[0] != 8'hff) begin
              if (send_recieve[0] != 8'hfe) begin
                error_out(SDCE_READ_3_ERROR);
              end else begin
                state <= SDC_READ_4;
                blockpos <= 0;
              end
            end
          end else begin
            state <= SDC_READ_3;
            send_buffer[0] <= 8'hff;
            send_buffer_len <= 1;
            send_enable <= 1;
            send_cs <= 1;
          end
        end
        SDC_READ_4: begin
          if (blockpos < SD_BLOCKLEN + 2) begin
            if (send_valid) begin
              blockpos <= blockpos + 1;
              send_enable <= 0;
              out <= send_recieve[0];
              outvalid <= 1;
            end else begin
              send_buffer[0] <= 8'hff;
              send_buffer_len <= 1;
              send_enable <= 1;
              send_cs <= 1;
            end
          end else begin
            blockpos <= 0;
            valid <= 1;
            state <= SDC_READY;
          end
        end
        SDC_WRITE_1: begin
          send_cmd(24, {addr[31:8], 8'h0});
          wait_cmd(SDC_WRITE_2);
        end
        SDC_WRITE_2: begin
          send_buffer[0] <= 8'hfe;
          send_buffer_len <= 1;
          send_enable <= 1;
          send_cs <= 1;
          blockpos <= 0;
          state <= SDC_WRITE_3;
        end
        SDC_WRITE_3: begin
          if (send_enable) begin
            if (send_valid) begin
              send_enable <= 0;
              blockpos <= blockpos + 1;
              if (blockpos == SD_BLOCKLEN + 1) begin
                state <= SDC_WRITE_4;
                state_timeout1 <= 1023;
              end
            end
          end else begin
            send_buffer_len <= 1;
            send_enable <= 1;
            send_cs <= 1;
            if (blockpos < SD_BLOCKLEN) begin
              send_buffer[0] <= in;
              invalid <= 1;
            end else begin
              send_buffer[0] <= (blockpos == SD_BLOCKLEN) ? 8'h69 : 8'h67;
            end
          end
        end
        SDC_WRITE_4: begin
          if (send_valid) begin
            send_enable <= 0;
            state_timeout1 <= state_timeout1 - 1;
            if (state_timeout1 == 0) begin
              error_out(SDCE_WRITE_TIMEOUT);
            end
            if (send_recieve[0] != 0) begin
              valid <= 1;
              state <= SDC_READY;
            end
          end else begin
            send_enable <= 1;
            send_buffer_len <= 1;
            send_cs <= 1;
            send_buffer[0] <= 8'hff;
          end
        end
        SDC_READY: begin 
          send_enable <= 0;
          send_cs <= 1; /// TODO: I don't wanna reset the cs ever do i?
          if (enable) begin
            if (we) begin
              // state <= SDC_WRITE;
            end else begin
              state <= SDC_READ_1;
            end
          end
        end
        SDC_ERROR: begin 
          state <= SDC_1_PULSE_1;
        end
      endcase
    end
  end

endmodule
