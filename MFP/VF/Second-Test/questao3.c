#include <limits.h>
/*@  requires n>=0 && \valid(V+(0..(n-1)));
     ensures \result==1 <==> 
                  (\forall integer k; 0<=k<n ==> V[k]>=x && V[k]<=y);
     ensures \result==0 <==> 
                  !(\forall integer k; 0<=k<n ==> V[k]>=x && V[k]<=y);
     ensures \result >= 0 && \result <= 1;
     ensures \result == 0 || \result == 1;
     assigns \nothing;
 */
int entre  (int V[], int n, int x, int y)
{
  int i=0;

  /*@ loop invariant 0 <= i <= n;
      loop invariant \forall integer j ; 0 <= j < i ==> V[j] >= x && V[j] <= y;
      loop assigns i;
      loop variant n-i;
  */
  while (i<n) {
    if (V[i] < x || V[i] > y)
      return 0;
    i++;
  }
  return 1;
}




void main(void){
 
  int A[10] = {2,0,4,-28,3,-17,34,-3,9,7};
  int i;

  i = entre(A,10,0,100);
  //@ assert i!=1;     
  //@ assert i==0;     

  /*@ loop invariant 0 <=i <= 10;
      loop invariant \forall integer j ; 0 <= j < i ==> A[j] == j+j; 
      loop assigns i, A[0..9];
      loop variant 10-i;
  */
  for(i=0; i<10; i++)
    A[i] = i+i;

  i = entre(A,10,0,100);
  //@ assert i==1;
}


//@ predicate ENTRE(int *A,int len,int a,int b) = \forall integer j ; 0 <= j < len ==> A[j] >= a && A[j] <= b;

/*@  requires n>=0 && \valid(V+(0..(n-1)));
     ensures \result==1 <==> 
                  ENTRE(V,n,x,y);
     ensures \result==0 <==> 
                  !ENTRE(V,n,x,y);
     ensures \result >= 0 && \result <= 1;
     ensures \result == 0 || \result == 1;
     assigns \nothing;
 */
int entre_alinea3  (int V[], int n, int x, int y)
{
  int i=0;
  
  /*@ loop invariant 0 <= i <= n;
      loop invariant ENTRE(V,i,x,y);
      loop assigns i;
      loop variant n-i;
  */
  while (i<n) {
    if (V[i] < x || V[i] > y)
      return 0;
    i++;
  }
  return 1;
}
