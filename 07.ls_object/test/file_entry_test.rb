# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/file_entry'

class FileEntryTest < Minitest::Test
  def test_file_entry
    file_entry = FileEntry.new('.gitkeep')
    instance_variables_hash = file_entry.instance_variables.each_with_object({}) do |var, hash|
      hash[var.to_s.delete('@').to_sym] = file_entry.instance_variable_get(var)
    end

    expected = { blocks: 0, permission: '-rw-r--r--@', nlink: '1', owner: 'light', group: 'staff', size: '0', month: '9', day: '21', time: '11:12',
                 filename: '.gitkeep', file: '.gitkeep' }
    assert_equal expected, instance_variables_hash
  end
end
