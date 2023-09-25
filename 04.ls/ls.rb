#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def retrieve_files(options)
  Dir.entries('.').select { |file| options[:a] || !file[0].start_with?('.') }.sort
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
  opt.parse(ARGV)

  files = retrieve_files(options)

  width = 3

  formatted_files = format_files(files, width)
  output(formatted_files)
end

main
