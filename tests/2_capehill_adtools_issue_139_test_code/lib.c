#include <proto/dos.h>

void __attribute__((constructor(101))) ctor()
{
    IDOS->Printf("%s\n", __func__);
}

void  __attribute__((destructor(101))) dtor()
{
    IDOS->Printf("%s\n", __func__);
}

void __attribute__((constructor(102))) ctor2()
{
    IDOS->Printf("%s\n", __func__);
}

void  __attribute__((destructor(102))) dtor2()
{
    IDOS->Printf("%s\n", __func__);
}

int function(int x)
{
    IDOS->Printf("%s %ld\n", __func__, x);

    return x;
}
