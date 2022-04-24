{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Exception (bracket)
import Control.Lens ((^.))
import Data.Aeson as A
  ( FromJSON,
    KeyValue ((.=)),
    ToJSON (toJSON),
    object,
  )
import Data.Aeson.Types as AT (Value (..), emptyObject)
import Data.List as L (concat, (++))
import Data.String.Conversions (cs)
import GHC.Generics (Generic)
import Lib2 (InitData (InitData, gameHeight, gameWidth), State, init, render, update, parseJsonMessage)
import Network.Wreq (asJSON, post, responseBody)
import qualified Network.Wreq.Session as Sess
import System.Console.ANSI as ANSI
  ( clearScreen,
    hideCursor,
    setCursorPosition,
    showCursor,
  )
import System.IO (BufferMode (..), hSetBuffering, hSetEcho, stderr, stdin, stdout)
import Prelude hiding (Left, Right)
import qualified Data.Either as DE

data NewGame = NewGame
  { uuid :: String,
    width :: Int,
    height :: Int
  }
  deriving (Generic, Show)

instance FromJSON NewGame

data Direction = Right | Left | Up | Down
  deriving (Show)

instance ToJSON Direction where
  toJSON = AT.String . cs . show

data Command
  = MoveBomberman Direction
  | FetchSurrounding
  | PlantBomb
  | FetchBombStatus
  deriving (Generic, Show)

instance ToJSON Command where
  toJSON FetchSurrounding = object ["name" .= AT.String "FetchSurrounding"]
  toJSON (MoveBomberman d) = object ["name" .= AT.String "MoveBomberman", "direction" .= toJSON d]
  toJSON PlantBomb = object ["name" .= AT.String "PlantBomb"]
  toJSON FetchBombStatus = object ["name" .= AT.String "FetchBombStatus"]

data Commands = Commands
  { command :: Command,
    additional :: Maybe Commands
  }
  deriving (Generic, Show)

instance ToJSON Commands

host :: String
host = "http://bomberman.homedir.eu"

main :: IO ()
main = do
  hSetBuffering stdin NoBuffering
  hSetBuffering stderr NoBuffering
  hSetBuffering stdout NoBuffering
  hSetEcho stdin False
  bracket
    ANSI.hideCursor
    (const showCursor)
    ( \_ -> do
        sess <- Sess.newSession
        response <- Sess.post sess (host ++ "/v1/game/new/random") AT.emptyObject >>= asJSON
        let newGame = response ^. responseBody :: NewGame
        let initData = Lib2.InitData {gameWidth = width newGame, gameHeight = height newGame}
        initialStr <- postCommands (uuid newGame) sess (Commands FetchSurrounding Nothing)
        case Lib2.parseJsonMessage initialStr of
          DE.Left e -> error e
          DE.Right j -> do
            let initialState = Lib2.init initData j 
            draw initialState
            loop (uuid newGame) sess initialState
    )

postCommands :: String -> Sess.Session -> Commands -> IO String
postCommands uuid sess commands = do
  r <- Sess.post sess (L.concat [host, "/v2/game/", uuid]) (toJSON commands)
  return $ cs $ r ^. responseBody

draw :: Lib2.State -> IO ()
draw state = do
  _ <- ANSI.clearScreen
  _ <- ANSI.setCursorPosition 0 0
  putStrLn $ render state

getAllInfo :: Maybe Commands
getAllInfo = Just (Commands FetchSurrounding (Just (Commands FetchBombStatus Nothing)))

loop :: String -> Sess.Session -> State -> IO ()
loop uuid sess state = do
  c <- getChar
  let commands = case c of
        'a' -> Commands (MoveBomberman Left) getAllInfo
        's' -> Commands (MoveBomberman Down) getAllInfo
        'd' -> Commands (MoveBomberman Right) getAllInfo
        'w' -> Commands (MoveBomberman Up) getAllInfo
        'b' -> Commands (PlantBomb) getAllInfo
        _ -> Commands FetchSurrounding Nothing
  r <- postCommands uuid sess commands
  case Lib2.parseJsonMessage r of
    DE.Left e -> error e
    DE.Right jl -> do
      let newState = Lib2.update state jl
      _ <- draw newState
      loop uuid sess newState
