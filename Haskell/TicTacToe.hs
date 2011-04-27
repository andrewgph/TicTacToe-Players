module TicTacToe (TicTacToeGame,
		      currentPlayer,
                      initGameTTT,
                      checkWin,
		      getPlayerMove,
		      nextStates,
		      playerOneTurn) where

import Array
import Maybe (isNothing,isJust)
import Game
import Grid

data TicTacToeGame = TicTacToeGame {player :: Player
				   ,board :: Array (Int,Int) (Maybe Player)}

instance Game TicTacToeGame where
    initGame = initGameTTT
    checkWin = checkWinTTT
    getPlayerMove  = getPlayerMoveTTT
    nextStates = nextStatesTTT
    playerOneTurn = playerOneTurnTTT 
    currentPlayer = player

playerOneTurnTTT :: TicTacToeGame -> Bool
playerOneTurnTTT game = (player game) == playerOne

initGameTTT :: TicTacToeGame
initGameTTT = TicTacToeGame playerOne (array ((1,1),(3,3)) [((i,j),Nothing)|i<-[1..3],j<-[1..3]])

nextStatesTTT :: TicTacToeGame -> [TicTacToeGame]
nextStatesTTT game = map createGame indices
	where createGame i = TicTacToeGame (switchPlayer (player game)) ((board game)//[(i,Just (player game))])
	      indices = map fst $ filter (isNothing.snd) $ assocs $ board game

getPlayerMoveTTT :: TicTacToeGame -> IO TicTacToeGame
getPlayerMoveTTT game = do 
  putStrLn "Please enter a move (row,column):"
  getPair >>= getMove
      where getMove mv | checkMove mv = return $ TicTacToeGame (switchPlayer (player game)) ((board game)//[(mv,Just (player game))])
                       | otherwise = do putStrLn message
                                        getPlayerMoveTTT game
            checkMove mv = not $ null $ filter (\((i,j),x) -> (i,j) == mv && isNothing x) $ assocs $ board game
            message = "That was not a valid move ... please try again."
            ex = \e -> do putStrLn message
                          getPair
            getPair = catch ((readLn)::IO (Int,Int)) ex
     
tttLines = [[(1,1),(2,2),(3,3)],[(3,1),(2,2),(1,3)]] ++
          [[(i,j) | i<-[1..3]] | j <- [1..3]] ++ 
          [[(i,j) | j <- [1..3]] | i <- [1..3]]

checkWinTTT :: TicTacToeGame -> Maybe Player
checkWinTTT game = foldr (\x y -> if isJust x then x else y) Nothing $ map line $ getBoardLines $ board game
    where line xs = foldl1 (\x y -> if x /= y then Nothing else x) xs
	  getBoardLines board = map (\l -> map (\s -> board!s) l) tttLines
 
showTTT :: TicTacToeGame -> String
showTTT game = showGrid 3 3 (board game)

instance Show TicTacToeGame where
    show = showTTT