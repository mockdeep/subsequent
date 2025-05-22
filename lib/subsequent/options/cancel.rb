# frozen_string_literal: true

# cancel and return to normal mode
module Subsequent::Options::Cancel
  # return true if the text matches any of the cancel options
  def self.match?(_state, text)
    ["", "q", "\u0004", "\u0003"].include?(text)
  end

  # return state with mode set to normal
  def self.call(state, _text)
    state.with(mode: Subsequent::Modes::Normal)
  end
end
