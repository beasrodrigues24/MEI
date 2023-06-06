module LTerms where

data Vars = X | Y | Z deriving (Show, Eq)

data LTerm = Leaf (Either Vars Double) | Plus LTerm LTerm | Mult Double LTerm
        deriving Show

sem :: LTerm -> (Vars -> Double) -> Double
sem (Leaf (Left x)) e = e x
sem (Leaf (Right r)) e = r
sem (Mult s t) e = s * (sem t e)
sem (Plus t1 t2) e = (sem t1 e) + (sem t2 e)

sigma (X) = 0
sigma (Y) = 1
sigma (Z) = -100
x = Leaf (Left X)
y = Leaf (Left Y)
z = Leaf (Left Z)

-- x + 2 * y
t = Plus x (Mult 2 y)

-- 2 * x + 2 * y
t2 = Plus (Mult 2 x) (Mult 2 y)

-- 3 * (2 * x) + 2 * (y + z)
t3 = Plus (Mult 3 (Mult 2 x)) (Mult 2 (Plus y z)) 
