# frozen_string_literal: true

# Add checklist item mode functionality
module Subsequent::Modes::AddChecklistItem
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  OPTIONS = [
    Subsequent::Options::Cancel,
    Subsequent::Options::CreateChecklistItem,
  ].freeze

  # add checklist item mode commands
  def self.commands(_state)
    ["enter checklist item name (#{cyan("q")}) to cancel: "]
  end

  # handle input for add checklist item mode
  def self.handle_input(state)
    text = input.gets.to_s.squish

    OPTIONS.find { |option| option.match?(state, text) }.call(state, text)
  end
end
