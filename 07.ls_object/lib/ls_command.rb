# frozen_string_literal: true

require 'optparse'
require_relative 'file_entry'
require_relative 'short_file_formatter'
require_relative 'long_file_formatter'

class LsCommand
  def initialize
    @options = parse_options
  end

  def execute
    file_entries = fetch_file_entries
    formatter = @options[:l] ? LongFileFormatter.new(file_entries) : ShortFileFormatter.new(file_entries)
    puts formatter.format
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
    file_names = file_names.reject { |file| file.start_with?('.') } unless @options[:a]
    file_names.sort!
    file_names.reverse! if @options[:r]
    file_names.map { |file| FileEntry.new(file) }
  end
end
