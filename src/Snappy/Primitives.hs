{-|Helpful primitives
 -}
module Snappy.Primitives where

import Snappy

{-|Ordered collection of things, where everything depends on previous element -}
newtype Chain a = collection :: [a]

{-|TODO Unordered collection of things, where everything can be instantiated in parallel (though not necessarily is) -}
type Fork a = [a]

--instance (Thing t) => Thing (Chain t) where
--  instantiate t = map instantiate (collection t)
