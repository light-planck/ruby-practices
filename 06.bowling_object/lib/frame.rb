# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots)
    raise 'Frame must have between 1 - 3 shots' if shots.empty? || shots.size > 3

    @shots = shots
  end
end
