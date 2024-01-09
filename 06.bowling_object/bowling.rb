#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/game'

def main
  results = ARGV[0]
  game = Game.new(results)
  puts game.score
end

main
