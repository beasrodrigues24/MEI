void f (unsigned int n)
{
    int *p;
    p = malloc(sizeof(int)*n);
    p[n-1] = 0;
    free(p);
}
