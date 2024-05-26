# frozen_string_literal: true

# fetch data from the Trello API
module Subsequent::Commands::FetchData
  # fetch data from the Trello API
  def self.call(sort:)
    cards = Subsequent::TrelloClient.fetch_cards

    Subsequent::State.format(cards:, sort:)
  end
end
