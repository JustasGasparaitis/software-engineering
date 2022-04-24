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
import Lib1 (InitData (InitData, gameHeight, gameWidth), State, init, render, update)
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
  deriving (Generic, Show)

instance ToJSON Command where
  toJSON FetchSurrounding = object ["name" .= AT.String "FetchSurrounding"]
  toJSON (MoveBomberman d) = object ["name" .= AT.String "MoveBomberman", "direction" .= toJSON d]

data Commands = Commands
  { command :: Command,
    additional :: Maybe Commands
  }
  deriving (Generic, Show)

instance ToJSON Commands

host :: String
host = "http://bomberman.homedir.eu/v1"

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
        response <- Sess.post sess (host ++ "/game/new/random") AT.emptyObject >>= asJSON
        let newGame = response ^. responseBody :: NewGame
        let initData = Lib1.InitData {gameWidth = width newGame, gameHeight = height newGame}
        initialState <- Lib1.init initData <$> postCommands (uuid newGame) sess (Commands FetchSurrounding Nothing)
        draw initialState
        loop (uuid newGame) sess initialState
    )

postCommands :: String -> Sess.Session -> Commands -> IO String
postCommands uuid sess commands = do
  r <- Sess.post sess (L.concat [host, "/game/", uuid]) (toJSON commands)
  return $ cs $ r ^. responseBody

draw :: Lib1.State -> IO ()
draw state = do
  _ <- ANSI.clearScreen
  _ <- ANSI.setCursorPosition 0 0
  putStrLn $ render state

loop :: String -> Sess.Session -> State -> IO ()
loop uuid sess state = do
  c <- getChar
  let commands = case c of
        'a' -> Commands (MoveBomberman Left) (Just (Commands FetchSurrounding Nothing))
        's' -> Commands (MoveBomberman Down) (Just (Commands FetchSurrounding Nothing))
        'd' -> Commands (MoveBomberman Right) (Just (Commands FetchSurrounding Nothing))
        'w' -> Commands (MoveBomberman Up) (Just (Commands FetchSurrounding Nothing))
        _ -> Commands FetchSurrounding Nothing
  r <- postCommands uuid sess commands
  let newState = Lib1.update state r
  _ <- draw newState
  loop uuid sess newState
