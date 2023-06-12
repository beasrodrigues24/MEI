---------------------------- MODULE philosopher ----------------------------
EXTENDS Integers

CONSTANT N

ASSUME N > 0

VARIABLES waiter,fork,pc

TypeOK == [] (waiter \in BOOLEAN /\ fork \in [0..N-1 -> BOOLEAN] /\ pc \in [0..N-1 -> 0..3])

Init == waiter = TRUE /\ fork = [i \in 0..N-1 |-> TRUE] /\ pc = [i \in 0..N-1 |-> 0]

left(i) == i 

right(i) == (i-1)%N

First(i) == 
    /\ pc[i] = 0
    /\ waiter = TRUE
    /\ fork' = fork
    /\ waiter' = FALSE
    /\ pc' = [pc EXCEPT ![i] = 1]
    
Second(i) == 
    /\ pc[i] = 1 
    /\ fork[left(i)] = TRUE
    /\ fork' = [fork EXCEPT ![left(i)] = FALSE]
    /\ waiter' = waiter
    /\ pc' = [pc EXCEPT ![i] = 2]
    
Third(i) == 
    /\ pc[i] = 2 
    /\ fork[right(i)] = TRUE
    /\ fork' = [fork EXCEPT ![right(i)] = FALSE]
    /\ waiter' = TRUE
    /\ pc' = [pc EXCEPT ![i] = 3]
    
Fourth(i) == 
    /\ pc[i] = 3 
    /\ fork' = [fork EXCEPT ![left(i)] = TRUE, ![right(i)] = TRUE]
    /\ waiter' = waiter
    /\ pc' = [pc EXCEPT ![i] = 0]

Next == \E i \in 0..N-1: First(i) \/ Second(i) \/ Third(i) \/ Fourth(i)

vars == <<waiter,fork,pc>>

Algorithm == Init /\ [][Next]_vars /\ WF_vars(Next)

NeighbourSameTime == [](\A i \in 0..N-1 : pc[i] = 3 => pc[right(i)] /= 3)

WillEat == [](\A i \in 0..N-1 : pc[i] = 1 => <> (pc[i] = 3))

=============================================================================
\* Modification History
\* Last modified Mon Jun 12 17:43:41 WEST 2023 by beasrodrigues24
\* Created Mon Jun 12 17:17:43 WEST 2023 by beasrodrigues24
