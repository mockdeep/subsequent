# frozen_string_literal: true

# Sort mode functionality
module Subsequent::Modes::Sort
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  OPTIONS = [
    Subsequent::Options::Cancel,
    Subsequent::Options::Sort,
    Subsequent::Options::Noop,
  ].freeze

  class << self
    # sort mode commands
    def commands(_state)
      string = "sort cards by " \
               "(#{cyan("f")})irst " \
               "(#{cyan("l")})east/" \
               "(#{cyan("m")})ost unchecked items"

      [string, "(#{cyan("q")}) to cancel"]
    end

    # handle input for sort mode
    def handle_input(state)
      text = input.getch

      OPTIONS.find { |option| option.match?(state, text) }.call(state, text)
    end
  end
end
