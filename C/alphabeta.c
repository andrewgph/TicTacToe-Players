/* aiplayer.c */

#include <stdio.h>
#include <stdlib.h>
#include "malloc.h"
#include <string.h>
#include "tictactoe.h"

int alphabeta(struct game *state,int alpha, int beta)
{

  /*  printf("minimax: Calculating minimax for board '%s' with player %c\n",state->board,state->player); */

  /* loop through next states getting minimax values */

  char outcome = isTerminal(state->board);

  switch(outcome)
  {
	case 'x':
	  return 1;
	case 'o':
	  return -1;
	case 'd':
	  return 0;
	case ' ':
	  if (state->player == 'x') {
		return maxvalue(gennextstates(state),alpha,beta);
	  } else {
		return minvalue(gennextstates(state),alpha,beta);
	  }
  }

}

int maxvalue(struct gamelist *nextstates,int alpha, int beta)
{

  int maxstatevalue = -2;
  int minimaxvalue;

  while (nextstates != NULL)
	{
	  minimaxvalue = alphabeta(nextstates->state,alpha,beta);
	  if (minimaxvalue > maxstatevalue) maxstatevalue = minimaxvalue;
	  if (maxstatevalue >= beta) return maxstatevalue;
	  if (alpha < maxstatevalue) alpha = maxstatevalue;

	  nextstates = nextstates->next;
	}

  return maxstatevalue;

}

int minvalue(struct gamelist *nextstates, int alpha, int beta)
{

  int minstatevalue = 2;
  int minimaxvalue;

  while (nextstates != NULL)
	{
	  minimaxvalue = alphabeta(nextstates->state,alpha,beta);
	  if (minimaxvalue < minstatevalue) minstatevalue = minimaxvalue;
	  if (minstatevalue <= alpha) return minstatevalue;
	  if (beta > minstatevalue) beta = minstatevalue;

	  nextstates = nextstates->next;
	}

  return minstatevalue;

}

