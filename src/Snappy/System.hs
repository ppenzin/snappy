{-|Common system primitives, like editing files
 -}
module Snappy.System where

import Snappy
import System.IO
import System.Directory

{-|Something to manage file contents
   path -- path to the file
   sourcePath -- path to the file to copy it from
 -}
data File = File { path :: String, sourcePath :: String }

{- TODO implement instance of Thing for it -}

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
  isPresent l = doesFileExist thePath >>= \yes -> if yes then (readFile thePath >>= return . match . lines) else return False
    where thePath = filePath l
          match [] = False
          match (x:xs) = if (x == (lineText l)) then True else (match xs)
  {-|Comment is appended first, then line, both 'as-is'-}
  instantiate l = doesFileExist thePath
              >>= \yes -> return (if yes then WriteMode else AppendMode)
              >>= \mode -> openFile thePath mode
              >>= \handle -> hPutStr handle (toAppend (lineText l) (comment l))
               >> hClose handle
    where thePath = filePath l
          toAppend line comment = (if comment /= "" then ("\n" ++ comment) else "" ) ++ "\n" ++ line ++ "\n" -- TODO system newlines
