# frozen_string_literal: true

# select a card from browse mode
module Subsequent::Options::SelectCard
  Subsequent::Options.register(self, :select_card)

  class << self
    # return true if text is a number in the current page's card range
    def match?(state, text)
      page_size = page_items(state).size
      return false if page_size.zero?

      ("1"..page_size.to_s).to_a.include?(text)
    end

    # set the selected card, transition to SelectChecklist
    def call(state, text)
      index = (state.browse_page * 9) + Integer(text) - 1
      card = state.cards.fetch(index)

      state.with(
        card:,
        checklist: Subsequent::Models::NullChecklist.new,
        checklist_items: [],
        mode: Subsequent::Modes::SelectChecklist,
        browse_page: 0,
      )
    end

    private

    def page_items(state)
      state.cards.each_slice(9).to_a.fetch(state.browse_page, [])
    end
  end
end
