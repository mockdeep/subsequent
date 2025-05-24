# frozen_string_literal: true

# create a new card in Trello
module Subsequent::Options::CreateCard
  Subsequent::Options.register(self, :create_card)

  class << self
    # return true, def ault to this when no other option matches
    def match?(*)
      true
    end

    # create a new card in Trello and re-fetch data
    def call(state, text)
      state => { filter:, sort: }
      Subsequent::TrelloClient.create_card(name: text)
      state = Subsequent::Commands::FetchData.call(filter:, sort:)

      state.with(mode: Subsequent::Modes::AddChecklist)
    end
  end
end
