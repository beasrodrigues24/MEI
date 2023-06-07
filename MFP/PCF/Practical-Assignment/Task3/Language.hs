module ProgTerm where

import LTerms
import BTerms
import Probability

data ProgTerm = Asg Vars LTerm | EitherP ProbRep ProgTerm ProgTerm | Seq ProgTerm ProgTerm 
        | Ife BTerm ProgTerm ProgTerm | Wh BTerm ProgTerm deriving Show

-- Changes the value of a variable
chMem :: Vars -> Double -> (Vars -> Double) -> (Vars -> Double)
chMem x r m = \a -> if a /= x then m a else r 

-- Multiplies a whole dist by a probability
multiply :: Dist (Vars -> Double) -> ProbRep -> [((Vars -> Double), ProbRep)]
multiply l p = [(m, pi * p) | (m, pi) <- unD l]
-- Same thing: multiply (D ((m,pi):t)) p = mkD $ ([(m,pi*p)] ++ multiply t p)

apply :: Dist (Vars -> Double) -> ProgTerm -> Dist (Vars -> Double)
apply xs q = mkD $ concatMap (\(m, p) -> multiply (wsem q m) p) (unD xs)
-- Same thing: apply (D ((m,p):t)) q = mkD $ ((multiply (wsem q m) p) ++ apply t q)

wsem :: ProgTerm -> (Vars -> Double) -> Dist (Vars -> Double)
wsem (Asg x t) m = return $ chMem x (sem t m) m 
wsem (EitherP pb p q) m = do pD <- wsem p m ; qD <- wsem q m ; choose pb pD qD
wsem (Seq p q) m = apply (wsem p m) q
wsem (Ife b p q) m | bsem b m = wsem p m 
                   | otherwise = wsem q m
wsem (Wh b p) m | bsem b m = apply (wsem p m) (Wh b p) 
                | otherwise = return m

lexy = Leq x y
xMaisy = (Asg X (Plus x y))
yMaisUm = Asg Y (Plus y (Leaf (Right 1)))

teste1 = EitherP 0.5 xMaisy yMaisUm -- D [(X=1;Y=1;Z=-100,0.5),(X=0;Y=2;Z=-100,0.5)]
teste2 = Seq xMaisy yMaisUm -- D [(X=1,Y=2;Z=-100,1)]
teste3 = Seq teste1 xMaisy -- D [(X=2;Y=1;Z=-100,0.5),(X=2;Y=2;Z=-100,0.5)]
teste4 = Wh lexy (Seq xMaisy yMaisUm) -- D [(X=6;y=4;Z=-100,1.0)]
teste5 = Wh lexy teste3 -- D [(X=6;Y=2;Z=-100,0.25),(X=5;Y=3;Z=-100,0.25),(X=2;Y=1;Z=-100,0.5)]

-- Run Tests
showWsem :: Dist (Vars -> Double) -> Vars -> Dist (Double)
showWsem p x = mkD [(m x, p) | (m, p) <- unD p] 
