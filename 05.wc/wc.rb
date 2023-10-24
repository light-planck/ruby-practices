#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  opt = OptionParser.new
  options = ARGV.getopts('l', 'w', 'c')
  opt.parse!(ARGV)

  file_names = ARGV
  total = {}
  total.default = 0
  total[:name] = 'total'

  max_filename_length = calculate_max_filename_length(file_names)

  file_names.each do |file_name|
    str = File.read(file_name)

    lines = str.count("\n")
    total[:lines] += lines

    words = str.split(/\s+/).size
    total[:words] += words

    bytes = File.size(file_name)
    total[:bytes] += bytes

    output({ lines:, words:, bytes:, name: file_name }, max_filename_length, options)
  end

  output(total, max_filename_length, options)
end

def calculate_max_filename_length(file_names)
  max_filename_langth = {}
  max_filename_langth[:lines] = file_names.map { |file_name| File.read(file_name).count("\n") }.max.to_s.length
  max_filename_langth[:words] = file_names.map { |file_name| File.read(file_name).split(/\s+/).size }.max.to_s.length
  max_filename_langth[:bytes] = file_names.map { |file_name| File.size(file_name) }.max.to_s.length
  max_filename_langth
end

def output(file, max_filename_length, options)
  base_padding = 4

  print ' ' * (base_padding + max_filename_length[:lines] - file[:lines].to_s.length)
  print file[:lines]

  print ' ' * (base_padding + max_filename_length[:words] - file[:words].to_s.length)
  print file[:words]

  print ' ' * (base_padding + max_filename_length[:bytes] - file[:bytes].to_s.length)
  print file[:bytes]

  print ' '

  puts file[:name]
end

main
