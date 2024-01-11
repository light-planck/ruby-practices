#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/cli_handler'

def main
  handler = CLIHandler.new
  handler.execute
end

main
