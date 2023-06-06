

// Here the functional dependency of the "isfact" predicate is established
// by axiomatically defining a funtion "fact".



/*@ axiomatic factorial {
  @
  @ predicate isfact(integer n, integer r);
  @
  @ axiom isfact0: isfact(0,1);
  @
  @ axiom isfactn: 
  @    \forall integer n, f; isfact (n-1,f) ==> isfact(n,f*n);
  @
  @
  @ logic integer fact (integer n);
  @
  @ axiom fact1: \forall integer n; isfact (n,fact(n));
  @
  @ axiom fact2: \forall integer n, f; isfact (n,f) ==> f==fact(n);
  @ }
  @
*/

// This function really does overflow... 

/*@ requires n >= 0;
  @ ensures \result == fact(n);
  @*/
int fact (int n)
{
  int f = 1; 
  int i = 1; 
  
  while (i <= n) {
  f = f * i; 
  i = i + 1;
  }
  return f;
}

