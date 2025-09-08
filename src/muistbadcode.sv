/*
module sdram_controller(
    input  logic         clk,       // SDRAM clock
    input  logic         rst_n,
    input  logic [23:0]  addr,      // row/column address
    input  logic [31:0]  wdata,
    input  logic         rw,        // 1=read, 0=write
    input  logic         req,       // request valid
    output logic [31:0]  rdata,
    output logic         sdram_cke,
    output logic         sdram_cs,
    output logic         sdram_ras,
    output logic         sdram_cas,
    output logic         sdram_we,
    output logic [31:0]  sdram_dq,
    output logic [3:0]   sdram_dqm
);

// ------------------------------------------------------------
// Parameters: SDRAM timing (cycles at 133MHz)
// ------------------------------------------------------------
localparam integer T_POWERUP = 26595; // 200us / 7.52ns
localparam integer T_RCD     = 2;     // Example: RAS->CAS delay in cycles
localparam integer T_RP      = 2;     // Precharge time
localparam integer T_RFC     = 7;     // Auto-refresh time
localparam integer BURST_LEN = 4;     // Burst length

// ------------------------------------------------------------
// FSM States
// ------------------------------------------------------------
typedef enum logic [3:0] {
    S_POWERUP_WAIT,
    S_PRECHARGE_ALL,
    S_AUTO_REFRESH,
    S_MODE_REGISTER_SET,
    S_IDLE,
    S_BANK_ACTIVATE,
    S_READ_BURST,
    S_WRITE_BURST,
    S_PRECHARGE,
    S_WAIT
} state_t;

state_t state, next_state;

// ------------------------------------------------------------
// Counters
// ------------------------------------------------------------
logic [15:0] counter;       // Generic timing counter
logic [3:0]  burst_cnt;     // Burst counter

// Bank tracking (example: 4 banks)
typedef enum logic [1:0]{IDLE,BANK_ACTIVE,BANK_PRECHARGE} bank_state_t;
bank_state_t bank_state[3:0];
logic [11:0] active_row[3:0]; // Store active row per bank

// ------------------------------------------------------------
// FSM Sequential Logic
// ------------------------------------------------------------
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state   <= S_POWERUP_WAIT;
        counter <= 0;
        burst_cnt <= 0;
    end else begin
        state <= next_state;
        // update counter
        if (counter > 0) counter <= counter - 1;
    end
end

// ------------------------------------------------------------
// FSM Combinational Logic
// ------------------------------------------------------------
always_comb begin
    // Default outputs
    sdram_cke = 1;
    sdram_cs  = 1;
    sdram_ras = 1;
    sdram_cas = 1;
    sdram_we  = 1;
    sdram_dqm = 4'b1111;
    next_state = state;

    case(state)
        // ----------------------------------------------------
        S_POWERUP_WAIT: begin
            if (counter == 0) begin
                counter = T_RP; // precharge timing
                next_state = S_PRECHARGE_ALL;
            end
        end

        // ----------------------------------------------------
        S_PRECHARGE_ALL: begin
            // Issue Precharge all command
            sdram_cs  = 0;
            sdram_ras = 0;
            sdram_cas = 1;
            sdram_we  = 0;
            if (counter == 0) begin
                counter = T_RFC;
                next_state = S_AUTO_REFRESH;
            end
        end

        // ----------------------------------------------------
        S_AUTO_REFRESH: begin
            sdram_cs  = 0;
            sdram_ras = 0;
            sdram_cas = 0;
            sdram_we  = 1;
            if (counter == 0) begin
                counter = T_RP;
                next_state = S_MODE_REGISTER_SET;
            end
        end

        // ----------------------------------------------------
        S_MODE_REGISTER_SET: begin
            sdram_cs  = 0;
            sdram_ras = 0;
            sdram_cas = 0;
            sdram_we  = 0;
            next_state = S_IDLE;
        end

        // ----------------------------------------------------
        S_IDLE: begin
            if (req) begin
                next_state = S_BANK_ACTIVATE;
            end
        end

        // ----------------------------------------------------
        S_BANK_ACTIVATE: begin
            sdram_cs  = 0;
            sdram_ras = 0;
            sdram_cas = 1;
            sdram_we  = 1;
            counter = T_RCD;
            next_state = rw ? S_READ_BURST : S_WRITE_BURST;
        end

        // ----------------------------------------------------
        S_READ_BURST: begin
            sdram_cs  = 0;
            sdram_ras = 1;
            sdram_cas = 0;
            sdram_we  = 1;
            burst_cnt++;
            if (burst_cnt == BURST_LEN-1) begin
                burst_cnt = 0;
                next_state = S_PRECHARGE;
            end
        end

        // ----------------------------------------------------
        S_WRITE_BURST: begin
            sdram_cs  = 0;
            sdram_ras = 1;
            sdram_cas = 0;
            sdram_we  = 0;
            sdram_dqm = 4'b0000; // enable outputs
            burst_cnt++;
            if (burst_cnt == BURST_LEN-1) begin
                burst_cnt = 0;
                counter = T_WR;
                next_state = S_PRECHARGE;
            end
        end

        // ----------------------------------------------------
        S_PRECHARGE: begin
            sdram_cs  = 0;
            sdram_ras = 0;
            sdram_cas = 1;
            sdram_we  = 0;
            if (counter == 0) next_state = S_IDLE;
        end
    endcase
end

endmodule
*/
