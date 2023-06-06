/*@ predicate Swap{L1,L2}(int *a, integer i,integer j) = 
       \at(a[i],L1) == \at(a[j],L2)
       && \at(a[i],L2) == \at(a[j],L1)
       && \forall integer k;  k!=i && k!=j ==> \at(a[k] ,L1) == \at(a[k] ,L2);
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





