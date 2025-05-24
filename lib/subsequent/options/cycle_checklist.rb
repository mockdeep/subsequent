# frozen_string_literal: true

# cycle checklist to the end
module Subsequent::Options::CycleChecklist
  Subsequent::Options.register(self, :cycle_checklist)

  extend Subsequent::DisplayHelpers

  class << self
    # return true if the text is "l"
    def match?(_state, text)
      text == "l"
    end

    # cycle checklist to the end and fetch data
    def call(state, _text)
      state => { card:, checklist:, filter:, sort: }

      pos = card.checklists.last.pos + 1

      show_spinner do
        Subsequent::TrelloClient.update_checklist(checklist, pos:)
        Subsequent::Commands::FetchData.call(filter:, sort:)
      end
    end
  end
end
