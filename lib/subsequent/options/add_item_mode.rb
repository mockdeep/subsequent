# frozen_string_literal: true

# switch to add item mode
module Subsequent::Options::AddItemMode
  class << self
    # return true if the text is "n"
    def match?(_state, text)
      text == "n"
    end

    # return state with mode set to add item
    def call(state, _text)
      state.with(mode: Subsequent::Modes::AddItem)
    end
  end
end
