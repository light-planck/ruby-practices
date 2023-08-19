#!/usr/bin/env ruby
# frozen_string_literal: true

# 引数をとる
score = ARGV[0]

# 1投毎に分割する
scores = score.split(',')

# 数字に変換
shots = []
FRAMES = 10 # フレーム数
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0 if shots.size < 2 * FRAMES - 1
  else
    shots << s.to_i
  end
end

# フレーム毎に分割
frames = shots.each_slice(2).to_a

if frames.size > FRAMES
  frames[-2].concat(frames[-1])
  frames.slice!(FRAMES)
end

point = 0

frames.each_with_index do |frame, i|
  point += frame.sum

  break if i + 1 >= FRAMES

  next_frame = frames[i + 1]

  # ストライク
  if frame.first == 10
    point += next_frame.first

    point += if next_frame.first < 10 || i + 2 >= FRAMES
               next_frame[1]
             else
               frames[i + 2].first
             end

  # スペア
  elsif frame.sum == 10
    point += next_frame.first
  end
end

puts point
