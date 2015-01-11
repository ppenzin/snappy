{-|Common system primitives, like editing files
 -}
module Config.Snappy.System where

import Config.Snappy
import System.IO
import System.Cmd
import System.Directory

{-|Something to manage file contents
   path -- path to the file
   sourcePath -- path to the file to copy it from
 -}
data File = File { path :: String, sourcePath :: String }

{- Instance of Thing for it -}
instance Thing File where 
  instantiate f = copyFile (sourcePath f) (path f)
  isPresent f = doesFileExist thePath
            >>= \yes -> if yes then compareFiles
                        else return False
    where thePath = path f
          srcPath = sourcePath f
          compareFiles = readFile thePath
                     >>= \content -> readFile srcPath
                     >>= \src -> return (content == src) -- TODO improve

{-|Add a single line to a file
   filePath -- path to the file
   lineText -- text you want to be present in a file
   comment -- optional comment to place above the line
              (including all the comment symbols)
 -}
data FileLine = FileLine { filePath :: String,
                           lineText :: String,
                           comment :: String }

{-|Instance of Thing for FileLine
 -}
instance Thing (FileLine) where
  {-|Line is present if there is its exact match in the file-}
  isPresent l = doesFileExist thePath
            >>= \yes -> if yes then (
                  readFile thePath >>= return . findMatch
                ) else return False
    where thePath = filePath l
          findMatch xs = forceRead xs `seq` (match (lines xs))
          match [] = False
          match (x:xs) = if (x == (lineText l)) then True else (match xs)
          forceRead [] = ()
          forceRead (x:xs) = forceRead xs
  {-|Comment is appended first, then line, both 'as-is'-}
  instantiate l = doesFileExist thePath
              >>= \yes -> return (if yes then AppendMode else WriteMode)
              >>= \mode -> openFile thePath mode
              >>= \handle -> hPutStr handle (toAppend (lineText l) (comment l))
               >> hClose handle
    where thePath = filePath l
          toAppend line comment = (if comment /= "" then ("\n" ++ comment) else "" ) ++ "\n" ++ line ++ "\n" -- TODO system newlines

{-| A generated file, such as XOrg config
 -}
data GeneratedFile = GeneratedFile {
                       genFilePath :: String,
                       genFileCmd :: String,
                       genFileCmdOpts :: [String]
                     }

instance Thing (GeneratedFile) where
  instantiate gf = rawSystem (genFileCmd gf) (genFileCmdOpts gf)
                >> return ()
  isPresent gf = doesFileExist (genFilePath gf)

-- |A command to run
data Command = Command { cmd :: String, opts :: [String] }
instance Thing Command where
  isPresent c  = return False
  instantiate c = rawSystem (cmd c) (opts c) >> return ()

command = Command { cmd = undefined, opts = []}
