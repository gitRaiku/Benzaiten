# addi x5, x0, 0xFF # Start addr
# lui x6, 1 # x6 = 4096
# addi x6, x0, 0xFFFF # End addr

addi x5, x0, 0xFF
addi x6, x0, 1
slli x6, x6, 24
.SET gpio_addr, -1
addi x20, x0, gpio_addr
addi x7, x0, 0x42  # Error register 

addi x1, x0, -4  # Iter 
setloop:
  addi x1, x1, 0x4
  add x3, x1, x5  # Target addr
  sub x2, x6, x1  # Random number
  sw x2, 0(x3)
bne x3, x6, setloop

addi x1, x0, -4  # Iter 
checkloop:
  addi x1, x1, 0x4
  add x3, x1, x5  # Target addr
  sub x2, x6, x1  # Random number
  lw x10, 0(x3)   # Get num
  xor x2, x10, x2 # Xor of target and actual number
  sltiu x2, x2, 1 # x2 = (x2 < 1)
  xori x2, x2, 1  # x2 = x2 ^ 1
  add x7, x7, x2
bne x3, x6, checkloop

infloop:
  sw x7, 0(x20)
j infloop
