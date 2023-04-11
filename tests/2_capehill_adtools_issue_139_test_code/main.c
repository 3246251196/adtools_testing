#include <proto/dos.h>

extern int function(int);

int main()
{
    int result = function(123);

    IDOS->Printf("%s result %ld\n", __func__, result);

    return 0;
}
