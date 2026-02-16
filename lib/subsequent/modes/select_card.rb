# frozen_string_literal: true

# select a card from the browsed list
module Subsequent::Modes::SelectCard
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :getch

  OPTIONS = [
    :cancel_browse, :select_card, :next_browse_page, :prev_browse_page,
  ].freeze

  class << self
    # select card mode commands
    def commands(state)
      <<~COMMANDS.strip
        select a card
        #{state.browse_cards_string}
        #{paging_hints(state.cards, state)}(#{cyan("q")}) to cancel
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
