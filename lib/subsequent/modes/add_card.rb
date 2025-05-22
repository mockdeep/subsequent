# frozen_string_literal: true

# Add card mode functionality
module Subsequent::Modes::AddCard
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  OPTIONS = [
    Subsequent::Options::Cancel,
    Subsequent::Options::CreateCard,
  ].freeze

  # add card mode commands
  def self.commands(_state)
    ["enter card name (#{cyan("q")}) to cancel: "]
  end

  # handle input for add card mode
  def self.handle_input(state)
    text = input.gets.to_s.squish

    OPTIONS.find { |option| option.match?(text) }.call(state, text)
  end
end
