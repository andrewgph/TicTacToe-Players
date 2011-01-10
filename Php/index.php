<?php

require 'minimax.php';
require 'tictactoe.php';

$square=$_GET["square"];
$board=$_GET["board"];

function endgame($g) 
{
  $result = $g->win();
  if ($result == 1) print "gw".implode("",$g->board);
  else if ($result == -1) print "gl".implode("",$g->board);
  else print "gd".implode("",$g->board);
}

function validboard($b)
{
  return (strlen($b) == 9 && strlen(preg_replace('/[xo-]*/',"",$b)) == 0);
}

if (isset($square) && isset($board) && ctype_digit($square) && validboard($board)) {

  $board = str_split($board);
  $board[$square] = "x";
  
  $game = new TicTacToe("o",$board);
  if ($game->terminal()) {
    endgame($game);
  }
  else {
    $moves = $game->next_states();
    $min = 2;
    $next = $moves[0];
    foreach ($moves as $g) {
      $curr = minimax($g);
      if ($curr <= $min) {
	$next = $g;
	$min = $curr;
      }
    }
    if ($next->terminal()) {
      endgame($next);
    }
    else {
      $board = $next->board;
      print implode("",$board);
    }
  }
  exit;
 }
?>
<html>
<head>
<script type="text/javascript">

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

  var response;

  xmlhttp.onreadystatechange=function()
  {
    if(xmlhttp.readyState==4) {
        document.getElementById("result").innerHTML="Your move";
         response = xmlhttp.responseText;
        if (response.charAt(0) == 'g') {
	  playing = false;
          if (response.charAt(1) == 'w') {
              document.getElementById("result").innerHTML="You have won!";
          }
          else if (response.charAt(1) == 'l') {
              document.getElementById("result").innerHTML="You have lost!";
          }
          else if (response.charAt(1) == 'd') {
              document.getElementById("result").innerHTML="A draw ... how dull.";
	  }
	  else {
	    document.getElementById("result").innerHTML="error";
          }
          board = response.substring(2,11);
        }
	else {board = response;}
        displayBoard();
      }
    else {
     document.getElementById("result").innerHTML="Thinking of a move ...";
    }
  }
  
  xmlhttp.open("GET","index.php"+"?square="+square+"&board="+board,true);
  xmlhttp.send(null);
}

function displayBoard()
{
  var canvas = document.getElementById('tttboard');
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
  if(playing) {
    var square = Math.floor(x/100)*3 + Math.floor(y/100);
    ajaxFunction(square.toString());
  }
  else { document.getElementById("result").innerHTML="The game is over."; }
}

function initBoard()
{
 var c = document.getElementById("tttboard");
 c.addEventListener('click',function(e) {makemove(e.clientX-c.offsetLeft,e.clientY-c.offsetTop);},false);
 displayBoard();
document.getElementById("result").innerHTML="Your move";
}

</script>
<style type="text/css">
  canvas {display:block;margin:0 auto; margin-top:100px}
  .feedback { text-align:center; margin-top:25px }
</style>
</head>
<body onload="initBoard();">

<canvas id="tttboard" width="300" height="300">
Your browser doesn't display the canvas tag
</canvas>

<div id="result" class="feedback">
</div>



</body>
</html>
