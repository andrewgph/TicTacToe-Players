package com.priddle_higson.scala.tictactoe

object Player extends Enumeration {
  type Player = Value
  val Cross = Value("X")
  val Nought = Value("O")
}