# frozen_string_literal: true

require_relative 'file_entry'

class ShortFileFormatter
  DISPLAY_COLUMNS = 3

  def initialize(file_entries)
    @file_entries = file_entries
  end

  def format
    file_names = format_file_names

    longest_file_name_length = file_names.flatten.map(&:size).max

    file_names.map do |row|
      row.map do |file|
        spaces = longest_file_name_length - file.size.to_i + 2
        file + ' ' * spaces
      end.join
    end
  end

  private

  def format_file_names
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
end
