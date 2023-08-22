#include <wchar.h>
#include <stdio.h>
#include <math.h>

int main(void) {
    fwprintf(stdout, L"1/0: %f\n", 1.0 / 0.0);
    return 0;
}
