# frozen_string_literal: true

# switch to add checklist mode
module Subsequent::Options::AddChecklist
  Subsequent::Options.register(self, :add_checklist)

  class << self
    # return true if the text is "l"
    def match?(_state, text)
      text == "l"
    end

    # return state with mode set to add checklist
    def call(state, _text)
      state.with(mode: Subsequent::Modes::AddChecklist)
    end
  end
end
