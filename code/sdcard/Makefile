all: a.bin

a.bin: uart.s
	rv32-as --march=rv32i uart.s -o a.o
	rv32-objcopy -O binary a.o a.bin
	rm a.o

clean:
	rm a.bin

install: a.bin
	dd if=a.bin of=/dev/mmcblk0
