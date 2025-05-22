# frozen_string_literal: true

# switch to sort mode
module Subsequent::Options::SortMode
  # return true if the text is "s"
  def self.match?(_state, text)
    text == "s"
  end

  # return state with mode set to sort
  def self.call(state, _text)
    state.with(mode: Subsequent::Modes::Sort)
  end
end
