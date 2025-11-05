.set IMEM_LEN, 54

addi x1, x0, 0x1
addi x2, x0, 0x1
addi x10, x0, 0x0
addi x11, x0, IMEM_LEN
addi x20, x0, 0x20

addi x2, x0, 0x1
addi x6, x0, 0x0

start:

# addi x10, x10, 0x2

add x3, x1, x2
mv x1, x2
mv x2, x3

addi x6, x6, 1
sw x6, IMEM_LEN - 1(x0)

bne x10, x11, start




# Laur the best
# addi x1, x0, 0x1
# addi x2, x0, 0x1
# addi x10, x0, 0x0
# addi x11, x0, 0x20
# start:
# addi x10, x10, 0x4
# add x3, x1, x2
# addi x1, x2, 0x0
# addi x2, x3, 0x0
# sw x1, 600(x10)
# bne x10, x11, start
