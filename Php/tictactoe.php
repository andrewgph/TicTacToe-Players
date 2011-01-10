<?php

//File: tictactoe.php
//Author: Andrew Priddle-Higson
//License: GPLv3

// Implementation of the tictactoe game.
// Player "x" starts, and is the max player (for minimax valuations).
class TicTacToe
{

  public $player;
  public $board;  
  
  function __construct($newplayer, $newboard)
  {
    // A constructor for a continuation of an existing game.
    $this->player = $newplayer;
    $this->board = $newboard;
  }

  function next_states()
  {
    // returns an array of new instances of TicTacToe refering to the possible continuations of the current game.
    $next = array();
    foreach ($this->board as $i => $sq) { 
	if ($sq == "-") {
	    $next[] = new TicTacToe($this->player_switch(),$this->make_move($i)); 
	  }
      }
    return $next;

  }

  function player_switch() 
  {
    // A helper function to alter the current player.
    if ($this->player == "o") return "x";
    else return "o";
  }

  function max_player(){
    return ($this->player == "x");
  }

  function make_move($i)
  {
    // try to alter the current board state, returning the board array if possible or false if not.
    if ($this->board[$i] == "-") {
      $newboard = $this->board;
      $newboard[$i] = $this->player;
      return $newboard;
      }
    else return FALSE;
  }			    

  function terminal()
  {
    // Check whether the game is over (i.e. whether someone has won or there are no remaining moves).
   if ($this->win() != 0) return TRUE;
   foreach ($this->board as $sq) {
      if ($sq == "-") {
	return FALSE;
      }
    }
    return TRUE;
  }

  function win()
  {
    // Check the rows, columns and diagonals for a winning line.
    $lines = array(array($this->board[0],$this->board[4],$this->board[8]),
		   array($this->board[2],$this->board[4],$this->board[6]));
    for($i=0;$i<=2;$i++) {
      $lines[] = array($this->board[$i],$this->board[$i+3],$this->board[$i+6]);
      $lines[] = array($this->board[$i*3],$this->board[$i*3+1],$this->board[$i*3+2]);
    }
    foreach ($lines as $line) {
      if (TicTacToe::checkline($line)) {
	if ($line[0] == "o") return -1;
	else if ($line[0] == "x") return 1;
      }
    }
    return 0;
  }

  function checkline($line)
  {
    return ((!($line[0] == "-")) && ($line[0] == $line[1]) && ($line[1] == $line[2]));
  }


}

?>
