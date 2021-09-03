//fast LCM (Linear Congruental Method) Integer Random numbers
//compile with z88dk
#include <graphics.h>
#include <stdio.h>

int rand(unsigned char *p) __z88dk_fastcall __naked {
#asm
    push DE
    push HL
    ld a,(HL)
    ld DE, (rand_value16)
	  ld H, E
	  ld L, 1
	  add HL, DE
	  add HL, DE
	  add HL, DE
	  add HL, DE
	  add HL, DE
	  ld A, H
	  ld (rand_value16), HL
    pop HL
    pop DE
    ld a, (rand_value8)
    ld C, 3
    and C
    ld (HL),a
	  ret
    rand_value16:
	  db 0xf0
    rand_value8:
	  db 0xf1
#endasm
}

void main() {

  int x, y, w;
  char a;
  a = 42;

  clg();

  draw(0, 0, 142, 0);
  draw(142, 0, 142, 46);
  draw(142, 46, 0, 46);
  draw(0, 46, 0, 0);

  for (x = 2; x < 141; x += 2) {
    for (y = 2; y < 45; y += 2) {
      w = 0;
      plot(x, y);

      while (!w) {
        rand(&a); // gives 4(!) random numbers, from 0-3

        switch (a) {
        case 0:
          if (!point(x, y - 1)) {
            plot(x, y - 1);
            w++;
            break;
          } else {
            break;
          }

        case 1:
          if (!point(x, y - 1)) {
            plot(x, y - 1);
            w++;
            break;
          } else {
            break;
          }

        case 2:
          if (!point(x, y + 1)) {
            plot(x, y + 1);
            w++;
            break;
          } else {
            break;
          }

        case 3:
          if (!point(x + 1, y)) {
            plot(x + 1, y);
            w++;
            break;
          } else {
            break;
          }
        }
      }
    }
  }

  while (getk() != 10) {
  };
}