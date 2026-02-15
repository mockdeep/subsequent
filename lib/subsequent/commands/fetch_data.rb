# frozen_string_literal: true

# fetch data from the Trello API
module Subsequent::Commands::FetchData
  class << self
    # fetch data from the Trello API
    def call(filter:, sort:)
      cards = Subsequent::TrelloClient.fetch_cards

      Subsequent::State.new(cards:, filter:, sort:)
    end
  end
end
