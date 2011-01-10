import java.util.*;

public class TicTacToe extends Game {
	
	TicTacToeBoard board;
        String player;
	
	TicTacToe(){
	    board = new TicTacToeBoard();
	    player = "x";
	}
	
	TicTacToe(String pl, TicTacToeBoard b){
	    if (pl == "o") {
		player = "o";
	    }
	    else {
		player = "x";
	    }
	    board = b;
	}

	
        public Boolean isMaxTurn() {
	    return (player == "x");
        }
	
	public ArrayList<Game> successors(){
	    ArrayList<Game> succs = new ArrayList<Game>();
	    String newplayer;
	    if(player == "x") {
		newplayer = "o";
	    }
	    else {
		newplayer = "x";
	    }
	    for (int i = 1; i < 10; i++){
		TicTacToeBoard b = board.move(player,i);
		if (b != null){
		    succs.add(new TicTacToe(newplayer,b));
		}
	    }
	    return succs;
	}
	
	public Boolean cutOff(){
	    return terminal();
	}
	
	public float evaluation(){
	    return board.evaluation();
	}
	
	public Boolean terminal(){
	    return (board.checkWin() != "");
	}
	
	public String getWinner(){
	    return board.checkWin();
	}
	
	protected void setBoard(TicTacToeBoard b){
	    board = b;
	}
	
	public TicTacToeBoard getBoard() {
	    return board;
	}
	
	public void makeMove(String pl, int n){
	    TicTacToeBoard b = board.move(pl,n);
	    if(b != null){
		setBoard(b);
	    }
	    if(pl == "x") {
		player = "o";
	    }
	    else {
		player = "x";
	    }
	}
	
	public String display(){
		return board.display();
	}

        public Boolean isValidMove(int n) {
	    return board.isEmpty(n);
	}

        public int compMove() {
	    float v = Game.range[1];
	    TicTacToe succ = null;
	    int square = -1;
	    for (Game next : this.successors()){
		float val = next.minimax();
		if (val <= v) {
		    v = val;
		    succ = (TicTacToe)next;
		}
	    }
	    if (succ != null) {
		for (int i = 0; i <= 8; i++) {
		     if (board.getSquare(i) != succ.getBoard().getSquare(i)) {
			square = i;
			}
		}
	      this.setBoard(succ.getBoard());
	      if (player == "x") {
		player = "o";
		}
	      else {
		player = "x";
		}
	    }
	    return square;
	}

        public String getSquare(int n) {
	    return board.getSquare(n);
	}

}
