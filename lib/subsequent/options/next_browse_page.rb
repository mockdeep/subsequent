# frozen_string_literal: true

# advance to the next browse page
module Subsequent::Options::NextBrowsePage
  Subsequent::Options.register(self, :next_browse_page)

  class << self
    # return true if text is ">" and more pages exist
    def match?(state, text)
      text == ">" &&
        state.browse_page < browse_items(state).each_slice(9).count - 1
    end

    # return state with incremented browse page
    def call(state, _text)
      state.with(browse_page: state.browse_page + 1)
    end

    private

    def browse_items(state)
      case state.mode.name
      when "Subsequent::Modes::SelectList" then state.lists
      when "Subsequent::Modes::SelectCard" then state.cards
      when "Subsequent::Modes::SelectChecklist"
        state.browse_checklists
      else []
      end
    end
  end
end
