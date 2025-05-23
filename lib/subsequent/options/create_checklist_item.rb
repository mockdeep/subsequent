# frozen_string_literal: true

# create a new checklist item in Trello
module Subsequent::Options::CreateChecklistItem
  class << self
    # return true, def ault to this when no other option matches
    def match?(*)
      true
    end

    # create a new checklist item in Trello and re-fetch data
    def call(state, text)
      state => { checklist:, filter:, sort: }
      Subsequent::TrelloClient.create_checklist_item(checklist:, name: text)

      state = Subsequent::Commands::FetchData.call(filter:, sort:)
      state.with(mode: Subsequent::Modes::AddChecklistItem)
    end
  end
end
