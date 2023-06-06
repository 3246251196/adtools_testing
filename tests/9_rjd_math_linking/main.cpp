#include <cmath>
#include <stdio.h>

#define PI 3.141592F

int main(int argc, char *argv[])
{
  (void)argc; (void) argv;
  { /* Float Math: SIN */
    float res = sinf(PI/2.0F);
    printf("%.3f\n", res);
  } /**/

  { /* Long Math: FLOOR */
    long double res = floorl( 42.49L);
    printf("%.3Lf\n", res);
  } /**/

  { /* "Double": CEIL */
    double res = ceil( 42.49 /* defaults to double */);
    printf("%.3f\n", res);
  }
  return 0;
}
