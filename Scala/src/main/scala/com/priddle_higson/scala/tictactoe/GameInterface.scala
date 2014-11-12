package com.priddle_higson.scala.tictactoe

import com.priddle_higson.scala.tictactoe.Player.Player

object GameInterface {
  def main(args: Array[String]) {
    println("Starting new TicTacToe game")
    val game = new TicTacToe()
    gameLoop(game)
  }

  def gameLoop(game : TicTacToe) : Unit = {
    println(s"$game")
    if (game.isTerminal) {
      game.getWinner match {
        case Some(player : Player) => println(s"Player $player won")
        case None => println("Game drawn")
      }
      return
    } else if(game.isHumanPlayerTurn) {
      gameLoop(game.makeHumanMove(getPlayerMove(game)))
    } else {
      gameLoop(game.makeComputerMove())
    }
  }

  def getPlayerMove(game : TicTacToe) : Board.Square = {
    println("Enter your move as a coordinate pair (such as \"1,1\"):")
    val line = Console.readLine()
    val pairList = line.replaceAll("\\s", "").split(',')
    if(isValidInput(game, pairList)) {
      return (pairList(0).toInt, pairList(1).toInt)
    } else {
      println("Not a valid move. Please try again.")
      getPlayerMove(game)
    }
  }

  def isValidInput(game : TicTacToe, pairList : Array[String]) : Boolean = {
    if (pairList.length != 2) return false

    val x = pairList(0)
    val y = pairList(1)

    // Check for valid numbers in the pair
    if (!x.forall(_.isDigit) || !y.forall(_.isDigit)) return false

    game.isValidMove((x.toInt, y.toInt))
  }

}
