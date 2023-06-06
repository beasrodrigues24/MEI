#include <limits.h>

/*@ requires N >= 0 && N < INT_MAX && \valid_read(A + (0..N-1));
    assigns \nothing;
    
    behavior found:
        assumes \exists integer j ; 0 <= j < N ==> A[j] == x;
        ensures A[\result] == x;
        ensures 0 <= \result <= N-1;
    behavior not_found:
        assumes !(\exists integer j ; 0 <= j < N ==> A[j] == x);
        ensures \result == -1;


    complete behaviors;
    disjoint behaviors;
*/
int where(int A[],int N, int x) {
  int i;
 
  /*@ loop invariant 0 <= i <= N;
      loop invariant \forall integer j ; 0 <= j < i ==> A[j] != x;
      loop assigns i;
      loop variant N-i;
  */
  for (i=0; i<N; i++)
    if (A[i]==x) return i;
  return -1;
}

int main() {
    int v[] = {1,2,3,4,5};
    int len = 5;
    int x = 3;

    int r = where(v, len, x);
    //@ assert r == 2;
}
