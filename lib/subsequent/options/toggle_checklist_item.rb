# frozen_string_literal: true

# toggle checklist item
module Subsequent::Options::ToggleChecklistItem
  # return true if the text is a number between 1 and the number of items
  def self.match?(state, text)
    ("1"..state.checklist_items.to_a.size.to_s).include?(text)
  end

  # toggle checklist item
  def self.call(state, text)
    Subsequent::Commands::ToggleChecklistItem.call(state, text)
  end
end
