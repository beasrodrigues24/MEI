#include <stdio.h>
#define MAX 10

int vec[MAX];


int fun (int n)
{
  int i, x=0;
  
  for (i=0; i < MAX; i++)
    if (vec[i]>n)
      x = x + vec[i]/(n-i);
    else x = x + vec[i]*(n-i);

  return x;
}


int cpdiff (int A[], int na, int B[], int nb, int x)
{
  int i, j=0;

  for (i=0; i<na; i++)
    if (A[i]!=x) {
      B[j] = A[i];
      j++;
    }
  return j;
}


void main()
{
  int j, t, y;
  int a[MAX], b[MAX];

  for (j=0; j<MAX; j++) {
    a[j] = j;
    vec[j] = j*30;
  }
  a[4] = 2;
  a[5] = 1;

  y =  fun(55);
  t = cpdiff(a,MAX,b,MAX,1);
}
	    
