{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}

module Lib3 where

import Data.Either as E (Either (..))
import Data.List as L (lookup)
import Lib2 (JsonLike (..), parseJsonMessage)
import Lib2
import Data.Maybe (isNothing)
import GHC.IO.Handle.Types (Handle__(haDevice))
import GHC.TopHandler (flushStdHandles)
import Control.Concurrent




-- Keep this type as is
type GameId = String

-- Keep these classes as is:
-- You will want to implement instances for them
class ToJsonLike a where
  toJsonLike :: a -> Either String JsonLike

class FromJsonLike a where
  fromJsonLike :: JsonLike -> Either String a

class ContainsGameId a where
  gameId :: a -> GameId

-- Further it is your code: you can change whatever you wish

jsonListToLikeList :: [JsonLike] -> JsonLike
jsonListToLikeList [] = JsonLikeList []
jsonListToLikeList (x:xs) = JsonLikeList (x:xs)

jsonTypeToStr' :: JsonLike -> String
jsonTypeToStr' JsonLikeNull = "null"
jsonTypeToStr' (JsonLikeInteger x) = show x
jsonTypeToStr' (JsonLikeString x) = concat ["\"", x, "\""]
jsonTypeToStr' (JsonLikeStringString x) = concat ["\"", x, "\""]
jsonTypeToStr' (JsonLikeList []) = ""
jsonTypeToStr' (JsonLikeList ((JsonLikeList x):xs)) = jsonTypeToStr (jsonListToLikeList x) ++ "," ++ jsonTypeToStr' (jsonListToLikeList xs)
jsonTypeToStr' (JsonLikeList (x:xs) ) = jsonTypeToStr' x ++ "," ++ jsonTypeToStr' (jsonListToLikeList xs)

