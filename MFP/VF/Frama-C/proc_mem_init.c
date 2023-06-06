
/*@ requires \valid(a) && \valid(b);
    requires a != b;
    ensures *a==10 && *b==20;
    assigns *a, *b;
*/
void proc(int *a, int *b) {
  *a = 10;
  *b = 20;
}
