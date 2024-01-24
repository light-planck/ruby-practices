# frozen_string_literal: true

require 'etc'

class FileEntry
  attr_reader :filename

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

  def initialize(filename)
    @fs = File.lstat("./#{filename}")
    @filename = filename
  end

  def blocks
    @fs.blocks
  end

  def permission
    formatted_mode = @fs.mode.to_s(8).rjust(6, '0')

    [TYPES[formatted_mode[0, 2]], PERMISSIONS[formatted_mode[3]], PERMISSIONS[formatted_mode[4]],
     PERMISSIONS[formatted_mode[5]]].join
  end

  def nlink
    @fs.nlink.to_s
  end

  def owner
    Etc.getpwuid(@fs.uid).name
  end

  def group
    Etc.getgrgid(@fs.gid).name
  end

  def size
    @fs.size.to_s
  end

  def month
    @fs.mtime.month.to_s
  end

  def day
    @fs.mtime.day.to_s
  end

  def time
    "#{format('%02d', @fs.mtime.hour)}:#{format('%02d', @fs.mtime.sec)}"
  end

  def file
    File.symlink?(@filename) ? "#{@filename} -> #{File.readlink(@filename)}" : @filename
  end
end
