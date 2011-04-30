/* main.c

A tic tac toe game in c with an AI opponent, using minimax algorithm
with alpha-beta pruning.

The implementation isn't especially efficient. It uses linked lists to
represent the layers in the search tree, and doesn't bother to free
the memory after the search tree has been built.

*/

#include <stdio.h>
#include <stdlib.h>
#include "malloc.h"
#include <string.h>
#include "tictactoe.h"

void main()
{

  struct game *statepointer = malloc(sizeof(struct game));
  struct game state = *statepointer;

  int i;
  for (i = 0; i < 9; i++) {
	state.board[i] = ' ';
  }
  state.board[9] = '\0';
  state.player = 'x';

  gameloop(&state);

}
