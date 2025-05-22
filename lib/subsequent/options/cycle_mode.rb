# frozen_string_literal: true

# switch to cycle mode
module Subsequent::Options::CycleMode
  # return true if the text is "c"
  def self.match?(_state, text)
    text == "c"
  end

  # return state with mode set to cycle
  def self.call(state, _text)
    state.with(mode: Subsequent::Modes::Cycle)
  end
end
