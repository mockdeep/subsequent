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

      animate_loading(state, task_number, item)

      toggled_state = item.checked? ? "incomplete" : "complete"
      toggled_item = item.with(state: toggled_state)
      toggled_items = checklist_items.dup
      toggled_items[task_number - 1] = toggled_item

      state.with(checklist_items: toggled_items)
    end

    private

    def animate_loading(state, task_number, item)
      loading_state = build_loading_state(state, task_number)

      thread =
        Thread.new { Subsequent::TrelloClient.toggle_checklist_item(item) }

      render_loading_frame(loading_state) while thread.alive?
      clear_screen

      thread.value
    end

    def render_loading_frame(state)
      state => { card: }

      clear_screen
      output.print(terminal_title(card.name))
      output.puts(state.title)
      output.puts("=" * card.name.size)
      output.puts(state.checklist_string)
      sleep(0.1)
    end

    def build_loading_state(state, task_number)
      index = task_number - 1
      loading_items = state.checklist_items.dup
      loading_items[index] = loading_items.fetch(index).with(state: "loading")
      state.with(checklist_items: loading_items)
    end
  end
end
