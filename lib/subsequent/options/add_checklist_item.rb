# frozen_string_literal: true

# switch to add checklist item mode
module Subsequent::Options::AddChecklistItem
  Subsequent::Options.register(self, :add_checklist_item)

  class << self
    # return true if the text is "i" and there is a checklist
    def match?(state, text)
      text == "i" && state.checklist.present?
    end

    # return state with mode set to add checklist item
    def call(state, _text)
      state.with(mode: Subsequent::Modes::AddChecklistItem)
    end
  end
end
