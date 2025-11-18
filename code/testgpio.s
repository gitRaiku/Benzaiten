# Laur the BEST
# Ramchecker v0.1α
.set RAM_START, 0xFF
.set RAM_END, 0x1000000
.set DELAY, 0x300
j __start

writedelay: # delay in x31
  sw x26, -1(x0) # Write gpio
  addi x30, x0, 0x0
  delayloop:
  addi x30, x30, 0x1
  bne x30, x31, delayloop
  jalr x0, x2, 0x0

write: # low 16 bits of x25
  and x26, x25, x28
  li x31, DELAY
  jal x2, writedelay

  or x26, x26, x27
  li x31, DELAY
  jal x2, writedelay

  jalr x0, x1, 0x0

__start:
  addi x27, x0, 0x1
  slli x27, x27, 16 # x27 = 0x10000
  addi x28, x27, -1   # x28 = 0xFFFF

  li x5, RAM_START
  li x6, RAM_END
  writeall:
    sw x5, 0(x5)
    addi x5, x5, 0x4
    blt x5, x6, writeall

  li x5, RAM_START
  readall:
    lw x7, 0(x5)

    mv x25, x5
    jal x1, write
    jal x1, write
    mv x25, x7
    jal x1, write

    addi x5, x5, 0x4
    blt x5, x6, readall

  main:
    j main

inff:
j inff
