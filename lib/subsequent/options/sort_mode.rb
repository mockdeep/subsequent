# frozen_string_literal: true

# switch to sort mode
module Subsequent::Options::SortMode
  Subsequent::Options.register(self, :sort_mode)

  class << self
    # return true if the text is "s"
    def match?(_state, text)
      text == "s"
    end

    # return state with mode set to sort
    def call(state, _text)
      state.with(mode: Subsequent::Modes::Sort)
    end
  end
end
