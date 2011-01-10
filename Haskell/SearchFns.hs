module SearchFns where

import Maybe (isNothing)
import List (sortBy)
import Game 

-- Section 1: Uniform Search 

-- 5 x 5 grid search states

type Trace = [(Int,Int)]

next :: Trace -> [Trace]
next trace | null trace = error "Where are you ..."
           | otherwise = map (:trace) $ filter inGrid [(x+1,y),(x-1,y),(x,y+1),(x,y-1)]
           where (x,y) = head trace
                 inGrid (i,j) = elem i [1..5] && elem j [1..5]

goal :: (Int,Int) -> Trace -> Bool
goal pt trace = null trace || head trace == pt

-- Breadth-First Search

breadthFirstSearch :: (a -> [a]) -> (a -> Bool) -> [a] -> Maybe a
breadthFirstSearch next goal states | null states = Nothing
                                    | goal $ head states = Just $ head states
                                    | otherwise = breadthFirstSearch next goal $ tail states ++ next (head states)

-- Depth-First Search 

depthFirstSearch :: (a -> [a]) -> (a -> Bool) -> [a] -> Maybe a
depthFirstSearch next goal states | null states = Nothing
                                  | goal $ head states = Just $ head states
                                  | otherwise = depthFirstSearch next goal $ next (head states) ++ tail states

-- Iterative-deepening search

iterDeepSearch :: (a -> [a]) -> (a -> Bool) -> Int -> a -> Maybe a
iterDeepSearch next goal d initialState = iterloop d [(initialState,0)]
    where iterloop lim states | null states = iterloop (lim+d) [(initialState,0)]
                              | goal current = Just current
                              | depth > lim = iterloop lim $ tail states
                              | otherwise = iterloop lim $ map (\x -> (x,lim+1)) (next current) ++ tail states
                              where (current,depth) = head states

-- Section 2: Informed search

-- Manhattan distance heuristic 

manhattan :: (Int,Int) -> (Int,Int) -> Int
manhattan (x1,y1) (x2,y2) = abs (x1 - x2) + abs (y1 - y2)

-- Best-First Search

bestFirstSearch :: (Ord b) => (a -> Bool) -> (a -> [a]) -> (a -> b) -> [a] -> Maybe a
bestFirstSearch goal next heuristic states | null states = Nothing
                                           | goal (head states) = Just $ head states
                                           | otherwise = bestFirstSearch goal next heuristic sortedStates
                                           where sortedStates = sortBy f $ next (head states) ++ tail states
                                                 f x y = compare (heuristic x) (heuristic y)

-- A* Search  

aStarSearch :: (Num b, Ord b) => (a -> Bool) -> (a -> [a]) -> (a -> b) -> (a -> b) -> [a] -> Maybe a
aStarSearch goal next heuristic cost states | null states = Nothing
                                            | goal (head states) = Just $ head states
                                            | otherwise = bestFirstSearch goal next heuristic sortedStates
                                            where sortedStates = sortBy f $ next (head states) ++ tail states
                                                  f x y = compare (heuristic x + cost x) (heuristic y + cost y)

cost :: Trace -> Int
cost tr = length tr - 1

-- Simplified-Model Heuristic

simpModel :: (Int,Int) -> (Int,Int) -> Int
simpModel (x1,y1) (x2,y2) = max (abs (x1 - x2)) (abs (y1 - y2))

-- Section 3: Games

minimax :: (Game a) => a -> Player -> Int
minimax game player | terminal game = eval game
                    | maxPlayer player = maximum succs
                    | otherwise = minimum succs
                    where succs = [minimax x (switch player) | x <- map (play player) (moves game)]



alphabeta :: (Game a) => a -> Player -> Int
alphabeta game player | maxPlayer player = maxValue player game (-2,2) 
                      | otherwise = minValue player game (-2,2)
    where maxValue pl g (a,b) | terminal g = eval g
                              | otherwise = snd $ foldr (\g' (a',v) -> 
                                       let newV = max v (minValue (switch pl) g' (a',b)) in
                                       if v >= b 
                                       then (a',v) -- If a state with an evaluation higher than beta has been found, we don't bother checking any further nodes on this branch.
                                       else (max a' newV, newV)) -- If not, we calculate the new alpha and v values.
                                (a,-2) (succs g pl)
          minValue pl g (a,b) | terminal g = eval g
                              | otherwise = snd $ foldr (\g' (b',v) ->
                                       let newV = min v (maxValue (switch pl) g' (a,b')) in
                                       if v <= a
                                       then (b',v) -- If a state with an evaluation lower than alpha has been found, ignore the rest of the nodes on this branch.
                                       else (min b' newV, newV)) -- If not, calculate the new beta and v values.
                                (b,2) (succs g pl)
          succs g pl = map (play pl) (moves g)



alphabetaEval :: (Num b, Ord b, Game a) => a -> Player -> Int -> b
alphabetaEval game player maxdepth | maxPlayer player = maxValue player game (-101,101) 0 -- use a range -101 to 101
                                   | otherwise = minValue player game (-101,101) 0
    where maxValue pl g (a,b) d | d > maxdepth || terminal g = evaluation g 
                                | otherwise =  snd $ foldr (\g' (a',v) -> 
                                       let newV = max v (minValue (switch pl) g' (a',b) (d+1)) in
                                       if v >= b 
                                       then (a',v) -- If a state with an evaluation higher than beta has been found, we don't bother checking any further nodes on this branch.
                                       else (max a' newV, newV)) -- If not, we calculate the new alpha and v values.
                                (a,-101) (succs g pl)
          minValue pl g (a,b) d | d > maxdepth || terminal g = evaluation g
                                | otherwise = snd $ foldr (\g' (b',v) ->
                                       let newV = min v (maxValue (switch pl) g' (a,b') (d+1)) in
                                       if v <= a
                                       then (b',v) -- If a state with an evaluation lower than alpha has been found, ignore the rest of the nodes on this branch.
                                       else (min b' newV, newV)) -- If not, calculate the new beta and v values.
                                (b,101) (succs g pl)
          succs g pl = map (play pl) (moves g)

 
ncEval :: (Num b, Ord b, Game a) => a -> b
ncEval game | terminal game = fromIntegral $ 100 * eval game -- evaluation scores are in the range -100 to 100
            | otherwise = sum $ map val bLines
    where bLines = map (map snd) $ getLines game
          val line = case score line of
                       (Nothing,_) -> 0
                       (Just pl,n) -> if maxPlayer pl 
                                      then fromIntegral $ n^3
                                      else fromIntegral $ -n^3
          score line = foldr (\pl (pl',n) -> 
                                if  n > 0 && (pl == pl' || isNothing pl')
                                then (pl,n+1)
                                else (Nothing,0)) (Nothing,1) line

connect4Eval :: (Num b, Ord b, Game a) => a -> b
connect4Eval game | terminal game = fromIntegral $ 100 * eval game
                  | otherwise = sum $ map val bLines
    where bLines = concat $ map fourLine $ getLines game
          val line = case score line of 
                       (Nothing,_) -> 0
                       (Just pl,n) -> if maxPlayer pl 
                                      then fromIntegral $ n^3
                                      else fromIntegral $ -n^3
          score line = foldr (\pl (pl',n) -> 
                                if  n > 0 && (pl == pl' || isNothing pl')
                                then (pl,n+1)
                                else (Nothing,0)) (Nothing,1) line
          fourLine line | length line < 4 = []
                        | otherwise = take 4 (map snd line):fourLine (tail line)
