#include <limits.h>

/*@ requires \valid_read(t+(0..(n-1)));
    requires n >= 0 && n <= INT_MAX;
    assigns \nothing;
    behavior noNegs:
        assumes n == 0 || \forall integer i ; 0 <= i < n ==> t[i] >= 0; 
        ensures \result == 1;
    behavior hasNegs:
        assumes n != 0 && \exists integer i ; 0 <= i < n ==> t[i] < 0; 
        ensures \result == 0;
    complete behaviors;
*/
int negs(int t[], int n) {
  int k;

  /*@ loop invariant 0 <= k <= n;
      loop invariant \forall integer i ; 0 <= i < k ==> t[i] >= 0;
      loop assigns k;
      loop variant n-k;
  */
  for(k = 0; k < n; k++)
    if (t[k] < 0) return 0;
  return 1;
}

void main(void){
  int a[10];
  int b[5] = {3,4,8,3,7};
  int c[5] = {2,4,-28,3,-17};
  int i;

  i = negs(b,5);
  //@ assert i!=0;
  //@ assert i==1;     

  i = negs(c,5);
  //@ assert i==0;


  for(i=0; i<10; i++)
    a[i] = i*3;

  i = negs(a,10);
  //@ assert i!=0;
}

