------------------------------- MODULE mutex -------------------------------
EXTENDS Integers

CONSTANT N

ASSUME N > 1

VARIABLES level,last,l,pc

TypeOK == [] (level \in [0..N-1 -> -1..N-2] /\ last \in [0..N-2 -> 0..N-1] /\ l \in [0..N-1 -> 0..1] /\ pc \in [0..N-1 -> 0..1])

Init == level = [i \in 0..N-1 |-> -1] /\ pc = [i \in 0..N-1 |-> 0] /\ l = [i \in 0..N-1 |-> 0]

FirstT(i) == 
    /\ pc[i] = 0
    /\ l[i] < N-1 
    /\ level' = [level EXCEPT ![i] = l[i]]
    /\ last' = [last EXCEPT ![l[i]] = i]
    /\ pc' = [pc EXCEPT ![i] = 1]
    
FirstF(i) ==
    /\ pc[i] = 0
    /\ l[i] >= N-1
    /\ pc' = [pc EXCEPT ![i] = 2]
    
Second(i) ==
    /\ pc[i] = 1 
    /\ (last[l[i]] # i \/ \A k \in {k_val \in 0..N-1 : k_val # i} : level[k] < l[i])
    /\ l' = [l EXCEPT ![i] = l[i]+1]
    /\ pc' = [pc EXCEPT ![i] = 0]
    
Third(i) ==
    /\ pc[i] = 2 
    /\ level' = [level EXCEPT ![i] = -1]
    /\ l' = [l EXCEPT ![i] = 0]
    /\ pc' = [pc EXCEPT ![i] = 0]

Next == \E i \in 0..N-1: FirstT(i) \/ FirstF(i) \/ Second(i) \/ Third(i)

vars == <<level,last,l,pc>>

Algorithm == Init /\ [][Next]_vars

MutualExclusion == [] \A i,j \in 0..N-1 : pc[i] = 2 /\ pc[j] = 2 => i = j

NoStarvation == [] \A i \in 0..N-1 : pc[i] = 1 => <> (pc[i] = 2)

=============================================================================
\* Modification History
\* Last modified Mon Jun 12 16:50:43 WEST 2023 by beasrodrigues24
\* Created Mon Jun 12 16:22:06 WEST 2023 by beasrodrigues24
