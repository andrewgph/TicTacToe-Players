# tictactoe.tcl 
# A tictactoe player in Tcl

proc minimax {game a b} {
    set result [evalstate $game]
    if {$result != 2} {
	return $result
    } else {
	if {[maxplayer $game]} {
	    set v -2
	    foreach state [nextstates $game "x"] {
		set temp [minimax $state $a $b]
		if {$temp > $v} {
		    set v $temp
		}
		if {$v >= $b} {
		    return $v
		}
		if {$v > $a} {
		    set a $v
		}
	    }
	    return $v
	} else {
	    set v 2
	    foreach state [nextstates $game "o"] {
		set temp [minimax $state $a $b]
		if {$temp < $v} {
		    set v $temp 
		}
		if {$v <= $a} {
		    return $v
		}
		if {$v < $b} {
		    set b $v
		}
	    }
	    return $v
	}
    }
}

# evalstate returns
# 2 if the game is still in progress
# 1 if x has won
# -1 if o has won
# 0 if there is a draw

proc evalstate {game} {
    set cols [getcols $game]
    set rows [getrows $game]
    set diags [getdiags $game]
    set lines [concat $cols $rows $diags]
    set draw 1
    foreach line $lines {
	set linescore [checkline $line]
	if {$linescore == 1} {
	    return 1
	} elseif {$linescore == -1} {
	    return -1
	} elseif {$linescore == 2} {
	    set draw 0
	}
    }
    if {$draw} {
	return 0
    } else {
	return 2
    }
}

proc nextstates {game player} {
    set nexts {}
    for {set i 0} {$i < 9} {incr i} {
	if {[lindex $game $i] == "-"} {
	    lappend nexts [lreplace $game $i $i $player]
	}
    }
    return $nexts
}

# checkline uses the same conventions as evalstate for the values it returns

proc checkline {line} {
    set cross 0
    foreach elem $line {
	if {$elem == "-"} {
	    return 2;
	} elseif {$elem == "x"} {
	    incr cross
	}
    }
    if {$cross == 3} {
	return 1;
    } elseif {$cross == 0} {
	return -1;
    } else {
	return 0;
    }
}

proc getrows {game} {
    return [list [lrange $game 0 2] [lrange $game 3 5] [lrange $game 6 8]]
}

proc getcols {game} {
    set cols {}
    foreach i {0 1 2} {
	lappend cols [concat [lindex $game $i] [lindex $game [expr {$i + 3}]] \
			  [lindex $game [expr {$i + 6}]]]
    }
    return $cols
}

proc getdiags {game} {
    return [list [concat [lindex $game 0] [lindex $game 4] [lindex $game 8]] \
		[concat [lindex $game 2] [lindex $game 4] [lindex $game 6]]]
}

proc maxplayer {game} {
    set spaces 0
    foreach elem $game {
	if {$elem == "-"} {incr spaces}
    }
    if {[expr {$spaces % 2}] == 0} {
	return 0
    } else {
	return 1
    }
}

proc show {game} {
    puts [lrange $game 0 2]
    puts [lrange $game 3 5]
    puts [lrange $game 6 8]
}

proc getmove {game} {
    puts {Move [1-9]:}
    set move [gets stdin]
    incr move -1
    if {[lindex $game $move] == "-"} {
	return [lreplace $game $move $move "x"]
    } else {
	puts "That was not a valid move!"
	puts "Please try again."
	getmove $game
    }
}

proc makemove {game} {
    set max 2
    foreach state [nextstates $game "o"] {
	set temp [minimax $state -2 2]
	if {$temp < $max} {
	    set next $state
	    set max $temp
	}
    }
    return $next
}

proc showresult {game} {
    set result [evalstate $game]
    if {$result == 0} {
	puts "A draw ... how dull"
    } elseif {$result == 1} {
	puts "You have won"
    } elseif {$result == -1} {
	puts "You have lost"
    } else {
	puts "Unknown error"
    }
    puts "Game Over, thanks for playing!"
}

puts "The squares are numbered 1 to 9, from left to right and top to bottom"
puts "An empty square is denoted by '-'"

set gamestate {- - - - - - - - -}

while {[evalstate $gamestate] == 2} {
    show $gamestate
    set gamestate [getmove $gamestate];
    set score [evalstate $gamestate];
    if {$score != 2} {
	break
    } else {
	set gamestate [makemove $gamestate]
    }
}

show $gamestate
showresult $gamestate