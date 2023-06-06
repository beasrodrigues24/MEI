int nondet_int();
int *p;
int global;

void f (void)
{
    int local = 10;
    int input = nondet_int();
    p = input ? &local : &global;
}

int main (void)
{
    int z;
    global = 10;
    f ();
    z = *p;
    assert (z==10);
}
