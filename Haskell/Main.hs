module Main where

import TicTacToe
import Game
import List (sortBy)
import Maybe (isNothing)

main = choosePlayer >>= playGame initGameTTT

choosePlayer :: IO Player
choosePlayer = do
	putStrLn "Do you want to be player 1 (x) or player 2 (o)? [Enter 1 or 2]"
	getInt >>= getPlayer
	where getInt = catch ((readLn)::IO Int) ex
	      ex e = do
		putStrLn "Not a number ... please try again"
		getInt
	      getPlayer i | i == 1 = return playerOne
			  | i == 2 = return playerTwo
			  | otherwise = do
				putStrLn "Not a valid player."
				choosePlayer
	

playGame :: (Game a, Show a) => a -> Player -> IO ()
playGame game player | terminal game = do
				putStrLn (show game)
				endGame game player
                     | currentPlayer game == player = do
				putStrLn (show game)
				newGame <- getPlayerMove game
				putStrLn (show game)
				playGame newGame player
                     | otherwise = playGame (compMove game player) player

compMove :: Game a => a -> Player -> a
compMove game player = fst $ head $ sortBy f $ map (\g -> (g, minimax g)) (nextStates game)
    where f (_,x) (_,y) | player == playerOne = compare x y
			| otherwise = invertCompare x y
	  invertCompare x y | x == y = EQ
			    | x >= y = LT
			    | otherwise = GT

endGame :: (Game a) => a -> Player -> IO ()
endGame game humanPlayer = putStrLn outcome
	where outcome | isNothing (checkWin game) = "Draw"
		      | checkWin game == Just humanPlayer = "You have won."
                      | checkWin game == Just compPlayer =  "You have lost."
	      compPlayer = switchPlayer humanPlayer