# Laur the BEST
.SET gpio_addr, 0x0FFFFFFF
.SET ram_addr, 0x0

addi x1, x0, 0x1
addi x6, x0, 0x0
li x10, gpio_addr
li x11, ram_addr

start:

addi x1, x1, 1
sw x1, 0(x10)
# lw x4, 10(x11)


j start
