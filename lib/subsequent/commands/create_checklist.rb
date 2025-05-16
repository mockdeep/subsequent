# frozen_string_literal: true

# create checklist on the current card and fetches the updated data
module Subsequent::Commands::CreateChecklist
  # create a checklist on the current card
  def self.call(state, name)
    state => { card:, filter:, sort: }
    Subsequent::TrelloClient.create_checklist(card: card, name:)

    state = Subsequent::Commands::FetchData.call(filter:, sort:)
    checklist = state.card.checklists.first
    mode = Subsequent::Modes::AddChecklistItem

    state.with(checklist:, checklist_items: checklist.items, mode:)
  end
end
