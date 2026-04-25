`timescale 1ns / 1ps

package defs;

typedef enum bit[4:0] { ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_XOR, ALU_EQN, 
                        ALU_LT, ALU_LTU, ALU_GT, ALU_GTU, ALU_SLL, ALU_SLR, 
                        ALU_SAR, ALU_MUL, ALU_MULH, ALU_MULHU, ALU_MULHSU,
                        ALU_DIV, ALU_DIVU, ALU_REM, ALU_REMU,
                        ALU_INVALID } aluop_t;
typedef enum bit[2:0] { INS_R, INS_I, INS_S, INS_B, INS_U, INS_J, INS_INVALID } instype_t;

endpackage
