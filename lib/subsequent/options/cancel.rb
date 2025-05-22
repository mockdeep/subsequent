# frozen_string_literal: true

# cancel and return to normal mode
module Subsequent::Options::Cancel
  # return true if the text matches any of the cancel options
  def self.match?(char)
    ["", "q", "\u0004", "\u0003"].include?(char)
  end

  # return state with mode set to normal
  def self.call(_text, state)
    state.with(mode: Subsequent::Modes::Normal)
  end
end
