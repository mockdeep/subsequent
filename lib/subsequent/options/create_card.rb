# frozen_string_literal: true

# create a new card in Trello
module Subsequent::Options::CreateCard
  # return true, default to this when no other option matches
  def self.match?(*)
    true
  end

  # create a new card in Trello and re-fetch data
  def self.call(state, text)
    state => { filter:, sort: }
    Subsequent::TrelloClient.create_card(name: text)
    state = Subsequent::Commands::FetchData.call(filter:, sort:)

    state.with(mode: Subsequent::Modes::AddChecklist)
  end
end
