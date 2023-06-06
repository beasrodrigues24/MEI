/*@ predicate Sorted{L}(int *t,integer i,integer j) =
      \forall integer k; i<=k<j ==> \at(t[k],L) <= \at(t[k+1],L);
*/

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

/*@ requires 0 < size && \valid(u+ (0..size-1));
    ensures 0 <= \result < size;
    ensures \forall integer a; 0 <= a < size ==> u[a] <= u[\result];
    assigns \nothing;
*/
int maxarray(int u[], int size);

/*@ requires \valid(t+i) && \valid(t+j);
    ensures Swap{Old,Here}(t,i,j);
    assigns t[i], t[j];
*/
void swap(int t[],int i,int j);


/*@ requires size >= 0 && \valid(a + (0..(size-1)));
    ensures Sorted{Here}(a,0,size);
    assigns a[0..(size-1)];
*/
void maxSort (int *a, int size) {
  int i, j;

  /*@ loop invariant 0 <= i < size; 
      loop invariant Sorted{Here}(a,i+1,size);
      loop assigns i,j,a[0..(size-1)];
      loop variant i;
  */
  for (i=size-1; i>0; i--) {
    j = maxarray(a,i+1);
    swap(a,i,j);
  }
}
