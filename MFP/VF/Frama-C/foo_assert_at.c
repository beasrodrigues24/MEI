
/*@ requires \valid_read(p) && \valid_read(q);
    ensures \result >= *p && \result >= *q;
    ensures \result == *p || \result == *q;
    assigns \nothing;
 */
int max_ptr (int *p, int *q);

void foo(){
    int a = 42;
    int b = 37;
    
  Label_b:
    b += 10;
    int c = max_ptr(&a,&b);
    //@ assert c == 47;
    b = c+b;
    //@ assert b == 94 && \at(b,Label_b) == 37;
}
