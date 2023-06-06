/*@ requires \valid(t+i) && \valid(t+j);
    ensures t[i] == \old(t[j]) && t[j] == \old(t[i]);
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
int partition (int A[], int p, int r) {
  int x = A[r];
  int j, i = p-1;

  for (j=p; j<r; j++)
    if (A[j] <= x) {
      i++;
      swap(A,i,j);
    }
  swap(A,i+1,r);
  return i+1;
}


