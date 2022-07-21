module Main where

import Data.Void ( Void )

import           Text.Megaparsec
import           Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L

type Parser = Parsec Void String

data Term
  = Var String
  | Abs String Term
  | App Term Term
  deriving (Show)

sc :: Parser ()
sc = L.space
  space1
  (L.skipLineComment "//")
  empty

lexeme :: Parser a -> Parser a
lexeme = L.lexeme sc

-- (\ a . a) "b"
-- Var "2"
-- Var "a"

pVar :: Parser Term
pVar = do
  v <- lexeme $ some letterChar
  pure $ Var v

pAbs :: Parser Term
pAbs = do
  lexeme $ char '\\'
  p <- lexeme $ some letterChar
  lexeme $ char '.'
  b <- lexeme pTerm
  pure $ Abs p b

pApp :: Parser Term
pApp = do
  v <- lexeme $ some $ pVar <|> parens pTerm
  pure $ foldl1 App v

pTerm :: Parser Term
pTerm = choice [pAbs, pApp, pVar]

parens :: Parser a -> Parser a
parens = between (lexeme $ char '(') (lexeme $ char ')')

id' = "\\ x . x"
idApp = "a b c d"

main :: IO ()
main = undefined
