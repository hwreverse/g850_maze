# g850_maze : "Maze" for Sharp PC-G850/V/VS 
"Maze" Problem Implementations in C and Z80 Assembler for Sharp PC-G850/V/VS Pocket Computers





Programmed by :<br>
	**HWR0** (@r0_hw) <br>
	*evilhardware@mail.ru*


maze_std.c	:
-------------
	Slow double precision floating point random numbers
	Straightforward C code implementation with graphics and math library
	Compiled by z88dk with generic math library
	Speed = 4.77sec approximately
	
maze_fastc1.c :
---------------
	Fast Linear Congruential Method Integer PRNG coded in inline z80 assembler
	Straightforward C code implementation with graphics library (no math library)
	Compiled by z88dk
	Speed = 1.1sec approximately

maze_fastc2.c :
---------------

	Fast Linear Congruential Method Integer PRNG - modification proposed by @fujitanozomu
	Straightforward C Code implementation with graphics library (no math library)
	Compiled by z88dk
	Speed = *to be tested (should be <1.1sec!)

maze_asm.asm :
--------------
	Straightforward exclusive Assembler implementation
	GFX routines partially implemented from libg800
	Fast Linear Congruential Method Integer PRNG 
	Image generation in memory, then copy to VRAM with single update to screen 
	Speed = 0.15-0.25s (!) 

maze_fasm.asm :
--------------
	Fastest implementation up to date
  Straightforward exclusive Assembler implementation
  GFX routines partially implemented from libg800
	Fast Linear Congruential Method Integer PRNG - modification proposed by @fujitanozomu
  Optimised jumps, Sacrificed memory over speed by copying the point(X,Y) routine 
	Image generation in memory, then copy to VRAM with single update to screen
	Speed < 0.15 (screen refresh is slow, cannot be measured visually any longer)
  
  
  
##TODO: 	
		Implement precise time measurement on PC-G850/V/VS by flipping PIO pin before and after "maze" to measure the delay between with a Logic Analyzer or an Arduino!
		
    
    
THANKS TO:
----------

*@hd61yukimizake*, for providing the mathematical "maze problem" idea on Twitter, <br>
*@fujitanozomu* for his PRNG variant <br>
*The original author of the libg800 library* <br>




Provided as is,<br>
by HWR0 (@r0_hw)
P.S.: Here , a part of my pocket computer collection!
