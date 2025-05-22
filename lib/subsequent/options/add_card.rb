# frozen_string_literal: true

# switch to add card mode
module Subsequent::Options::AddCard
  # return true if the text is "c"
  def self.match?(_state, text)
    text == "c"
  end

  # return state with mode set to add card
  def self.call(state, _text)
    state.with(mode: Subsequent::Modes::AddCard)
  end
end
