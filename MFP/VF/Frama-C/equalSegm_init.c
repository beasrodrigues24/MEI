#include <limits.h> 

/*@ requires 0 <= a <= b <= N - 1 <= INT_MAX && \valid_read(A + (a .. b)) && \valid_read(B + (a .. b));
    assigns \nothing;

    behavior equals_seg:
       assumes \forall integer j ; a <= j <= b ==> A[j] == B[j];
       ensures \result == 0;
    behavior dif_seg:
        assumes \exists integer j ; a <= j <= b ==> A[j] != B[j];
        ensures \result == 1;

    complete behaviors;
    disjoint behaviors;

*/
int equal_seg(int A[], int B[], int a, int b, int N) {
  int i;
  /*@ loop invariant a <= i <= b+1;
      loop invariant \forall integer j ; a <= j < i ==> A[j] == B[j];
      loop assigns i;
      loop variant b-i+1;
  */
  for (i=a; i<=b; i++)
    if (A[i]!=B[i]) return 0;
  return 1;
}

int main() {
    int a[] = {1,2,3,4,5};
    int b[] = {5,2,3,4,5};

    int r = equal_seg(a,b,1,4,5);
    //@ assert r == 1;
}
