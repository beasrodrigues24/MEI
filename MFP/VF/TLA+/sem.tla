-------------------------------- MODULE sem --------------------------------

EXTENDS Integers

CONSTANT N

ASSUME N > 1

VARIABLES sem,pc

TypeOK == [] (sem \in 0..1 /\ pc \in [0..N-1 -> 0..2])

Init == sem = 1 /\ pc = [i \in 0..N-1 |-> 0] 

Semaphore_wait(i) ==
    /\ pc[i] = 0
    /\ sem' = sem
    /\ pc' = [pc EXCEPT ![i] = 1]

Semaphore_lock(i) == 
    /\ pc[i] = 1
    /\ sem = 1 
    /\ sem' = 0
    /\ pc' = [pc EXCEPT ![i] = 2]
    
Semaphore_unlock(i) ==
    /\ pc[i] = 2
    /\ sem' = 1
    /\ pc' = [pc EXCEPT ![i] = 0]

Next == \E i \in 0..N-1 : Semaphore_wait(i) \/ Semaphore_lock(i) \/ Semaphore_unlock(i)

vars == <<sem,pc>>

Algorithm == Init /\ [][Next]_vars /\ SF_vars(Next)

MutualExclusion == [] \A i,j \in 0..N-1 : (pc[i] = 2 /\ pc[j] = 2) => i = j

NoStarvation == [] \A i \in 0..N-1 : pc[i] = 1 => <> (pc[i] = 2)

=============================================================================
\* Modification History
\* Last modified Mon Jun 12 17:59:41 WEST 2023 by beasrodrigues24
\* Created Mon Jun 12 15:51:16 WEST 2023 by beasrodrigues24
