# frozen_string_literal: true

# fetch data from the Trello API
module Subsequent::Commands::FetchData
  class << self
    # fetch data from the Trello API
    def call(filter:, sort:, list_id: nil, **state_args)
      cards = fetch_cards(list_id)

      Subsequent::State.new(
        cards:,
        filter:,
        sort:,
        browse_list_id: list_id,
        **state_args,
      )
    end

    private

    def fetch_cards(list_id)
      if list_id
        Subsequent::TrelloClient.fetch_cards(list_id:)
      else
        Subsequent::TrelloClient.fetch_cards
      end
    end
  end
end
