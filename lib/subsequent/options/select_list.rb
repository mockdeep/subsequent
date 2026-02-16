# frozen_string_literal: true

# select a list from browse mode
module Subsequent::Options::SelectList
  Subsequent::Options.register(self, :select_list)

  extend Subsequent::DisplayHelpers

  class << self
    # return true if text is a number in the current page's list range
    def match?(state, text)
      page_size = page_items(state).size
      return false if page_size.zero?

      ("1"..page_size.to_s).to_a.include?(text)
    end

    # fetch cards for selected list, transition to SelectCard
    def call(state, text)
      index = (state.browse_page * 9) + Integer(text) - 1
      list = state.lists.fetch(index)

      show_spinner { fetch_and_transition(state, list) }
    end

    private

    def fetch_and_transition(state, list)
      cards = Subsequent::TrelloClient.fetch_cards(list_id: list.id)

      state.with(
        cards:,
        card: cards.first || Subsequent::Models::NullCard.new,
        checklist: Subsequent::Models::NullChecklist.new,
        checklist_items: [],
        browse_list_id: list.id,
        mode: Subsequent::Modes::SelectCard,
        browse_page: 0,
      )
    end

    def page_items(state)
      state.lists.each_slice(9).to_a.fetch(state.browse_page, [])
    end
  end
end
