#include <limits.h>

/*@ requires \valid_read(a + (0 .. (len-1)));
    requires len > 0 && len < INT_MAX;
    ensures \forall integer j ; 0 <= j < len ==> a[\result] <= a[j] && 0 <= \result < len;
    assigns \nothing;
*/
int minarray(int *a, int len) {
  int min, k;
  k = 0;
  min = a[0];
  
  /*@ loop invariant 1<=i<=len;
      loop invariant \forall integer j ; 0 <= j < i ==> a[k] <= a[j];
      loop invariant 0 <= k < i;
      loop invariant a[k] == min;
      loop assigns k, min, i;
      loop variant len-i;
  */
  for (int i = 1; i<len; i++) {
    if (a[i] < min) {
      k = i;
      min = a[i];
    }
  }
  return k ;
}

int main() {
    int v[] = {1,3,4,0,5};
    int len = 5;

    int r = minarray(v,len);
    //@ assert r == 3;
    return 0;
}
