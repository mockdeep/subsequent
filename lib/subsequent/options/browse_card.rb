# frozen_string_literal: true

# browse cards in the current list
module Subsequent::Options::BrowseCard
  Subsequent::Options.register(self, :browse_card)

  class << self
    # return true if the text is "c"
    def match?(_state, text)
      text == "c"
    end

    # enter SelectCard mode for the current list
    def call(state, _text)
      state.with(mode: Subsequent::Modes::SelectCard, browse_page: 0)
    end
  end
end
