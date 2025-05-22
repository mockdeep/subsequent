# frozen_string_literal: true

# switch to add checklist item mode
module Subsequent::Options::AddChecklistItem
  # return true if the text is "i" and there is a checklist
  def self.match?(state, text)
    text == "i" && state.checklist.present?
  end

  # return state with mode set to add checklist item
  def self.call(state, _text)
    state.with(mode: Subsequent::Modes::AddChecklistItem)
  end
end
