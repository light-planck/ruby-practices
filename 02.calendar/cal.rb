#!/usr/bin/env ruby

require 'date'
require 'optparse'

opt = OptionParser.new
options = {}
opt.on("-y [OPTIONAL]") {|v| options[:y] = v}
opt.on("-m [OPTIONAL]") {|v| options[:m] = v}
opt.parse(ARGV)

today = Date.today
year = today.year
month = today.month
day = today.day

# 引数で受け取った値をセット
unless options[:y].nil?
  year = options[:y].to_i
end
unless options[:m].nil?
  month = options[:m].to_i
end

puts "     #{Date.new(year, month, day).strftime("%B")} #{year}"
WEEK = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
puts WEEK.join(" ")

# 該当月の1日まで空白を出力1
print "   " * (Date.new(year, month, 1).wday)

# 2日から月末まで表示
((Date.new(year, month, 1))..(Date.new(year, month, -1))).each do |date|
  print "#{date.day} ".rjust(3);

  # 土曜なら改行
  puts if (date.saturday?)
end
puts 
