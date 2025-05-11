# frozen_string_literal: true

# filter to return all cards unfiltered
module Subsequent::Filter::None
  # return all cards unfiltered
  def self.call(cards)
    cards
  end
end
