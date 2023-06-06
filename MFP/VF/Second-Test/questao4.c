#include <limits.h>

/*@ requires na >= 0 && \valid(A + (0..(na-1))) && \forall integer j ; 0 <= j < na ==> INT_MIN/2 <= A[j] <= INT_MAX/2; 
    ensures \forall integer j ; 0 <= j < na ==> A[j] == 2*\old(A[j]);
    assigns A[0..(na-1)];
*/
void doubles (int A[], int na)
{
  int i = 0;
  
  /*@ loop invariant 0 <= i <= na;
      loop invariant \forall integer j ; 0 <= j < i ==> A[j] == 2*\at(A[j],Pre);
      loop invariant \forall integer j ; i <= j < na ==> A[j] == \at(A[j],Pre);
      loop assigns A[0..(na-1)], i;
      loop variant na-i; 
  */
  while (i<na){
    A[i] = 2*A[i];
    i = i+1;
  }
}
