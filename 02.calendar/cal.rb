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
Week = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
puts Week.join(" ")

# 該当月の1日にマッチする曜日を見つける
w = 0
not_found = true
while not_found
  if (Date.new(year, month, 1).wday == w)
    print " 1 "
    not_found = false
  else
    print "   "
  end
  
  # 曜日を計算
  w += 1

  # 土曜なら改行
  puts "" if (w == 7)
end

# 2日から月末まで表示
last = Date.new(year, month, -1)
(2..last.day).each do |d|
  print "#{d} ".rjust(3);

  # 土曜なら改行
  puts "" if (Date.new(year, month, d).saturday?)
end
puts ""