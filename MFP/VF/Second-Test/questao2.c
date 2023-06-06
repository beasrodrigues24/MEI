
void doubles (int A[], int na)
{
  int i = 0;
  
  while (i<na){
    A[i] = 2*A[i];
    i = i+1;
  }
}


void main(void)
{ 
  int A[10] = {2,0,4,-28,3,-17,34,-3,9,7};
  int B[10];
  int i;

  
    int j = nondet_int();
    __CPROVER_assume(0 <= j && j < 10);
    int value_doubled = A[j]*2;
    doubles(A,10);
    assert(A[j] == value_doubled);
  
  
  for (i=0; i<10; i++) 
      B[i] = nondet_int(); 

  doubles(B,10);
}
