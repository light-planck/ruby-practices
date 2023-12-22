# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    raise if !mark.is_a?(String) || mark.size != 1
    raise if mark != 'X' && mark !~ /\A[0-9]\z/

    @mark = mark
  end

  def score
    mark == 'X' ? 10 : mark.to_i
  end
end
