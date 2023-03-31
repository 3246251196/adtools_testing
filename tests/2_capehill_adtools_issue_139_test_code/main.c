#include <stdio.h>

int function(int);

int main()
{
    int result = function(123);

    printf("%s result %d\n", __func__, result);

    return 0;
}
