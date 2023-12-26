# frozen_string_literal: true

class Shot
  def initialize(mark)
    raise if !mark.is_a?(String)
    raise if !valid_input?(mark)

    @mark = mark
  end

  def valid_input?(str)
    str =~ /\A(X|[0-9]|10)\z/
  end

  def score
    @mark == 'X' ? 10 : @mark.to_i
  end
end
