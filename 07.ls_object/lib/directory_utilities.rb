# frozen_string_literal: true

module DirectoryUtilities
  module Private
    DISPLAY_COLUMNS = 3
    KEYS = %i[nlink owner group size month day].freeze
  end
  private_constant :Private

  def self.to_short_format(directory)
    file_names = directory.entries.map(&:filename)

    formatted_width = [(file_names.size + Private::DISPLAY_COLUMNS - 1) / Private::DISPLAY_COLUMNS, 1].max

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

  def self.print_long_format(directory)
    puts "total #{directory.total_blocks}"

    padding_length = calculate_padding_length(directory)
    directory.entries.each do |file|
      print file.permission
      Private::KEYS.each do |key|
        print padding(padding_length[key], file.send(key), 1) + file.send(key)
      end
      print " #{file.time}"
      print " #{file.file}"
      puts
    end
  end

  def self.print_short_format(filenames)
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

  def self.calculate_longest_filename_length(filenames)
    filenames.flatten.map(&:size).max
  end

  def self.calculate_padding_length(directory)
    initial_value = Private::KEYS.map { |key| [key, 0] }.to_h
    directory.entries.each_with_object(initial_value) do |entry, max_length|
      Private::KEYS.each do |key|
        max_length[key] = [entry.send(key).length, max_length[key]].max
      end
    end
  end

  def self.padding(padding_length, value, bias)
    ' ' * (padding_length - value.length + bias)
  end

  private_class_method :calculate_longest_filename_length, :calculate_padding_length, :padding
end
