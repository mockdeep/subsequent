# frozen_string_literal: true

# Toggle a checklist item
module Subsequent::Commands::ToggleChecklistItem
  class << self
    # Toggle a checklist item
    def call(state, char)
      state => { checklist_items: }

      task_number = Integer(char)
      item = checklist_items.fetch(task_number - 1)

      Subsequent::TrelloClient.toggle_checklist_item(item)

      toggled_state = item.checked? ? "incomplete" : "complete"
      toggled_item = item.dup.tap { |i| i.state = toggled_state }
      toggled_items = checklist_items.dup
      toggled_items[task_number - 1] = toggled_item

      state.with(checklist_items: toggled_items)
    end
  end
end
