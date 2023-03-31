#include <stdio.h>

void __attribute__((constructor(101))) ctor()
{
    printf("%s\n", __func__);
}

void  __attribute__((destructor(101))) dtor()
{
    printf("%s\n", __func__);
}

void __attribute__((constructor(102))) ctor2()
{
    printf("%s\n", __func__);
}

void  __attribute__((destructor(102))) dtor2()
{
    printf("%s\n", __func__);
}

int function(int x)
{
    printf("%s %d\n", __func__, x);

    return x;
}
