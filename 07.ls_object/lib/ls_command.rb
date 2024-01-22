# frozen_string_literal: true

require 'optparse'
require_relative 'file_entry'

class LsCommand
  DISPLAY_COLUMNS = 3
  KEYS = %i[nlink owner group size month day].freeze
  PERMISSIONS = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze
  TYPES = {
    '01' => 'p',
    '02' => 'c',
    '04' => 'd',
    '06' => 'b',
    '10' => '-',
    '12' => 'l',
    '14' => 's'
  }.freeze

  def initialize
    @options = parse_options
    @file_entries = fetch_file_entries
  end

  def self.padding(padding_length, value, bias)
    ' ' * (padding_length - value.length + bias)
  end

  def execute
    if @options[:l]
      puts @file_entries.sum(&:blocks)

      formatted_in_long = format_in_long
      puts formatted_in_long
      exit
    end

    formatted_in_short = format_in_short
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

  def fetch_file_entries
    file_names = Dir.entries('.')
    file_names = file_names.select { |file| @options[:a] || !file.start_with?('.') }
    file_names.sort!
    file_names.reverse! if @options[:r]
    file_names.map { |file| FileEntry.new(file) }
  end

  # short format
  def format_in_short
    file_names = @file_entries.map(&:filename)
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
    longest_filename_length = filenames.flatten.map(&:size).max

    filenames.each do |row|
      row.each do |file|
        break if file == ''

        spaces = longest_filename_length - file.size.to_i + 2
        print file + ' ' * spaces
      end
      puts
    end
  end

  # long format
  def format_in_long
    padding_length = calculate_padding_length
    @file_entries.map do |file_entry|
      "#{file_entry.permission} " +
        KEYS.map { |key| "#{LsCommand.padding(padding_length[key], file_entry.send(key), 1)}#{file_entry.send(key)}" }.join(' ') +
        " #{file_entry.time} #{file_entry.file}"
    end
  end

  def calculate_padding_length
    initial_value = KEYS.map { |key| [key, 0] }.to_h
    @file_entries.each_with_object(initial_value) do |file_entry, max_length|
      KEYS.each do |key|
        max_length[key] = [file_entry.send(key).length, max_length[key]].max
      end
    end
  end

  def permission(mode)
    formatted_mode = mode.to_s(8).rjust(6, '0')

    [TYPES[formatted_mode[0, 2]], PERMISSIONS[formatted_mode[3]], PERMISSIONS[formatted_mode[4]],
     PERMISSIONS[formatted_mode[5]]].join
  end
end
