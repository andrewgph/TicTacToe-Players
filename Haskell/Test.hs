import TicTacToe
import Game
import Test.QuickCheck
import Text.Printf
import Maybe (isNothing)
 
main  = mapM_ (\(s,a) -> printf "%-25s: " s >> a) tests
 
instance Arbitrary TicTacToeGame where
    arbitrary     = undefined

instance Arbitrary Player where
    arbitrary     = undefined

prop_minimaxTerminalOne :: TicTacToeGame -> Property
prop_minimaxTerminalOne g = terminal g && checkWin g == Just playerOne ==> minimax g == 1

prop_minimaxTerminalTwo :: TicTacToeGame -> Property
prop_minimaxTerminalTwo g = terminal g && checkWin g == Just playerTwo ==> minimax g == -1

prop_minimaxTerminalDraw :: TicTacToeGame -> Property
prop_minimaxTerminalDraw g = terminal g && isNothing (checkWin g) ==> minimax g == 0

prop_switchPlayerId :: Player -> Bool
prop_switchPlayerId pl = switchPlayer (switchPlayer pl) == pl


-- and add this to the tests list
tests  = [("minimaxTerminalOne", quickCheck prop_minimaxTerminalOne),
	  ("minimaxTerminalTwo", quickCheck prop_minimaxTerminalTwo),
	  ("minimaxTerminalDraw", quickCheck prop_minimaxTerminalDraw),
	  ("switchPlayerId", quickCheck prop_switchPlayerId)]