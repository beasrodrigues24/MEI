

void reverse (int A[], int n)
{
  int i, x;

  for (i=0; i<n/2; i++) {
    x = A[i];
    A[i] = A[n-1-i];
    A[n-1-i] = x;
  }  
}
