#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def retrieve_files(options)
  files = Dir.entries('.').reject { |file| file[0] == '.' }.sort
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
  opt.on('-r') { |v| options[:r] = v }
  opt.parse(ARGV)

  files = retrieve_files(options)

  width = 3

  formatted_files = format_files(files, width)
  output(formatted_files)
end

main
