#include <stdio.h>
#include "sharedObj.h"

int main( int argc, char *argv[] )
{
  (void)argc;
  (void)argv;
  int ret = startAThread();
  return ret;
}
