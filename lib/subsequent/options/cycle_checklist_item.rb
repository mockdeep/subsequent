# frozen_string_literal: true

# cycle checklist item to the end
module Subsequent::Options::CycleChecklistItem
  Subsequent::Options.register(self, :cycle_checklist_item)

  extend Subsequent::DisplayHelpers

  class << self
    # return true if the text is "i"
    def match?(_state, text)
      text == "i"
    end

    # cycle checklist item to the end and fetch data
    def call(state, _text)
      state => { checklist:, checklist_items:, filter:, sort: }

      checklist_item = checklist_items.first
      pos = checklist.items.last.pos + 1
      show_spinner do
        Subsequent::TrelloClient.update_checklist_item(checklist_item, pos:)
        Subsequent::Commands::FetchData.call(filter:, sort:)
      end
    end
  end
end
