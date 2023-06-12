--------------------------- MODULE AlternatingBit ---------------------------

EXTENDS Naturals, TLC, Sequences

CONSTANTS N, K

VARIABLES msgs, acks, bitSender, data, mSender, bitReceiv, rcvd, mReceiver

TypeOK == [] (msgs \in Seq([msg : 1..N, bit : 0..1]))
          /\ acks \in Seq(0..1)
          /\ bitSender \in 0..1
          /\ data \in 1..N
          /\ mSender \in [msg: 1..N, bit: 0..1]
          /\ bitReceiv \in 0..1
          /\ rcvd \in 1..N
          /\ mReceiver \in [msg: 1..N, bit: 0..1]
          
Init == /\ msgs = <<>>
        /\ acks = <<>>
        /\ bitSender = 1
        /\ data = 0
        /\ mSender = [msg: 1..N, bit: 0..1]
        /\ bitReceiv = 0
        /\ rcvd = 0
        /\ mReceiver \in [msg: 1..N, bit: 0..1]

empty(set) == Len(set) = 0

receive(set) == set' = Tail(set)

send(m, set) ==
    IF Len(set) < K THEN
        set' = Append(set, m)
    ELSE
        set' = Append(Tail(set), m)

sender_receive_ack == 
    /\ ~empty(acks)
    /\ bitSender = Head(acks)
    /\ receive(acks)
    /\ bitSender' = 1 - bitSender
    /\ data' = 1..N
    /\ msgs' = msgs
    /\ mSender' = mSender 
    /\ bitReceiv' = bitReceiv 
    /\ rcvd' = rcvd
    /\ mReceiver' = mReceiver
    
sender_send_msg == 
    /\ mSender' = [msg |-> data, bit |-> bitSender]
    /\ send(mSender, msgs)
    /\ acks' = acks
    /\ bitSender' = bitSender 
    /\ data' = data
    /\ bitReceiv' = bitReceiv 
    /\ rcvd' = rcvd
    /\ mReceiver' = mReceiver
   
receiver_rcv_msg == 
    /\ ~empty(msgs)
    /\ mReceiver' = Head(msgs)
    /\ receive(msgs)
    /\ rcvd' = mReceiver.data
    /\ bitReceiv' = mReceiver.bit
    /\ acks' = acks
    /\ data' = data 
    /\ mSender' = mSender

receiver_send_ack == 
    /\ send(bitReceiv, acks)
    /\ msgs' = msgs 
    /\ bitSender' = bitSender 
    /\ data' = data 
    /\ mSender' = mSender 
    /\ bitReceiv' = bitReceiv 
    /\ rcvd' = rcvd 
    /\ mReceiver' = mReceiver

dropper_drop_msg == 
    /\ ~empty(msgs)
    /\ receive(msgs) 
    /\ acks' = acks
    /\ bitSender' = bitSender 
    /\ data' = data 
    /\ mSender' = mSender 
    /\ bitReceiv' = bitReceiv 
    /\ rcvd' = rcvd 
    /\ mReceiver' = mReceiver 
    
dropper_drop_acks == 
    /\ ~empty(acks)
    /\ receive(acks) 
    /\ msgs' = msgs
    /\ bitSender' = bitSender 
    /\ data' = data 
    /\ mSender' = mSender 
    /\ bitReceiv' = bitReceiv 
    /\ rcvd' = rcvd 
    /\ mReceiver' = mReceiver 
    
Next == sender_receive_ack \/ sender_send_msg \/ receiver_rcv_msg \/ receiver_send_ack
        \/ dropper_drop_msg \/ dropper_drop_acks
    
vars == <<msgs, acks, bitSender, data, mSender, bitReceiv, rcvd, mReceiver>>    
    
Algorithm == Init /\ [][Next]_vars /\ WF_vars(Next)

=============================================================================
\* Modification History
\* Last modified Mon Jun 12 19:13:44 WEST 2023 by beasrodrigues24
\* Created Mon Jun 12 18:27:40 WEST 2023 by beasrodrigues24
