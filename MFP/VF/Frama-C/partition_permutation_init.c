/*@ predicate Swap{L1,L2}(int *a, integer i,integer j) = 
       \at(a[i],L1) == \at(a[j],L2)
       && \at(a[i],L2) == \at(a[j],L1)
       && \forall integer k;  k!=i && k!=j ==> \at(a[k] ,L1) == \at(a[k] ,L2);
*/

/*@ inductive Permut{L1,L2}(int *a, integer l, integer h) {
       case Permut_refl{L}:  
              \forall int *a, integer l, h; Permut{L,L}(a, l, h) ; 
       case Permut_sym{L1,L2}: \forall int *a, integer l, h;  
              Permut{L1,L2}(a, l, h) ==> Permut{L2,L1}(a, l, h) ; 
       case Permut_trans{L1,L2,L3}:  
              \forall int *a, integer l, h; Permut{L1,L2}(a, l, h) && Permut{L2,L3}(a, l, h) 
                                      ==> Permut{L1,L3}(a, l, h) ; 
       case Permut_swap{L1,L2}:  
              \forall int *a, integer l, h, i, j;  
                   l <= i <= h && l <= j <= h && Swap{L1,L2}(a, i, j) ==> Permut{L1,L2}(a, l, h) ;
     }
*/


/*@ lemma Permut_swap_sequence{L1,L2,L3}: \forall int *a, integer l, h, i, j;
              Permut{L1,L2}(a, l, h) ==>  l<=i<=h ==>l<=j<=h ==> Swap{L2,L3}(a, i, j) ==>  
                      Permut{L1,L3}(a, l, h) ; 
*/

/*@ requires \valid(t+i) && \valid(t+j);
    ensures Swap{Old,Here}(t,i,j);
    assigns t[i], t[j];
*/
void swap(int t[],int i,int j);

void swap(int t[],int i,int j) {
  int tmp = t[i];
  t[i] = t[j];
  t[j] = tmp;
}


/*@ requires 0 <= p <= r && \valid(A+(p..r));
    ensures p<=\result<=r;
    ensures \forall integer l; p <= l < \result ==> A[l] <= A[\result];
    ensures \forall integer l; \result < l <= r ==> A[l] > A[\result];
    ensures  A[\result] == \old(A[r]);
    assigns A[p..r];
*/
int partition (int A[], int p, int r)
{
  int x = A[r];
  int j, i = p-1;

  /*@ loop invariant p <= j <= r && p-1 <= i < j;
      loop invariant \forall integer k; p<=k<=i ==> A[k]<=x;
      loop invariant \forall integer k; i<k<j ==> A[k]>x;
      loop invariant A[r] == x;
      loop assigns j, i, A[p..r];
      loop variant r-j;
  */
  for (j=p; j<r; j++)
    if (A[j] <= x) {
      i++;
      swap(A,i,j);
    }
  swap(A,i+1,r);
  return i+1;
}


