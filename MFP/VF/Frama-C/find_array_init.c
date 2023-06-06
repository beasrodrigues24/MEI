
/*@ requires len >= 0;
    requires \valid(arr+(0..(len-1)));
    requires \forall integer i, j; 0 <= i <= j < len ==> arr[i] <= arr[j]; 
    ensures (\exists integer i; 0 <= i < len && arr[i] == x) ==>
                              0 <= \result < len && arr[\result] == x;
    ensures (\forall integer i; 0 <= i < len ==> arr[i] != x) ==> \result == -1; 
    assigns \nothing; 
*/
int find_array(int* arr, int len, int x);

