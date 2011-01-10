module Grid (showGrid) where

import Array
import Maybe (fromJust,isNothing)

showGrid :: Show a => Int -> Int -> Array (Int,Int) (Maybe a) -> String
showGrid r c board = foldl1 g $ map (showRow.row) [1..r]
    where row n = filter ((==n).(fst.fst)) $ assocs board
          showRow rw = " " ++ (foldl1 f $ map (showSquare.snd) rw) ++ "\n"
          f x y = x ++ " | " ++ y
          g x y = x ++ concat (replicate c " -  ") ++ "\n" ++ y
          showSquare x | isNothing x = " "
                       | otherwise = show $ fromJust x