module Lib2 where

import Data.Either
import Text.Read

data InitData = InitData
  { gameWidth :: Int,
    gameHeight :: Int
  }
  deriving (Show)

data JsonLike
  = JsonLikeInteger Integer
  | JsonLikeString String
  | JsonLikeObject [(String, JsonLike)]
  | JsonLikeList [JsonLike]
  | JsonLikeNull
  deriving (Show)

-- | Change State the way need but please keep
--  the name of the type, i.e. "State"
data State = State JsonLike [[[Integer]]] InitData
  deriving (Show)

parseJsonMessage :: String -> Either String JsonLike
parseJsonMessage xs = Prelude.Right (parse (JsonLikeString xs))

-- | Is called in a very beginning of a game
init ::
  -- | Initial data of the game
  InitData ->
  -- | First json message before any moves performed
  JsonLike ->
  -- | An initial state based on initial data and first message
  State
init i j = State j (applyLinkedListParser (getSurrounding j)) i

-- | Is called after every user interaction (key pressed)
update ::
  -- | Current state
  State ->
  -- | Json message from server
  JsonLike ->
  -- | A new state, probably based on the message arrived
  State
update (State j currGame i) newGameJson = State newGameJson (applyUniqueValues ([]:drop 1 (applyExplodedBricks currGame newGame (getBomb j))) newGame) i
   where newGame = applyLinkedListParser (getSurrounding newGameJson)

-- | Renders the current state
render ::
  -- | A state to be rendered
  State ->
  -- | A string which represents the state. The String is rendered from the upper left corner of terminal.
  String
render (State j game (InitData gameWidth gameHeight)) = fillBomb (getBomb j) (renderGameNew game (toInteger gameWidth) (toInteger gameHeight)) (toInteger gameWidth)
-- JSON Parsing

-- Helper functions

-- Removes curly brackets from String, if they exist
stripCurlyBrackets :: String -> String
stripCurlyBrackets "" = ""
stripCurlyBrackets (x:xs)
   | x == '{'  = Prelude.init xs
   | otherwise = x:xs

-- Removes square brackets from String, if they exist
stripSquareBrackets :: String -> String
stripSquareBrackets "" = ""
stripSquareBrackets (x:xs)
   | x == '['  = Prelude.init xs
   | otherwise = x:xs

-- Appends a tuple of (String, JsonLike) to a JsonLikeObject
appendToJsonLikeObject x (JsonLikeObject []) = JsonLikeObject [x]
appendToJsonLikeObject x (JsonLikeObject xs) = JsonLikeObject (x:xs)

-- parseJsonLikeObjectName "\"bomb\":null"                   ==> "bomb"
-- parseJsonLikeObjectName "\"bombermans\":{\"head\":null"}" ==> "bombermans"
parseJsonLikeObjectName :: String -> String
parseJsonLikeObjectName (x:xs)
   | x == '\"' = parseJsonLikeObjectName' xs
   | otherwise = "incorrect name: " ++ (x:xs)

parseJsonLikeObjectName' :: String -> String
parseJsonLikeObjectName' (x:xs)
   | x == '\"' = ""
   | otherwise = x : parseJsonLikeObjectName' xs


-- parseJsonLikeObjectValue "\"bomb\":null"                   ==> "null"
-- parseJsonLikeObjectValue "\"bombermans\":{\"head\":null"}" ==> "{\"head\":null"}"
parseJsonLikeObjectValue :: String -> String
parseJsonLikeObjectValue "" = ""
parseJsonLikeObjectValue (x:xs)
   | x == ':'  = parseJsonLikeObjectValue' xs 0
   | otherwise = parseJsonLikeObjectValue xs

parseJsonLikeObjectValue' :: String -> Int -> String
parseJsonLikeObjectValue' "" _ = ""
parseJsonLikeObjectValue' (x:xs) brCount
   | x == '{'                   = x : parseJsonLikeObjectValue' xs (brCount + 1)
   | x == '}' && brCount == 0 = ""
   | x == '}' && brCount /= 0 = x : parseJsonLikeObjectValue' xs (brCount - 1)
   | otherwise                  = x : parseJsonLikeObjectValue' xs brCount


-- parseJsonLikeInteger "123"  ==> Right 123
-- parseJsonLikeInteger "123b" ==>  Left "error: integer parse"
parseJsonLikeInteger :: String -> Either String JsonLike
parseJsonLikeInteger xs = case (readEither xs :: Either String Integer) of
   Left  err -> Left "error: integer parse"
   Right num -> Right (JsonLikeInteger num)


