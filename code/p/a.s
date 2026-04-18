# Laur the BEST
.SET gpio_addr, 0x0FFFFFFF
.SET card_addr, 0x40000000
.SET ram_addr, 0x0

.SET unit, 250000

li a3, card_addr
li a2, gpio_addr
li a1, ~0

loop:

jal ra, linie
jal ra, linie
jal ra, punct
jal ra, punct
jal ra, linie
jal ra, linie

li x10, unit * 9
jal ra, sleep

j loop

linie:
mv t1, ra 

sw x0, 0(a2)
li x10, unit * 3
jal ra, sleep

sw a1, 0(a2)
li x10, unit
jal ra, sleep

mv ra, t1
ret

punct:
mv t1, ra 

sw x0, 0(a2)
li x10, unit
jal ra, sleep

sw a1, 0(a2)
li x10, unit
jal ra, sleep

mv ra, t1
ret

sleep:
addi x10, x10, -1
bne x10, x0, sleep

ret
