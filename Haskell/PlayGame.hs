module PlayGame (playGameMain) where

import Game
import TicTacToe
import ConnectFour
import SearchFns
import List (sortBy)

playGameMain = do
  putStrLn "Would you like a game of:"
  putStrLn "1. TicTacToe"
  putStrLn "2. Connect Four"
  getLine >>= parseInput

parseInput :: String -> IO ()
parseInput str = case (read str)::Int of
                   1 -> getMethod >>= (playGame initNC humanPlayer)
                   2 -> getMethod >>= (playGame initC4 humanPlayer)
                   (_) -> putStrLn "That is not a valid option."

getMethod :: IO (Int,Int)
getMethod = do
  putStrLn "Which game search method do you want to use?"
  putStrLn "1. Minimax"
  putStrLn "2. Alphabeta"
  putStrLn "3. Alphabeta with evaluation functions."
  getInt >>= (\i -> case i of
                      1 -> return (1,0)
                      2 -> return (2,0)
                      3 -> do putStrLn "What depth do you want to cut off at?"
                              getInt >>= (\j -> if j >= 0 
                                                then return (3,j) 
                                                else putStrLn "Depth must be positive." >> getMethod))

getInt :: IO Int
getInt = getLine >>= (\str -> catch ((readIO str):: IO Int)
                              (\e -> do putStrLn "Not a valid Int value"
                                        getInt))

playGame :: (Game a, Show a) => a -> Player -> (Int,Int) ->  IO ()
playGame game player (x,y) | terminal game = putStrLn (show game) >> endGame game
                           | player == humanPlayer = putStrLn (show game) >> getMove game >>= (\mv -> playGame (play humanPlayer mv) (switch humanPlayer) (x,y))
                           | otherwise = playGame (compMove game (x,y)) humanPlayer (x,y)

endGame :: (Game a) => a -> IO ()
endGame game | checkWin game == Just humanPlayer = putStrLn "You have won."
             | checkWin game == Just (switch humanPlayer) = putStrLn "You have lost ... although this presumably means that your game player was quite good, so in a wider context you have actually won. Welldone!"
             | otherwise = putStrLn "Draw"

compMove :: Game a => a -> (Int,Int) -> a
compMove game m = fst $ head $ sortBy f $ map (\g -> (g, method g)) succs
    where method g = case m of
                       (1,_) -> minimax g humanPlayer
                       (2,_) -> alphabeta g humanPlayer
                       (3,d) -> alphabetaEval g humanPlayer d
          succs = map (play (switch humanPlayer)) $ moves game
          f (_,x) (_,y) = compare x y
