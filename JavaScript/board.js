function displayBoard(board,board_div) {
	var canvas = document.getElementById(board_div);
	var ctx = canvas.getContext('2d');
	ctx.clearRect(0,0,300,300);
	ctx.beginPath();
	ctx.moveTo(100,0);
	ctx.lineTo(100,300);
	ctx.moveTo(200,0);
	ctx.lineTo(200,300);
	ctx.moveTo(0,100);
	ctx.lineTo(300,100);
	ctx.moveTo(0,200);
	ctx.lineTo(300,200);
	ctx.stroke();
	for(i=0;i<3;i++) {
		for (j=0;j<3;j++) {
			switch(board[i][j]) {
				case '-':
					break;
				case 'x':
					drawCross(ctx,i*100 + 50,j*100 + 50);
					break;
				case 'o':
					drawNought(ctx,i*100 + 50,j*100 + 50);
					break;
				default:
					break;
			}
		}
	}
}

function drawCross(ctx,x,y) {
	ctx.beginPath();
	ctx.moveTo(x-25,y-25);
	ctx.lineTo(x+25,y+25);
	ctx.moveTo(x+25,y-25);
	ctx.lineTo(x-25,y+25);
	ctx.stroke();
}

function drawNought(ctx,x,y) {
	ctx.beginPath();
	ctx.arc(x,y,25,0,Math.PI*2,true);
	ctx.stroke();
}