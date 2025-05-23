# frozen_string_literal: true

# sort by first card
module Subsequent::Sorts::First
  class << self
    # name of the sort
    def to_s
      "first"
    end

    # return the first card
    def call(cards)
      cards.first
    end
  end
end
