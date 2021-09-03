// slow unoptimized double precision floating point random numbers
// compile with z88dk
#include <graphics.h>
#include <math.h>
#include <stdio.h>

void main() {

  int x, y, a, w;

  clg(); //clear graphics

  draw(0, 0, 142, 0);
  draw(142, 0, 142, 46);
  draw(142, 46, 0, 46);
  draw(0, 46, 0, 0);

  for (x = 2; x < 141; x += 2) {
    for (y = 2; y < 45; y += 2) {
      w = 0;
      plot(x, y);

      while (!w) {
        a = (int)(3 * fprand() + 1);
        switch (a) {
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