# bomberman-client

## Installation
First, install [Stack](https://docs.haskellstack.org/en/stable/README/). After that, in the root of the project, run `stack install` to install the dependencies. Once the dependencies have been installed, you can run the game with `stack run`. Exit the game with `Control+C`.

## Gameplay

### Maze:

```
###############
#     ++++++++#
#+#+# # # # # #
#   + +   +  O#
# # # # # #+#+#
#   +   +     #
# # #+#+# #+#+#
#      B  + + #
#+#+# #+#+#+#+#
#     +O      #
#+#+# #+#+#+# #
#     +       #
# #+#+#+#+#+#+#
#            ~#
###############
```

### Symbols:
* `B` - Bomberman (you)
* `!` - Bomb
* `#` - Wall
* `O` - Ghost
* `+` - Brickg
* `~` - Gate (your goal)

### Controls:
* `W` - Move up
* `A` - Move left
* `S` - Move down
* `D` - Move right
* `B` - Plant a bomb

The map refresh every 5s automatically.
The game will end once you reach the gate.