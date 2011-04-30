/* game.c */

#include <stdio.h>
#include <stdlib.h>
#include "malloc.h"
#include <string.h>
#include "tictactoe.h"

void gameloop(struct game *state)
{

  printf("gameloop: current board '%s' with player %c\n",state->board,state->player);

  displayGame(state);

  if(gameover(state) == 1) {
	return;
  }

  makePlayerMove(state,getPlayerMove(state));

  displayGame(state);

  if(gameover(state) == 1) {
	return;
  }

  makeComputerMove(state);

  gameloop(state);

}

int gameover(struct game *state)
{

  printf("gameover: checking board '%s'\n",state->board);

  char outcome = isTerminal(state->board);

  switch( outcome )
  {
	case 'x':
	  printf("You have won!\n");
	  return 1;
	  break;
	case 'o':
	  printf("You have lost.\n");
	  return 1;
	  break;
	case 'd':
	  printf("A draw ...\n");
	  return 1;
	  break;
  }

  return 0;

}

void makePlayerMove(struct game *state,int move)
{
  printf("makePlayerMove: State is '%s' move is %d\n",state->board,move);

  state->board[move] = 'x';
  state->player = 'o';

}

void makeComputerMove(struct game *state)
{

  printf("makeComputerMove: Making computer move on board '%s' with player %c\n",state->board,state->player);

  /* Get the next possible states and choose the one with the least
	 minimax value */

  struct gamelist *nextstates = gennextstates(state);

  /* Set the minstatevalue to 2, larger than the minimax function will
	 return, so that the nextgame variable is definitely set */

  int minstatevalue = 2;
  int minimaxvalue;
  struct game *nextgame;

  puts("looping through next states checking minimax");

  while (nextstates != NULL)
	{
	  minimaxvalue = alphabeta(nextstates->state,-2,2);
	  if (minimaxvalue < minstatevalue) {
		minstatevalue = minimaxvalue;
		nextgame = nextstates->state;
	  }
      printf("Minimax value of board '%s' = %i\n",nextstates->state->board,minimaxvalue);
	  nextstates = nextstates->next;
	}

  strcpy(state->board,nextgame->board);
  state->player = nextgame->player;

}

struct gamelist *gennextstates(struct game *state)
{

  /*  printf("gennextstates: Generating next states for board '%s' with player %c\n",state->board,state->player); */

  int i, j;
  struct gamelist *root;
  struct gamelist *previousstate;
  struct gamelist *currentstate;
  struct game *currentgame;

  root = malloc(sizeof(struct gamelist));
  currentstate = root;

  for (i = 0; i < 9; i++) {
	if (state->board[i] == ' ') {
	  if (currentstate == NULL) {
		currentstate = malloc(sizeof(struct gamelist));
		previousstate->next = currentstate;
	  }

	  currentstate->next  = NULL;

	  currentstate->state = malloc(sizeof(struct game));
	  currentgame = currentstate->state;

	  previousstate = currentstate;
	  currentstate = currentstate->next;

	  strcpy(currentgame->board,state->board);
	  currentgame->board[i] = state->player;

	  if (state->player == 'x') {
		currentgame->player = 'o';
	  } else {
		currentgame->player = 'x';
	  }

	}
  }

  return root;

}

int getPlayerMove(struct game *state)
{

  int move;

  printf("Please enter a number between 1 and 9 to choose your move: ");
  scanf("%d",&move);

  if(move < 1 || move > 9 || state->board[move - 1] != ' ') {
	printf("Not a valid move.\n");
	return getPlayerMove(state);
  }

  return (move - 1);

}
