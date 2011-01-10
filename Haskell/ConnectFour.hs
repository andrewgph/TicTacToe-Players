module ConnectFour (ConnectFour,
                    moves,
                    checkWin,
                    evaluation,
                    getLines,
                    initC4) where

import Maybe (isNothing,isJust)
import Grid
import Game
import Array
import List (sort)
import SearchFns (connect4Eval)

newtype ConnectFour = C4 (Array (Int,Int) (Maybe Player))

initC4 :: ConnectFour
initC4 = C4 $ array ((1,1),(6,7)) [((i,j),Nothing)|i<-[1..6],j<-[1..7]]

instance Game ConnectFour where
    moves (C4 game) = map (\i -> makeMove (\player -> C4 $ game//[(i,Just player)])) $ filter notFloat indexes
        where notFloat mv = null $ filter (\((i,j),sq) -> j == snd mv && isNothing sq && i > fst mv) $ assocs game
              indexes = map fst $ filter (isNothing.snd) $ assocs game
    checkWin = checkWinC4
    evaluation = connect4Eval
    getLines (C4 game) = map (map (\i -> (i,game!i))) c4Lines
    getMove game = getMoveC4 game


getMoveC4 :: ConnectFour -> IO (Move ConnectFour)
getMoveC4 (C4 game) = do 
  putStrLn "Please enter a column number:"
  getInt >>= checkMove
      where checkMove mv | not $ null $ filter (\((i,j),x) -> j == mv && isNothing x) $ assocs game = return $ makeMove (\player -> C4 $ game//[((row,mv), Just player)])
                         | otherwise = do putStrLn message
                                          getMove (C4 game)
                where row = head $ reverse $ sort $ map (fst.fst) $ filter (\((i,j),x) -> j == mv && isNothing x) $ assocs game
            message = "That was not a valid move ... please try again."
            ex = \e -> do putStrLn message
                          getInt 
            getInt = catch ((readLn)::IO Int) ex

checkWinC4 :: ConnectFour -> Maybe Player
checkWinC4 (C4 board) | null winLines = Nothing
                      | otherwise = snd $ head winLines 
    where conseq4 (x:xs) = foldl f (1,board!x) $ map (board!) xs
          f (n,pre) sq | n >= 4 = (n,pre)
                       | sq == pre && isJust sq = (n+1,sq)
                       | otherwise = (1,sq)
          winLines = filter ((>=4).fst) (map conseq4 c4Lines)

-- note that diags only includes the diagonals which have at least 4 squares.
c4Lines :: [[(Int,Int)]]
c4Lines = diags ++ rows ++ cols
    where cols = [[(i,j) | i <- [1..6]] | j <- [1..7]]
          rows = [[(i,j) | j <- [1..7]] | i <- [1..6]]
          diags = [[(i + j - 1, j) | j <- [1..6], i + j - 1 <= 6] | i <- [1..3]] 
                  ++ [[(i, j + i - 1) | i <- [1..6], j + i - 1 <= 7] | j <- [2..4]]
                  ++ [[(i - j + 1, j) | j <- [1..6], i - j + 1 >= 1] | i <- [4..6]]
                  ++ [[(7 - i, j + i - 1) | i <- [1..6], j + i - 1 <= 7] | j <- [2..4]]

showC4 :: ConnectFour -> String
showC4 (C4 x) = showGrid 6 7 x

instance Show ConnectFour where
    show = showC4