all: a.bin

a.bin: a.s
	rv32-as --march=rv32i a.s -o a.o
	rv32-objcopy -O binary a.o a.bin
	rm a.o

install: a.bin
	dd if=a.bin of=/dev/mmcblk0
