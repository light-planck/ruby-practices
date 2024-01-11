# frozen_string_literal: true

module DirectoryUtilities
  module Private
    WIDTH = 3
  end
  private_constant :Private

  def self.to_long_format; end

  def self.to_short_format(directory)
    file_names = directory.entries.map(&:filename)

    formatted_width = [(file_names.size + Private::WIDTH - 1) / Private::WIDTH, 1].max

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

  def self.print_long_format; end

  def self.print_short_format(file_names)
    max_file_name_length = calculate_max_file_length(file_names)

    file_names.each do |row|
      row.each do |file|
        break if file == ''

        spaces = max_file_name_length - file.size.to_i + 2
        print file + ' ' * spaces
      end
      puts
    end
  end

  def self.calculate_max_file_length(file_names)
    lengths = []
    file_names.each do |row|
      row.each do |file|
        lengths << file.size
      end
    end
    lengths.max
  end

  private_class_method :calculate_max_file_length
end
