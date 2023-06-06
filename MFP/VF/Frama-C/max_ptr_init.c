/*@ requires \valid(p) && \valid(q);
    ensures \result >= *p && \result >= *q; 
    ensures \result == *p || \result == *q;
    assigns \nothing;
*/
int max_ptr (int *p, int *q) {
  if (*p >= *q) return *p ;
  return *q ;
}
