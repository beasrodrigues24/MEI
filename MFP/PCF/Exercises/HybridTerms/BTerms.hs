module BTerms where

import LTerms

data BTerm = Leq LTerm LTerm | Conj BTerm BTerm | Neg BTerm deriving Show

bsem :: BTerm -> (Vars -> Double) -> Bool
bsem (Leq t1 t2) e = if (sem t1 e) <= (sem t2 e) then True else False
bsem (Neg b) e = not (bsem b e)
bsem (Conj b1 b2) e = (bsem b1 e) && (bsem b2 e)


