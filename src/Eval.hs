module Eval where

import Data.Map as Map
import Data.Text (Text)

import Parser
import Expr
import qualified Data.Map.Strict as M
import qualified Data.Maybe

eval :: Context -> Term -> Maybe Value
eval ctx =
  \case
    Let id idBody inBody ->
      let idBody' = eval ctx idBody
        in case idBody' of
          Just b -> eval (Map.insert id b ctx) inBody
          _      -> Nothing
    App f a ->
      let f' = eval ctx f
          a' = eval ctx a
       in case f' of
        Just x -> case x of
          Closure ctx' (Lambda p b) ->
            case a' of
              Just a -> eval (Map.insert p a ctx) b
              _ -> Nothing
          int@(VInt v) -> Just int
        _ -> Nothing
    Abs p b ->
      let l = Lambda p b
       in Just $ Closure ctx l
    Var name    -> Map.lookup name ctx
    Lit n -> Just $ VInt n
