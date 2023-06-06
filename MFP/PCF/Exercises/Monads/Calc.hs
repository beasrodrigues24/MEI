-- Different variants of a Calculator 
module Calc where

-- Import of two monads
import DurationMonad
import Probability 

------ Exceptions --------
-- The calculator may raise exceptions

-- Raises an Exception
e :: () -> Maybe a
e () = Nothing

-- A program that can possibly raise an exception.
myDiv :: (Double,Double) -> Maybe Double
myDiv (x,0) = e ()
myDiv (x,y) = return (x / y)

-- Calculates x / (y / z). Note that there are two possible ways
-- of raising an exception.
calc1 :: (Double,Double,Double) -> Maybe Double
calc1 (x,y,z) = do r1 <- myDiv(y,z) ; myDiv(x, r1)

-- Calculates (x / y) / z.
calc2 :: (Double,Double,Double) -> Maybe Double
calc2 (x,y,z) = do r1 <- myDiv(x,y) ; myDiv(r1, z)

-- A program that can possibly raise an exception.
mysqrt :: Double -> Maybe Double
mysqrt d | d < 0 = e ()
         | otherwise = return (sqrt d)

-- Calculates sqrt ( sqrt(x) / y ).
calc3 :: (Double,Double) -> Maybe Double -- (Double,Double,Double) ?
calc3 (x,y) = do r1 <- mysqrt(x) ; r2 <- myDiv(r1,y) ; mysqrt(r2)

------ Durations ---------
-- The calculator takes time to calculate

myDiv' :: (Double,Double) -> Duration Double
myDiv' (x,y) = wait2 ( return (x / y) )

-- Calculates x / (y / z) 
calc1' :: (Double,Double,Double) -> Duration Double
calc1' (x,y,z) = do r1 <- myDiv'(y,z) 
                    myDiv'(x, r1)

-- Calculates (x / y) / z
calc2' :: (Double,Double,Double) -> Duration Double
calc2' (x,y,z) = do r1 <- myDiv'(x,y) ; myDiv'(r1,z)

mysqrt' :: Double -> Duration Double
mysqrt' d = wait2(return (sqrt d))

-- Calculates sqrt ( sqrt(x) / y )
calc3' :: (Double,Double) -> Duration Double
calc3' (x,y) = do r1 <- mysqrt'(x) ; r2 <- myDiv'(r1,y) ; mysqrt'(r2)

------ Non-determinism ---------
-- The calculator nondeterministically outputs wrong values.

nor :: ([a],[a]) -> [a]
nor (l1,l2) = l1 ++ l2

myDiv'' :: (Double,Double) -> [Double]
myDiv'' (x,y) = nor ( return (x / y), return 7 )

-- Calculates x / (y / z) 
calc1'' :: (Double,Double,Double) -> [Double]
calc1'' (x,y,z) = do r1 <- myDiv''(y,z) 
                     myDiv''(x, r1)

-- Calculates (x / y) / z
calc2'' :: (Double,Double,Double) -> [Double]
calc2'' (x,y,z) = do r1 <- myDiv''(x,y) ; myDiv''(r1,z)

mysqrt'' :: Double -> [Double]
mysqrt'' d = nor (return (sqrt(d)), return 7)

-- Calculates sqrt ( sqrt(x) / y )
calc3'' :: (Double,Double) -> [Double]
calc3'' (x,y) = do r1 <- mysqrt''(x) ; r2 <- myDiv''(r1,y) ; mysqrt''(r2)

------ Probabilities ---------
-- The calculator outputs wrong values with a certain probability

por :: (Dist a, Dist a) -> Dist a
por (x,y) = do a <- x
               b <- y
               choose 0.5 a b

myDiv''' :: (Double,Double) -> Dist Double
myDiv''' (x,y) = por ( return (x / y), return 7 )

-- Calculates x / (y / z) 
calc1''' :: (Double,Double,Double) -> Dist Double
calc1''' (x,y,z) = do r1 <- myDiv'''(y,z) 
                      myDiv'''(x, r1)

-- Calculates (x / y) / z
calc2''' :: (Double,Double,Double) -> Dist Double
calc2''' (x,y,z) = do r1 <- myDiv'''(x,y) ; myDiv'''(r1,z)

mysqrt''' :: Double -> Dist Double
mysqrt''' d = por ( return (sqrt d), return 7)

-- Calculates sqrt ( sqrt(x) / y )
calc3''' :: (Double,Double) -> Dist Double
calc3''' (x,y) = do r1 <- mysqrt'''(x) ; r2 <- myDiv'''(r1,y) ; mysqrt'''(r2)


