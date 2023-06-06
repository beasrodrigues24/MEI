int fun (int n)
{
    int *p, i, s=0;
    p = malloc(sizeof(int)*n);
    for (i=0; i<++n; i++)
        p[i] = 10*i;
    for (i=0; i<n; i++)
        s += p[i];
    return s;
}

int main(void)
{
    printf("%d",fun(8) + 100);
    return 0;
}
