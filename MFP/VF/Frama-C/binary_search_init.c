/*@ predicate sorted(int* arr, integer length) =
       \forall integer i, j; 0 <= i <= j < length ==> arr[i] <= arr[j];

    predicate elem(int v, int* arr, integer length) = 
       \exists integer i; 0 <= i < length && arr[i] == v; 
*/

/*@ requires sorted(arr,len);
    requires len >= 0;
    requires \valid(arr+(0..(len-1)));

    assigns \nothing;

    behavior belongs:
      assumes elem(x, arr, len); 
      ensures 0 <= \result < len; 
      ensures arr[\result] == x;
    behavior not_belongs:
      assumes ! elem(x, arr, len); 
      ensures \result == -1; 
*/
int find_array(int* arr, int len, int x) {
  int low = 0;
  int high = len - 1;
  
  while (low <= high) {
    int mean = (low + high) / 2;
    if (arr[mean] == x) return mean;
    if (arr[mean] < x) low = mean + 1;
    else high = mean - 1;
  }
  return -1;
}
