{-| FreeBSD primitives 
    Dependencies:
    - pkgng
 -}
module Snappy.Platform.FreeBSD where

import Snappy
import System.Directory
import System.Cmd
import System.Exit

-- |Root directory for ports tree 
portsRoot :: String
portsRoot =  "/usr/ports"

-- |A port defenition
data Port = Port { category :: String, packageName :: String }

instance Thing Port where
  instantiate p =
    (setCurrentDirectory $ portsRoot
       ++ "/" ++ (category p) ++ "/" ++ (packageName p))
    >> rawSystem "make" ["install", "clean"]
    >> return () -- TODO throw exceptions
  isPresent p =
    isPresent (Package {name = packageName p})

-- |A package defenition
data Package = Package { name :: String }

instance Thing Package where
  instantiate p =
    rawSystem "pkg" ["install", name p] 
    >> return () -- TODO throw exceptions
  isPresent p =
    rawSystem "pkg" ["info", "-e", name p] 
    >>= return . ( == ExitSuccess)

