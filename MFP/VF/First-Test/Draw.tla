-------------------------------- MODULE Draw --------------------------------
EXTENDS Naturals, Sequences

VARIABLES inbox, result, try, firstSend

TypeOK == [] (inbox \in [0..1 -> Seq(1..2)]
              /\ result \in [0..1 -> 0..2]
              /\ try \in [0..1 -> 1..2]
              /\ firstSend \in [0..1 -> BOOLEAN])

Init ==
    /\ inbox = [i \in 0..1 |-> <<>>]
    /\ result = [id \in 0..1 |-> 0]
    /\ try = [id \in 0..1 |-> (CHOOSE val \in 1..2 : TRUE)]
    /\ firstSend = [id \in 0..1 |-> FALSE]
         
send(i, val) == 
   inbox' = [inbox EXCEPT ![i] = Append(@,val)]
   
InitialSend(i) ==
    /\ firstSend[i] = FALSE
    /\ send(1-i, try[i])
    /\ firstSend' = [firstSend EXCEPT ![i] = TRUE]
    /\ result' = result
    /\ try' = try

Loop(i) == 
    /\ firstSend[i] = TRUE
    /\ result[i] = 0
    /\ Len(inbox[i]) # 0
    /\ (IF try[i] = Head(inbox[i]) THEN  
        /\ try' = [try EXCEPT ![i] = CHOOSE val \in 1..2 : TRUE] 
        /\ send(1-i, try[i])
        ELSE result' = [result EXCEPT ![i] = try[i]])
    /\ inbox' = [inbox EXCEPT ![i] = <<>>]
    /\ result' = result
    /\ try' = try

Next == \E i \in 0..1 : InitialSend(i) \/ Loop(i)

vars == <<inbox,result,try,firstSend>>

Algorithm == Init /\ [][Next]_vars

\* Exercício 2 

DifferentResult == [](\A i \in 0..1 : result[i] # 0 => result[i] # result[1-i] )

MaxTwoMsgs == [](\A i \in 0..1 : Len(inbox[i]) <= 2)

ImplyNewResult == [](\A i \in 0..1 : result[i] # 0 => <>(result[1-i] # 0))

=============================================================================
\* Modification History
\* Last modified Mon Jun 12 23:29:26 WEST 2023 by beasrodrigues24
\* Created Mon Jun 12 22:27:05 WEST 2023 by beasrodrigues24
