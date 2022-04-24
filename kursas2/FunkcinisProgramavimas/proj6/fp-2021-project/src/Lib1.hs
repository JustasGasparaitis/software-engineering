module Lib1 where

import GHC.StableName (StableName)

data InitData = InitData
  { gameWidth :: Int,
    gameHeight :: Int
  }
  deriving (Show)

-- | Change State the way need but please keep
--  the name of the type, i.e. "State"
data State = State String InitData
  deriving (Show)

-- | Is called in a very beginning of a game
init ::
  -- | Initial data of the game
  InitData ->
  -- | First json message before any moves performed
  String ->
  -- | An initial state based on initial data and first message
  State
init i j = State j i

-- | Is called after every user interaction (key pressed)
update ::
  -- | Current state
  State ->
  -- | Json message from server
  String ->
  -- | A new state, probably based on the message arrived
  State
update (State _ i) j = State j i

-- | Renders the current state
render ::
  -- | A state to be rendered
  State ->
  -- | A string which represents the state. The String is rendered from the upper left corner of terminal.
  String
render = show
