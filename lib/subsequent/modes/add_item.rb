# frozen_string_literal: true

# Add item mode functionality
module Subsequent::Modes::AddItem
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :getch

  OPTIONS = [:cancel, :add_card, :add_checklist, :add_checklist_item].freeze

  class << self
    # add item mode commands
    def commands(state)
      string =
        if state.checklist.present?
          "add new (#{cyan("c")})ard, check(#{cyan("l")})ist " \
            "or (#{cyan("i")})tem"
        else
          "add new (#{cyan("c")})ard or check(#{cyan("l")})ist"
        end

      <<~COMMANDS.strip
        #{string}
        (#{cyan("q")}) to cancel
      COMMANDS
    end
  end
end
