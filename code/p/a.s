# Laur the BEST
.SET gpio_addr, 0x0FFFFFFF
.SET card_addr, 0x40000000
.SET ram_addr, 0x0

li x10, gpio_addr
li x3, card_addr
addi x3, x3, 2000
li x2, 0xdeadbeef

# start:

# sw x3, 0(x10)
# addi x3, x3, 4
# addi x3, x3, 48
# sw x2, 0(x3)


sw x2, 0(x3)
addi x3, x3, 2000
sw x2, 0(x3)

start:
j start
