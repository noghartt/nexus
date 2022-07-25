module Expr where

import Data.Text ( Text )
import Data.Map as M

type Id      = Text
type Context = Map Text Value

data Term
  = Var Id
  | Abs Id Term
  | App Term Term
  | Let Id Term Term
  | Lit Int
  deriving (Show)

data Lambda = Lambda Text Term
  deriving (Show)

data Value
  = VInt Int
  | VNil
  | Closure Context Lambda
  deriving (Show)

-- instance Show Term where
  -- show (App x y)    = showX x ++ showY y where
    -- showX (Abs _ _) = "(" ++ show x ++ ")"
    -- showX _         = show x
    -- showY (Var s)   = ' ':s
    -- showY _         = "(" ++ show y ++ ")"
  -- show (Abs s t)    = "\955" ++ s ++ showB t where
    -- showB (Abs x y) = "" ++ x ++ showB y
    -- showB expr      = "." ++ show expr
  -- show (Var s)      = s
