<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
  <title>Andrew Priddle-Higson Homepage</title>
  <link rel="stylesheet" type="text/css" href="/s0674512/homepage.css" />
  <script type="text/javascript" src="tttCanvas.js">
  </script>
  <style type="text/css">
   canvas {display:block;margin:0 auto; margin-top:100px; }
   .feedback { text-align:center; margin-top:25px; }
  </style>
</head>
<body onload="initBoard();">

<?php
 
require '../../../menu.php';

?>

<div id="content">
<canvas id="tttboard" width="300" height="300">
Your browser doesn't display the canvas tag (try Firefox or Safari web browsers) 
</canvas>

<div id="result" class="feedback">
</div>
</div>



</body>
</html>
