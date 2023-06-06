
int numOccur(const int* a, int n, int val) {
  int counted = 0;
 
  for (int i = 0; i < n; ++i) {
    if (a[i] == val) {
      counted++; }
  }
  return counted;
}
