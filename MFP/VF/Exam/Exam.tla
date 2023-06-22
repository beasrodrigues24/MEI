-------------------------------- MODULE Exam --------------------------------
\* Exercise 1 

EXTENDS Integers 

CONSTANTS N, K

ASSUME N > 0 /\ K > 0 

VARIABLES front, size, queue, lock, val, pcPush, pcPop

TypeOK == [] ( front \in 0..K-1
            /\ size \in 0..K
            /\ queue \in [0..K-1 -> 0..N]
            /\ lock \in BOOLEAN
            /\ val \in [1..N -> 0..N]
            /\ pcPush \in [1..N -> 0..3]
            /\ pcPop \in [1..N -> 0..3])

Init == 
    /\ front = 0
    /\ size = 0
    /\ queue = [i \in 0..K-1 |-> 0]
    /\ lock = TRUE 
    /\ val = [i \in 1..N |-> 0]
    /\ pcPush = [i \in 1..N |-> 0]
    /\ pcPop = [i \in 1..N |-> 0]

PopInit(i) == 
    /\ pcPop[i] = 0
    /\ lock
    /\ lock' = FALSE
    /\ IF size = 0 
       THEN (lock' = TRUE
          /\ pcPop' = [pcPop EXCEPT ![i] = 1])
       ELSE pcPop' = [pcPop EXCEPT ![i] = 2]
    /\ UNCHANGED <<front, size, queue, val, pcPush>>
    
PopRepeat(i) == 
    /\ pcPop[i] = 1 
    /\ lock 
    /\ size > 0
    /\ lock' = FALSE
    /\ pcPop' = [pcPop EXCEPT ![i] = 2]
    /\ UNCHANGED <<front, size, queue, val, pcPush>>
    
PopEnd(i) ==
    /\ pcPop[i] = 2 
    /\ val' = [val EXCEPT ![i] = queue[front]]
    /\ front' = (front + 1)%K 
    /\ size' = size - 1
    /\ lock' = TRUE 
    /\ pcPop' = [pcPop EXCEPT ![i] = 3]
    /\ UNCHANGED <<queue, pcPush>>
           
PushInit(i) == 
    /\ pcPush[i] = 0
    /\ lock 
    /\ lock' = FALSE
    /\ IF size = K
       THEN (lock' = TRUE 
          /\ pcPush' = [pcPush EXCEPT ![i] = 1])
       ELSE pcPush' = [pcPush EXCEPT ![i] = 2]
    /\ UNCHANGED <<front, size, queue, val, pcPop>>        
    
PushRepeat(i) ==
    /\ pcPush[i] = 1 
    /\ lock
    /\ size < K
    /\ lock' = FALSE
    /\ pcPush' = [pcPush EXCEPT ![i] = 2]
    /\ UNCHANGED <<front, size, queue, val, pcPop>>

PushEnd(i) ==
    /\ pcPush[i] = 2 
    /\ queue' = [queue EXCEPT ![(front+size)%K] = i]
    /\ size' = size + 1
    /\ lock' = TRUE 
    /\ pcPush' = [pcPush EXCEPT ![i] = 3]
    /\ UNCHANGED <<front, val, pcPop>>
     
Pop(i) == PopInit(i) \/ PopRepeat(i) \/ PopEnd(i)
    
Push(i) == PushInit(i) \/ PushRepeat(i) \/ PushEnd(i)

Next == \E i \in 1..N : Pop(i) \/ \E j \in 1..N : Push(j)

vars == <<front, size, queue, lock, val, pcPush, pcPop>>

Spec == Init /\ [][Next]_vars /\ WF_vars(Next)

\* Exercise 2

\* As variáveis partilhadas têm sempre valores do tipo correto.
\* TypeOK está definido acima - linha 12

\* Todos os pops retiram valores diferentes da queue.
PopDif == [](\A i,j \in 0..N : val[i] # 0 /\ val[i] = val[j] => i = j)

\* Liveness: O primeiro pop só termina depois do primeiro push terminar.
PopAfterFirstPush == [](\A i \in 1..N : pcPop[i] = 3 => \E j \in 1..N: pcPush[j] = 3)

\* Liveness: Todos os identificadores pushed vão ser inevitavelmente popped.
InevitablePop == [](\E i \in 1..N : pcPush[i] = 3 => <>(size = 0))

\* Exercise 3 
\* Escreveria um invariante que reflete que os pushes não são feitos na ordem 
\* requerida e contaria que o TLC me fornecesse um cotnra exemplo, provando 
\* assim a existência de um cenário que segue este requisito

PushByOrder == 
    ~([](\A i \in 1..N : pcPush[i] = 3 => \A j \in 1..i-1 : pcPush[j] = 3))

=============================================================================
\* Modification History
\* Last modified Wed Jun 21 15:41:47 WEST 2023 by beasrodrigues24
\* Created Wed Jun 21 13:56:09 WEST 2023 by beasrodrigues24
