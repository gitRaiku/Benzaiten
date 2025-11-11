# Laur the BEST
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
  lui x31, 0x20
  # addi x31, x0, 0x7FF
  jal x2, writedelay

  or x26, x26, x27
  addi x31, x0, 0x20
  jal x2, writedelay # call delay with 0x20

  and x26, x25, x28
  addi x31, x0, 0x7FF
  jal x2, writedelay

  or x26, x26, x27
  addi x31, x0, 0x20
  jal x2, writedelay # call delay with 0x20

  jalr x0, x1, 0x0

__start:
  addi x27, x0, 0x1
  slli x27, x27, 16 # x27 = 0x10000
  addi x28, x27, -1   # x28 = 0xFFFF
  addi x5, x0, 0x0

  main:
    addi x5, x5, 0x1
    mv x25, x5
    jal x1, write
    j main

inff:
j inff
