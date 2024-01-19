#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/ls_command'

def main
  ls = LsCommand.new
  ls.execute
end

main
