# frozen_string_literal: true

require 'optparse'
require_relative 'file_entry'

class LsCommand
  DISPLAY_COLUMNS = 3

  def initialize
    @options = parse_options
  end

  def execute
    file_entries = FileEntry.fetch_file_entries(@options)

    if @options[:l]
      print_in_long_format(file_entries)
      exit
    end

    formatted_in_short = format_in_short(file_entries)
    print_in_short_format(formatted_in_short)
  end

  private

  def parse_options
    opt = OptionParser.new
    options = {}
    opt.on('-a') { |v| options[:a] = v }
    opt.on('-r') { |v| options[:r] = v }
    opt.on('-l') { |v| options[:l] = v }
    opt.parse(ARGV)
    options
  end

  def format_in_short(file_entries)
    file_names = file_entries.map(&:filename)
    formatted_width = [(file_names.size + DISPLAY_COLUMNS - 1) / DISPLAY_COLUMNS, 1].max

    formatted_file_names = [[]]
    file_names.each do |file|
      if formatted_file_names.last.size < formatted_width
        formatted_file_names.last << file
      else
        formatted_file_names << [file]
      end
    end

    # 転置するときの整合性を取るために空文字列を入れる
    if formatted_file_names.last.size < formatted_width
      (formatted_width - formatted_file_names.last.size).times do
        formatted_file_names.last << ''
      end
    end

    formatted_file_names.transpose
  end

  def print_in_short_format(filenames)
    longest_filename_length = calculate_longest_filename_length(filenames)

    filenames.each do |row|
      row.each do |file|
        break if file == ''

        spaces = longest_filename_length - file.size.to_i + 2
        print file + ' ' * spaces
      end
      puts
    end
  end

  def calculate_longest_filename_length(filenames)
    filenames.flatten.map(&:size).max
  end
end
