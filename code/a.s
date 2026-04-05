# Laur the BEST
.SET gpio_addr, 0x0FFFFFFF
.SET card_addr, 0x40000000
.SET ram_addr, 0x0

addi x1, x0, 0x1
addi x6, x0, 0x0
li x10, gpio_addr
li x11, ram_addr
li x12, card_addr

start:

lw x1, 0(x12)
sw x1, 0(x11)

addi x12, x12, 1
addi x11, x11, 1
# addi x1, x1, 1
# sw x1, 0(x10)
# lw x4, 10(x11)


j start
