module ProgTerm where

import LTerms
import BTerms

-- Added a to the data type to use a list in the Write
data ProgTerm a = Asg Vars LTerm | Write [a] (ProgTerm a)  | Seq (ProgTerm a) (ProgTerm a) 
        | Ife BTerm (ProgTerm a) (ProgTerm a) | Wh BTerm (ProgTerm a) deriving Show

-- Kept this the same as the one provided in the classes
chMem :: Vars -> Double -> (Vars -> Double) -> (Vars ->  Double)
chMem x r m = \a -> if a /= x then m a else r -- Changes the value of a variable

-- Added the Write case and adapted all of the cases to fit the new type ([a], Vars -> Double)
-- This way there will be kept comments on the left side of the pair and the result on the right side 
wsem :: (ProgTerm a) -> ([a], Vars -> Double) -> ([a], Vars -> Double)
wsem (Asg x t) (n, m) = (n, chMem x (sem t m) m) -- chMem doesn't change the messages
wsem (Write l t) (n, m) = wsem t (n ++ l, m) -- Write appends new messages to the previously established ones
wsem (Seq p q) (n, m) = wsem q (fst pair, snd pair) -- q will use p's output 
    where pair = wsem p (n,m)
wsem (Ife b p q) (n, m) | bsem b m = wsem p (n,m) -- Standard if 
                        | otherwise = wsem q (n,m)
wsem (Wh b p) (n, m) | bsem b m = wsem (Wh b p) (fst pair, snd pair) -- If while keeps running, it uses the output of executing p once 
                     | otherwise = (n,m)
    where pair = wsem p (n,m)

-- For testing purposes I added this, since Haskell doesn't have show for ([a], Vars->double)
printResult r v = (list,result v)
    where (list,result) = r 

lexx = Leq x y
xMaisy = (Asg X (Plus x y))
yMaisUm = Asg Y (Plus y (Leaf (Right 1)))
teste = Wh lexx (Seq xMaisy yMaisUm)

test1 = Write ["ola", "ole"] xMaisy
test2 = Write ["ola", "ole"] yMaisUm 
test3 = Write ["ola", "ole"] teste 
