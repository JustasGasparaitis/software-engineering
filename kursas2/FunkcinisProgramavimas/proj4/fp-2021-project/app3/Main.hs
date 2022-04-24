module Main where

import Control.Exception (bracket)
import Control.Lens ((^.))
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import Data.Either as E (either)
import Data.Function ((&))
import Data.List as L (concat, (++))
import Data.String.Conversions (cs)
import Lib3
import Network.Wreq (post, responseBody)
import Network.Wreq.Lens (Response (..))
import qualified Network.Wreq.Session as Sess
import Control.Concurrent
import System.Console.ANSI as ANSI


  ( clearScreen,
    hideCursor,
    setCursorPosition,
    showCursor,
  )
import System.IO (BufferMode (..), hSetBuffering, hSetEcho, stderr, stdin, stdout)
import Prelude hiding (Left, Right)
import Lib2 (init, render, State, InitData (InitData), gameWidth, gameHeight, update)
import Data.Either as E (Either (..))
-- MANDATORY CODE
host :: String
host = "http://bomberman.homedir.eu"

createGame ::
  (FromJsonLike a) =>
  Sess.Session ->
  IO a
createGame sess = do
  r <- Sess.post sess (host ++ "/v1/game/new/random") B.empty
  let resp = cs $ r ^. responseBody :: String
  return $ toJsonLike resp & e & fromJsonLike & e

postCommands ::
  (FromJsonLike a, ToJsonLike a, FromJsonLike b, ToJsonLike b) =>
  GameId ->
  Sess.Session ->
  a ->
  IO b
postCommands uuid sess commands = do
  let str = toJsonLike commands & e & fromJsonLike & e :: String
  --putStrLn $ show str
  let req = cs str :: B.ByteString
  r <- Sess.post sess (L.concat [host, "/v3/game/", uuid]) req
  let respStr = cs $ r ^. responseBody :: String
  --putStrLn $ respStr
  return $ toJsonLike respStr & e & fromJsonLike & e

e :: Either String a -> a
e = E.either error id


-- MANDATORY CODE END

main :: IO ()
main = do
  hSetBuffering stdin NoBuffering
  hSetBuffering stderr NoBuffering
  hSetBuffering stdout NoBuffering
  hSetEcho stdin False
  bracket
    (ANSI.hideCursor >> Sess.newAPISession)
    (const showCursor)
    ( \sess -> do
        --ch <- newChan
        game <- createGame sess :: IO NewGame
        let commands = Commands FetchBombSurrounding Nothing:: Commands
        initialStr <- postCommands (uuid game) sess (Commands FetchSurrounding Nothing) :: IO CommandsResponse
        --putStrLn initialStr
        case toJsonLike initialStr of
          E.Left e -> error e
          E.Right j -> do
            let initialState = Lib2.init (InitData {gameWidth = fromInteger $ width game, gameHeight = fromInteger $ height game}) j
            draw initialState 

            ch <- newChan
            forkIO $ writer ch initialState (uuid game) sess
            forkIO (loop ch)
            forkIO (doSmth ch)
            return ()
            
        
    )


writer :: Control.Concurrent.Chan Commands-> State -> String -> Sess.Session-> IO()
writer ch state uuid sess = do
  commands <- readChan ch
  --putStrLn $ show $ toJsonLike $ commands
  response <- postCommands uuid sess commands :: IO CommandsResponse
  case Lib3.toJsonLike response of
    E.Left e -> error e
    E.Right jl -> do
      let newState = Lib2.update state jl
      _ <- ANSI.clearScreen
      _ <- ANSI.setCursorPosition 0 0
      putStrLn $ Lib2.render state
      writer ch newState uuid sess

doSmth :: Control.Concurrent.Chan Commands -> IO()
doSmth ch = do
  let commands = Commands FetchBombSurrounding getAllInfo :: Commands
  writeChan ch commands
  threadDelay 5000000
  doSmth ch

draw :: Lib2.State -> IO ()
draw state  = do
  _ <- ANSI.clearScreen
  _ <- ANSI.setCursorPosition 0 0
  putStrLn $ Lib2.render state

loop :: Control.Concurrent.Chan Commands -> IO()
loop ch = do
  threadDelay 1000
  c <- getChar
  let commands = case c of
        'a' -> Commands (MoveBomberman Lib3.Left) getAllInfo
        's' -> Commands (MoveBomberman Down) getAllInfo
        'd' -> Commands (MoveBomberman Lib3.Right) getAllInfo
        'w' -> Commands (MoveBomberman Up) getAllInfo
        'b' -> Commands (PlantBomb) getAllInfo
        _ -> Commands FetchSurrounding (Just (Commands FetchBombStatus Nothing)) 
  writeChan ch commands
  loop ch

getAllInfo :: Maybe Commands
getAllInfo = Just (Commands FetchSurrounding(Just (Commands FetchBombStatus (Just(Commands FetchBombSurrounding Nothing)))))