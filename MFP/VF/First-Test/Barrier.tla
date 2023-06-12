------------------------------ MODULE Barrier ------------------------------
EXTENDS Naturals 

CONSTANTS N 

ASSUME N > 0 

VARIABLES lock, waiting, n, pc

TypeOK == [] (/\ lock \in BOOLEAN
              /\ waiting \in [1..N -> BOOLEAN]
              /\ n \in 0..N
              /\ pc \in [1..N -> 0..3])

Init == /\ lock = TRUE 
        /\ waiting = [i \in 1..N |-> FALSE]
        /\ n = 0
        /\ pc = [i \in 1..N |-> 0]

PreLoop(i) == 
    /\ pc[i] = 0
    /\ lock = TRUE
    /\ lock' = FALSE 
    /\ n' = n + 1 
    /\ waiting' = waiting 
    /\ pc' = [pc EXCEPT ![i] = 1]
    
LoopT(i) == 
    /\ pc[i] = 1 
    /\ n < N 
    /\ waiting' = [waiting EXCEPT ![i] = TRUE]
    /\ lock' = TRUE
    /\ n' = n
    /\ pc' = [pc EXCEPT ![i] = 2]
    
InsideLoop(i) ==
    /\ pc[i] = 2
    /\ lock = TRUE 
    /\ ~waiting[i]
    /\ lock' = FALSE
    /\ waiting' = waiting
    /\ n' = n  
    /\ pc' = [pc EXCEPT ![i] = 1]  
    
LoopF(i) ==
    /\ pc[i] = 1 
    /\ n >= N
    /\ waiting' = [j \in 1..N |-> FALSE]
    /\ lock' = TRUE 
    /\ n' = n
    /\ pc' = [pc EXCEPT ![i] = 3]

Next == \E i \in 1..N : PreLoop(i) \/ LoopT(i) \/ InsideLoop(i) \/ LoopF(i) 

vars == <<lock, waiting, n, pc>>

\* Exercício 2

EnforceType == TypeOK

Algorithm == Init /\ [][Next]_vars /\ WF_vars(Next)

Impossible == [] \E i \in 1..N : pc[i] = 2 => \E j \in 1..N : pc[j] # 2

EndExec == <>(\A i \in 1..N : pc[i] = 3)

BarrierAlgorithm == [](\E i \in 1..N : pc[i] = 3 => \A j \in 1..N : pc[j] > 0)

\* Exercício 3 

\* ???

=============================================================================
\* Modification History
\* Last modified Mon Jun 12 22:26:17 WEST 2023 by beasrodrigues24
\* Created Mon Jun 12 22:00:06 WEST 2023 by beasrodrigues24