-- parseJsonLikeNull "null"  ==> Right 123
-- parseJsonLikeNull "nulll" ==> Left "error: null parse"
parseJsonLikeNull :: String -> Either String JsonLike
parseJsonLikeNull xs
   | xs == "null" = Right JsonLikeNull
   | otherwise    = Left "error: null parse"


-- Breaks down a JsonLikeString, if it's a JsonLikeList, into individual elements
-- divideJsonLikeList "[1,2,3]"             ==> ["1", "2", "3"]
-- divideJsonLikeList "[[1,6],[1,7],[1,8]]" ==> ["[1,6]","[1,7]","[1,8]"]
divideJsonLikeList :: String -> [String]
divideJsonLikeList xs = divideJsonLikeList' (stripSquareBrackets xs) 0 ""

divideJsonLikeList' "" _ str = [str]
divideJsonLikeList' (x:xs) brCount str
   | x == '['                   = divideJsonLikeList' xs (brCount + 1) (str ++ [x])
   | x == ']'                   = divideJsonLikeList' xs (brCount - 1) (str ++ [x])
   | x == ',' && brCount == 0 = str : divideJsonLikeList' xs brCount ""
   | otherwise                  = divideJsonLikeList' xs brCount (str ++ [x])

-- Parses each string, representing an element in a list, to a JsonLike
-- parseJsonLikeList "[null,null,null]"    ==> Right (JsonLikeList [JsonLikeNull,JsonLikeNull,JsonLikeNull])
-- parseJsonLikeList "[[1,6],[1,7],[1,8]]" ==> Right (JsonLikeList [JsonLikeList [JsonLikeInteger 1,JsonLikeInteger 6],
--                                             JsonLikeList [JsonLikeInteger 1,JsonLikeInteger 7],
--                                             JsonLikeList [JsonLikeInteger 1,JsonLikeInteger 8]])
-- parseJsonLikeList "{null,null,null}"    ==> Left "error: list parse"

