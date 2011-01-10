#!/usr/bin/env bash
# tictactoe.sh: TicTacToe player
# Author: Andrew Priddle-Higson
# License: GPL3 

# This is a tictactoe player, using alphabeta game search, written in bash.
#
# The tictactoe board is represented as a 9 character string.
# The state of each square on the board is stored as a character in this string.
# Squares are numbered from left to right top to down.
# Squares can be either 'x', 'o' (representing crosses and noughts respectively) 
# or '-' representing an empty square.
#
# There are two important variables: 
# 1. $state represents the state of the current game board.
#    This variable is not used by the minimax function.
#
# 2. $player is used by the minimax auxilliary functions to determine the current player.
#
# The game is played via the console.
# The human player is set to play 'x' and the computer plays 'o'
# 'x' always plays first.
#
#
# Interesting features (that might just be clumsy bash style):
# - Use of result=$? to get the return value of a function
# - Use of `func` to get the output of a function
# - Sed and bash string manipulation to alter and test board state
#
# Summary of experience of writing tictactoe in bash:
# I found it hard to write this, as there are not many features in bash for
# abstraction and getting functions to do useful computation without altering 
# a global state is clumsy.
# The code is likely to be buggy, e.g. I use the same temporary variable
# name in different functions. If I have forgotten to set the variable, but use
# it anyway, then there could be a bug.
# In conclusion, writing 20 line shell scripts is ok, but anything longer is messy.
# To be fair this is not the kind of programming bash was intended for, but this 
# was a fun exercise in demonstrating turing completeness of programming languages.


# Variable scope problems with recursive call to minimax
function minimax 
{
    local currstate=$1
    evalstate $currstate
    local result=$?
    if [[ $result < 3 ]]; then
	return $result
    else
	local alpha=$2
	local beta=$3
	maxplayer $1
	if [ $? -eq 0 ]; then # if maxplayer function returns 0, it is max's turn
	    local v=0
	    for s in `next $currstate "x"`; do
		minimax $s $alpha $beta
		local temp=$?
		if [[ $temp > $v ]]; then
		    v=$temp
		fi
		if (( $v >= $beta )); then
		    return $v
		fi
		if [[ $v > $alpha ]]; then
		    alpha=$v
		fi
	    done
	    return $v
	else
	    local v=2
	    for s in `next $currstate "o"`; do
		minimax $s $alpha $beta
		local temp=$?
		if [[ $temp < $v ]]; then
		    v=$temp
		fi
		if (( $v <= $alpha )); then
		    return $v
		fi
		if [[ $v < $beta ]]; then
		    beta=$v
		fi
	    done
	    return $v
	fi
    fi
}

function evalstate 
{
  # If x wins return 1, o wins return -1, draw return 0, and if still playing return 3.
  for row in `rows $1`; do
      checkline $row
      result=$?
      if [ ! $result -eq 1 ]; then
	  return $result
      fi
  done
  for diag in `diags $1`; do
      checkline $diag
      result=$?
      if [ ! $result -eq 1 ]; then
	  return $result
      fi
  done
  for col in `cols $1`; do
      checkline $col
      result=$?
      if [ ! $result -eq 1 ]; then
	  return $result
      fi
  done
  empty=`echo $1 | sed -e 's/[xo]//g'`
  if [ ${#empty} -eq 0 ]; then
      return 1
  else
      return 4
  fi


}

function checkline 
{
    line=$1
    if [[ ${line:0:1} == ${line:1:1} && ${line:1:1} == ${line:2:1} ]]; then
	case ${line:0:1} in
	    "x") return 2 ;;
	    "o") return 0 ;;
	    "-") return 1 ;;
	esac
    fi
    return 1
}

function rows
{
    temp=$1
    echo ${temp:0:3}
    echo ${temp:3:3}
    echo ${temp:6:3}
}

function cols
{
    temp=$1
    echo "${temp:0:1}${temp:3:1}${temp:6:1}"
    echo "${temp:1:1}${temp:4:1}${temp:7:1}"
    echo "${temp:2:1}${temp:5:1}${temp:8:1}"
}

function diags
{
    temp=$1
    echo "${temp:0:1}${temp:4:1}${temp:8:1}"
    echo "${temp:2:1}${temp:4:1}${temp:6:1}"
}

# Check that the string has got an odd number of '-'s 
function maxplayer
{
    free=`echo $1 | sed -e 's/[xo]//g'`
    if [ `expr ${#free} % 2` -eq 1 ]; then
	return 0
    else 
	return 1
    fi
}					

function next
{
    player=$2
    temp=$1
    for i in `seq 0 8`; do
	if [ ${temp:$i:1} = "-" ]; then
	    rest=`expr $i + 1`
	    echo "${temp:0:$i}$player${temp:$rest}"
	fi
    done
}

function show
{
    s=$1
    echo ${s:0:3}
    echo ${s:3:3}
    echo ${s:6:3}
}

function getMove
{
    echo "Please enter a move, positions are denoted 1-9 (reading left to right)"
    read move
    move=`expr $move - 1`
    if (($move >= 0)) && (($move <= 8)); then
	if [ ${state:$move:1} = "-" ]; then
	    rest=`expr $move + 1`
	    state="${state:0:$move}x${state:$rest}"
	else
	    echo "not a valid move, please try again."
	    getMove
	fi
    else 
	echo "Please enter an integer between 1 and 9 (inclusive)"
	getMove
    fi
}

function makeMove
{
    local min=2
    for i in `seq 0 8`; do
	if [ ${state:$i:1} = "-" ]; then
	    local rest=`expr $i + 1`
	    local succ="${state:0:$i}o${state:$rest}"
	    minimax $succ 0 2
	    local result=$?
	    if (( $result <= $min )); then
		min=$result
		next=$succ
	    fi
	fi
    done
    state=$next
}

function showResult
{
    evalstate $state
    case $? in
	2) echo "You have won" ;;
	0) echo "You have lost" ;;
	1) echo "A draw ... how dull" ;;
    esac

}

# Some test cases 
#teststate="x--------"
#teststate="oxx--xo-o"
#teststate="xxxo-o---"
#teststate="xoooxxxxo"
#teststate="xoxxo--o-"
#teststate="xxooox-xo"
#teststate="xxoox-x-o"
#minimax $teststate 0 2
#evalstate $teststate
#echo $?
#exit

state="---------"

while [ true ]
do
    show $state
    getMove
    evalstate $state
    if [ $? -lt 3 ]; then
	show $state
	showResult
	break
    else
	makeMove
	evalstate $state
	if [ $? -lt 3 ]; then
	    show $state
	    showResult
	    break
	fi
    fi
done

exit
