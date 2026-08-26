# frozen_string_literal: true

# sort and return to normal mode
module Subsequent::Options::Sort
  Subsequent::Options.register(self, :sort)

  MODES = {
    f: Subsequent::Sorts::First,
    m: Subsequent::Sorts::MostUncheckedItems,
    l: Subsequent::Sorts::LeastUncheckedItems,
  }.freeze

  class << self
    # return true, def ault to this when no other option matches
    def match?(_state, text)
      ["f", "l", "m"].include?(text)
    end

    # return state with selected sort, back in normal mode
    def call(state, text)
      state
        .with(sort: MODES.fetch(text.to_sym), mode: Subsequent::Modes::Normal)
        .reselect
    end
  end
end
