package com.priddle_higson.scala.tictactoe

trait AlphaBetaGame[Self <: AlphaBetaGame[Self]] {

  def isTerminal : Boolean

  def minEvaluationValue : Double

  def maxEvaluationValue : Double

  def evaluation : Double

  def nextGames : Seq[Self]

  def isMaxTurn : Boolean

  def getSelf : Self

  /**
   * nextGame should be set to Some(game). If it's None, we intentionally throw an Exception here.
   */
  def minimax() : Self = {
    if (isMaxTurn) {
      val (_, nextGame) = maxValue(minEvaluationValue, maxEvaluationValue)
      nextGame.get
    } else {
      val (_, nextGame) = minValue(minEvaluationValue, maxEvaluationValue)
      nextGame.get
    }
  }

  def maxValue(alpha_ : Double, beta : Double) : (Double, Option[Self]) = {
    if (isTerminal) {
      return (evaluation, Some(getSelf))
    }
    var alpha = alpha_
    var v = minEvaluationValue
    var bestGame : Option[Self] = None
    for (game <- nextGames) {
      val (min, _) = game.minValue(alpha, beta)
      if (v < min) {
        v = min
        bestGame = Some(game)
      }
      if (v >= beta) {
        return (v, bestGame)
      }
      if (v > alpha) {
        alpha = v
      }
    }
    (v, bestGame)
  }

  def minValue(alpha : Double, beta_ : Double) : (Double, Option[Self]) = {
    if (isTerminal) {
      return (evaluation, Some(getSelf))
    }
    var beta = beta_
    var v = maxEvaluationValue
    var bestGame : Option[Self] = None
    for (game <- nextGames) {
      val (max, _) = game.maxValue(alpha, beta)
      if (v > max) {
        v = max
        bestGame = Some(game)
      }
      if (v <= alpha) {
        return (v, bestGame)
      }
      if (v > beta) {
        beta = v
      }
    }
    (v, bestGame)
  }

}
