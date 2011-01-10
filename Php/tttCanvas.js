var board = "---------";

var playing = true;

function ajaxFunction(square)
{

  var xmlhttp;

  if (window.XMLHttpRequest)
  {
  // code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else if (window.ActiveXObject)
  {
  // code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
else
  {
  alert("Your browser does not support XMLHTTP!");
  }

  xmlhttp.onreadystatechange=function()
  {
    if(xmlhttp.readyState==4) {
        document.getElementById("result").innerHTML="Your move";
        board = xmlhttp.responseText;
        if (board.charAt(0) == 'g') {
          if (board.charAt(1) == 'w') {
              document.getElementById("result").innerHTML="You have won!";
          }
          else if (board.charAt(1) == 'l') {
              document.getElementById("result").innerHTML="You have lost!";
          }
          else {
              document.getElementById("result").innerHTML="A draw ... how dull.";
          }
          board = board.substring(2);
          playing = !playing;
	}
        displayBoard();
      }
    else {
     document.getElementById("result").innerHTML="Thinking of a move ...";
    }
  }

  if(playing) {
   xmlhttp.open("GET","game.php"+"?square="+square+"&board="+board,true);
   xmlhttp.send(null);
  }
  else {
   document.getElementById("result").innerHTML = "Game is over!";
  }
}

function displayBoard()
{
  var canvas = document.getElementById('tttboard');
  var ctx = canvas.getContext('2d');
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
 for(i=0;i<=8;i++) {
   switch(board.charAt(i))
   {
   case '-':
     break;
   case 'x':
     drawCross(ctx,Math.floor(i/3)*100 + 50,(i%3)*100 + 50);
     break;
   case 'o':
     drawNought(ctx,Math.floor(i/3)*100 + 50,(i%3)*100 + 50);
     break;
   default:
     break;
   } 
 }
}

function drawCross(ctx,x,y) 
{
 ctx.beginPath();
 ctx.moveTo(x-25,y-25);
 ctx.lineTo(x+25,y+25);
 ctx.moveTo(x+25,y-25);
 ctx.lineTo(x-25,y+25);
 ctx.stroke();
}

function drawNought(ctx,x,y)
{
 ctx.beginPath();
 ctx.arc(x,y,25,0,Math.PI*2,true);
 ctx.stroke();
}

function makemove(x,y) 
{
 var square = Math.floor(x/100)*3 + Math.floor(y/100) + 1;
 if (board.charAt(square-1) == '-') {
  ajaxFunction(square.toString());
 }
 else if(!playing) {
  document.getElementById("result").innerHTML = "Game is over!";
 }
 else { 
  document.getElementById("result").innerHTML = "Not a valid move!";
 }
}

function initBoard()
{
 var c = document.getElementById("tttboard");
 c.addEventListener('click',function(e) {makemove(e.clientX-c.offsetLeft,e.clientY-c.offsetTop);},false);
 displayBoard();
document.getElementById("result").innerHTML="Your move";
}
