#include <pthread.h>
#include <stdio.h>

__thread int i;

void *fn( void* )
{
  printf("Created thread addr of i: %p\n",&i);
  i = 0;
  while(i++ < 1000000000);
  printf("Created thread val of i : %i\n",i);
}

int main(void)
{
  pthread_t t;
  printf("Parent thread addr of i : %p\n",&i);
  if ( pthread_create( &t, NULL, fn, NULL ) )
    {
      return 10;
    }

  if ( pthread_join( t, NULL ) )
    {
      return 10;
    }

  printf("Parent thread val of i  : %i\n",i);
  return 0;
}
