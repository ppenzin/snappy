{-|Common system primitives, like editing files
 -}
module System where

{-|Something to manage file contents
   path -- path to the file
   sourcePath -- path to the file to copy it from
 -}
data File = File { path :: String, sourcePath :: String }

{- TODO implement instance of Thing for it -}
