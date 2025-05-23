# frozen_string_literal: true

# filter to return all cards unfiltered
module Subsequent::Filters::None
  class << self
    # return all cards unfiltered
    def call(cards)
      cards
    end
  end
end
