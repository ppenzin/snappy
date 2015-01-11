{-# LANGUAGE ExistentialQuantification #-}
{-| Snappy -- library of various system installation primitives
  -}
module Config.Snappy where

import Config.Snappy.Shuffle

{-|Thing is something installable
 -}
class Thing a where
  instantiate, ensure :: a -> IO ()
  isPresent           :: a -> IO Bool
  ensure x            = isPresent x >>= \a -> if a then return() else instantiate x 

{-|Container for Thing which hides the actual type instance
 -}
data SomeThing = forall a. (Thing a) => Some a 

{-|Obvious instance of Thing for its container
 -}
instance Thing (SomeThing) where
  isPresent (Some x) = isPresent x
  instantiate (Some x) = instantiate x

{-|Collection without dependencies
   all of the elements will get instanciated
   together, but no particular order is
   enforced. Collection is shuffled before
   taking any action.
 -}
instance (Thing a) => Thing [a] where
  isPresent xs = shuffle xs >>= verify
    where verify (x:xs) = isPresent x
                      >>= \b -> if b then (isPresent xs) else return False
          verify []     = return True
  instantiate xs = shuffle xs >>= install
    where install (x:xs) = ensure x >> install xs
          install []     = return ()

{-|Order of dependencies
   `from' element with be treated befor the `to'
   element
 -}
data Arrow a b = Arrow {from :: a, to :: b}

{-|Infix operator to create dependency ordering -}
(~>) :: a -> b -> (Arrow a b)
x ~> y = Arrow { from = x, to = y}

{-|Execution instance for ordered dependencies
 -}
instance (Thing a, Thing b) => Thing (Arrow a b) where
  isPresent a = isPresent (from a) >>= \t -> if t then isPresent (to a) else return False
  instantiate a = ensure (from a) >> ensure (to a)

{-|Conditional installation
  Before instantiating it will check the condition
  (can be user prompt, hardware scan, etc)
 -}
data Conditional a = Conditional {condition :: IO Bool, subject :: a}

instance (Thing a) => Thing (Conditional a) where
  isPresent c = isPresent (subject c)
  instantiate c = (condition c)
              >>= \needed -> if needed then (instantiate (subject c))
                                       else return ()

