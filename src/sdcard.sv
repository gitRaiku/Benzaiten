`timescale 1ns / 1ps

typedef enum { SDC_READ, SDC_WRITE, SDC_NONE } sdc_type;
module sdcard(
  input logic clk, rst,

  input sdc_type command, input logic enable,
  input [31:0]addr, input [31:0]val,
  output [31:0]res, output logic valid,

  output spi_ss_n, output spi_sclk,
  output spi_mosi, input spi_miso
  );

  logic spi_enable, spi_valid;
  logic spi_cclk;
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
  wire spi_clk = spi_clk_speed ? spi_clk_fast : spi_clk_slow;
  spi sdspi(
      .rst(rst),
      .enable(spi_enable), .valid(spi_valid),
      .cclk(spi_clk), .cs(spi_cs),
      .obuf(spi_obuf), .ibuf(spi_ibuf),
      .ss_n(spi_ss_n), .sclk(spi_sclk),
      .mosi(spi_mosi), .miso(spi_miso)
    );

  logic [15:0][7:0]send_buffer;
  logic [15:0][7:0]send_recieve;
  logic [7:0]send_buffer_len;
  logic [7:0]send_curbufpos;
  logic send_enable, send_valid, send_cs;
  always_ff @(posedge clk) begin
    send_valid <= 0;
    spi_enable <= 0;
    spi_cs <= 0;
    send_curbufpos <= 0;
    if (send_enable) begin
      spi_cs <= send_cs;
      spi_enable <= 1;
      send_curbufpos <= send_curbufpos;

      if (send_buffer_len == send_curbufpos) begin
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

  typedef enum { SDC_1_PULSE, SDC_2_INIT, SDC_3_CHECKSDV2, SDC_4_SDV1_1, SDC_4_SDV1_2, SDC_4_SDV1_3, SDC_4_SDV1_4, SDC_5_INIT_FINISH, SDC_CMD_WAIT, SDC_READ_1, SDC_READ_2, SDC_READ_3, SDC_WAIT, SDC_READY, SDC_ERROR } sdc_mstate_t;
  typedef enum { SDCE_UNSUPPORTED_VER, SDCE_SDV1_INIT_FAIL, SDCE_CMD_TIMEOUT, SDCE_READ_TIMEOUT, SDC_READ_ERROR } sdc_errors_t;
  sdc_mstate_t state, nstate;
  sdc_errors_t error;
  logic statefc;
  logic [7:0]state_timeout;
  logic [7:0]state_timeout1;
  logic cmdvalid;
  logic sdver; // 0: SDV1, 1: SDV2

  task automatic error_out; input sdc_errors_t cur_error;
    error <= cur_error;
    state <= SDC_ERROR;
  endtask
  task automatic wait_cmd; input sdc_mstate_t next_state;
    state <= SDC_CMD_WAIT; state_timeout <= 100; nstate <= next_state;
  endtask
  task automatic wait_valid; input sdc_mstate_t next_state;
    state <= SDC_WAIT; nstate <= next_state;
  endtask

  task automatic send_cmd; input [7:0]cmd; input [31:0]arg;
    send_cs <= 1;
    send_buffer[0] <= 8'hff;
    send_buffer[1] <= cmd | 8'h40;
    send_buffer[2] <= arg[7:0];
    send_buffer[3] <= arg[15:8];
    send_buffer[4] <= arg[23:16];
    send_buffer[5] <= arg[31:24];
    if (cmd == 0) begin
      send_buffer[6] <= 8'h95;
    end else if (cmd == 8) begin
      send_buffer[6] <= 8'h87;
    end else begin
      send_buffer[6] = 8'h01;
    end
  endtask

  localparam logic [31:0]sd_blocklen = 512;
  logic [31:0]sd_rbuf;

  always_ff @(posedge clk) begin
    cmdvalid <= 0;
    if (rst) begin
      state <= SDC_1_PULSE;
      send_cs <= 0;
      send_buffer_len <= 0;
      send_enable <= 0;
      spi_clk_speed <= 0;
    end else begin
      unique case (state)
        SDC_1_PULSE: begin
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
          send_buffer_len <= 11;
          send_enable <= 1;
          send_cs <= 0;
          spi_clk_speed <= 0;
          wait_valid(SDC_2_INIT);
        end
        SDC_2_INIT: begin
          send_cmd(0, 0);
          wait_cmd(SDC_3_CHECKSDV2);
        end
        SDC_3_CHECKSDV2: begin 
          if ((send_recieve[0] & 8'h04) != 0) begin
            state <= SDC_4_SDV1_1;
            state_timeout1 <= 100;
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
          end
        end
        SDC_READ_1: begin
          send_cmd(17, addr);
          state_timeout1 <= 100;
          wait_cmd(SDC_READ_2);
        end
        SDC_READ_2: begin
          if (send_valid) begin
            send_enable <= 0;
            state_timeout1 <= state_timeout1 - 1;
            if (state_timeout1 == 0) begin
              error_out(SDCE_READ_TIMEOUT);
            end
            if (send_recieve[0] != 8'hff) begin
              state <= SDC_READ_3;
            end
          end else begin
            send_buffer[0] <= 8'hff;
            send_buffer_len <= 1;
            send_enable <= 1;
            send_cs <= 1;
          end
        end
        SDC_READ_3: begin
          if (send_recieve[0] == 8'hfe) begin
            error_out(SDC_READ_ERROR);
          end else begin
            
          end
        end
        SDC_READY: begin 
          if (enable) begin
            if (command == SDC_READ) begin
              state <= SDC_READ_1;
            end else if (command == SDC_WRITE) begin
            end
          end
        end
        SDC_ERROR: begin end
      endcase
    end
  end
endmodule
