# Laur the BEST
.SET gpio_addr, 0x0FFFFFFF
.SET card_addr, 0x40000000
.SET ram_addr, 0x0

loop:

li x2, gpio_addr
li x3, 'H'
sb x3, -1(x2)
li x3, 'e'
sb x3, -1(x2)
li x3, 'l'
sb x3, -1(x2)
li x3, 'l'
sb x3, -1(x2)
li x3, 'o'
sb x3, -1(x2)
li x3, ' '
sb x3, -1(x2)
li x3, 'w'
sb x3, -1(x2)
sb x3, -2(x2)
li x3, 'o'
sb x3, -1(x2)
li x3, 'r'
sb x3, -1(x2)
li x3, 'l'
sb x3, -1(x2)
li x3, 'd'
sb x3, -1(x2)
li x3, '!'
sb x3, -1(x2)
li x3, '\r'
sb x3, -1(x2)
li x3, '\n'
sb x3, -1(x2)
sb x3, -2(x2)

j loop
