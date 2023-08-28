#!/usr/bin/env ruby
# frozen_string_literal: true

# カレントディレクトリに存在するファイルを名前でソート(昇順)した配列を返す
def get_files
  files = []
  Dir.entries('.').each do |file|
    next if ['.', '..'].include?(file)
    next if file[0] == '.'
    files << file
  end
  files.sort!
end

# ファイルを要件定義の通りの順番に並び変える
def format_files(files, height)
  formatted_width = height

  formatted = [[]]
  files.each do |file|
    next if ['.', '..'].include?(file)
    next if file[0] == '.'

    if formatted.last.size < formatted_width
      formatted.last << file
    else
      formatted << [file]
    end
  end

  # 転置するときの整合性を取るために空文字列を入れる
  if (formatted.last.size < formatted_width)
    (formatted_width - formatted.last.size).times do
      formatted.last << ''
    end
  end

  formatted.transpose
end

# ファイル名の長さの最大値を計算
def calculate_max_file_length(files)
  lengths = []
  files.each do |row|
    row.each do |file|
      lengths << file.size
    end
  end
  lengths.max
end

def output(files)
  max_file_name_length = calculate_max_file_length(files)

  files.each do |row|
    row.each do |file|
      break if file == ''

      # ファイル同士の間隔はファイル名の最大値 + 2にそろえる
      spaces = max_file_name_length - file.size + 2
      print file + ' ' * spaces
    end
    puts
  end
end

def main
  files = get_files

  w = 3
  h = [files.size / w, 1].max

  formatted_files = format_files(files, h)
  output(formatted_files)
end

main
