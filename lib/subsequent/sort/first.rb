# frozen_string_literal: true

# sort by first card
module Subsequent::Sort::First
  # name of the sort
  def self.to_s
    "first"
  end

  # return the first card
  def self.call(cards)
    cards.first
  end
end
