#include <stdio.h>

extern int add42(int);

int main( void )
{
  int ans = add42( 42 );
  printf("Answer: %d\n", ans);

  return 0;
}
