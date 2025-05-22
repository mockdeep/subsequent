# frozen_string_literal: true

# Add item mode functionality
module Subsequent::Modes::AddItem
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  OPTIONS = [
    Subsequent::Options::Cancel,
    Subsequent::Options::AddCard,
    Subsequent::Options::AddChecklist,
    Subsequent::Options::AddChecklistItem,
    Subsequent::Options::Noop,
  ].freeze

  # add item mode commands
  def self.commands(state)
    state => { checklist: }

    string =
      if checklist.present?
        "add new (#{cyan("c")})ard, check(#{cyan("l")})ist or (#{cyan("i")})tem"
      else
        "add new (#{cyan("c")})ard or check(#{cyan("l")})ist"
      end

    [string, "(#{cyan("q")}) to cancel"]
  end

  # handle input for add item mode
  def self.handle_input(state)
    text = input.getch

    OPTIONS.find { |option| option.match?(state, text) }.call(state, text)
  end
end
