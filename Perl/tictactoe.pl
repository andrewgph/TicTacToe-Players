#!/usr/bin/perl

# File: tictactoe.pl
# Author: Andrew Priddle-Higson

my $gamestate = "---------";

#$teststate="x--------";
#$teststate="oxx--xo-o";
#$teststate="xxxo-o---";
#$teststate="xoooxxxxo";
#$teststate="xoxxo--o-";
#$teststate="xxooox-xo";
#$teststate="xxoox-x-o";
#$teststate="xxooxxxoo";

#@nexts = nextstates($teststate,'o');

#print "@nexts \n";
#print minimax($teststate,-2,2)."\n";
#print makeMove($teststate)."\n";

#exit;

print "The squares are numbered 1 to 9, from left to right and top to bottom\n";
print "An empty square is denoted by '-'\n";

while(evalstate($gamestate) == 2) {
    show($gamestate);
    $gamestate = getMove($gamestate);
    my ($score) = evalstate($gamestate);
    if (!($score == 2)) {
	break;
    }
    else {
	$gamestate = makeMove($gamestate);
    }
}

show($gamestate);
showResult($gamestate);

sub minimax {
    my ($currstate) = $_[0];
    my ($result) = evalstate($currstate);
    if (!($result == 2)) {
	return $result;
    }
    else {
	my ($alpha) = $_[1];
	my ($beta) = $_[2];
	my ($state);
	my ($temp);
	my ($v);
	if (maxplayer($currstate)) {
	    $v = -2;
	    foreach $state (nextstates($currstate,"x")) {
		$temp = minimax($state,$alpha,$beta);
		if ($temp > $v) {
		    $v = $temp;
		}
		if ($v >= $beta) {
		    return $v;
		}
		if ($v > $alpha) {
		    $alpha = $v;
		}
	    }
	    return $v;
	}
	else {
	    $v = 2;
	    foreach $state (nextstates($currstate,"o")) {
		$temp = minimax($state,$alpha,$beta);
		if ($temp < $v) {
		    $v = $temp;
		}
		if ($v <= $alpha) {
		    return $v;
		}
		if ($v < $beta) {
		    $beta = $v;
		}
	    }
	    return $v;
	}
    }
	
}

sub evalstate {
    # If x wins return 1, o wins return -1, draw return 0, and if still playing return 2.
    my ($currstate) = $_[0];
    my (@cols) = getcols($currstate);
    my (@diags) = getdiags($currstate);
    my (@lines) = getrows($currstate);
    my $draw = 'true';
    foreach $line (@cols) {
	push(@lines,$line);
    }
    foreach $line (@diags) {
	push(@lines,$line);
    }
    foreach $line (@lines) {
	my ($linescore) = checkline($line);
	if($linescore == 1) {
	    return 1;
	}
	elsif($linescore == -1) {
	    return -1;
	}
	elsif($linescore == 2) {
	    $draw = '';
	}
    }
    if($draw) {
	return 0;
    }
    else {
	return 2;
    }
}

sub nextstates {
    # get the nextstates states
    my ($currstate) = $_[0];
    my ($player) = $_[1];
    my (@nexts) = ();
    for($i = 0; $i < 9; $i++) {
	if(substr($currstate,$i,1) eq '-') {
	    push(@nexts,substr($currstate,0,$i).$player.substr($currstate,$i+1)); # could create an error if $i+1 > 8.
	}
    }
    return @nexts;
}

sub checkline {
    # check a line to see if it is winning
    # return 1 for x win, -1 for a o win, 0 for a full line and 2 for a line with space
    my ($line) = $_[0];
    if($line =~ /.*-.*/) {
	return 2;
    }
    elsif((substr($line,0,1) eq substr($line,1,1)) 
	  && (substr($line,1,1) eq substr($line,2,1))) {
	if(substr($line,0,1) eq 'x'){
	    return 1;
	}
	elsif(substr($line,0,1) eq 'o') {
	    return -1;
	}
	else {
	    return 0;
	}
    }
    return 0;
}

sub getrows {
    my ($currstate) = $_[0];
    my (@rows) = (substr($currstate,0,3),substr($currstate,3,3),substr($currstate,6,3));
    return @rows;
}

sub getcols {
    my ($currstate) = $_[0];
    my (@ix) = (0,3,6);
    for ($i = 0; $i <= 2; $i++) {
	@cols[$i] = substr($currstate,@ix[0]+$i,1).substr($currstate,@ix[1]+$i,1).substr($currstate,@ix[2]+$i,1);
    }
    return @cols;
}

sub getdiags {
    my ($currstate) = $_[0];
    my (@diags) = (substr($currstate,0,1).substr($currstate,4,1).substr($currstate,8,1),
		   substr($currstate,2,1).substr($currstate,4,1).substr($currstate,6,1));
    return @diags;
}

sub maxplayer {
    my ($currstate) = $_[0];
    $currstate =~ s/-//g;
    return ((length($currstate) % 2) == 0);
}

sub show {
    # displays the current state
    my ($currstate) = $_[0];
    print substr($currstate,0,3)."\n";
    print substr($currstate,3,3)."\n";
    print substr($currstate,6,3)."\n";
}

sub getMove {
    # gets a move from the player
    my ($currstate) = $_[0];
    print "Move [1-9]:";
    my ($move);
    $move = <STDIN>;
    chomp($move);
    if(validMove($currstate,$move)) {
	return (substr($currstate,0,$move-1).'x'.substr($currstate,$move));
    }
    else {
	print "Please enter a valid move\n";
	getMove($currstate);
    }
    return $currstate;
}

sub validMove {
    my ($currstate) = $_[0];
    my ($move) = $_[1];
    --$move;
    if((substr($currstate,$move,1) eq '-') && ($move >= 0) && ($move <= 8)) {
	return 'true';
    }
    else {
	return '';
    }
}

sub makeMove {
    my ($currstate) = $_[0];
    my ($max) = 2;
    my ($temp);
    my ($next);
    foreach $state (nextstates($currstate,'o')) {
	$temp = minimax($state,-2,2);
	if($temp < $max) {
	    $next = $state;
	    $max = $temp;
	}
    }
    return $next;
}

sub showResult {
    # displays a message to the player when the game is over.
    my ($currstate) = $_[0];
    my ($result) = evalstate($currstate);
    if($result == 0) {
	print "A draw ... how dull.\n";
    }
    elsif($result == 1) {
	print "You have won (you shouldn't be seeing this)\n";
    }
    elsif($result == -1) {
	print "You have lost\n";
    }
    else {
	print "Wow, what happened?";
    }
    print "Game Over, thanks for playing!\n";
}
