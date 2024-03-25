#include <stdio.h>
#include <pthread.h>
#include "sharedObj.hpp"

int count = 0;

void *threadFn( void* );

int startAThread( void )
{
  pthread_t t0;
  if ( pthread_create( &t0, NULL, threadFn, NULL ) )
    {
      fprintf( stderr, "Error creating thread\n" );
      return 10;
    }
  pthread_join( t0, NULL );
  printf( "Count: %d\n", count );
  return 0;
}

void *threadFn( void* a )
{
  (void)a;
  while( count < 100000000 )
    {
      ++count;
    }
  return a;
}
