# frozen_string_literal: true

# Cycle mode functionality
module Subsequent::Modes::Cycle
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  OPTIONS = [
    Subsequent::Options::Cancel,
    Subsequent::Options::CycleCard,
    Subsequent::Options::CycleChecklist,
    Subsequent::Options::CycleChecklistItem,
    Subsequent::Options::Noop,
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

      [string, "(#{cyan("q")}) to cancel"]
    end

    # handle input for cycle mode
    def handle_input(state)
      text = input.getch

      OPTIONS.find { |option| option.match?(state, text) }.call(state, text)
    end
  end
end
