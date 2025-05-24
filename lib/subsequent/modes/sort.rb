# frozen_string_literal: true

# Sort mode functionality
module Subsequent::Modes::Sort
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :getch

  OPTIONS = [:cancel, :sort].freeze

  class << self
    # sort mode commands
    def commands(_state)
      string = "sort cards by " \
               "(#{cyan("f")})irst " \
               "(#{cyan("l")})east/" \
               "(#{cyan("m")})ost unchecked items"

      [string, "(#{cyan("q")}) to cancel"].join("\n")
    end
  end
end
