module Lib1 where

data InitData = InitData
  { gameWidth :: Int,
    gameHeight :: Int
  }
  deriving (Show)

-- | Change State the way need but please keep
--  the name of the type, i.e. "State"
data State = State ([[Int]], [[Int]], [[Int]], [[Int]], [[Int]]) InitData
  deriving (Show)

-- Returns the array of arrays for a specific category
getBombermans = read . strBetween "{\"bombermans\":" ",\"bricks\":"
getBricks = read . strBetween ",\"bricks\":" ",\"gates\":"
getGates = read . strBetween ",\"gates\":" ",\"ghosts\":"
getGhosts = read . strBetween ",\"ghosts\":" ",\"wall\":"
getWalls = read . strBetween ",\"wall\":" "}"

-- Concatenates two "sets"
uniqueValues xs (y:ys) = if y `elem` xs then uniqueValues xs ys else uniqueValues (y:xs) ys
uniqueValues xs []     = xs

-- | Is called in a very beginning of a game
init ::
  -- | Initial data of the game
  InitData ->
  -- | First json message before any moves performed
  String ->
  -- | An initial state based on initial data and first message
  State
init i j = State (getBombermans j, getBricks j, getGates j, getGhosts j, getWalls j) i

-- | Is called after every user interaction (key pressed)
update ::
  -- | Current state
  State ->
  -- | Json message from server
  String ->
  -- | A new state, probably based on the message arrived
  State
update (State (_, bricks, gates, ghosts, walls) i) j = State (getBombermans j, uniqueValues bricks (getBricks j), uniqueValues gates (getGates j), uniqueValues ghosts (getGhosts j), uniqueValues walls (getWalls j)) i

-- Checks whether a string starts with a given prefix
isPrefixOf (p:prefix) (s:string)
  | p == s    = isPrefixOf prefix string
  | otherwise = False
isPrefixOf [] _ = True
isPrefixOf _ [] = False

-- Strips a prefix off of a string or returns string if it's not prefixed by the given prefix
stripPrefix (p:prefix) (s:string) = if (p:prefix) `isPrefixOf` (s:string) then stripPrefix prefix string else s:string
stripPrefix _ string              = string

-- Helper function, returns the string once it reaches the suffix
strBetween' suffix string acc
  | string == ""               = ""
  | suffix `isPrefixOf` string = reverse acc
  | otherwise                  = strBetween' suffix (tail string) (head string:acc)

-- Finds a string surrounded by a prefix and a suffix inside of a given string
-- First off, removes the prefix
-- Works lazily
strBetween prefix suffix string
  | string == ""               = ""
  | prefix `isPrefixOf` string = strBetween' suffix (stripPrefix prefix string) ""
  | otherwise                  = strBetween prefix suffix (tail string)

-- Checks whether a substring is inside of a string
contains substr string
  | substr == ""               = True
  | string == ""               = False
  | substr `isPrefixOf` string = True
  | otherwise                  = contains substr (tail string)

-- Gets the correct symbol for a given pair of coordinates
getSymbol w h (a, b, c, d, e)
  | [h, w] `elem` e = '#' -- Wall
  | [h, w] `elem` b = '+' -- Brick
  | [h, w] `elem` d = 'O' -- Ghost
  | [h, w] `elem` c = '~' -- Gate
  | [h, w] `elem` a = 'B' -- Bomberman
  | otherwise       = ' ' -- Empty

-- Returns the 2D map of the game
displayString game w h width height str
  | w == width = displayString game 0 (h + 1) width height ('\n':str)
  | h < height = displayString game (w + 1) h width height (getSymbol w h game:str)
  | otherwise  = reverse str

-- | Renders the current state
render ::
  -- | A state to be rendered
  State ->
  -- | A string which represents the state. The String is rendered from the upper left corner of terminal.
  String
render (State game (InitData gameWidth gameHeight)) = displayString game 0 0 gameWidth gameHeight ""

-- Formatted example JSON
--{
--    "surrounding":
--    {
--        "bombermans":[[1,1]],
--        "bricks":[[1,6],[1,7],[1,8],[2,1],[2,3],[3,4],[3,6],[5,4],[5,8],[6,5],[6,7],[8,1],[8,3],[8,7]],
--        "gates":[],
--        "ghosts":[],
--        "wall":[[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],[0,8],[1,0],[2,0],[2,2],[2,4],[2,6],[2,8],[3,0],[4,0],[4,2],[4,4],[4,6],[4,8],[5,0],[6,0],[6,2],[6,4],[6,6],[6,8],[7,0],[8,0],[8,2],[8,4],[8,6],[8,8]]
--    }
--}

-- Unformatted example JSON
--"{\"surrounding\":{\"bombermans\":[[1,1]],\"bricks\":[[1,6],[1,7],[1,8],[2,1],[2,3],[3,4],[3,6],[5,4],[5,8],[6,5],[6,7],[8,1],[8,3],[8,7]],\"gates\":[],\"ghosts\":[],\"wall\":[[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],[0,8],[1,0],[2,0],[2,2],[2,4],[2,6],[2,8],[3,0],[4,0],[4,2],[4,4],[4,6],[4,8],[5,0],[6,0],[6,2],[6,4],[6,6],[6,8],[7,0],[8,0],[8,2],[8,4],[8,6],[8,8]]}}"
