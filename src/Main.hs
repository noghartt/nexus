module Main where

import qualified Data.Map.Strict as M

import Parser
import Expr ( Term(..) )

alphaConvert :: Term -> String -> Term -> Term
alphaConvert var@(Var n) v r
  | n == v    = r
  | otherwise = var
alphaConvert (App f a) v r =
  let f' = alphaConvert f v r
      a' = alphaConvert a v r
    in App f' a'
alphaConvert abs@(Abs n b) v r
  | n == v    = abs
  | otherwise =
      let b' = alphaConvert b v r
       in Abs n b'

betaReduce :: Term -> Term
betaReduce var@(Var v) = var
betaReduce (Abs v b)   = Abs v (betaReduce b)
betaReduce (App f a)   =
  case betaReduce f of
    Abs v b -> alphaConvert b v a
    x       -> App x (betaReduce a)

reduce :: Term -> Term
reduce ast =
  let ast' = betaReduce ast
   in if ast /= ast'
        then reduce ast'
        else ast

printParse x = 
  case parseTerm x of
    Right x -> print $ reduce x
    Left err -> putStrLn err

main :: IO ()
main = undefined
