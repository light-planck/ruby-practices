#!/usr/bin/env ruby
# frozen_string_literal: true

def retrieve_files
  files = []
  Dir.entries('.').each do |file|
    next if ['.', '..'].include?(file)
    next if file[0] == '.'

    files << file
  end
  files.sort!
end

def format_files(files, height)
  formatted_width = height

  formatted = [[]]
  files.each do |file|
    next if ['.', '..'].include?(file)
    next if file[0] == '.'

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
  files = retrieve_files

  width = 3

  height = [(files.size + width - 1) / width, 1].max

  formatted_files = format_files(files, height)
  output(formatted_files)
end

main
