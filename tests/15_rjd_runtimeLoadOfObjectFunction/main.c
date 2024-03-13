#include <dlfcn.h>
#include <stdio.h>

const char so_str[] = "librelo.so", sym_str[] = "add42";

int main( int argc, char *argv[] )
{
  (void)argc;
  (void)argv;
  int ret = 10;
  void *dl = dlopen( so_str, RTLD_LAZY ), *sym = NULL;
  if( dl )
    {
      sym = dlsym( dl, sym_str );
      if ( sym )
	{
	  int ans = ((int (*)(int))(sym))( 42 );
	  printf("Answer: %d\n", ans);
	  ret = 0;
	}
      else
	{
	  fprintf( stderr, "Unable to location symbol: `%s'\n", sym_str );
	}
    }
  else
    {
      fprintf( stderr, "Unable to load shared object: `%s'\n", so_str );
    }

  if ( dl )
    {
      dlclose( dl );
    }

  return ret;
}
