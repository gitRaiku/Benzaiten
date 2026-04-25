# Laur the BEST
.SET gpio_addr, 0x0FFFFFFF
.SET card_addr, 0x40000000
.SET ram_addr, 0x0

li x2, gpio_addr
li x3, 0xDEADBEEF
sw x3, -1(x2)
sb x3, -1(x2)
sb x3, -1(x2)
sb x3, -1(x2)
sb x3, -2(x2)

loop:
j loop
