#include <dlfcn.h>
#include <iostream>

std::string so_str = "librelo.so";
std::string sym_str = "_Z5add42i"; /* c++ mangled */
std::string sym_str_c = "add42another";

int main( int argc, char *argv[] )
{
  (void)argc;
  (void)argv;
  int ret = 10;
  void *dl = dlopen( so_str.c_str(), RTLD_LAZY ), *sym = NULL, *sym2 = NULL;
  if( dl )
    {
      sym = dlsym( dl, sym_str.c_str() );
      if ( sym )
	{
	  int ans = ((int (*)(int))(sym))( 42 );

	  sym2 = dlsym( dl, sym_str_c.c_str() );
	  if ( sym2 )
	    {
	      int ans2 = ((int (*)(int))(sym2))( ans );
	      std::cout << "Answer: " << ans2 << std::endl;
	      ret = 0;
	    }
	  else
	    {
	      std::cerr << "Unable to locate symbol: `" << sym_str_c << "'" << std::endl;
	    }
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
