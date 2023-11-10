#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  file_names = ARGV

  # 標準入力がある場合
  if file_names.empty?
    file_info = get_file_info($stdin.read)
    output(file_info, { lines: 0, words: 0, bytes: 0 }, options)
    exit
  end

  max_filename_length = calculate_max_filenames_length(file_names)
  total_info = { lines: 0, words: 0, bytes: 0, name: 'total' }

  file_names.each do |file_name|
    file = File.read(file_name)
    file_info = get_file_info(file, file_name)

    file_info.reject { |key| key == :name }.each do |key, value|
      total_info[key] += value
    end

    output(file_info, max_filename_length, options)
  end

  return if file_names.size <= 1

  output(total_info, max_filename_length, options)
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
    file_info = get_file_info(file, file_name)

    file_info.each do |key, value|
      max_filenames_length[key] = [max_filenames_length[key], value.to_s.length].max
    end
  end

  max_filenames_length
end

def get_file_info(file, file_name = '')
  lines = file.count("\n")
  words = file.split(/\s+/).size
  bytes = file.bytesize
  { lines:, words:, bytes:, name: file_name }
end

def output(file, max_filename_length = {}, options = {})
  base_padding = 10

  output_string = ''
  output_string += format("%#{base_padding - max_filename_length[:lines]}s", file[:lines]) if options['l']
  output_string += format("%#{base_padding - max_filename_length[:words]}s", file[:words]) if options['w']
  output_string += format("%#{base_padding - max_filename_length[:bytes]}s", file[:bytes]) if options['c']
  output_string += " #{file[:name]}" if file[:name] != ''
  puts output_string
end

main
