# frozen_string_literal: true

# create a new checklist item in Trello
module Subsequent::Options::CreateChecklistItem
  # return true, default to this when no other option matches
  def self.match?(*)
    true
  end

  # create a new checklist item in Trello and re-fetch data
  def self.call(state, text)
    state => { checklist:, filter:, sort: }
    Subsequent::TrelloClient.create_checklist_item(checklist:, name: text)

    state = Subsequent::Commands::FetchData.call(filter:, sort:)
    state.with(mode: Subsequent::Modes::AddChecklistItem)
  end
end
