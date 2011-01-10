import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.shape.*;
import javafx.scene.shape.Line;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Path;
import javafx.scene.*;
import javafx.scene.input.MouseEvent;
import javafx.util.Math;

var game:TicTacToe = new TicTacToe();

Stage {
	title: 'TicTacToe'
	var scene: Scene = Scene {
		width: 300
		height: 300
		content: [
			Rectangle {
				x: 0
				y: 0
				width: 300
				height: 300
				fill:Color.WHITE
				var cross: Path
			        var nought: Path
				onMouseClicked: function(e) {
						if(not game.terminal()) {
						var square = getSquare(e.sceneX,e.sceneY) + 1;
						if(game.isValidMove(square)) {
						 println(square);
						 var cx =  javafx.util.Math.floor(e.sceneX / 100 as Double) * 100;
						 var cy =  javafx.util.Math.floor(e.sceneY / 100 as Double) * 100;
						 println(cx);
						 println(e.sceneX);
						 println(cy);
						 cross = Path { 
							elements: [
							 MoveTo { x: cx + 25 y: cy + 25},
							 LineTo { x: cx + 75 y: cy + 75},
							 MoveTo { x: cx + 75 y: cy + 25},
							 LineTo { x: cx + 25 y: cy + 75}
							]
							};
						 insert cross into scene.content;
						 game.makeMove("x",square);
						 var nsquare = game.compMove();
						 var nx = ((nsquare mod 3))*100 + 25;
						 var ny = ((nsquare / 3))*100 + 25;
						 nought = Path { 
							 elements: [
							   MoveTo { x: nx y: ny },
							   ArcTo { x: nx + 50 y: ny + 50 
								    radiusX: 25 radiusY: 25},
							   ArcTo { x: nx y: ny
								    radiusX: 25 radiusY: 25}
							   ]
							  };
						 insert nought into scene.content;
						 println(game.display());
						}	
						}}
			},
			Line {
				startX: 100 
				startY: 0
				endX: 100 
				endY: 300
			}, 
			Line {
				startX: 200 
				startY: 0
				endX: 200 
				endY: 300
			}, 
			Line {
				startX: 0 
				startY: 100
				endX: 300 
				endY: 100
			}, 
			Line {
				startX: 0 
				startY: 200
				endX: 300 
				endY: 200
			}	
			]
	}
	scene: scene
}

function getSquare(x:Integer,y:Integer) {
	return (x/100) + (y/100)*3;
}
