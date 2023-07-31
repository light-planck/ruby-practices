#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数をとる
score = ARGV[0]

# 1投毎に分割する
scores = score.split(',')

# 数字に変換
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

# フレーム毎に分割
frames = []

FRAME = 10
(0...FRAME * 2).step(2).each do |i|
  frames << if i < (FRAME - 1) * 2
              [shots[i], shots[i + 1]]
            else
              shots[(i..)]
            end
end
frames.last.delete_if(&:zero?) if frames.last.size > 3

point = 0
frames.each_with_index do |frame, i|
  point += frame.sum

  break if i == frames.size - 1

  # ストライク
  if frame.first == 10
    point += frames[i + 1].first

    if frames[i + 1][1] > 0
      point += frames[i + 1][1]
    else
      

  # スペア
  elsif frame.sum == 10
    point += frames[i + 1].first
  end
end

puts point
