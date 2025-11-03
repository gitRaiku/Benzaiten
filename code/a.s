# Laur the best
addi x1, x0, 0x1
addi x2, x0, 0x1
addi x10, x0, 0x0
addi x11, x0, 0x20
start:
addi x10, x10, 0x4
add x3, x1, x2
addi x1, x2, 0x0
addi x2, x3, 0x0
sw x1, 0x40(x10)
bne x10, x11, start
