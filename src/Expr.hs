module Expr ( Term(..) ) where

data Term
  = Var String
  | Abs String Term
  | App Term Term
  deriving (Eq)

instance Show Term where
  show (App x y)    = showX x ++ showY y where
    showX (Abs _ _) = "(" ++ show x ++ ")"
    showX _         = show x
    showY (Var s)   = ' ':s
    showY _         = "(" ++ show y ++ ")"
  show (Abs s t)    = "\955" ++ s ++ showB t where
    showB (Abs x y) = "" ++ x ++ showB y
    showB expr      = "." ++ show expr
  show (Var s)      = s
