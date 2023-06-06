module ProgTerm where

import LTerms
import BTerms

data ProgTerm = Asg Vars LTerm | Seq ProgTerm ProgTerm 
        | Ife BTerm ProgTerm ProgTerm | Wh BTerm ProgTerm deriving Show

chMem :: Vars -> Double -> (Vars -> Double) -> (Vars -> Double)
chMem x r m = \a -> if a /= x then m a else r

wsem :: ProgTerm -> (Vars -> Double) -> (Vars -> Double)
wsem (Asg x t) m = let r = sem t m in chMem x r m 
wsem (Seq p q) m = let m' = wsem p m
                       m'' = wsem q m' in m''
wsem (Ife b p q) m = let v = bsem b m
                         m' = wsem p m
                         m'' = wsem q m in if v then m' else m''
wsem (Wh b p) m = let v = bsem b m
                      m' = wsem p m
                      m'' = wsem (Wh b p) m' in 
                                if v then m'' else m

-- teste
lexx = Leq x x
xMaisy = (Asg X (Plus x y))
yMaisUm = Asg Y (Plus y (Leaf (Right 1)))
teste = Wh lexx (Seq xMaisy yMaisUm)

