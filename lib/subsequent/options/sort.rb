# frozen_string_literal: true

# sort and return to normal mode
module Subsequent::Options::Sort
  MODES = {
    f: Subsequent::Sorts::First,
    m: Subsequent::Sorts::MostUncheckedItems,
    l: Subsequent::Sorts::LeastUncheckedItems,
  }.freeze

  # return true, default to this when no other option matches
  def self.match?(_state, text)
    ["f", "l", "m"].include?(text)
  end

  # return state with selected sort
  def self.call(state, text)
    state => { cards:, filter: }
    sort = MODES.fetch(text.to_sym)

    Subsequent::State.new(cards:, filter:, sort:)
  end
end
