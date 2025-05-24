# frozen_string_literal: true

# Add checklist mode functionality
module Subsequent::Modes::AddChecklist
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  OPTIONS = [
    Subsequent::Options::Cancel,
    Subsequent::Options::CreateChecklist,
  ].freeze

  class << self
    # add checklist mode commands
    def commands(_state)
      ["enter checklist name (#{cyan("q")}) to cancel: "]
    end

    # handle input for add checklist mode
    def handle_input(state)
      text = input.gets.to_s.squish

      OPTIONS.find { |option| option.match?(state, text) }.call(state, text)
    end
  end
end
