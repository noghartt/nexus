module Main where

import System.Environment (getArgs)
import System.IO
import Control.Monad

import Data.Map as Map
import Data.Text (Text, unpack, pack)
import Data.Maybe (fromMaybe)

import Eval
import Parser
import Expr

printParse :: Text -> Value
printParse x =
  case parseTerm x of
    Right ast ->
      fromMaybe undefined (eval Map.empty ast)
    Left err  -> VNil

main :: IO ()
main = do
  (p:_) <- getArgs
  handle <- openFile p ReadMode
  contents <- hGetContents handle
  print $ printParse (pack contents)
