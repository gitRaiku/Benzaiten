module sdramController(
  input logic clk, rst_n,
  input logic [24:0]  addr,
  input logic [1:0]   oplen,
  input logic [31:0]  wdata,
  input logic         rw,
  input logic         enable,
  output logic [11:0] s_address,
  output logic [1:0]  s_bs,
  output logic [3:0]  s_dq,
  output logic        s_cs,
  output logic        s_ras,
  output logic        s_cas,
  output logic        s_we,
  output logic [1:0]  s_dqm,
  output logic [1:0]  s_clk,
  output logic [1:0]  s_cke
);

typedef enum logic [3:0] {
  S_IDLE,
  S_DECIDE,
  S_IDLE_ON,
  S_POWERUP_WAIT,
  S_PRECHARGE_ALL,
  S_AUTO_REFRESH,
  S_MODE_REGISTER_SET,
  S_BANK_ACTIVATE,
  S_READ_BURST,
  S_WRITE_BURST,
  S_PRECHARGE,
  S_WAIT
} state_t;

state_t state, next_state;
typedef enum logic [1:0] { IDLE,BANK_ACTIVE, BANK_PRECHARGE } bank_state_t;

logic [15:0]counter;

localparam integer TSECPOWERUP   = 10000 + 4000; /// 50MHz -> 20ns; 200uS -> 10000cycles
localparam integer TRCD       = 2; // Example: RAS->CAS delay in cycles
localparam integer TRC = 60; // Auto Refresh (60 cycles)
localparam integer TRP = 2; // Precharge Time (2 cycles)
localparam integer BURSTLEN   = 4; // Burst length

logic [3:0]startupStep;

/*
 * StartUp
 *
 * WaitStart, Precharge, Mode Register State
 * AutoRefresh 1-8,
 *
 */

always_ff @(negedge rst_n or posedge clk) begin
  if (!rst_n) begin
    counter <= 0;
    state <= S_DECIDE;
    next_state <= S_DECIDE;
    startupStep <= 8'h00;
  end else begin
    if (next_state == S_DECIDE) begin
      if (startupStep < 11) begin
        counter <= 1;
        startupStep <= startupStep + 1;
        case (startupStep)
          0: begin
            state <= S_POWERUP_WAIT;
            counter <= TSECPOWERUP;
          end
          1: begin
            state <= S_PRECHARGE_ALL;
          end
          2: begin
            state <= S_MODE_REGISTER_SET;
          end
          3, 4, 5, 6, 7, 8, 9, 10: begin
            state <= S_AUTO_REFRESH;
          end
          default: begin end
        endcase
      end
    end
    state <= next_state;
    if (counter > 0) begin counter <= counter - 1; end
  end
end

always_comb begin
  s_cs = 1'b0;
  s_ras = 1'b0;
  s_cas = 1'b0;
  s_we = 1'b0;
  s_bs = 2'b00;
  s_address = 12'h0000;
  s_dqm = 2'b00;
  s_cke = 2'b00;
  s_dqm = 2'b00;
  next_state = state;

  case (state)
    S_IDLE_ON: begin
      s_cs = 1'b1;
      s_cke = 2'b11;
      if (counter == 0) begin
        next_state = S_DECIDE;
      end
    end
    S_POWERUP_WAIT: begin
      s_cs  = 0;
      s_ras = 0;
      s_cas = 0;
      s_we  = 0;
      if (counter == 0) begin
        counter = TSECPOWERUP;
        next_state = S_PRECHARGE_ALL;
      end
    end
    S_PRECHARGE_ALL: begin
      s_cs  = 1'b0;
      s_ras = 1'b0;
      s_cas = 1'b1;
      s_we  = 1'b0;
      s_address[10] = 1'b1;
      s_cke = 2'b11;
      s_dqm = 2'b00;

      if (counter == 0) begin
        counter = 999990; /* PRECHARGE CHECK */
        next_state = S_IDLE_ON;
      end
    end
    S_MODE_REGISTER_SET: begin
      s_cke = 2'b11;
      s_cs  = 1'b0;
      s_ras = 1'b0;
      s_cas = 1'b0;
      s_we  = 1'b0;

      if (counter == 0) begin
        counter = 99990; /* PRECHARGE CHECK */
        next_state = S_PRECHARGE_ALL;
      end
    end
    S_AUTO_REFRESH: begin
      s_cs  = 1'b0;
      s_ras = 1'b0;
      s_cas = 1'b0;
      s_we  = 1'b1;
      s_cke = 2'b11;
      s_dqm = 2'b11;

      if (counter == 0) begin
        counter = TRC;
        next_state = S_PRECHARGE_ALL;
      end
    end
    default: begin end
  endcase
end

endmodule
