# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    raise if mark != 'X' && !(0..9).cover?(mark.to_i)

    @mark = mark
  end

  def score
    mark == 'X' ? 10 : mark.to_i
  end
end
