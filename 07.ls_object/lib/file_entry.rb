# frozen_string_literal: true

require 'etc'
require_relative 'permission'

class FileEntry
  attr_reader :blocks

  def initialize(filename)
    fs = File.lstat("./#{filename}")

    @blocks = fs.blocks
    @permission = Permission.permission(fs.mode)
    @nlink = fs.nlink.to_s
    @owner = Etc.getpwuid(fs.uid).name
    @group = Etc.getgrgid(fs.gid).name
    @size = fs.size.to_s
    @month = fs.mtime.month.to_s
    @day = fs.mtime.day.to_s
    @time = "#{format('%02d', fs.mtime.hour)}:#{format('%02d', fs.mtime.sec)}"
    @filename = filename
    @file = File.symlink?(filename) ? "#{filename} -> #{File.readlink(filename)}" : filename
  end
end
