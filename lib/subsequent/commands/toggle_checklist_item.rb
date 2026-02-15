# frozen_string_literal: true

# Toggle a checklist item
module Subsequent::Commands::ToggleChecklistItem
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  class << self
    # Toggle a checklist item
    def call(state, char)
      state => { checklist_items: }

      task_number = Integer(char)
      item = checklist_items.fetch(task_number - 1)

      render_loading_state(state, task_number)

      Subsequent::TrelloClient.toggle_checklist_item(item)

      toggled_state = item.checked? ? "incomplete" : "complete"
      toggled_item = item.dup.tap { |i| i.state = toggled_state }
      toggled_items = checklist_items.dup
      toggled_items[task_number - 1] = toggled_item

      state.with(checklist_items: toggled_items)
    end

    private

    def render_loading_state(state, task_number)
      loading_state = build_loading_state(state, task_number)

      clear_screen
      output.puts loading_state.title
      output.puts "=" * loading_state.card.name.size
      output.puts loading_state.checklist_string
    end

    def build_loading_state(state, task_number)
      index = task_number - 1
      loading_items = state.checklist_items.dup
      loading_items[index] =
        loading_items.fetch(index).dup.tap { |i| i.state = "loading" }
      state.with(checklist_items: loading_items)
    end
  end
end
