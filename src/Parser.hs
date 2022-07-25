module Parser where

import Data.Void ( Void )
import Data.Text ( Text, pack, unpack )

import           Text.Megaparsec
import           Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L

import Expr ( Term(..) )

type Parser = Parsec Void Text

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
  case v of
    "let" -> fail "keyword `let` is reserved" 
    "in"  -> fail "keyword `in` is reserved" 
    _     -> pure $ Var (pack v)

pAbs :: Parser Term
pAbs = do
  lexeme $ char '\\' <|> char 'λ'
  p <- lexeme $ some letterChar
  lexeme $ char '.'
  b <- lexeme pTerm
  pure $ Abs (pack p) b

pApp :: Parser Term
pApp = do
  v <- lexeme $ some $ pInt <|> pVar <|> parens pTerm
  pure $ foldl1 App v

-- let id := λx.x in id 2
pLet :: Parser Term
pLet = do
  lexeme $ string "let"
  id' <- lexeme $ some letterChar
  lexeme $ string ":="
  letBody <- lexeme pTerm
  lexeme $ string "in"
  inBody <- lexeme pTerm
  pure $ Let (pack id') letBody inBody

pInt :: Parser Term
pInt = do
  x <- some numberChar
  pure $ Lit (read x)

pTerm :: Parser Term
pTerm = choice $ try <$> [pInt, pAbs, pLet, pApp, pVar]

parens :: Parser a -> Parser a
parens = between (lexeme $ char '(') (lexeme $ char ')')

-- String !== [Char]
parseTerm :: Text -> Either Text Term
parseTerm input =
  let
    outputE = parse
      (between sc eof pTerm)
      ""
      -- The actual string to be parsed
      input
  in
  case outputE of
    Left err -> Left $ pack (errorBundlePretty err)
    Right output -> Right output
