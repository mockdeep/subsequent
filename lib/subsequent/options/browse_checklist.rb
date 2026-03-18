# frozen_string_literal: true

# browse checklists on the current card
module Subsequent::Options::BrowseChecklist
  Subsequent::Options.register(self, :browse_checklist)

  class << self
    # return true if the text is "k"
    def match?(_state, text)
      text == "k"
    end

    # enter SelectChecklist mode for the current card
    def call(state, _text)
      state.with(mode: Subsequent::Modes::SelectChecklist, browse_page: 0)
    end
  end
end
