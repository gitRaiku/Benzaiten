package defs;
typedef enum { INS_R, INS_I, INS_S, INS_B, INS_U, INS_J, INS_INVALID } instype_t;
typedef enum { ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_XOR, ALU_EQN, ALU_LT, ALU_LTU, ALU_GT,
               ALU_GTU, ALU_SLL, ALU_SLR, ALU_SAR, ALU_INVALID } aluop_t;
endpackage
