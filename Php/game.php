<?php

// File: game.php
// Author: Andrew Priddle-Higson
// License: GPLv3


require 'minimax.php';
require 'tictactoe.php';

function endgame($g) {
  $result = $g->win();
  if ($result == 1) print "gw".implode("",$g->board);
  else if ($result == -1) print "gl".implode("",$g->board);
  else print "gd".implode("",$g->board);
}

$square=$_GET["square"];
$board=$_GET["board"];
$board = str_split($board);

//Check whether the game was over
$oldgame = new TicTacToe("o",$board);
if($oldgame->terminal()) {
  endgame($oldgame);
}

//Check whether move is valid, if not then return original board.
if($board[$square-1] != '-') {
  print implode("",$board);
}

//Check new game and if still playing, get next move.
$board[$square - 1] = "x";
$game = new TicTacToe("o",$board);
if ($game->terminal()) {
  endgame($game);
}
else {
  $moves = $game->next_states();
  $min = 1;
  $next = $moves[0];
  foreach ($moves as $g) {
    $curr = minimax($g);
    if ($curr <= $min) {
      $next = $g;
      $min = $curr;
    }
  }
  if ($next->terminal()) {
    endgame($next);
  }
  else {
    $board = $next->board;
    print implode("",$board);
  }
}
?>
