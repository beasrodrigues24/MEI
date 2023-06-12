---------------------------- MODULE Transactions ----------------------------
EXTENDS Naturals, TLC, Sequences

CONSTANTS N

VARIABLES inbox, stateWorker, stateMaster, prepared

Status == {"Working", "Prepared", "Aborted", "Committed"}

TypeOK == [] (inbox \in [0..N -> Seq([from : 0..N,type : Status ])]
            /\ stateWorker \in [1..N -> Status] 
            /\ stateMaster \in Status
            /\ prepared \in [1..N -> BOOLEAN])

Init == /\ inbox = [i \in 0..N |-> <<>>]
        /\ stateWorker = [i \in 1..N |-> "Working"]
        /\ stateMaster = "Working"
        /\ prepared = [i \in 1..N |-> FALSE]

empty(specificInbox) ==
    Len(specificInbox) = 0

receive(id) ==
    inbox' = [inbox EXCEPT ![id] = Tail(inbox[id])]
    
broadcast(msg) == 
    inbox' = [id \in 0..N |-> IF id = 0 THEN inbox[0] ELSE Append(inbox[id], msg)]
        
sendToMaster(msg) ==
    inbox' = [id \in 0..N |-> IF id = 0 THEN Append(inbox[0],msg) ELSE inbox[id]]        
         
Worker_Finish(id) == 
    /\ stateWorker[id] = "Working"
    /\ stateWorker' = [stateWorker EXCEPT ![id] = "Prepared"]
    /\ sendToMaster([from |-> id, type |-> "Prepared"])
    /\ stateMaster' = stateMaster 
    /\ prepared' = prepared 

Worker_Abort(id) == 
    /\ stateWorker[id] = "Working"
    /\ stateWorker' = [stateWorker EXCEPT ![id] = "Aborted"]
    /\ inbox' = inbox 
    /\ stateMaster' = stateMaster
    /\ prepared' = prepared 
    
Worker_Receive(id) ==
    /\ ~empty(inbox[id])
    /\ (Head(inbox[id]).type = "Aborted" \/ Head(inbox[id]).type = "Committed")
    /\ stateWorker' = [stateWorker EXCEPT ![id] = Head(inbox[id]).type]
    /\ receive(id)
    /\ stateMaster' = stateMaster
    /\ prepared' = prepared 

Master_Abort ==
    /\ stateMaster = "Working"
    /\ stateMaster' = "Aborted"
    /\ broadcast([from |-> 0, type |-> "Aborted"])
    /\ stateWorker' = stateWorker 
    /\ prepared' = prepared

Master_Receive ==
    /\ ~empty(inbox[0])    
    /\ prepared' = [prepared EXCEPT ![Head(inbox[0]).from] = TRUE]
    /\ receive(0)
    /\ stateWorker' = stateWorker
    /\ (IF /\stateMaster = "Working"
           /\ \A j \in 1..N : prepared[j] = TRUE
        THEN stateMaster'= "Committed"
            /\ broadcast([from |-> 0, type |-> "Committed"])
        ELSE stateMaster' = stateMaster)
    
Master == Master_Abort \/ Master_Receive 

Worker(i) == Worker_Finish(i) \/ Worker_Abort(i) \/ Worker_Receive(i)
    
Next == Master \/ \E i \in 1..N : Worker(i)

vars == <<inbox, stateWorker, stateMaster, prepared>>

Algorithm == Init /\ [][Next]_vars /\ WF_vars(Next)

Consistency == []~(\E i,j \in 1..N : stateWorker[i] = "Aborted" /\ stateWorker[j] = "Committed")

StabilityCommitted == [](\A i \in 1..N : stateWorker[i] = "Committed" => [](stateWorker[i] = "Committed"))

StabilityAborted == [](\A i \in 1..N : stateWorker[i] = "Aborted" => [](stateWorker[i] = "Aborted"))

Stability == StabilityAborted /\ StabilityCommitted

Progress == [](\E i \in 1..N : stateWorker[i] = "Committed" => <>(\A j \in 1..N : stateWorker[j] = "Committed"))

=============================================================================
\* Modification History
\* Last modified Mon Jun 12 21:50:08 WEST 2023 by beasrodrigues24
\* Created Mon Jun 12 19:38:41 WEST 2023 by beasrodrigues24
