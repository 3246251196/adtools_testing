#include <dlfcn.h>
#include <iostream>

std::string so_str = "librelo.so";
std::string sym_str = "add42";

int main( int argc, char *argv[] )
{
  (void)argc;
  (void)argv;
  int ret = 10;
  void *dl = dlopen( so_str.c_str(), RTLD_LAZY ), *sym = NULL;
  if( dl )
    {
      sym = dlsym( dl, sym_str.c_str() );
      if ( sym )
	{
	  int ans = ((int (*)(int))(sym))( 42 );
	  std::cout << "Answer " << ans << std::endl;
	  ret = 0;
	}
      else
	{
	  std::cerr << "Unable to locate symbol: `" << sym_str << "'" << std::endl;
	}
    }
  else
    {
      std::cerr << "Unable to load shared object: `" << so_str << "'" << std::endl;
    }

  if ( dl )
    {
      dlclose( dl );
    }

  return ret;
}
