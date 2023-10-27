#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options

  if ARGV.empty?
    file = readlines
    file_info = get_file_info(file.join)
    single_output(file_info)
    exit
  end

  file_names = ARGV
  max_filename_length = calculate_max_filename_length(file_names)

  file_names.each do |file_name|
    file = File.read(file_name)
    file_info = get_file_info(file, file_name)
    output(file_info, max_filename_length, options)
  end

  return if file_names.size <= 1

  total_info = calculate_total_file_info(file_names)
  output(total_info, max_filename_length, options) if file_names.size > 1
end

def parse_options
  opt = OptionParser.new
  options = ARGV.getopts('l', 'w', 'c')
  opt.parse!(ARGV)
  options = { 'l' => true, 'w' => true, 'c' => true } if options.values.all?(false)
  options
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

def get_file_info(file, file_name = '')
  lines = file.count("\n")
  words = file.split(/\s+/).size
  bytes = file.bytesize
  { lines:, words:, bytes:, name: file_name }
end

def calculate_total_file_info(file_names)
  total_info = { lines: 0, words: 0, bytes: 0, name: 'total' }
  file_names.each do |file_name|
    file = File.read(file_name)
    file_info = get_file_info(file, file_name)
    total_info[:lines] += file_info[:lines]
    total_info[:words] += file_info[:words]
    total_info[:bytes] += file_info[:bytes]
  end
  total_info
end

def single_output(file)
  width = 10

  length = { lines: 0, words: 0, bytes: 0 }
  file.each do |key, value|
    length[key] = value.to_s.length
  end

  print "#{file[:lines].to_s.rjust(width - length[:lines], ' ')} "
  print "#{file[:words].to_s.rjust(width - length[:words], ' ')} "
  puts file[:bytes].to_s.rjust(width - length[:bytes], ' ')
end

def output(file, max_filename_length = {}, options = {})
  base_padding = 4

  output_string = ''
  output_string += format("%#{max_filename_length[:lines] + base_padding}s", file[:lines]) if options['l']
  output_string += format("%#{max_filename_length[:words] + base_padding}s", file[:words]) if options['w']
  output_string += format("%#{max_filename_length[:bytes] + base_padding}s", file[:bytes]) if options['c']
  output_string += " #{file[:name]}"
  puts output_string
end

main
