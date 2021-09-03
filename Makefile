TARGETS = maze_std.ihx maze_fastc1.ihx maze_fastc2.ihx maze_asm.ihx maze_fasm.ihx
CCFLAGS = +g800 -create-app -clib=g850b # 6 lines/V
CC = zcc

ASMFLAGS = +g800 --no-crt -create-app -Cz"--ihex --org=0x100"


all: $(TARGETS)

maze_std.ihx: maze_std.c
	$(CC) $(CCFLAGS) -lm -o$*.ihx $<
	$(RM) *.rom
	

.SUFFIXES: .c .ihx .lib .asm


.c.ihx:
	$(CC) $(CCFLAGS) -o$*.ihx $<
	$(RM) *.rom
.c.lib:
	$(CC) +g800 -x -o$* $<
.asm.ihx:
	$(CC) $(ASMFLAGS) -o$*.ihx $<
	$(RM) *.rom

.PHONY: clean
clean:
	$(RM) $(TARGETS) *.o *.def *.bin *.rom *.lst *.lib g800user.txt
