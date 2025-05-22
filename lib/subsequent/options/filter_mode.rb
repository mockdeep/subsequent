# frozen_string_literal: true

# switch to filter mode
module Subsequent::Options::FilterMode
  # return true if the text is "f"
  def self.match?(_state, text)
    text == "f"
  end

  # return state with mode set to filter
  def self.call(state, _text)
    state.with(mode: Subsequent::Modes::Filter)
  end
end
