# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/shot'

class ShotTest < Minitest::Test
  def test_shot
    assert_equal 0, Shot.new('0').score
    assert_equal 10, Shot.new('X').score

    assert_raises(RuntimeError) { Shot.new(5) }
    assert_raises(RuntimeError) { Shot.new('11') }
    assert_raises(RuntimeError) { Shot.new(-1) }
    assert_raises(RuntimeError) { Shot.new('x') }
  end
end
