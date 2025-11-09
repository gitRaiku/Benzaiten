# Laur the BEST
.SET gpio_addr, -1
.SET ram_addr, 0xFF


addi x1, x0, 0x1
addi x6, x0, 0x0
addi x10, x0, gpio_addr
addi x11, x0, ram_addr

start:

# add x2, x1, x1
# add x1, x1, x2
# mv x2, x1
# srli x2, x2, 0x3
# xor x1, x1, x2

addi x1, x1, 1
sw x1, 10(x11)
lw x4, 10(x11)

sw x4, 0(x10)

j start




# ADDI X1, X0, 0X1
# ADDI X2, X0, 0X1
# ADDI X10, X0, 0X0
# ADDI X11, X0, 0X20
# START:
# ADDI X10, X10, 0X4
# ADD X3, X1, X2
# ADDI X1, X2, 0X0
# ADDI X2, X3, 0X0
# SW X1, 600(X10)
# BNE X10, X11, start
