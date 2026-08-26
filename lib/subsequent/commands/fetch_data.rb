# frozen_string_literal: true

# fetch data from the Trello API
module Subsequent::Commands::FetchData
  class << self
    # re-fetch data, staying on the current list
    # anything in state_args overrides what is carried over from the state
    def call(state, **state_args)
      state => { filter:, sort:, list_id:, lists: }

      initial(filter:, sort:, list_id:, lists:, **state_args)
    end

    # fetch data before there is any state to carry over
    def initial(filter:, sort:, list_id:, **state_args)
      cards = Subsequent::TrelloClient.fetch_cards(list_id:)

      Subsequent::State.build(cards:, filter:, sort:, list_id:, **state_args)
    end
  end
end
