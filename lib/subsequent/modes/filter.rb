# frozen_string_literal: true

# filter to return cards with a specific tag
module Subsequent::Modes::Filter
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :getch

  OPTIONS = [
    :cancel, :remove_filters, :next_tag_page, :prev_tag_page, :add_filter,
  ].freeze

  class << self
    # filter mode commands
    def commands(state)
      <<~COMMANDS.strip
        select tag to filter by
        (#{cyan("n")})one
        #{state.tag_string}
        #{paging_hints(state)}(#{cyan("q")}) to cancel
      COMMANDS
    end

    private

    def paging_hints(state)
      pages = state.tags.each_slice(9).count
      return "" if pages <= 1

      page = state.tag_page + 1
      "(#{cyan("<")}) prev (#{cyan(">")}) next " \
        "- page #{page}/#{pages}\n"
    end
  end
end
