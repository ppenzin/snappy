{-| Snappy -- library of various system installation primitives
  -}
module Snappy where

import Snappy.Shuffle

{-|Thing is something installable
 -}
class Thing a where
  instantiate, ensure :: a -> IO ()
  isPresent           :: a -> IO Bool
  ensure x            = isPresent x >>= \a -> if a then return() else instantiate x 

{-|List of things
   is a collection without dependencies
   all of them will get instanciated
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
