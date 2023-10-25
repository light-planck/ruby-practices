#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  opt = OptionParser.new
  options = ARGV.getopts('l', 'w', 'c')
  opt.parse!(ARGV)

  file_names = ARGV
  total = total = { lines: 0, words: 0, bytes: 0, name: 'total' }

  max_filename_length = calculate_max_filename_length(file_names)

  file_names.each do |file_name|
    file = File.read(file_name)
    lines = file.count("\n")
    words = file.split(/\s+/).size
    bytes = File.size(file_name)

    output({ lines:, words:, bytes:, name: file_name }, max_filename_length, options)

    total[:lines] += lines
    total[:words] += words
    total[:bytes] += bytes
  end

  output(total, max_filename_length, options)
end

def calculate_max_filename_length(file_names)
  max_filename_length = Hash.new(0)

  file_names.each do |file_name|
    file = File.read(file_name)
    max_filename_length[:lines] = [max_filename_length[:lines], file.count("\n").to_s.length].max
    max_filename_length[:words] = [max_filename_length[:words], file.split(/\s+/).size.to_s.length].max
    max_filename_length[:bytes] = [max_filename_length[:bytes], File.size(file_name).to_s.length].max
  end

  max_filename_length
end

def output(file, max_filename_length, options)
  base_padding = 4

  output_string = format("%#{max_filename_length[:lines] + base_padding}s", file[:lines])
  output_string += format("%#{max_filename_length[:words] + base_padding}s", file[:words])
  output_string += format("%#{max_filename_length[:bytes] + base_padding}s", file[:bytes])
  output_string += " #{file[:name]}"

  puts output_string
end

main
