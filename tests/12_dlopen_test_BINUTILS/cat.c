#include "animal.h"
#include <stdio.h>
#include <dlfcn.h>

void print_name(const char* type)
{
    printf( "Called\n");
    printf( "Tama is a %s.\n", type);

    void *handle;
    void (*func_print_name)(const char*);

    handle = dlopen("libdog.so", RTLD_LAZY);
    if (handle != NULL) {
        *(void**)(&func_print_name) = dlsym(handle, "print_name");
        func_print_name("print_name\n");
        dlclose(handle);
    }
}

