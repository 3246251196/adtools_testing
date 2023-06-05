#include <math.h>
#include <stdio.h>

#define PI 3.141592F

int main(int argc, char *argv[])
{
  float res = sinf(PI/2.0F);
  printf("%.3f", res);
  return 0;
}
