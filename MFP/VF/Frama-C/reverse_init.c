#include <limits.h>

/*@ requires \valid(A+(0..n-1)) && 0 <= n <= INT_MAX;
    ensures forall integer k; 0 <= k < n/2 ==> A[k] == \old(A[n-1-k]);
    assigns \nothing;
*/
void reverse (int A[], int n)
{
  int i, x;

  /*@ loop invariant 0<= i<=n/2;
      loop invariant forall integer k; 0 <= k < i ==> A[k] == \at(A[n-1-k], Pre) && A[n-1-k] == \at(A[k], Pre);
      loop invariant forall integer k; i <= k < n/2 ==> A[k] == \at(A[k], Pre);
      loop assigns i, A+(0..n-1), x;
      loop variant n/2-i 
  */
  for (i=0; i<n/2; i++) {
    x = A[i];
    A[i] = A[n-1-i];
    A[n-1-i] = x;
  }  
}
