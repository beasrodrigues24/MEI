/*@ requires \valid(a) && \valid(b);
    ensures *a == \old(*b) && *b == \old(*a);
    assigns *a, *b;
*/
void change(int *a, int *b) {
  int tmp = *a;
  *a = *b;
  *b = tmp;
}

int main() {
    int a = 5;
    int b = 6;

    change(&a, &b); 
    //@ assert a == 6 && b == 5;
}
