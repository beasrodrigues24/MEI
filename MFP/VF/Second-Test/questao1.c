#include <stdio.h>

int entre (int V[], int n, int x, int y)
{
  int i=0;

  //__CPROVER_assume(V != NULL);
  //__CPROVER_assume(n > 0);
  //__CPROVER_rw_ok(V, n);
  
  while (i<n) {
    int j = nondet_int();
    __CPROVER_assume(0 <= j && j < i);
    assert(V[j] >= x && V[j] <= y);

    if (V[i] < x || V[i] > y)
      return 0;
    i++;
  }
  return 1;
}


void main(void)
{ 
  int A[10] = {2,0,4,-28,3,-17,34,-3,9,7};
  int i;

  i = entre(A,10,0,100);
  assert(i == 0);

  for(i=0; i<10; i++)
    A[i] = i+i;

  i = entre(A,10,0,100);
  assert(i == 1);
}


