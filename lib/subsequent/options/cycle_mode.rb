# frozen_string_literal: true

# switch to cycle mode
module Subsequent::Options::CycleMode
  Subsequent::Options.register(self, :cycle_mode)

  class << self
    # return true if the text is "c"
    def match?(_state, text)
      text == "c"
    end

    # return state with mode set to cycle
    def call(state, _text)
      state.with(mode: Subsequent::Modes::Cycle)
    end
  end
end
