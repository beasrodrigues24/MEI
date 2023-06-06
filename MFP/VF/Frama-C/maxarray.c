/*@ requires 0 < size && \valid(u+ (0..size-1));
    ensures 0 <= \result < size;
    ensures \forall integer a; 0 <= a < size ==> u[a] <= u[\result];
    assigns \nothing;
*/
int maxarray(int u[], int size) {
  int i = 1;
  int max = 0;

  /*@ loop invariant \forall integer a; 0 <= a < i ==> u[a] <= u[max];
      loop invariant 0 <= max < i <= size;
      loop assigns max, i;
      loop variant size-i;
  */
  while (i < size) {
    if (u[i] > u[max])  max = i;
    i++;
  }
  return max;
}
