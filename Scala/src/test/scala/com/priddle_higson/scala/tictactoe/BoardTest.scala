package com.priddle_higson.scala.tictactoe

import org.scalatest.{Matchers, FlatSpec}

class BoardTest extends FlatSpec with Matchers {

  val allSquares = for (x <- 1 to 3; y <- 1 to 3) yield (x,y)
  val fullBoardMap = allSquares.map((s) => s -> Player.Cross).toMap
  val drawnBoardMap = Map((1,1) -> Player.Nought, (1,2) -> Player.Cross, (1,3) -> Player.Nought,
    (2,1) -> Player.Nought, (2,2) -> Player.Cross, (2,3) -> Player.Cross,
    (3,1) -> Player.Cross, (3,2) -> Player.Nought, (3,3) -> Player.Cross)

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
    val board = new Board(drawnBoardMap)
    board.isTerminal() should be (true)
  }

  "A Board" should "return Player.Cross on hasWinner for a board full of crosses" in {
    val board = new Board(fullBoardMap)
    board.hasWinner().get should be (Player.Cross)
  }

  "A Board" should "return None on hasWinner for a drawn board" in {
    val board = new Board(drawnBoardMap)
    board.hasWinner() should be (None)
  }

  "A Board" should "return None on hasWinner for an empty board" in {
    val board = new Board()
    board.hasWinner() should be (None)
  }

  "A Board" should "return Player.Cross on hasWinner for a board with a row win" in {
    val board = new Board(Map((1,1) -> Player.Cross, (1,2) -> Player.Cross, (1,3) -> Player.Cross))
    board.hasWinner().get should be (Player.Cross)
  }

  "A Board" should "return Player.Cross on hasWinner for a board with a column win" in {
    val board = new Board(Map((1,1) -> Player.Cross, (2,1) -> Player.Cross, (3,1) -> Player.Cross))
    board.hasWinner().get should be (Player.Cross)
  }

  "A Board" should "return Player.Cross on hasWinner for a board with a diagonal win" in {
    val board = new Board(Map((1,1) -> Player.Cross, (2,2) -> Player.Cross, (3,3) -> Player.Cross))
    board.hasWinner().get should be (Player.Cross)
  }
}
