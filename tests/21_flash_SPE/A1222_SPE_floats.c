#include <stdio.h>

#define SPE 1

#if SPE
#include <spe.h>
#endif /* SPE */

float sum (float, float, float);

int main()
{
    double x,y,z,result;

    x = 1.0f;
    y = 1.0f;
    z = 1.0f;

    result = sum (x,y,z);

    printf ("should be 3: %f\n", result);

    return 0;
}

float sum (float a, float b, float c)
{
    return a + b + c;
}
