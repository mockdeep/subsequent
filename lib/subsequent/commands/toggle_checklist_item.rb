# frozen_string_literal: true

# Toggle a checklist item
module Subsequent::Commands::ToggleChecklistItem
  class << self
    # Toggle a checklist item
    def call(state, char)
      state => { checklist_items: }

      task_number = Integer(char)
      item = checklist_items[task_number - 1]

      Subsequent::TrelloClient.toggle_checklist_item(item)

      state
    end
  end
end
