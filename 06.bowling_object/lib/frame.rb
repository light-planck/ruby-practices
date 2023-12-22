# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(marks)
    raise 'Frame must have between 1 - 3 shots' if marks.empty? || marks.size > 3

    @shots = marks.map { |mark| Shot.new(mark) }
  end

  def score
    @shots.sum(&:score)
  end
end
