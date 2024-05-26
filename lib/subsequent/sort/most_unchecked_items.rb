# frozen_string_literal: true

# sort by most unchecked items
module Subsequent::Sort::MostUncheckedItems
  # name of the sort
  def self.to_s
    "most_unchecked_items"
  end

  # return the card with the most unchecked items
  def self.call(cards)
    cards.max_by do |card|
      card.checklists.sum do |checklist|
        checklist.unchecked_items.count
      end
    end
  end
end
