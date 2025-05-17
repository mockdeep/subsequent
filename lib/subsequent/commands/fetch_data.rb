# frozen_string_literal: true

# fetch data from the Trello API
module Subsequent::Commands::FetchData
  # fetch data from the Trello API
  def self.call(filter:, sort:)
    cards = Subsequent::TrelloClient.fetch_cards

    Subsequent::State.new(cards:, filter:, sort:)
  end
end
