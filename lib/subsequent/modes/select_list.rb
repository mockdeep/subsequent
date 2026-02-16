# frozen_string_literal: true

# select a list to browse
module Subsequent::Modes::SelectList
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :getch

  OPTIONS = [
    :cancel, :select_list, :next_browse_page, :prev_browse_page,
  ].freeze

  class << self
    # select list mode commands
    def commands(state)
      <<~COMMANDS.strip
        select a list
        #{state.list_string}
        #{paging_hints(state.lists, state)}(#{cyan("q")}) to cancel
      COMMANDS
    end

    private

    def paging_hints(items, state)
      pages = items.each_slice(9).count
      return "" if pages <= 1

      page = state.browse_page + 1
      "(#{cyan("<")}) prev (#{cyan(">")}) next " \
        "- page #{page}/#{pages}\n"
    end
  end
end
