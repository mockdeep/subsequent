# frozen_string_literal: true

# sort by most unchecked items
module Subsequent::Sorts::MostUncheckedItems
  class << self
    # name of the sort
    def to_s
      "most_unchecked_items"
    end

    # return the card with the most unchecked items
    def call(cards)
      cards.max_by do |card|
        card.checklists.sum do |checklist|
          checklist.unchecked_items.count
        end
      end
    end
  end
end
