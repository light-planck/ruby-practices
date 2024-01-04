# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'

class GameTest < Minitest::Test
  RESULTS_AND_SCORES = [
    ['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5', 139],
    ['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X', 164],
    ['0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4', 107],
    ['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0', 134],
    ['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8', 144],
    ['X,X,X,X,X,X,X,X,X,X,X,X', 300],
    ['X,X,X,X,X,X,X,X,X,X,X,2', 292],
    ['X,0,0,X,0,0,X,0,0,X,0,0,X,0,0', 50]
  ].freeze

  RESULTS_AND_SCORES.each_with_index do |(result, score), i|
    define_method("test_game_#{i + 1}") do
      game = Game.new(result)
      game.set_frames
      assert_equal score, game.score
    end
  end
end
