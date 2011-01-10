import java.util.*;

public class TicTacToeBoard {
	
	String[] state = new String[9];
	
	TicTacToeBoard(){
	    for (int i = 0; i < 9; i++) {
		state[i] = " ";
	    }
	}

	public String getSquare(int n){
		return state[n];
	}
	
	protected void setSquare(int n,String pl){
		state[n] = pl;
	}
	
        public TicTacToeBoard move(String player,int n){
	    if(n > 0 && n < 10 && state[n-1] == " ") {
		TicTacToeBoard b = new TicTacToeBoard();
		for (int i = 0; i < 9; i++){
		    b.setSquare(i,state[i]);
		}
		b.setSquare(n-1,player);
		return b;
	    } else {
		return null;
	    }
	}
    
	public ArrayList<String[]> getLines(){
		ArrayList<String[]> lines = new ArrayList<String[]>();

		for (int i = 0; i < 3; i++){
			String[] row = new String[3];
			row[0] = state[i*3];
			row[1] = state[i*3+1];
			row[2] = state[i*3+2];
			lines.add(row);
		}
		
		for (int i = 0; i < 3; i++){
			String[] column = new String[3];
			column[0] = state[i];
			column[1] = state[i+3];
			column[2] = state[i+6];
			lines.add(column);
		}
		
		String[] diag1 = {state[0],state[4],state[8]};
		String[] diag2 = {state[2],state[4],state[6]};
		
		lines.add(diag1);
		lines.add(diag2);
		
		return lines;
	}
	
	public String checkWin(){
		for (String[] line: getLines()){
			if(winningLine(line) != ""){
			    return winningLine(line);
			}
		}
		if (isFull()){
			return "draw";
		}
		return "";
	}
	
	protected String winningLine(String[] line){
		if (line[0] == line[1] && line[1] == line[2]){
			if (line[0] == "x"){
				return "x";
			} else if (line[0] == "o"){
				return "o";
			} 
		}
		return "";
	}
	
        public String display(){
	    String board = "-------------\n";
	    for (int i = 0; i < 3; i++){
		for (int j = 0; j < 3; j++) {
		    board += "| " + state[i*3+j] + " ";
		}
		board += "|\n-------------\n";
	    }
	    return board;
	}
	
	public float evaluation(){
		// Player "x" is max, and player "o" is min.
		if(checkWin() == "draw"){
			return 0;
		}
		else if (checkWin() == "o") {
		    return -1;
		}
		else if (checkWin() == "x") {
		    return 1;
		}
		else { return 0;}
	}
	
	protected Boolean isFull(){
	    Boolean full = true;
	    for (int i = 0; i < 9; i++){
		if (state[i] == " "){
		    full = false;
		}
	    }
	    return full;
	}
	
        public Boolean isEmpty(int n) {
	    return (state[n-1] == " ");
	}

}
