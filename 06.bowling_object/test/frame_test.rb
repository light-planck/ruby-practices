# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/frame'

class FrameTest < Minitest::Test
  def test_frame
    assert_equal 0, Frame.new(%w[0]).score
    assert_equal 10, Frame.new(%w[0 X]).score
    assert_equal 30, Frame.new(%w[X X X]).score

    assert_raises { Frame.new([]) }
    assert_raises { Frame.new(%w[1 2 3 4]) }
  end
end
