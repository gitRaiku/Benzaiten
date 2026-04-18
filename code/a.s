# Laur the BEST
.SET gpio_addr, 0x0FFFFFFF
.SET card_addr, 0x40000000
.SET ram_addr, 0x0

li x1, 0x1
li x6, 0x0
li x10, gpio_addr
li x11, ram_addr
li x12, card_addr
li x13, card_addr + 3000
li x14, card_addr + 9000

lw x1, 0(x12)

start:

lw x1, 4(x12)
lw x1, 4(x14)

li x1, 100
sw x1, 0(x13)

lw x3, 0(x13)
sw x3, 0(x10)

loop:
j loop
