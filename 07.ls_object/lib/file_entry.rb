# frozen_string_literal: true

require 'etc'
require_relative 'permission'

class FileEntry
  attr_reader :filename

  def initialize(filename)
    @fs = File.lstat("./#{filename}")
    @filename = filename
  end

  def blocks
    @fs.blocks
  end

  def permission
    Permission.permission(@fs.mode)
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

  def day
    @fs.mtime.day.to_s
  end

  def time
    "#{format('%02d', @fs.mtime.hour)}:#{format('%02d', fs.mtime.sec)}"
  end

  def file
    File.symlink?(@filename) ? "#{@filename} -> #{File.readlink(@filename)}" : @filename
  end
end