jsonTypeToStr :: JsonLike -> String
jsonTypeToStr JsonLikeNull = "null"
jsonTypeToStr (JsonLikeInteger x) = show x
jsonTypeToStr (JsonLikeString x) = concat ["\"", x, "\""]
jsonTypeToStr (JsonLikeStringString x) = concat ["\"", x, "\""]
jsonTypeToStr (JsonLikeList []) = []
jsonTypeToStr (JsonLikeList x) = "[" ++ Prelude.init (jsonTypeToStr' (jsonListToLikeList x)) ++ "]"
jsonTypeToStr (JsonLikeObject []) = ""
jsonTypeToStr (JsonLikeObject (x:xs)) = fromJsonLikeDuplicate (JsonLikeObject (x:xs))

isJsonLikeObj :: JsonLike -> Bool
isJsonLikeObj (JsonLikeObject x) = True
isJsonLikeObj _ = False

-- Converts a JsonLike into a String: renders json
instance FromJsonLike String where
  fromJsonLike (JsonLikeObject x) = E.Right $ (fromJsonLikeDuplicate (JsonLikeObject x))
  fromJsonLike _ = E.Right "{}"

fromJsonLikeDuplicate (JsonLikeObject (x:xs)) = concat ["{","\"" ,fst x, "\"", ":"] ++ (jsonTypeToStr (snd x)) ++ (fromJsonLikeDuplicate' xs) ++ "}"

fromJsonLikeDuplicate' :: [([Char], JsonLike)] -> [Char]
fromJsonLikeDuplicate' [] = ""
fromJsonLikeDuplicate' (x:xs) = if isJsonLikeObj $ snd x
                                 then "," ++ concat ["\"" ,fst x, "\"", ":"] ++ fromJsonLikeDuplicate (snd x) ++ (fromJsonLikeDuplicate' (xs))
                                 else "," ++ concat ["\"" ,fst x, "\"", ":"] ++ (jsonTypeToStr (snd x)) ++ (fromJsonLikeDuplicate' (xs))


-- Acts as a parser from a String
instance ToJsonLike String where
  toJsonLike = Lib2.parseJsonMessage

data NewGame = NewGame {
  uuid :: GameId,
  height :: Integer,
  width :: Integer
} 
  deriving (Show)

instance ContainsGameId NewGame where
  gameId (NewGame gid hv wv) = gid


instance FromJsonLike NewGame where
  fromJsonLike o@(JsonLikeObject [("height", JsonLikeInteger hv), ("uuid", JsonLikeStringString uuid), ("width", JsonLikeInteger wv)]) = E.Right $ NewGame uuid hv wv
  fromJsonLike _ = E.Left "Error: wrong format"


data Direction = Right | Left | Up | Down
  deriving (Show, Eq)


data Command
  = MoveBomberman Direction
  | FetchSurrounding
  | PlantBomb
  | FetchBombStatus
  | FetchBombSurrounding
  deriving (Show, Eq)

data Commands = Commands
  { command :: Command,
    additional :: Maybe Commands
  }
  deriving (Show, Eq)

isBombermanCommand :: Command -> Bool 
isBombermanCommand x
  | x == MoveBomberman Up = True 
  | x == MoveBomberman Down = True 
  | x == MoveBomberman Lib3.Right = True 
  | x == MoveBomberman Lib3.Left = True 
  | otherwise = False 

getDirection :: Command -> Direction
getDirection (MoveBomberman x) = x



isNothing :: Eq a => Maybe a -> Bool
isNothing x 
  | x == Nothing = True 
  | otherwise = False 

fromJust :: Maybe a -> a
fromJust (Just x) = x


instance ToJsonLike Commands where
    --toJsonLike x = E.Right $JsonLikeObject [("command",JsonLikeObject [("name", JsonLikeStringString "MoveBomberman"), ("direction", JsonLikeStringString "Right")]),("additional",JsonLikeNull)]
  --toJsonLike x = E.Right $ JsonLikeObject [("command", JsonLikeObject[("name", JsonLikeStringString $ show $ command x)]), ("additional", JsonLikeNull)]
  --toJsonLike _ = E.Left "error in: toJsonLike Command instance"
  toJsonLike x
    | ((Data.Maybe.isNothing $ additional x) && (isBombermanCommand $ command x)) = E.Right $ JsonLikeObject [("command",JsonLikeObject [("name", JsonLikeStringString "MoveBomberman"), ("direction", JsonLikeStringString (show $ getDirection $ command x))]),("additional",JsonLikeNull)]
    | (Data.Maybe.isNothing $ additional x) = E.Right $ JsonLikeObject [("command", JsonLikeObject[("name", JsonLikeStringString $ show $ command x)]), ("additional", JsonLikeNull)]
    | (not (Data.Maybe.isNothing $ additional x) && (isBombermanCommand $ command x)) = E.Right $ JsonLikeObject [("command",JsonLikeObject [("name", JsonLikeStringString "MoveBomberman"), ("direction", JsonLikeStringString (show $ getDirection $ command x))]),("additional", toJsonLikeAdditional(additional x) )]
    | not (Data.Maybe.isNothing $ additional x) = E.Right $ JsonLikeObject [("command", JsonLikeObject[("name", JsonLikeStringString $ show $ command x)]), ("additional", toJsonLikeAdditional (additional x))]
     
toJsonLikeAdditional :: Maybe Commands -> JsonLike 
toJsonLikeAdditional (Just x)
  | (Lib3.isNothing $ additional x) = JsonLikeObject [("command", JsonLikeObject [("name", JsonLikeStringString $ show $ command x)])]
  | not (Lib3.isNothing $ additional x) = JsonLikeObject [("command", JsonLikeObject [("name", JsonLikeStringString $ show $ command x)]), ("additional", toJsonLikeAdditional $ additional x)]

instance FromJsonLike Commands where
  fromJsonLike _ = E.Left "Implement me from json like commands"

data CommandsResponse = CommandsResponse String
  deriving (Show)

instance ToJsonLike CommandsResponse where
  toJsonLike (CommandsResponse x) = toJsonLike x
  toJsonLike _ = E.Left "error at toJsonLike CommandsResponse"


instance FromJsonLike CommandsResponse where
  --fromJsonLike x = E.Right $ CommandsResponse $ fromJsonLikeDuplicate x
  fromJsonLike o@(JsonLikeObject x) = E.Right $ CommandsResponse (fromJsonLikeDuplicate o)
  fromJsonLike x = E.Left (show x)

--labas :: Chan String -> IO()