# Laur the BEST
.SET gpio_addr, 0x0FFFFFFF
.SET card_addr, 0x40000000
.SET ram_addr, 0x0

.SET unit, 500000

li a2, gpio_addr
li a1, ~0

loop:

call linie
call linie
call punct
call punct
call linie
call linie

li x10, unit
call sleep

j loop

linie:
mv t1, ra 

sw x0, 0(a2)
li x10, unit * 3
call sleep

sw a1, 0(a2)
li x10, unit
call sleep

mv ra, t1
ret

punct:
mv t1, ra 

sw x0, 0(a2)
li x10, unit
call sleep

sw a1, 0(a2)
li x10, unit
call sleep

mv ra, t1
ret

sleep:
addi x10, x10, -1
bne x10, x0, sleep

ret
