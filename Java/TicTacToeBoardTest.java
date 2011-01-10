
public class TicTacToeBoardTest {
	
	public static void main(String[] args){
		TicTacToeBoard b = new TicTacToeBoard();
		
		System.out.println(b.display());
		System.out.println(b.move("x",1).display());
		System.out.println(b.move("o",9).display());
		b = b.move("x",1);
		b = b.move("o",2);
		b = b.move("x",3);
		b = b.move("o",4);
		b = b.move("o",5);
		b = b.move("x",6);
		b = b.move("x",7);
		b = b.move("x",8);
		b = b.move("o",9);
		System.out.println(b.checkWin());
		for (String[] line: b.getLines()) {
		    String l = line[0] + line[1] + line[2];
		    System.out.println(l);
		}
		if(b.isFull()) {
		    System.out.println("full");
		}
		System.out.println(b.display());
		if(b.checkWin() != "") {
		    System.out.println(Float.toString(b.evaluation()));
		}
		else {
		    System.out.println("not over");
		}
		for (String[] line: b.getLines()) {
		    String l = line[0] + line[1] + line[2];
		    System.out.println(l);
		}


	}

}
