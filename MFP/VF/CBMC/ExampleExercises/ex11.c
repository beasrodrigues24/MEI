int sumqq (int x)
{
    short int i, s;
    s = 0;
    for (i = 0; i <= x; i++)
        s += i+i;
    return s;
}
