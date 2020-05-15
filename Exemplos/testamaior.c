#include <stdio.h>

extern long long maior(long long a, long long b);

int main()
{
    long long a=10, b=87, m;
    m=maior(a, b);
    printf("%lld\n", m);
    return 0;
}