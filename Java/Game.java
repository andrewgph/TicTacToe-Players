import java.util.*;

abstract class Game{

	static float[] range = {-100,100};
	
	abstract ArrayList<Game> successors();
	
	abstract Boolean cutOff();
	
        // evaluation function should return a value within the range.
	abstract float evaluation();
	
	abstract Boolean terminal();
	
	abstract void makeMove(String p, int mv);
	
	abstract String display();
	
	abstract String getWinner();

        abstract Boolean isMaxTurn();
	
	public float minimax(){
		float alpha = range[0];
		float beta = range[1];
		if(this.isMaxTurn()) {
		    return maxValue(this,alpha,beta);
		}
		else {
		    return minValue(this,alpha,beta);
		}
	}
	
	protected static float maxValue(Game g, float alpha, float beta){
		if(g.cutOff()){
			return g.evaluation();
		}
		float v = Game.range[0];
		float val;
		for (Game next: g.successors()){
			val = minValue(next,alpha,beta);
			if (val >= v) {v = val;}
			if (v >= beta) {return v;}
			if (v > alpha) { alpha = v;}
		}
		return v;
	}
	
	protected static float minValue(Game g, float alpha, float beta){
		if(g.cutOff()){
			return g.evaluation();
		}
		float v = Game.range[1];
		float val;
		for (Game next: g.successors()){
			val = maxValue(next,alpha,beta);
			if (val <= v) {v = val;}
			if (v <= alpha) {return v;}
			if (v < beta) { beta = v;}
		}
		return v;
	}
	
}
