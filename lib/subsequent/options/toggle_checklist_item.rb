# frozen_string_literal: true

# toggle checklist item
module Subsequent::Options::ToggleChecklistItem
  Subsequent::Options.register(self, :toggle_checklist_item)

  class << self
    # return true if the text is a number between 1 and the number of items
    def match?(state, text)
      ("1"..state.checklist_items.size.to_s).include?(text)
    end

    # toggle checklist item
    def call(state, text)
      Subsequent::Commands::ToggleChecklistItem.call(state, text)
    end
  end
end
