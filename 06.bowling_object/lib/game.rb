# frozen_string_literal: true

require_relative 'frame'

class Game
  PER_SHOTS = 2
  FRAMES = 10

  def initialize(results)
    @results = results
  end

  def prepare_frames
    splited_frames = @results.split(',').each_with_object([]) do |mark, ret|
      if mark == 'X' && ret.size < PER_SHOTS * FRAMES - 2
        ret << mark
        ret << '0'
      else
        ret << mark
      end
    end.each_slice(PER_SHOTS).to_a

    # 10フレーム目に3回投げた場合
    if splited_frames.size > FRAMES
      last = splited_frames.pop
      splited_frames[-1] << last.first
    end

    @frames = splited_frames.map do |marks|
      Frame.new(marks)
    end
  end

  def score
    raise 'Please prepare frames before calculating score.' if @frames.nil?

    @frames.each_with_index.sum do |frame, i|
      frame.score + bonus_score(frame, i)
    end
  end

  private

  def bonus_score(frame, idx)
    return 0 if idx + 1 >= FRAMES

    next_frame = @frames[idx + 1]

    if frame.strike?
      ret = next_frame.shots.first.score
      ret += if next_frame.shots.first.score < 10 || idx + 2 >= FRAMES
               next_frame.shots[1].score
             else
               @frames[idx + 2].shots.first.score
             end
      ret
    elsif frame.spare?
      next_frame.shots.first.score
    else
      0
    end
  end
end
