# frozen_string_literal: true

require_relative 'file_entry'

class Directory
  attr_reader :entries, :total_blocks

  def initialize(options)
    @entries = fetch_entries(options)
    @total_blocks = calculate_total_blocks
  end

  private

  def fetch_entries(options)
    entries = Dir.entries('.').select { |file| options[:a] || !file.start_with?('.') }.sort.map do |file|
      FileEntry.new(file)
    end
    options[:r] ? entries.reverse : entries
  end

  def calculate_total_blocks
    @entries.map(&:blocks).sum
  end
end
