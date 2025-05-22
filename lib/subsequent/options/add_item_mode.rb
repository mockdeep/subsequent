# frozen_string_literal: true

# switch to add item mode
module Subsequent::Options::AddItemMode
  # return true if the text is "n"
  def self.match?(_state, text)
    text == "n"
  end

  # return state with mode set to add item
  def self.call(state, _text)
    state.with(mode: Subsequent::Modes::AddItem)
  end
end
