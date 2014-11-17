package com.priddle_higson.scala.tictactoe

import com.priddle_higson.scala.tictactoe.Player.Player

object TicTacToe {
  val humanPlayer = Player.Cross
  val computerPlayer = Player.Nought

  def minEvaluationValue : Double = -1.0

  def maxEvaluationValue : Double = 1.0

  def nextPlayer(player : Player) : Player = player match {
    case Player.Cross => Player.Nought
    case Player.Nought => Player.Cross
  }

  /**
   * Cross X is the max player
   * Nought O is the min player
   */
  def isMaxPlayer(player : Player) : Boolean = player match {
    case Player.Cross => true
    case Player.Nought => false
  }

  def playerValue(player : Player) : Double = {
    if (isMaxPlayer(player)) {
      maxEvaluationValue
    } else {
      minEvaluationValue
    }
  }
}

class TicTacToe(currentPlayer : Player, board : Board) extends AlphaBetaGame[TicTacToe] {

  import TicTacToe._

  def this() = {
    this(TicTacToe.humanPlayer, new Board)
  }

  def isHumanPlayerTurn : Boolean = {
    currentPlayer == humanPlayer
  }

  def getSelf : TicTacToe = this

  def minEvaluationValue : Double = TicTacToe.minEvaluationValue

  def maxEvaluationValue : Double = TicTacToe.maxEvaluationValue

  def isMaxTurn : Boolean = isMaxPlayer(currentPlayer)

  def isTerminal : Boolean = {
    board.isTerminal
  }

  def getWinner : Option[Player] = {
    if (!isTerminal) {
      throw new Exception(s"Game has not finished yet: $this")
    }
    board.hasWinner
  }

  def evaluation: Double = {
    val winner = board.hasWinner()
    winner match {
      case Some(player) => playerValue(player)
      case None => 0
    }
  }

  /**
   * Get the next possible games for either player
   */
  def nextGames: Seq[TicTacToe] = {
    board.getFreeSquares().map((square) =>
      new TicTacToe(nextPlayer(currentPlayer), board.makeMove(square, currentPlayer)))
  }

  def makeComputerMove() : TicTacToe = {
    if (currentPlayer != computerPlayer) {
      throw new Exception(s"current player $currentPlayer is not the computer player: $this")
    }
    minimax
  }

  def makeHumanMove(square : Board.Square) : TicTacToe = {
    if (!isHumanPlayerTurn) {
      throw new Exception(s"current player $currentPlayer is not the human player: $this")
    }
    if (!isValidMove(square)) {
      throw new Exception(s"Square $square is not a valid move: $this")
    }
    new TicTacToe(nextPlayer(currentPlayer), board.makeMove(square, currentPlayer))
  }

  def isValidMove(square : Board.Square) : Boolean = {
    Board.squareInBoard(square) && board.isSquareFree(square)
  }

  override def toString() : String = {
    s"Current Player : $currentPlayer\n$board\n"
  }
}
