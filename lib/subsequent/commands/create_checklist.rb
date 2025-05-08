# frozen_string_literal: true

# create checklist on the current card and fetches the updated data
module Subsequent::Commands::CreateChecklist
  # create a checklist on the current card
  def self.call(state, name)
    Subsequent::TrelloClient.create_checklist(card: state.card, name:)

    state = Subsequent::Commands::FetchData.call(sort: state.sort)
    checklist = state.card.checklists.first
    mode = Subsequent::Mode::AddChecklistItem

    state.with(checklist:, checklist_items: checklist.items, mode:)
  end
end
