#include <stdio.h>
#define LENGTH 5

int vec[LENGTH];
int max_int = (int)(((unsigned int)-1) >> 1);    
#define INT_MIN (-2147483647 - 1)

int sum (int u[], int size) {
    __CPROVER_assume(u != NULL 
        && __CPROVER_OBJECT_SIZE(u) == sizeof(int) * size
        && size > 0 
        && size <= max_int);
    
    int i, s=0;

    for (i=0; i<size; i++) {
        s += u[i];
    }

    return s;
}

int main() {
    int i;
    for (i=0; i<LENGTH; i++) { // Fixed <= to <
        int x = nondet_int(); 
        __CPROVER_assume(x >= -500 && x <= 500);
        vec[i] = x;
    }
    
    int r = sum(vec, LENGTH);
}
