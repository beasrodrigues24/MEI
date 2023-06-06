#include <limits.h>

/*@ requires x > INT_MIN;
 ensures (x >= 0 ==> \result == x) &&
 (x < 0 ==> \result == -x);
 assigns \nothing;
 */
int abs (int x);

void foo(int a){
    int b = abs(42);
    int c = abs(-50);
    int d = abs(a);       // False : "a" can be INT_MIN
    int e = abs(INT_MIN); // False : the parameter must be
                          // strictly greater than INT_MIN
}
