#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

PERMISSIONS = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

TYPES = {
  '01' => 'p',
  '02' => 'c',
  '04' => 'd',
  '06' => 'b',
  '10' => '-',
  '12' => 'l',
  '14' => 's'
}.freeze

def permission(mode)
  "#{TYPES[mode[0, 2]]}#{PERMISSIONS[mode[3]]}#{PERMISSIONS[mode[4]]}#{PERMISSIONS[mode[5]]}@"
end

def calculate_long_format_length(long_format_files)
  max_length = { nlink: 0, owner: 0, group: 0, size: 0, month: 0, day: 0 }
  long_format_files.each do |file|
    max_length[:nlink] = [file[:nlink].length, max_length[:nlink]].max
    max_length[:owner] = [file[:owner].length, max_length[:owner]].max
    max_length[:group] = [file[:group].length, max_length[:group]].max
    max_length[:size] = [file[:size].length, max_length[:size]].max
    max_length[:month] = [file[:month].length, max_length[:month]].max
    max_length[:day] = [file[:day].length, max_length[:day]].max
  end
  max_length
end

def padding(max_length, file, sym, bias)
  ' ' * (max_length[sym].to_i - file[sym].length.to_i + bias)
end

def output_long_format_file(long_format_files)
  max_length = calculate_long_format_length(long_format_files)

  puts "total #{long_format_files.sum { |file| file[:blocks] }}"
  long_format_files.each do |file|
    print file[:permission]
    print padding(max_length, file, :nlink, 1) + file[:nlink]
    print padding(max_length, file, :owner, 1) + file[:owner]
    print padding(max_length, file, :group, 2) + file[:group]
    print padding(max_length, file, :size, 2) + file[:size]
    print padding(max_length, file, :month, 2) + file[:month]
    print padding(max_length, file, :day, 1) + file[:day]
    print " #{file[:time]}"
    print " #{file[:file]}"
    puts
  end
end

def retrieve_files(options)
  files = Dir.entries('.').select { |file| options[:a] || !file.start_with?('.') }.sort.map do |file|
    fs = File.lstat("./#{file}")

    {
      blocks: fs.blocks,
      permission: permission(fs.mode.to_s(8).rjust(6, '0')),
      nlink: fs.nlink.to_s,
      owner: Etc.getpwuid(fs.uid).name,
      group: Etc.getgrgid(fs.gid).name,
      size: fs.size.to_s,
      month: fs.mtime.month.to_s,
      day: fs.mtime.day.to_s,
      time: "#{format('%02d', fs.mtime.hour)}:#{format('%02d', fs.mtime.sec)}",
      file: File.symlink?(file) ? "#{file} -> #{File.readlink(file)}" : file
    }
  end

  files.reverse! if options[:r]
  files
end

def format_files(files, width)
  formatted_width = [(files.size + width - 1) / width, 1].max

  formatted = [[]]
  files.each do |file|
    if formatted.last.size < formatted_width
      formatted.last << file
    else
      formatted << [file]
    end
  end

  # 転置するときの整合性を取るために空文字列を入れる
  if formatted.last.size < formatted_width
    (formatted_width - formatted.last.size).times do
      formatted.last << ''
    end
  end

  formatted.transpose
end

def calculate_max_file_length(files)
  lengths = []
  files.each do |row|
    row.each do |file|
      lengths << file.size
    end
  end
  lengths.max
end

def output(files)
  max_file_name_length = calculate_max_file_length(files)

  files.each do |row|
    row.each do |file|
      break if file == ''

      spaces = max_file_name_length - file.size + 2
      print file + ' ' * spaces
    end
    puts
  end
end

def main
  opt = OptionParser.new
  options = {}
  opt.on('-a') { |v| options[:a] = v }
  opt.on('-r') { |v| options[:r] = v }
  opt.on('-l') { |v| options[:l] = v }
  opt.parse(ARGV)

  files = retrieve_files(options)

  if options[:l]
    output_long_format_file(files)
    exit
  end

  width = 3
  formatted_files = format_files(files.map { |file| file[:file] }, width)
  output(formatted_files)
end

main
