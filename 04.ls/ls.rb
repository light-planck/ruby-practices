#!/usr/bin/env ruby
# frozen_string_literal: true

def calculate_max_file_length
  lengths = []
  Dir.entries('.').each do |file|
    lengths << file.size
  end
  lengths.max + 2
end

def get_files(width)
  files = [[]]
  Dir.entries('.').each do |file|
    next if ['.', '..'].include?(file)

    if files.last.size < width
      files.last << file
    else
      files << [file]
    end
  end
  files.transpose
end

def output(files)
  files.each do |row|
    row.each do |file|
      spaces = MAX_FILE_LENGTH - file.size
      print file + ' ' * spaces
    end
    puts
  end
end

W = 3
H = [(Dir.entries('.').size - 2) / W, 1].max
MAX_FILE_LENGTH = calculate_max_file_length

files = get_files(H)
output(files)
