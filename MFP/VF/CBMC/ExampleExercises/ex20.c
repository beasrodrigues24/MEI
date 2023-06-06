int nondet_int();
int x, y;

void main (void)
{
    x = nondet_int();
    __CPROVER_assume (x<10);
    y = x+1;
    assert (y>x);
}
