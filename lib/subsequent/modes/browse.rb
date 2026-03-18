# frozen_string_literal: true

# browse prefix mode - waits for lane/card/checklist subcommand
module Subsequent::Modes::Browse
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :getch

  OPTIONS = [:browse_lane, :browse_card, :browse_checklist, :cancel].freeze

  class << self
    # browse mode commands
    def commands(_state)
      <<~COMMANDS.strip
        browse (#{cyan("l")})ane (#{cyan("c")})ard chec(#{cyan("k")})list
        (#{cyan("q")}) to cancel
      COMMANDS
    end
  end
end
