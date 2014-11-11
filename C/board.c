/* board.c

The functions for checking and displaying the game board

*/


#include <stdio.h>
#include <stdlib.h>
#include "malloc.h"
#include <string.h>
#include "tictactoe.h"

char isTerminal(char *board)
{

  /*  printf("isTerminal: checking board '%s'\n",board); */

  char rows;
  char diags;
  char cols;

  rows = checkRows(board);
  diags = checkDiags(board);
  cols = checkCols(board);

  if (rows != ' ' && rows != 'd') {
	return rows;
  }

  if (cols != ' ') {
	return cols;
  }

  if (diags != ' ') {
	return diags;
  }

  if (rows == 'd') {
	return 'd';
  } else {
	return ' ';
  }

}

char checkRows(char *board)
{

  int i;
  int areFreeSpaces = 0;

  for (i = 0; i < 3; i++) {
    if ((board[3*i] == ' ') || (board[(3*i)+1] == ' ') || (board[(3*i)+2] == ' ')) areFreeSpaces = 1;
    if ((board[3*i] != ' ') && (board[3*i] == board[(3*i)+1]) && (board[(3*i)+1] == board[(3*i)+2])) return board[3*i];
  }

  if (areFreeSpaces == 1) {
	return ' ';
  } else {
	return 'd';
  }

}

char checkDiags(char *board)
{

  if ((board[0] != ' ') && (board[0] == board[4]) && (board[4] == board[8])) return board[0];
  if ((board[2] != ' ') && (board[2] == board[4]) && (board[4] == board[6])) return board[2];
  return ' ';

}

char checkCols(char *board)
{

  int i;

  for (i = 0; i < 3; i++) {
    if ((board[i] != ' ') && (board[i] == board[i+3]) && (board[i+3] == board[i+6])) return board[i];
  }

  return ' ';

}

void displayGame(struct game *state)
{

  printf("%c|%c|%c\n",state->board[0],state->board[1],state->board[2]);
  printf("-----\n");
  printf("%c|%c|%c\n",state->board[3],state->board[4],state->board[5]);
  printf("-----\n");
  printf("%c|%c|%c\n",state->board[6],state->board[7],state->board[8]);

}
