<?php

// File: minimax.php
// Author: Andrew Priddle-Higson
// License: GPLv3

// Calculates minimax value using alpha-beta pruning
function minimax($g) 
{
  if ($g->max_player()) {
    return maxvalue($g,-2,2);
  }
  else {
    return minvalue($g,-2,2);
  }
}

function maxvalue($game,$alpha,$beta)
{
  if ($game->terminal()) {
    return $game->win();
  }
  else {
    $v = -2;
    foreach($game->next_states() as $succ) {
      $v = max($v,minvalue($succ,$alpha,$beta));
      if($v >= $beta) return $v;
      $alpha = max($alpha,$v);
    }
    return $v;
  }
}

function minvalue($game,$alpha,$beta)
{
 if ($game->terminal()) {
    return $game->win();
  }
  else {
    $v = 2;
    foreach($game->next_states() as $succ) {
      $v = min($v,maxvalue($succ,$alpha,$beta));
      if($v <= $alpha) return $v;
      $beta = min($beta,$v);
    }
    return $v;
  } 
}

?>
