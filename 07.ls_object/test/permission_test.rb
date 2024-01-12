# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/permission'

class PermissionTest < Minitest::Test
  def test_permission
    assert_equal 'drwxr-xr-x', Permission.permission('16877'.to_i)
    assert_equal '-rw-r--r--', Permission.permission('33188'.to_i)
    assert_equal '-rwxr-xr-x', Permission.permission('33261'.to_i)
  end
end
