# Laur the BEST
.SET gpio_addr, 0x0FFFFFFF
.SET card_addr, 0x40000000
.SET ram_addr, 0x0

li x10, gpio_addr
li x3, card_addr
li x2, 0xdeadbeef

li x3, card_addr + 2000
li x4, card_addr + 4000

start:

sw x3, 0(x3)
addi x3, x3, 4
bne x3, x4, start


li x1, gpio_addr
li x5, 0

loop:

li x2, 1000000
sleep:
addi x2, x2, -1
bne x2, x0, sleep

sw x5, 0(x1)
xor x5, x5, ~0

j loop
