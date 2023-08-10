#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

void test_worker(int, char**);

static int RET = EXIT_SUCCESS;

static char *tests[2][2] = { { "dlopen_sample", "dog" }, { "dlopen_sample", "cat" } };

void test_worker(int argc, char **argv)
{
  void *handle;
  void (*func_print_name)(const char*);

  if (argc != 2) {
    fprintf(stderr, "Usage: %s animal_type\n", argv[0]);
    RET = EXIT_FAILURE;
    return;
  }

  if (strcmp(argv[1], "dog") == 0) {
    handle = dlopen("libdog.so", RTLD_LOCAL);
  } else if (strcmp(argv[1], "cat") == 0) {
    handle = dlopen("libcat.so", RTLD_LOCAL);
  } else {
    fprintf(stderr, "Error: unknown animal type: %s\n", argv[1]);
    RET = EXIT_FAILURE;
    return;
  }
  if (!handle) {
    /* fail to load the library */
    fprintf(stderr, "Error: %s\n", dlerror());
    RET = EXIT_FAILURE;
    return;
  }

  *(void**)(&func_print_name) = dlsym(handle, "print_name");
  if (!func_print_name) {
    /* no such symbol */
    fprintf(stderr, "Error: %s\n", dlerror());
    dlclose(handle);
    RET = EXIT_FAILURE;
    return;
  }
  printf("argv1 = %s\n", argv[1]);

  func_print_name(argv[1]);
  printf("Closing handle\n");
  dlclose(handle);
}

int main(int argc, char **argv)
{(void)argc; (void)argv;
  int i=0;
  for(;RET==EXIT_SUCCESS && i < 2;i++)
    test_worker(2, tests[i]);

  return RET;
}
