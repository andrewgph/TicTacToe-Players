package com.priddle_higson.scala.tictactoe

import com.priddle_higson.scala.tictactoe.Player.Player

object Board {
  type Square = Pair[Int, Int]

  def squareInBoard(square : Board.Square) : Boolean = square match {
    case (x, y) => (1 to 3 contains x) && (1 to 3 contains y)
    case _ => false
  }
}

class Board(board: Map[Board.Square, Player]) {

  import Board._

  def this() = {
    this(Map[Board.Square, Player]())
  }

  def getFreeSquares() : List[Board.Square] = {
    (for (x <- 1 to 3; y <- 1 to 3) yield (x,y)).foldRight(List[Board.Square]())((s, ls) => {
      if (isSquareFree(s)) {
        s :: ls
      } else {
        ls
      }
    })
  }

  def isSquareFree(square : Board.Square) : Boolean = {
    (board get square) == None
  }

  def makeMove(square : Board.Square, player : Player) : Board = {
    if (!squareInBoard(square)) {
      throw new IllegalArgumentException("Square $square needs to be in range (1,1) to (3,3).")
    }
    if (!isSquareFree(square)) {
      throw new Exception(s"Square $square not empty.")
    }
    new Board(board + (square -> player))
  }

  def isTerminal() : Boolean = {
    hasWinner != None || !hasEmptySpaces
  }

  private def hasEmptySpaces : Boolean = {
    (for (x <- 1 to 3; y <- 1 to 3) yield (x,y)).filter((square) => isSquareFree(square)).length > 0
  }

  def hasWinner() : Option[Player] = {
    checkLines(getRows ++ getDiagonals ++ getColumns)
  }

  private def checkLines(lines : List[List[Board.Square]]) : Option[Player] = {
    lines.filter((line) => {
      !isSquareFree(line(0)) &&
        ((board get line(0)) == (board get line(1))) && ((board get line(0)) == (board get line(2)))
    }).map((line) => {
      board(line(0))
    }).headOption
  }

  private def getRows() : List[List[Board.Square]] = {
    (1 to 3).foldRight(List[List[Board.Square]]())((y, lss) => {
      (1 to 3).foldRight(List[Board.Square]())((x, ls) => {
        (x, y) :: ls
      }) :: lss
    })
  }

  private def getDiagonals() : List[List[Board.Square]] = {
    List(List((1, 1), (2, 2), (3, 3)), List((3, 1), (2, 2), (1, 3)))
  }

  private def getColumns() : List[List[Board.Square]] = {
    (1 to 3).foldRight(List[List[Board.Square]]())((x, lss) => {
      (1 to 3).foldRight(List[Board.Square]())((y, ls) => {
        (x, y) :: ls
      }) :: lss
    })
  }

  override def toString() : String = {
    (1 to 3).map((x) => {
      (1 to 3).map((y) => {
        if (isSquareFree((x, y))) {
          " "
        } else {
          board((x,y)).toString
        }
      }).mkString("|").concat("\n")
    }).mkString("------\n")
  }
}