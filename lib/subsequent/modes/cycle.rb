# frozen_string_literal: true

# Cycle mode functionality
module Subsequent::Modes::Cycle
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :getch

  OPTIONS = [
    :cancel,
    :cycle_card,
    :cycle_checklist,
    :cycle_checklist_item,
  ].freeze

  class << self
    # cycle mode commands
    def commands(state)
      state => { checklist:, checklist_items: }

      string = [
        "move first",
        checklist_items && "(#{cyan("i")})tem,",
        checklist && "(#{cyan("l")})ist or",
        "(#{cyan("c")})ard to end",
      ].compact.join(" ")

      <<~COMMANDS.strip
        #{string}
        (#{cyan("q")}) to cancel
      COMMANDS
    end
  end
end
