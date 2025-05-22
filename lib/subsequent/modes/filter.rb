# frozen_string_literal: true

# filter to return cards with a specific tag
module Subsequent::Modes::Filter
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  OPTIONS = [
    Subsequent::Options::Cancel,
    Subsequent::Options::RemoveFilters,
    Subsequent::Options::AddFilter,
    Subsequent::Options::Noop,
  ].freeze

  # filter mode commands
  def self.commands(state)
    [
      "select tag to filter by",
      "(#{cyan("n")})one",
      *state.tags.each_with_index.map do |tag, index|
        "(#{cyan(index + 1)}) #{tag}"
      end,
      "(#{cyan("q")}) to cancel",
    ]
  end

  # handle input for filter mode
  def self.handle_input(state)
    text = input.getch

    OPTIONS.find { |option| option.match?(state, text) }.call(state, text)
  end
end
