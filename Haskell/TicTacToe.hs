module TicTacToe (TicTacToe, 
                          moves, 
                          checkWin,
                          evaluation,
                          getLines,
                          initNC,
                          getMove) where

import Array
import Maybe (isNothing,isJust)
import Game
import Grid
import SearchFns (ncEval)

newtype TicTacToe = NC (Array (Int,Int) (Maybe Player))

initNC :: TicTacToe
initNC = NC $ array ((1,1),(3,3)) [((i,j),Nothing)|i<-[1..3],j<-[1..3]]

instance Game TicTacToe where
    moves (NC game) = map (\i -> makeMove (\player -> NC $ game//[(i,Just player)])) indexes
                       where indexes = map fst $ filter (isNothing.snd) $ assocs game
    checkWin = checkWinNC
    evaluation = ncEval
    getLines (NC game)= map (map (\pt -> (pt, game!pt))) ncLines 
    getMove game = getMoveNC game

getMoveNC :: TicTacToe -> IO (Move TicTacToe)
getMoveNC (NC game) = do 
  putStrLn "Please enter a move (row,column):"
  getPair >>= checkMove
      where checkMove mv | not $ null $ filter (\((i,j),x) -> (i,j) == mv && isNothing x) $ assocs game = return $ makeMove (\player -> NC $ game//[(mv,Just player)])
                         | otherwise = do putStrLn message
                                          getMove (NC game)
            message = "That was not a valid move ... please try again."
            ex = \e -> do putStrLn message
                          getPair
            getPair = catch ((readLn)::IO (Int,Int)) ex
     
ncLines = [[(1,1),(2,2),(3,3)],[(3,1),(2,2),(1,3)]] ++  
          [[(i,j) | i<-[1..3]] | j <- [1..3]] ++ 
          [[(i,j) | j <- [1..3]] | i <- [1..3]]

checkWinNC :: TicTacToe -> Maybe Player
checkWinNC (NC board) = foldr (\x y -> if isJust x then x else y) Nothing $ map line $ getLines (NC board)
    where line xs = foldl1 (\x y -> if x /= y then Nothing else x) $ map snd xs
 
showNC :: TicTacToe -> String
showNC (NC x) = showGrid 3 3 x

instance Show TicTacToe where
    show = showNC