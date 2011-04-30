/* tictactoe.h */

struct gamelist {
  struct game *state;
  struct gamelist *next;
};

struct game {
  char board[10];
  char player;
};

void gameloop(struct game *state);
int gameover(struct game *state);
void makePlayerMove(struct game *state,int move);
void makeComputerMove(struct game *state);
int alphabeta(struct game *state,int alpha, int beta);
int maxvalue(struct gamelist *nextstates,int alpha, int beta);
int minvalue(struct gamelist *nextstates,int alpha, int beta);
struct gamelist *gennextstates(struct game *state);
char isTerminal(char *board);
char checkRows(char *board);
char checkDiags(char *board);
char checkCols(char *board);
void displayGame(struct game *state);
int getPlayerMove(struct game *state);
