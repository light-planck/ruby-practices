# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/frame'

class FrameTest < Minitest::Test
  def test_frame
    assert_raises { Frame.new([]) }
    assert_raises { Frame.new([1, 2, 3, 4]) }

    frame = Frame.new([0, 10])
    assert_equal [0, 10], frame.shots
  end
end
