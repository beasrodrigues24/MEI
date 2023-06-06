#include <stdio.h>
#define LENGTH 5

int vec[LENGTH];
int max_int = (int)(((unsigned int)-1) >> 1);    

int maxarray(int u[], int size) {
    __CPROVER_assume(u != NULL 
            && __CPROVER_OBJECT_SIZE(u) == sizeof(int) * size
            && size > 0 
            && size <= max_int);

    int i = 1, a, max = 0;

    while (i < size) {
        /* 1 - Fails
        int k = nondet_int();
        __CPROVER_assume(0 <= k && k <= i);
        assert(vec[k] <= vec[max]);
        */
        /* 2 - Fails
        int k = nondet_int();
        __CPROVER_assume(0 <= k && k < i);
        assert(vec[k] < vec[max]);
        */
        /* 3 - Passes
        int k = nondet_int();
        __CPROVER_assume(0 <= k && k < i);
        assert(vec[k] <= vec[max]);
        */
        /* 4 - Fails
        int k = nondet_int();
        __CPROVER_assume(0 <= k && k <= i);
        assert(vec[k] < vec[max]);
        */ 
        if (u[i] > u[max]) { max = i; }
        i++;
    }

    assert(max >= 0 && max < size);
    return max;
}
    
void main() {
    int i;
    for (i=0; i<LENGTH; i++) { // Fixed <= to <
        vec[i] = nondet_int(); 
    }
    int r = maxarray(vec, LENGTH);
    i = nondet_int();
    __CPROVER_assume(0 <= i && i < LENGTH);
    assert(vec[i] <= vec[r]);
}
