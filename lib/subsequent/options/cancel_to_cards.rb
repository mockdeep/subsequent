# frozen_string_literal: true

# cancel from SelectChecklist back to SelectCard
module Subsequent::Options::CancelToCards
  Subsequent::Options.register(self, :cancel_to_cards)

  class << self
    # return true if the text matches cancel
    def match?(_state, text)
      ["", "q", "\u0004", "\u0003"].include?(text)
    end

    # return state with mode set to SelectCard
    def call(state, _text)
      state.with(mode: Subsequent::Modes::SelectCard, browse_page: 0)
    end
  end
end
