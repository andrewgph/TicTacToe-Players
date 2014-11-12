package com.priddle_higson.scala.tictactoe

import org.scalatest.{Matchers, FlatSpec}

class BoardTest extends FlatSpec with Matchers {

  val allSquares = for (x <- 1 to 3; y <- 1 to 3) yield (x,y)
  val fullBoardMap = allSquares.map((s) => s -> Player.Cross).toMap

  "A Board" should "return all squares from getFreeSquares for or an empty board" in {
    val board = new Board()
    val expectedSquares = allSquares
    board.getFreeSquares() diff expectedSquares should be (Nil)
    expectedSquares diff board.getFreeSquares() should be (Nil)
  }

  "A Board" should "return expected squares from getFreeSquares for a board with one play on it" in {
    val board = new Board(Map((1,1) -> Player.Cross))
    val expectedSquares = allSquares diff List((1,1))
    board.getFreeSquares() diff expectedSquares should be (Nil)
    expectedSquares diff board.getFreeSquares() should be (Nil)
  }

  "A Board" should "return no squares from getFreeSquares for a full board" in {
    val board = new Board(fullBoardMap)
    board.getFreeSquares() should be (Nil)
  }

  "A Board" should "return squareInBoard for only squares in (1,1) to (3,3) range" in {
    allSquares.map((square) => {
      Board.squareInBoard(square) should be (true)
    })

    val outsideSquares = (for (x <- -1 to 5; y <- -1 to 5) yield (x,y)) diff allSquares
    outsideSquares.map((square) => {
      Board.squareInBoard(square) should be (false)
    })
  }

  "A Board" should "allow makeMove for a valid move" in {
    val board = new Board()
    val newBoard = board.makeMove((1,1), Player.Cross)
    val expectedSquares = allSquares diff List((1,1))

    newBoard.getFreeSquares() diff expectedSquares should be (Nil)
    expectedSquares diff newBoard.getFreeSquares() should be (Nil)
  }

  "A Board" should "throw exception on makeMove for an invalid move" in {
    val board = new Board(fullBoardMap)
    intercept[Exception] {
      board.makeMove((1, 1), Player.Cross)
    }

    intercept[Exception] {
      board.makeMove((-1, 5), Player.Cross)
    }
  }

  "A Board" should "return isTerminal false for an empty board" in {
    val board = new Board()
    board.isTerminal() should be (false)
  }

  "A Board" should "return isTerminal true for a full board" in {
    val board = new Board(fullBoardMap)
    board.isTerminal() should be (true)
  }



}
