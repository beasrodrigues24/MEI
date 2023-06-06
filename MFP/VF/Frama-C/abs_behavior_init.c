#include <limits.h>

// Why does this proof fails?

/*@ requires x > INT_MIN;
    assigns \nothing ; 
    behavior pos :
      assumes x >= 0;
      ensures \result == x; 
    behavior neg :
      assumes x < 0;
      ensures \result == -x; 
    complete behaviors;
    disjoint behaviors;
*/
int abs (int x) {
  if (x >= 0) return x; 
  return -x; 
}
