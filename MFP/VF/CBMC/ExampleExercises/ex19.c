int nondet_int();
int x, y;

void main (void)
{
    x = nondet_int();
    y = x+1;
    assert (y>x);
}
