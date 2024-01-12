# frozen_string_literal: true

require 'optparse'
require_relative 'directory'
require_relative 'directory_utilities'

class CLIHandler
  def initialize
    @options = parse_options
    @directory = Directory.new(@options)
  end

  def execute
    if @options[:l]
      DirectoryUtilities.print_long_format(@directory)
      exit
    end

    formatted_entries = DirectoryUtilities.to_short_format(@directory)
    DirectoryUtilities.print_short_format(formatted_entries)
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
end
