# frozen_string_literal: true

class LongFileFormatter
  KEYS = %i[nlink owner group size month day].freeze

  def initialize(file_entries)
    @file_entries = file_entries
  end

  def format
    padding_length = calculate_padding_length
    @file_entries.map do |file_entry|
      "#{file_entry.permission} " +
        KEYS.map { |key| "#{padding(padding_length[key], file_entry.send(key), 1)}#{file_entry.send(key)}" }.join(' ') +
        " #{file_entry.time} #{file_entry.file}"
    end.unshift(@file_entries.sum(&:blocks))
  end

  private

  def calculate_padding_length
    initial_value = KEYS.map { |key| [key, 0] }.to_h
    @file_entries.each_with_object(initial_value) do |file_entry, max_length|
      KEYS.each do |key|
        max_length[key] = [file_entry.send(key).length, max_length[key]].max
      end
    end
  end

  def padding(padding_length, value, offset)
    ' ' * (padding_length - value.length + offset)
  end
end
