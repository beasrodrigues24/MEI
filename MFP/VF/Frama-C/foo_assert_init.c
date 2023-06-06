#include <limits.h>

/*@ requires \valid_read(p) && \valid_read(q);
    ensures \result >= *p && \result >= *q;
    ensures \result == *p || \result == *q;

    assigns \nothing;

    behavior plarger:
        assumes *p >= *q;
        ensures \result == *p;

    behavior qlarger:
        assumes *q > *p;
        ensures \result == *q;

    complete behaviors;
    disjoint behaviors;
*/
int max_ptr (int *p, int *q);

void foo(){
    int a = 42;
    int b = 37;
    
    //@ requires b+10 <= INT_MAX;
    b += 10;
    int c = max_ptr(&a,&b);
    //@ assert c == 47;
}
