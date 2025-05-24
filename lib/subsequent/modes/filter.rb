# frozen_string_literal: true

# filter to return cards with a specific tag
module Subsequent::Modes::Filter
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :getch

  OPTIONS = [:cancel, :remove_filters, :add_filter].freeze

  class << self
    # filter mode commands
    def commands(state)
      [
        "select tag to filter by",
        "(#{cyan("n")})one",
        *state.tags.each_with_index.map do |tag, index|
          "(#{cyan(index + 1)}) #{tag}"
        end,
        "(#{cyan("q")}) to cancel",
      ].join("\n")
    end
  end
end
