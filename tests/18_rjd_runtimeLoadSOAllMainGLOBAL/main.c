#include <dlfcn.h>
#include <stdio.h>

void someExternFn( void )
{
  printf("Inside main's someExternFn()\n");
}

const char so_str[] = "librelo.so", sym_str[] = "add42";
const char so_str1[] = "libextern.so", sym_str1[] = "someExternFn";

int main( int argc, char *argv[] )
{
  (void)argc;
  (void)argv;
  int ret = 10;
  void *dl1 = dlopen( so_str1, RTLD_LAZY|RTLD_GLOBAL );
  void *dl = dlopen( so_str, RTLD_NOW|RTLD_GLOBAL ), *sym = NULL;
  if( dl && dl1 )
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
	  fprintf( stderr, "Unable to locate symbols: '%s'\n",dlerror());
	}
    }
  else
    {
      fprintf( stderr, "Unable to load shared objects: '%s'\n",dlerror());
    }

  if ( dl )
    {
      dlclose( dl );
    }
  if ( dl1 )
    {
      dlclose( dl1 );
    }

  someExternFn();

  return ret;
}
