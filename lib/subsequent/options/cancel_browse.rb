# frozen_string_literal: true

# cancel from SelectCard back to SelectList
module Subsequent::Options::CancelBrowse
  Subsequent::Options.register(self, :cancel_browse)

  class << self
    # return true if the text matches cancel
    def match?(_state, text)
      ["", "q", "\u0004", "\u0003"].include?(text)
    end

    # return state with mode set to SelectList
    def call(state, _text)
      state.with(mode: Subsequent::Modes::SelectList, browse_page: 0)
    end
  end
end
