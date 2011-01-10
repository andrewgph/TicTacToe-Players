
import java.io.*;

public class GameLauncher {


	public static void main(String[] args) {
		Game game = new TicTacToe();

		while(!game.terminal()){
			System.out.println(game.display());
			game.makeMove("x",getMove());
			if(game.terminal()){
				break;
			}
			float v = Game.range[1];
			Game succ = null;
			for (Game next : game.successors()){
			    float val = next.minimax();
			    if (val <= v) {
				v = val;
				succ = next;
			    }
			}
			game = succ;
		}
		System.out.println(game.display());
		if (game.getWinner() == "draw") { 
			System.out.println("draw!");
		} else {
			System.out.println("The " + game.getWinner() + " player has won!");
		}
		
	}
	
	public static int getMove(){
		int move = 0;
		System.out.println("Please enter a number (between 1 and 9):");
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		try {
	         move = Integer.parseInt(br.readLine());
	      } catch (IOException ioe) {
	         System.out.println("IO error occured while trying to get your move");
	         System.exit(1);
	      }
		if (move < 1 || move > 9) {
			System.out.println("A move has to be between 1 and 9.");
			return getMove();
		}
	      
		return move;
	}

}
