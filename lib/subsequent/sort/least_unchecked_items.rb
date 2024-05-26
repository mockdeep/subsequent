# frozen_string_literal: true

# sort by least unchecked items
module Subsequent::Sort::LeastUncheckedItems
  # name of the sort
  def self.to_s
    "least_unchecked_items"
  end

  # return the card with the least unchecked items
  def self.call(cards)
    cards.min_by do |card|
      card.checklists.sum do |checklist|
        checklist.unchecked_items.count
      end
    end
  end
end
