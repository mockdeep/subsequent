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
      <<~COMMANDS.strip
        select tag to filter by
        (#{cyan("n")})one
        #{state.tag_string}
        (#{cyan("q")}) to cancel
      COMMANDS
    end
  end
end
