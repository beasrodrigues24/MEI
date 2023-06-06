/*@ ensures \result >= x && \result >= y; 
*/
int max (int x, int y) {
  if (x >= y) return x ;
  return y ;
}
