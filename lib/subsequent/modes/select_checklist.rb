# frozen_string_literal: true

# select a checklist from the browsed card
module Subsequent::Modes::SelectChecklist
  extend Subsequent::Modes::Base
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  INPUT_METHOD = :getch

  OPTIONS = [
    :cancel_to_cards, :select_checklist, :next_browse_page, :prev_browse_page,
  ].freeze

  class << self
    # select checklist mode commands
    def commands(state)
      <<~COMMANDS.strip
        select a checklist
        #{state.browse_checklists_string}
        #{paging_hints(state.browse_checklists, state)}(#{cyan("q")}) to cancel
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
