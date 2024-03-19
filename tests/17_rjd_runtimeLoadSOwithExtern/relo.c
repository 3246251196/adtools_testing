#include <dlfcn.h>
extern void someExternFn( void );

int add42( int x )
{
  void *ptr = dlopen("libextern.so",RTLD_LAZY);
  void *someExternFn = dlsym(ptr,"someExternFn");


  ((void (*)(void))someExternFn)();

  dlclose(ptr);
  return x+42;
}
