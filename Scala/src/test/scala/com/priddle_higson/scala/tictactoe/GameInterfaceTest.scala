package com.priddle_higson.scala.tictactoe

import org.scalatest.{Matchers, FlatSpec}

class GameInterfaceTest extends FlatSpec with Matchers {

  "GameInterface.isValidInput" should "return false for invalid moves" in {
    val game = new TicTacToe()
    GameInterface.isValidInput(game, Array()) should be(false)
    GameInterface.isValidInput(game, Array("1")) should be(false)
    GameInterface.isValidInput(game, Array("1", "1", "1")) should be(false)
    GameInterface.isValidInput(game, Array("test", "test")) should be(false)
    GameInterface.isValidInput(game, Array("-1", "1")) should be(false)
    GameInterface.isValidInput(game, Array("4", "3")) should be(false)
  }

  "GameInterface.isValidInput" should "return true for valid moves" in {
    val game = new TicTacToe()
    GameInterface.isValidInput(game, Array("1", "1")) should be (true)
    GameInterface.isValidInput(game, Array("3", "3")) should be (true)
  }

}