parseJsonLikeList :: String -> Either String JsonLike
parseJsonLikeList (x:xs)
   | x == '[' = Right (JsonLikeList (parseJsonLikeList' (x:xs)))
   | otherwise = Left "error: list parse"

parseJsonLikeList' xs = parseJsonLikeList'' (divideJsonLikeList xs)

parseJsonLikeList'' [] = []
parseJsonLikeList'' (x:xs)
   | isRight (parseJsonLikeNull x)    = fromRight (JsonLikeString "error") (parseJsonLikeNull x) : parseJsonLikeList'' xs
   | isRight (parseJsonLikeInteger x) = fromRight (JsonLikeString "error") (parseJsonLikeInteger x) : parseJsonLikeList'' xs
   | otherwise                        = JsonLikeList (parseJsonLikeList' x) : parseJsonLikeList'' xs


-- Divide a JsonLikeObject to a separate list of JsonLikeStrings
-- divideJsonLikeObject (JsonLikeString "\"bombermans\":{\"head\":[1,1],\"tail\":{\"head\":null}")
--                  ==> [JsonLikeString "\"bombermans\":{\"head\":[1,1],\"tail\":{\"head\":null}"]
-- divideJsonLikeObject (JsonLikeString "\"head\":[1,1],\"tail\":{\"head\":null}") -->
--                  ==> [JsonLikeString "\"head\":[1,1]",JsonLikeString "\"tail\":{\"head\":null}"]
divideJsonLikeObject :: JsonLike -> [JsonLike]
divideJsonLikeObject (JsonLikeString xs) = divideJsonLikeObject' (divideJsonLikeObject'' (stripCurlyBrackets xs) 0 0 "")

divideJsonLikeObject' = map JsonLikeString

divideJsonLikeObject'' "" _ _ str = [str]
divideJsonLikeObject'' (x:xs) cbrCount sbrCount str
   | x == '['                                     = divideJsonLikeObject'' xs cbrCount (sbrCount + 1) (str ++ [x])
   | x == ']'                                     = divideJsonLikeObject'' xs cbrCount (sbrCount - 1) (str ++ [x])
   | x == '{'                                     = divideJsonLikeObject'' xs (cbrCount + 1) sbrCount (str ++ [x])
   | x == '}'                                     = divideJsonLikeObject'' xs (cbrCount - 1) sbrCount (str ++ [x])
   | x == ',' && cbrCount == 0 && sbrCount == 0 = str : divideJsonLikeObject'' xs cbrCount sbrCount ""
   | otherwise                                    = divideJsonLikeObject'' xs cbrCount sbrCount (str ++ [x])


-- Merge a list of JsonLikeStrings to a JsonLikeObject
-- mergeJsonLikeObject (divideJsonLikeObject (JsonLikeString "\"head\":[1,1],\"tail\":{\"head\":null}")) -->
--                 ==> JsonLikeObject [("head",JsonLikeString "[1,1]"),("tail",JsonLikeString "{\"head\":null}")]
mergeJsonLikeObject :: [JsonLike] -> JsonLike
mergeJsonLikeObject xs = JsonLikeObject (mergeJsonLikeObject' xs)

mergeJsonLikeObject' [] = []
mergeJsonLikeObject' ((JsonLikeString x) : xs) =
   (
      parseJsonLikeObjectName x,
      JsonLikeString (parseJsonLikeObjectValue x)
   ) : mergeJsonLikeObject' xs


-- parseJsonLikeObjectString (JsonLikeString "\"bombermans\":{\"head\":[1,1],\"head\":[1,1]")
--                      ==>  JsonLikeObject [("bombermans",JsonLikeString "{\"head\":[1,1],\"head\":[1,1]")]
-- parseJsonLikeObjectString (JsonLikeString "null")
--                      ==>  JsonLikeNull
-- Parses a JsonLikeString into a JsonLike type
parseJsonLikeObjectString :: JsonLike -> JsonLike
parseJsonLikeObjectString (JsonLikeString xs)
   | isRight (parseJsonLikeNull xs)    = fromRight (JsonLikeString "error") (parseJsonLikeNull xs)
   | isRight (parseJsonLikeInteger xs) = fromRight (JsonLikeString "error") (parseJsonLikeInteger xs)
   | isRight (parseJsonLikeList xs)    = fromRight (JsonLikeString "error") (parseJsonLikeList xs)
   | otherwise                         = mergeJsonLikeObject (divideJsonLikeObject (JsonLikeString xs))

-- parseJsonLikeObject (JsonLikeObject [("head",JsonLikeString "[1,1]"),("tail",JsonLikeString "{\"head\":null}")])
--                 ==> JsonLikeObject [("head",JsonLikeList [JsonLikeInteger 1,JsonLikeInteger 1]),
--                                     ("tail",JsonLikeObject [("head",JsonLikeNull)])]
-- Parses each second value of tuple in an object: JsonLikeObject [(name, unparsedValue)]
--                                             ==> JsonLikeObject [(name, parsedValue)]
parseJsonLikeObject :: JsonLike -> JsonLike
parseJsonLikeObject (JsonLikeObject []) = JsonLikeObject []
parseJsonLikeObject JsonLikeNull = JsonLikeNull
parseJsonLikeObject (JsonLikeList x) = JsonLikeList x
parseJsonLikeObject (JsonLikeObject x) = case x of
   ((x1,JsonLikeString x2) : xs) ->
      appendToJsonLikeObject (x1,parseJsonLikeObject (parseJsonLikeObjectString (JsonLikeString x2))) (parseJsonLikeObject (JsonLikeObject xs))

-- Final parser
parse :: JsonLike -> JsonLike
parse xs = parseJsonLikeObject (mergeJsonLikeObject (divideJsonLikeObject xs))

-- Formatting into a game
-- Parses values from a JsonLikeList to a standard list
getList (JsonLikeList []) = []
getList (JsonLikeList (x:xs)) = case x of
   (JsonLikeInteger x) -> x : getList (JsonLikeList xs)

getValue x = case x of
   (JsonLikeList x) -> Right (getList (JsonLikeList x))
   JsonLikeNull     -> Left JsonLikeNull

-- Parses a linked list into a standard list
linkedListParser xs = reverse (linkedListParser' xs)

linkedListParser' (JsonLikeObject [(head, headVal), (tail, tailVal)])
   | isRight (getValue headVal) = fromRight [] (getValue headVal) : linkedListParser' tailVal
   | otherwise                  = []

-- Applies the parser to a JsonObject
applyLinkedListParser (JsonLikeObject []) = []
applyLinkedListParser (JsonLikeObject ((n,v):xs)) = linkedListParser v : applyLinkedListParser (JsonLikeObject xs)

getBomb (JsonLikeObject [(bombName,bombVal), (surrName,surrVal)]) = getValue bombVal
getSurrounding (JsonLikeObject [(bombName,bombVal), (surrName,surrVal)]) = surrVal

-- Get a game field, filled with whitespace, separated with newlines at width
getGameField gameWidth gameHeight = getGameField' gameWidth gameHeight 0 0

getGameField' gameWidth gameHeight w h
   | h == gameHeight = ""
   | w == gameWidth  = '\n' : getGameField' gameWidth gameHeight 0 (h + 1)
   | otherwise       = ' '  : getGameField' gameWidth gameHeight (w + 1) h

-- Replaces the nth element of a list
replaceN xs y n = replaceN' xs y n 0

replaceN' [] _ _ _ = []
replaceN' (x:xs) y n i
   | n == i    = y : replaceN' xs y n (i + 1)
   | otherwise = x : replaceN' xs y n (i + 1)

-- Render the game string
renderGameNew = renderGame'
renderGame' xs w h = renderGame'' xs (getGameField w h) w (length xs) 0

renderGame'' xs gameField w xsLength i
   | i == 0    = renderGame'' xs (fillBombermans (head xs) gameField w) w xsLength (i + 1)
   | i == 1    = renderGame'' xs (fillBricks (xs !! 1) gameField w)     w xsLength (i + 1)
   | i == 2    = renderGame'' xs (fillGates (xs !! 2) gameField w)      w xsLength (i + 1)
   | i == 3    = renderGame'' xs (fillGhosts (xs !! 3) gameField w)     w xsLength (i + 1)
   | i == 4    = renderGame'' xs (fillWall (xs !! 4) gameField w)       w xsLength (i + 1)
   | otherwise = gameField

-- The below fill functions fill in an empty game field with the following characters:
-- B - Bomberman (you)
-- ! - Bomb
-- # - Wall
-- O - Ghost
-- + - Brick
-- ~ - Gate (your goal)
fillBombermans [] gameField _ = gameField
fillBombermans (x:xs) gameField w = fillBombermans xs (replaceN gameField 'B' (getIndexFromCoordinates x w)) w

fillBricks [] gameField _ = gameField
fillBricks (x:xs) gameField w = fillBricks xs (replaceN gameField '+' (getIndexFromCoordinates x w)) w

fillGates [] gameField _ = gameField
fillGates (x:xs) gameField w = fillGates xs (replaceN gameField '~' (getIndexFromCoordinates x w)) w

fillGhosts [] gameField _ = gameField
fillGhosts (x:xs) gameField w = fillGhosts xs (replaceN gameField 'O' (getIndexFromCoordinates x w)) w

fillWall [] gameField _ = gameField
fillWall (x:xs) gameField w = fillWall xs (replaceN gameField '#' (getIndexFromCoordinates x w)) w

fillBomb xs gameField w = case xs of
   Left x  -> gameField
   Right x -> replaceN gameField '!' (getIndexFromCoordinates x w)

-- Gets an index of a game field string, given the coordinates and the width
getIndexFromCoordinates [x,y] w = x * (w + 1) + y
getIndexFromCoordinates _ _ = 0

-- Caching (handle finding exploded bricks)
applyExplodedBricks xs ys bomb = replaceN xs (removeExplodedBricks xs ys bomb) 1

removeExplodedBricks xs ys bomb = removeExplodedBricks' (getExplodedBricks xs ys bomb) (xs !! 1)

removeExplodedBricks' [] ys = ys
removeExplodedBricks' (x:xs) ys = removeExplodedBricks' xs (removeExplodedBricks'' x ys)

removeExplodedBricks'' _ [] = []
removeExplodedBricks'' x (y:ys)
   | x == y    = removeExplodedBricks'' x ys
   | otherwise = y : removeExplodedBricks'' x ys

getExplodedBricks xs ys bomb = getExplodedBricks' (xs !! 1) (ys !! 1) bomb

getExplodedBricks' [] _ bomb = []
getExplodedBricks' _ [] bomb = []
getExplodedBricks' (x:oldGame) newGame bomb
   | inBombRange x bomb   = x : getExplodedBricks' oldGame newGame bomb
   | otherwise            = getExplodedBricks' oldGame newGame bomb

-- Checks if a brick is in bomb range
inBombRange x (Prelude.Left JsonLikeNull) = False
inBombRange x (Prelude.Right [a,b])
   | x == [a-1,b] = True
   | x == [a+1,b] = True
   | x == [a,b-1] = True
   | x == [a,b+1] = True
   | otherwise    = False

-- Apply uniqueValues to our map
applyUniqueValues (x:xs) (y:ys) = applyUniqueValues' (x:xs) (y:ys)
applyUniqueValues' [] _ = []
applyUniqueValues' _ [] = []
applyUniqueValues' (x:xs) (y:ys) = uniqueValues x y : applyUniqueValues' xs ys

-- Concatenates two sets
uniqueValues xs (y:ys) = if y `elem` xs then uniqueValues xs ys else uniqueValues (y:xs) ys
uniqueValues xs []     = xs