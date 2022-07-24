module Parser
  ( Term
  , parseTerm
  , pTerm
  , pApp
  , pAbs
  , pVar
  ) where

import Data.Void ( Void )

import           Text.Megaparsec
import           Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L

import Expr ( Term(..) )

type Parser = Parsec Void String

sc :: Parser ()
sc = L.space
  space1
  (L.skipLineComment "//")
  empty

lexeme :: Parser a -> Parser a
lexeme = L.lexeme sc

pVar :: Parser Term
pVar = do
  v <- lexeme $ some letterChar
  pure $ Var v

pAbs :: Parser Term
pAbs = do
  lexeme $ char '\\' <|> char 'λ'
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

parseTerm :: String -> Either String Term
parseTerm input =
  let
    outputE = parse
      (between sc eof pTerm)
      ""
      -- The actual string to be parsed
      input
  in
  case outputE of
    Left err -> Left $ errorBundlePretty err
    Right output -> Right output
