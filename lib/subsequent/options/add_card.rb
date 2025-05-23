# frozen_string_literal: true

# switch to add card mode
module Subsequent::Options::AddCard
  class << self
    # return true if the text is "c"
    def match?(_state, text)
      text == "c"
    end

    # return state with mode set to add card
    def call(state, _text)
      state.with(mode: Subsequent::Modes::AddCard)
    end
  end
end
