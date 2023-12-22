# frozen_string_literal: true

class Shot
  attr_reader :score

  def initialize(mark)
    raise if mark != 'X' && !(0..9).cover?(mark.to_i)

    @score = mark == 'X' ? 10 : mark.to_i
  end
end
