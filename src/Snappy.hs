{-| Snappy -- library of various system installation primitives -}
module Snappy where

class Thing a where
  instantiate :: a -> IO ()
  isPresent   :: a -> IO Bool
