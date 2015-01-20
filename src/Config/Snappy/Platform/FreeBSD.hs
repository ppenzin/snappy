{-| FreeBSD primitives 
    Dependencies:
    - pkgng
    - optionsNG
 -}
module Config.Snappy.Platform.FreeBSD where

import Config.Snappy
import System.Directory
import System.Process
import System.Exit

-- |Root directory for ports tree 
portsRoot :: String
portsRoot =  "/usr/ports"

-- |Users base directory
usersBase :: String
usersBase =  "/home"

{-|A port defenition
  category - category, such as www
  packageName - name, such as opera
  withOpts - options to enable (from OptionsNG)
  withoutOpts - options to disable (from OptionsNG)
 -}
data Port = Port {
                   category :: String,
                   packageName :: String,
                   withOpts :: [String],
                   withoutOpts :: [String]
                 }

-- TODO automate: set a configuration and force its use
-- need to confirm, but WITH and WITHOUT syntax is able
-- turn options on and off, -DBATCH flag should force it
instance Thing Port where
  instantiate p =
--     putStrLn ("Extra options: " ++ show(allArguments))
    (setCurrentDirectory $ portsRoot
       ++ "/" ++ (category p) ++ "/" ++ (packageName p))
    >> callProcess "make" (extraOpts ++ ["config-recursive"]) 
    >> callProcess "make" ["install", "clean"]
    >> return () -- TODO throw exceptions
    where extraOpts = optsArg "WITH" (withOpts p) ++
                      optsArg "WITHOUT" (withoutOpts p)
          optsArg name opts = if opts == [] then [] else [makeOpt name opts]
          makeOpt name opts = name ++ "=" ++ optsStr opts
          optsStr [] = ""
          optsStr (x:xs) = x ++ (\s -> if s == "" then "" else " " ++ s)(optsStr xs)
  isPresent p =
    isPresent (Package {name = packageName p})

{-|Port with a default configuration
 -}
port = Port { category = "", packageName = "", withOpts = [], withoutOpts = []}

-- |A package defenition
data Package = Package { name :: String }

instance Thing Package where
  instantiate p =
    callProcess "pkg" ["install", name p] -- TODO throw exceptions
  isPresent p =
    readProcessWithExitCode "pkg" ["info", "-e", name p] ""
    >>= \(status, _, _) -> return (status == ExitSuccess)

{-|A file in user's home directory
 -}
data UserFile = UserFile { relativePath :: String, absSrcPath :: String}

{- TODO an instance of thing for it -}

{-|Run some IO computation of every user directry
   get a list of results
 -}
forEveryUser :: (String -> IO a) -> IO [a]
forEveryUser f = undefined
