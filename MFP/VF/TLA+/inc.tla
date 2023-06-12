-------------------------------- MODULE inc --------------------------------

EXTENDS Integers

CONSTANT N

ASSUME N > 0

VARIABLES x,y,pc

TypeOK == [] (x \in Int /\ y \in [1..N -> Int] /\ pc \in [1..N -> 0..2])

Init == x = 0 /\ pc = [i \in 1..N |-> 0] /\ y = [i \in 1..N |-> 0]

Increment_Asg(i) ==
    /\ pc[i] = 0
    /\ \A j \in 1..N : pc[j] # 1
    /\ x' = x
    /\ y' = [y EXCEPT ![i] = x]
    /\ pc' = [pc EXCEPT ![i] = 1]

Increment_Inc(i) == 
    /\ pc[i] = 1 
    /\ y' = y
    /\ x' = y[i] + 1
    /\ pc' = [pc EXCEPT ![i] = 2]
        
Next == \E i \in 1..N : Increment_Asg(i) \/ Increment_Inc(i)

vars == <<x,pc,y>>

Algorithm == Init /\ [][Next]_vars /\ WF_vars(Next)

Finish == \A i \in 1..N : pc[i] = 2

PartialCorrectness == [] (Finish => x \in 1..N)

MutualExclusion == [](\A i,j \in 1..N : pc[i] = 1 /\ i # j => pc[j] # 1)

NoStarvation == [](\A i \in 1..N : pc[i] = 1 => <>(pc[i] = 2))

Termination == <> Finish


=============================================================================
\* Modification History
\* Last modified Mon Jun 12 17:56:55 WEST 2023 by beasrodrigues24
\* Created Mon Jun 12 14:46:09 WEST 2023 by beasrodrigues24
