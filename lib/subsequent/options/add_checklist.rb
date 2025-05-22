# frozen_string_literal: true

# switch to add checklist mode
module Subsequent::Options::AddChecklist
  # return true if the text is "l"
  def self.match?(_state, text)
    text == "l"
  end

  # return state with mode set to add checklist
  def self.call(state, _text)
    state.with(mode: Subsequent::Modes::AddChecklist)
  end
end
