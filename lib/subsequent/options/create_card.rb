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
      Subsequent::TrelloClient.create_card(
        name: text, list_id: state.browse_list_id,
      )
      state = Subsequent::Commands::FetchData.call(state)

      state.with(mode: Subsequent::Modes::AddChecklist)
    end
  end
end
