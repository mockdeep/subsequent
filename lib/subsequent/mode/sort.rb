# frozen_string_literal: true

# Sort mode functionality
module Subsequent::Mode::Sort
  extend Subsequent::TextFormatting

  # sort mode commands
  def self.commands(_state)
    string = "sort cards by " \
             "(#{cyan("f")})irst " \
             "(#{cyan("l")})east/" \
             "(#{cyan("m")})ost unchecked items"

    [string, "(#{cyan("q")}) to cancel"]
  end
end
