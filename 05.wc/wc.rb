#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  file_names = ARGV

  # 標準入力がある場合
  if file_names.empty?
    file_stats = get_file_stats($stdin.read)
    output(file_stats, '', { lines: 0, words: 0, bytes: 0 }, options)
    exit
  end

  max_filename_length = calculate_max_filenames_length(file_names)
  total_stats = { lines: 0, words: 0, bytes: 0 }

  file_names.each do |file_name|
    file = File.read(file_name)
    file_stats = get_file_stats(file)

    file_stats.each do |key, value|
      total_stats[key] += value
    end

    output(file_stats, file_name, max_filename_length, options)
  end

  return if file_names.size <= 1

  output(total_stats, 'total', max_filename_length, options)
end

def parse_options
  opt = OptionParser.new
  options = ARGV.getopts('l', 'w', 'c')
  opt.parse!(ARGV)
  options = { 'l' => true, 'w' => true, 'c' => true } if options.values.all?(false)
  options
end

def calculate_max_filenames_length(file_names)
  max_filenames_length = { lines: 0, words: 0, bytes: 0, name: 0 }

  file_names.each do |file_name|
    file = File.read(file_name)
    file_stats = get_file_stats(file)

    file_stats.each do |key, value|
      max_filenames_length[key] = [max_filenames_length[key], value.to_s.length].max
    end
    max_filenames_length[:name] = [max_filenames_length[:name], file_name.length].max
  end

  max_filenames_length
end

def get_file_stats(file)
  lines = file.count("\n")
  words = file.split(/\s+/).size
  bytes = file.bytesize
  { lines:, words:, bytes: }
end

def output(file_stats, file_name, max_filename_length = {}, options = {})
  base_padding = 10
  option_keys = { lines: 'l', words: 'w', bytes: 'c' }.freeze

  output_string = ''
  file_stats.each do |key, value|
    output_string += format("%#{base_padding - max_filename_length[key]}s", value) if options[option_keys[key]]
  end

  output_string += " #{file_name}" if file_name != ''

  puts output_string
end

main
