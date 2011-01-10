
public class TicTacToeTest {
	
	public static void main(String[] args){
		TicTacToe g = new TicTacToe();
		
		System.out.println(g.display());

		for (Game next : g.successors()){
			System.out.println(next.display());
			System.out.println(Float.toString(next.minimax()));
		}
		g.makeMove("x", 1);
		for (Game next : g.successors()){
			System.out.println(next.display());
			System.out.println(Float.toString(next.minimax()));
		}
		g.makeMove("x",2);
		g.makeMove("x",3);
		g.makeMove("x",4);
		g.makeMove("x",5);
		g.makeMove("x",6);
		g.makeMove("x",7);
		g.makeMove("x",8);
		g.makeMove("x",9);
		System.out.println(g.display());
		if(g.terminal()) {
		    System.out.println("over");
		    System.out.println(Float.toString(g.evaluation()));
		    System.out.println(g.getWinner());
		}
		/*		
		g.makeMove("o", 9);
		g.makeMove("x", 7);
		System.out.println(Float.toString(g.evaluation()));
		System.out.println(Float.toString(g.minimax()));
		g.makeMove("o", 8);
		g.makeMove("x", 4);
		System.out.println(Float.toString(g.evaluation()));
		System.out.println(g.display());
		if(g.cutOff()) {
		    System.out.println("over");
		}
		else {
		    System.out.println("not over");
		}
		g.makeMove("o", 4);
		g.makeMove("x", 8);
		System.out.println(g.display());
		System.out.println(g.getWinner());
		*/
		
	}

}
