module Game (Player,
	     playerOne,
	     playerTwo,
             Game,
             switchPlayer,
	     initGame,
	     currentPlayer,
	     getPlayerMove,
             terminal,
             checkWin,
	     nextStates,
	     minimax,
	     playerOneTurn) where

import Maybe (isJust)

-- |The Player type has values One and Two, for the players of a two-player game. Note that for the minimax functions player One is max and player Two is min.
data Player = One | Two
    deriving (Eq)

playerOne :: Player
playerOne = One

playerTwo :: Player
playerTwo = Two

instance Show Player where
    show One = "1"
    show Two = "2"

-- |switchPlayer returns the opposite player value from its argument, this function is useful for switching players between max and min when calculating the minimax value of a state.
switchPlayer :: Player -> Player 
switchPlayer One = Two
switchPlayer Two = One

-- |maxPlayer checks whether a player is the max player or not. Player One is max by default.
maxPlayer :: Player -> Bool
maxPlayer = (== One)

-- |The Game class provides an interface for two-player games.
class Game a where
    initGame :: a
    currentPlayer :: a -> Player
    getPlayerMove :: a -> IO a
    terminal :: a -> Bool -- ^ A game is terminal (finished) either if one of the players has won, or if there are no moves available. It is defined by default using checkWin and moves.
    terminal game = isJust (checkWin game) || null (nextStates game) 
    checkWin :: a -> Maybe Player -- ^ If either player has won then checkWin returns Just that player, otherwise it returns Nothing.
    nextStates :: a -> [a] -- ^ nextStates returns the possible next game states from a game state
    minimax :: a -> Int
    minimax = minimax'
    playerOneTurn :: a -> Bool

minimax' game | playerOneTurn game = maxValue game (-2,2) 
              | otherwise    = minValue game (-2,2)
    where maxValue g (a,b) | terminal g = eval g
                           | otherwise = snd $ foldr (\g' (a',v) -> 
                                       let newV = max v (minValue g' (a',b)) in
                                       if v >= b 
                                       then (a',v) -- If a state with an evaluation higher than beta has been found, we don't bother checking any further nodes on this branch.
                                       else (max a' newV, newV)) -- If not, we calculate the new alpha and v values.
                                (a,-2) (nextStates g)
          minValue g (a,b) | terminal g = eval g
                           | otherwise = snd $ foldr (\g' (b',v) ->
                                       let newV = min v (maxValue g' (a,b')) in
                                       if v <= a
                                       then (b',v) -- If a state with an evaluation lower than alpha has been found, ignore the rest of the nodes on this branch.
                                       else (min b' newV, newV)) -- If not, calculate the new beta and v values.
                                (b,2) (nextStates g)
	  eval g = case (checkWin g) of
			(Just One) -> 1
			(Just Two) -> -1
			(_) -> 0