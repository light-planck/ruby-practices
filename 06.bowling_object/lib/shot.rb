# frozen_string_literal: true

class Shot
  attr_reader :value

  def initialize(value)
    raise 'Value must be between 0 and 10' if !(0..10).cover?(value)

    @value = value
  end
end
