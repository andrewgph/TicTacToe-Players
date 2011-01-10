module Game (Player,
             Game,
             Move,
             humanPlayer,
             makeMove,
             moves,
             terminal,
             checkWin,
             play,
             eval,
             getLines,
             switch, 
             maxPlayer,
             evaluation,
             getMove) where

import Maybe (isJust)

-- |The Player type has values One and Two, for the players of a two-player game. Note that for the minimax functions player One is max and player Two is min.
data Player = One | Two
    deriving (Eq)

instance Show Player where
    show One = "1"
    show Two = "2"

-- |switch returns the opposite player value from its argument, this function is useful for switching players between max and min when calculating the minimax value of a state.
switch :: Player -> Player 
switch One = Two
switch Two = One

-- |maxPlayer checks whether a player is the max player or not. Player One is max by default.
maxPlayer :: Player -> Bool
maxPlayer = (== One)

-- |Player One is the human player (in PlayGame.hs) by default.
humanPlayer :: Player 
humanPlayer = One

-- |The Move type has a type parameter a (a is restricted to an instance of the Game class). A move is a function which takes a Player and returns a new game state. Note that this type can only represent moves in symmetrical games, where a move can be played by either player.
newtype (Game a) => Move a = Move (Player -> a)

-- |makeMove creates a value of type Move when given a function which takes a Player and returns a game.
makeMove :: (Game a) => (Player -> a) -> Move a
makeMove f = Move f 

-- |The Game class provides an interface for two-player games played on an (n*m) grid. The minimax and alphabeta functions should use this interface to determine the minimax value of a game state.
class Game a where
    play :: Player -> Move a -> a -- ^ play takes a Player and a Move and returns the game resulting from that player playing that move. It is defined by default.
    play plyr (Move mv) = mv plyr
    terminal :: a -> Bool -- ^ A game is terminal (finished) either if one of the players has won, or if there are no moves available. It is defined by default using checkWin and moves.
    terminal game = isJust (checkWin game) || null (moves game) 
    checkWin :: a -> Maybe Player -- ^ If either player has won then checkWin returns Just that player, otherwise it returns Nothing.
    evaluation :: (Num b, Ord b) => a -> b -- ^ The evaluation function gives a ranking for game states, with a positive ranking being good for One and a negative ranking being good for Two.
    moves :: a -> [Move a] -- ^ moves returns the possible moves available in a game state.
    getLines :: a -> [[((Int,Int),Maybe Player)]] -- ^ getLines takes a game and returns a list of the grid lines and their status. Note that not all grid lines may be returned, only those that are relevant to the goals of the game. For example, in connect four the grid lines with a length less that three are not relevant to the game.
    getMove :: a -> IO (Move a) -- ^ getMove gets a move from a human player, you should not need to use this function (unless you are planning on creating your own instances of the Game class).

-- |eval provides a default evaluation function for an instance of the Game class. There are three possible evaluations: positive one if player One wins, zero if it is a draw, and negative one if player Two wins. You should use this function when creating the minimax and alphabeta functions that don't have a cut-off test.
eval :: Game a => a -> Int
eval game = case (checkWin game) of
              Just One -> 1
              Just Two -> (-1)
              Nothing -> 0

