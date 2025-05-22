# frozen_string_literal: true

# cycle checklist to the end
module Subsequent::Options::CycleChecklist
  extend Subsequent::DisplayHelpers

  # return true if the text is "l"
  def self.match?(_state, text)
    text == "l"
  end

  # cycle checklist to the end and fetch data
  def self.call(state, _text)
    state => { card:, checklist:, filter:, sort: }

    pos = card.checklists.last.pos + 1

    show_spinner do
      Subsequent::TrelloClient.update_checklist(checklist, pos:)
      Subsequent::Commands::FetchData.call(filter:, sort:)
    end
  end
end
