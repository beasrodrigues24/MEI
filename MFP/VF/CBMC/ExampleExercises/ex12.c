int f() {
    static int s=0;
    s++;
    return s;
}

int g() {
    int l=0;
    l++;
    return l;
}

int h() {
    int x=10;
    x += f() + g();
    return x;
}

void main(void)
{
    assert(f()==1); // first call to f
    assert(f()==2); // second call to f
    assert(g()==1); // first call to g
    assert(g()==1); // second call to g
    assert(h()==14);
}
