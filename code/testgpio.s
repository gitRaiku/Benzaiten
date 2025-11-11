# Laur the BEST
j __start

func:
addi x30, x0, 0x1
jalr x1, 0x0

__start:

jal x1, func
jal x1, func
jal x1, func

inff:
j inff


/*
.SET gpio_addr, -1
.SET ram_addr, 0xFF

addi x20, x0, 0x1
addi x21, x0, gpio_addr

addi x10, x0, 0x10

jalr x1

pula:
j pula
call waitmuch
call waitmuch
call waitmuch
call waitmuch


j start

start:
j start
# addi x1, x1, 1
# sw x1, 0(x21)
# call waitmuch
# j waitmuch


waitmuch:
addi x29, x0, 0x0
addi x30, x0, 0x1
slli x21, x21, 8

# waitmuchloop:
# addi x29, x29, 0x1
# bne x29, x30, waitmuchloop

ret

j start*/
