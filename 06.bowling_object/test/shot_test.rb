# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/shot'

class ShotTest < Minitest::Test
  def test_shot
    assert_raises(RuntimeError) { Shot.new(11) }
    assert_raises(RuntimeError) { Shot.new(-1) }

    shot = Shot.new(0)
    assert_equal 0, shot.value

    shot2 = Shot.new(10)
    assert_equal 10, shot2.value
  end
end
